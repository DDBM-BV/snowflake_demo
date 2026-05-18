-- Set up context for worksheet
use role accountadmin;
use warehouse compute_wh;

-- Resource monitors track credit usage by warehouses.
-- They can notify, suspend, or immediately suspend warehouses
-- when usage reaches a defined threshold.
-- Note: only ACCOUNTADMIN can create resource monitors.

-- Create a basic resource monitor with a monthly quota
create or replace resource monitor daily_limit
    with credit_quota = 100
    frequency = daily
    start_timestamp = immediately
    triggers on 75 percent do notify
             on 90 percent do suspend
             on 100 percent do suspend_immediate;

-- Create a monthly resource monitor with notifications for specific users
create or replace resource monitor monthly_limit
    with credit_quota = 5000
    frequency = monthly
    start_timestamp = immediately
    triggers on 50 percent do notify
             on 75 percent do notify
             on 100 percent do suspend
             on 110 percent do suspend_immediate;

-- Assign resource monitors to warehouses
-- Each warehouse can only be assigned to one resource monitor
alter warehouse compute_wh set resource_monitor = daily_limit;

-- View all resource monitors and their current usage
show resource monitors;


-- This monitors ALL warehouses in the account
create or replace resource monitor account_limit
    with credit_quota = 20000
    frequency = monthly
    start_timestamp = immediately
    triggers on 80 percent do notify
             on 100 percent do suspend;

alter account set resource_monitor = account_limit;

-- Unassign a resource monitor from a warehouse
alter warehouse compute_wh unset resource_monitor;

-- Drop a resource monitor
drop resource monitor if exists daily_limit;

-- Create a warehouse with a resource monitor
create or replace warehouse my_medium_warehouse
with
    warehouse_type = standard
    warehouse_size = medium
    auto_suspend = 60
    initially_suspended = true
    resource_monitor = monthly_limit;

-- Cleanup
alter account unset resource_monitor;
drop resource monitor if exists account_limit;
drop resource monitor if exists monthly_limit;
drop resource monitor if exists daily_limit;
drop warehouse if exists my_medium_warehouse;
