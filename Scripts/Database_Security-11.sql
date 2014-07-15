select name ,
is_policy_checked as [Password Policy],
 is_expiration_checked as [Password Expiration]
 from sys.sql_logins where is_disabled =0