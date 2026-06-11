# if you would like to utilize a table prefix when upgrading these tables, be sure to use the one you have setup in config.inc.php.
# this option is $db_prefix.  if you are unaware of what is meant by utilizing a 'table prefix', then please disregard.


###################################################################
#                                                                 #
# If upgrading from version 1.01 or 1.0, run these sql statements #
# below on the PHP Timeclock database.                            #
#                                                                 #
###################################################################

#
# Table structure for table `audit`
#

CREATE TABLE audit (
  modified_by_ip   VARCHAR(39)  NOT NULL DEFAULT '',
  modified_by_user VARCHAR(50)  NOT NULL DEFAULT '',
  modified_when    BIGINT       NOT NULL,
  modified_from    BIGINT       NOT NULL,
  modified_to      BIGINT       NOT NULL,
  modified_why     VARCHAR(250) NOT NULL DEFAULT '',
  user_modified    VARCHAR(50)  NOT NULL DEFAULT '',
  PRIMARY KEY (modified_when),
  UNIQUE KEY modified_when (modified_when)
) ENGINE=MyISAM;

# --------------------------------------------------------

#
# dbversion table
#

UPDATE `dbversion`
SET `dbversion` = '1.4';

# --------------------------------------------------------

#
# info table
#

ALTER TABLE `info` ADD `ipaddress` VARCHAR(39) NOT NULL DEFAULT '';

# --------------------------------------------------------

#
# employees table
#

ALTER TABLE `employees` ADD `disabled` TINYINT NOT NULL DEFAULT '0';
ALTER TABLE `employees` ADD `first_name` VARCHAR(50) NOT NULL DEFAULT '' AFTER `empfullname`;
ALTER TABLE `employees` ADD `middle_name` VARCHAR(50) NOT NULL DEFAULT '' AFTER `first_name`;
ALTER TABLE `employees` ADD `last_name` VARCHAR(50) NOT NULL DEFAULT '' AFTER `middle_name`;
ALTER TABLE `employees` ADD `hire_date` DATE DEFAULT NULL AFTER `last_name`;
ALTER TABLE `employees` ADD `termination_date` DATE DEFAULT NULL AFTER `hire_date`;
UPDATE `employees`
SET `first_name` = SUBSTRING_INDEX(`empfullname`, ' ', 1),
    `last_name` = CASE WHEN `empfullname` LIKE '% %' THEN SUBSTRING_INDEX(`empfullname`, ' ', -1) ELSE '' END
WHERE `first_name` = '' AND `middle_name` = '' AND `last_name` = '';

# --------------------------------------------------------


########################################################################
#                                                                      #
# If upgrading from version 0.9.4-1 or 0.9.4, run these sql statements #
# below on the PHP Timeclock database.                                 #
#                                                                      #
########################################################################

#
# Table structure for table `audit`
#

CREATE TABLE audit (
  modified_by   VARCHAR(50)  NOT NULL DEFAULT '',
  modified_when BIGINT       NOT NULL,
  modified_from BIGINT       NOT NULL,
  modified_to   BIGINT       NOT NULL,
  modified_why  VARCHAR(250) NOT NULL DEFAULT '',
  PRIMARY KEY (modified_when),
  UNIQUE KEY modified_when (modified_when)
) ENGINE=MyISAM;

# --------------------------------------------------------

#
# dbversion table
#

UPDATE `dbversion`
SET `dbversion` = '1.4';

# --------------------------------------------------------

#
# employees table
#

ALTER TABLE `employees` ADD `displayname` VARCHAR(50) NOT NULL DEFAULT '';
ALTER TABLE `employees` ADD `first_name` VARCHAR(50) NOT NULL DEFAULT '' AFTER `empfullname`;
ALTER TABLE `employees` ADD `middle_name` VARCHAR(50) NOT NULL DEFAULT '' AFTER `first_name`;
ALTER TABLE `employees` ADD `last_name` VARCHAR(50) NOT NULL DEFAULT '' AFTER `middle_name`;
ALTER TABLE `employees` ADD `hire_date` DATE DEFAULT NULL AFTER `last_name`;
ALTER TABLE `employees` ADD `termination_date` DATE DEFAULT NULL AFTER `hire_date`;
ALTER TABLE `employees` ADD `email` VARCHAR(75) NOT NULL DEFAULT '';
ALTER TABLE `employees` ADD `groups`          VARCHAR(50) NOT NULL DEFAULT '';
ALTER TABLE `employees` ADD `office` VARCHAR(50) NOT NULL DEFAULT '';
ALTER TABLE `employees` ADD `admin` TINYINT NOT NULL DEFAULT '0';
ALTER TABLE `employees` ADD `reports` TINYINT NOT NULL DEFAULT '0';
ALTER TABLE `employees` ADD `time_admin` TINYINT NOT NULL DEFAULT '0';
ALTER TABLE `employees` ADD `disabled` TINYINT NOT NULL DEFAULT '0';
UPDATE `employees`
SET `first_name` = SUBSTRING_INDEX(`empfullname`, ' ', 1),
    `last_name` = CASE WHEN `empfullname` LIKE '% %' THEN SUBSTRING_INDEX(`empfullname`, ' ', -1) ELSE '' END
WHERE `first_name` = '' AND `middle_name` = '' AND `last_name` = '';
INSERT INTO employees (empfullname, first_name, middle_name, last_name, hire_date, termination_date, tstamp, employee_passwd, displayname, email, `groups`, office, admin, reports, time_admin, disabled)
VALUES ('admin', 'admin', '', '', NULL, NULL, NULL, 'xy.RY2HT1QTc2', 'administrator', '', '', '', 1, 1, 1, 0);

# --------------------------------------------------------

#
# groups table
#

CREATE TABLE `groups` (
  groupname VARCHAR(50) NOT NULL DEFAULT '',
  groupid   INT         NOT NULL AUTO_INCREMENT,
  officeid  INT         NOT NULL DEFAULT '0',
  PRIMARY KEY (groupid)
) ENGINE=MyISAM;

# --------------------------------------------------------

#
# info table
#

ALTER TABLE `info` CHANGE `inout` `inout` VARCHAR(50) NOT NULL;
ALTER TABLE `info` ADD `ipaddress` VARCHAR(39) NOT NULL DEFAULT '';

# --------------------------------------------------------

#
# offices table
#

CREATE TABLE offices (
  officename VARCHAR(50) NOT NULL DEFAULT '',
  officeid   INT         NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (officeid)
) ENGINE=MyISAM;

# --------------------------------------------------------

#
# punchlist table
#

ALTER TABLE `punchlist` CHANGE `punchitems` `punchitems` VARCHAR(50) NOT NULL;
ALTER TABLE `punchlist` ADD `in_or_out` TINYINT DEFAULT '0' NOT NULL;
UPDATE `punchlist`
SET `in_or_out` = '1'
WHERE `punchitems` = 'in'
LIMIT 1;
UPDATE `punchlist`
SET `in_or_out` = '0'
WHERE `punchitems` = 'out'
LIMIT 1;
UPDATE `punchlist`
SET `in_or_out` = '0'
WHERE `punchitems` = 'break'
LIMIT 1;
UPDATE `punchlist`
SET `in_or_out` = '0'
WHERE `punchitems` = 'lunch'
LIMIT 1;
