#!/usr/bin/env bash
set -e

echo "🚀 Starting setup for SQLite-based JupyterLite lab..."

# === 1. Create and activate virtual environment ===
echo "📦 Creating Python virtual environment..."
python3 -m venv .venv
source .venv/bin/activate

# === 2. Install dependencies ===
echo "📚 Installing JupyterLite, ipython-sql, pandas and SQLite support..."
pip install --upgrade pip
pip install jupyterlite==0.4.0 jupyterlab==4.1.8 notebook==7.1.0 ipython-sql pandas SQLAlchemy==2.0.34 --no-cache-dir

# === 3. Create content directory for the JupyterLite site ===
mkdir -p content
cd content

# === 4. Create demo notebook ===
cat << 'EOF' > demo.ipynb
{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# 🧠 SQLite Practice Lab\n",
    "This notebook allows you to run SQL queries directly from Jupyter using `ipython-sql`."
   ]
  },
  {
   "cell_type": "code",
   "metadata": {},
   "source": [
    "%load_ext sql\n",
    "%sql sqlite:///demo.db"
   ]
  },
  {
   "cell_type": "code",
   "metadata": {},
   "source": [
    "%%sql\n",
    "CREATE TABLE IF NOT EXISTS students (\n",
    "    id INTEGER PRIMARY KEY AUTOINCREMENT,\n",
    "    name TEXT,\n",
    "    age INTEGER,\n",
    "    major TEXT\n",
    ");"
   ]
  },
  {
   "cell_type": "code",
   "metadata": {},
   "source": [
    "%%sql\n",
    "INSERT INTO students (name, age, major) VALUES\n",
    "('Alice', 22, 'Data Science'),\n",
    "('Bob', 23, 'Computer Engineering'),\n",
    "('Charlie', 21, 'Mathematics');"
   ]
  },
  {
   "cell_type": "code",
   "metadata": {},
   "source": [
    "%%sql\n",
    "SELECT * FROM students;"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "name": "python",
   "version": "3.10"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
EOF

cd ..

# === 5. Build the JupyterLite site ===
echo "🏗️ Building JupyterLite static site..."
jupyter lite build

# === 6. Instructions ===
echo "✅ Setup complete!"
echo ""
echo "To preview locally, run:"
echo "  python3 -m http.server --directory _output 8000"
echo ""
echo "Then open 👉 http://localhost:8000 in your browser."
echo ""
echo "To embed in LearnWorlds, deploy _output/ to GitHub Pages and use:"
echo "  https://<your-username>.github.io/<your-repo>/?embed=true"
