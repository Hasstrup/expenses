import React, { useState, useEffect } from "react";
import request from "../request";
import { useNotifications } from "./Notifications";
/**
 * I created a user, account resource  [in the API] that scopes expenses to user's accounts.
 * with this HOC I intend to get the current user OR CREATE one and the corresponing accounts
 * so that you can test this seamlessly
 */

export const AuthenticationContext = React.createContext();

export const AccountOnly = ({ children }) => {
  const authenticationState = localStorage.getItem("Authentication::State");
  const parsedAuthState = authenticationState
    ? JSON.parse(authenticationState)
    : null;
  const [authState, setAuthState] = useState(parsedAuthState);
  const { notifyInfo } = useNotifications();

  useEffect(() => {
    const registerUserAndAccount = async () => {
      if (authState) return;

      notifyInfo("Setting up user and accounts, one sec");
      const options = {
        method: "POST",
        body: { user: { name: "Test User" } },
      };
      await request("/users", options).then(async (response) => {
        const { id: userId } = response.body.data;
        const accountCreateOptions = {
          method: "POST",
          body: { account: { name: "Test User Account", number: 1234567890 } },
        };
        await request(`users/${userId}/accounts`, accountCreateOptions).then(
          (response) => {
            const { id: accountId } = response.body.data;
            const accountState = {
              userId,
              accountId,
            };
            localStorage.setItem("Authentication::State", JSON.stringify(accountState));
            setAuthState(accountState);
          }
        );
      });
      notifyInfo("done");
    };

    registerUserAndAccount();
  }, []);

  return (
    <AuthenticationContext.Provider value={authState}>
      {children}
    </AuthenticationContext.Provider>
  );
};
