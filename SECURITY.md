# Security Policy

## Reporting a vulnerability
Please do **not** open a public issue for security problems.
Use GitHub's **Security → Report a vulnerability** (private advisory) on this repository.

## Supported setup
This project uses Supabase. Before deploying your own instance:
- Enable **Row Level Security (RLS)** on every table.
- Never put the `service_role` key in the app or the repo — only the `anon` key.
- Store passwords hashed (Supabase Auth / bcrypt), never as plain text.
