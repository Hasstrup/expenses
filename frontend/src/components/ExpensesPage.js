import React, { useEffect, useState, useContext } from "react";
import { Link } from "react-router-dom";
import LoadingIndicator from "./LoadingIndicator";
import ErrorMessage from "./ErrorMessage";
import request from "../request";
import styles from "./ExpensesPage.module.css";
import Button from "./Button";
import { AuthenticationContext } from './AccountOnly';

function ExpenseRow({ expense }) {
  return (
    <li className={styles.item}>
      <Link to={`/expense/${expense.id}`} className={styles.itemInner}>
        <div className={styles.descriptionText}>{expense.attributes.description}</div>
        <div className={styles.amountText}>${expense.attributes.amount.toFixed(2)}</div>
      </Link>
    </li>
  );
}

function ExpenseList({ expenses }) {
  const newExpenseButton = <Button to={"/expense/new"}>New Expense</Button>;

  if (expenses.length === 0) {
    return (
      <div className={styles.emptyState}>
        <div className={styles.emptyStateMessage}>
          You haven't recorded any expenses.
        </div>
        <div>{newExpenseButton}</div>
      </div>
    );
  }

  return (
    <>
      <ul className={styles.list}>
        {expenses.map((expense) => (
          <ExpenseRow key={expense.id} expense={expense} />
        ))}
      </ul>

      <div className={styles.actions}>{newExpenseButton}</div>
    </>
  );
}

function ExpensesPage() {
  const [expenses, setExpenses] = useState([]);
  const [status, setStatus] = useState("loading");
  const authState = useContext(AuthenticationContext)

  useEffect(function () {
    async function loadExpenses() {
      const response = await request(`/users/${authState.userId}/accounts/${authState.accountId}/expenses`, {
        method: "GET",
      });
      if (response.ok) {
        setExpenses(response.body.data);
        setStatus("loaded");
      } else {
        setStatus("error");
      }
    }

    loadExpenses();
  }, []);

  let content;
  if (status === "loading") {
    content = <LoadingIndicator />;
  } else if (status === "loaded") {
    content = <ExpenseList expenses={expenses} />;
  } else if (status === "error") {
    content = <ErrorMessage />;
  } else {
    throw new Error(`Unexpected status: ${status}`);
  }

  return content;
}

export default ExpensesPage;
