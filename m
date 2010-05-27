From: zkabelac@sourceware.org
Subject: dmraid/lib .export.sym
Date: 27 May 2010 20:24:27 -0000
Message-ID: <20100527202427.26003.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	dmraid
Changes by:	zkabelac@sourceware.org	2010-05-27 20:24:27

Modified files:
	lib            : .export.sym 

Log message:
	Removed double NL/LF
	Sorted

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/.export.sym.diff?cvsroot=dm&r1=1.3&r2=1.4

--- dmraid/lib/.export.sym	2009/09/16 11:45:12	1.3
+++ dmraid/lib/.export.sym	2010/05/27 20:24:27	1.4
@@ -1,61 +1,61 @@
-Base {

-	global:

-		add_delimiter;

-		change_set;

-		check_valid_format;

-		collapse_delimiter;

-		count_devices;

-		count_devs;

-		count_sets;

-		_dbg_free;

-		_dbg_malloc;

-		_dbg_realloc;

-		_dbg_strdup;

-		discover_devices;

-		discover_partitions;

-		discover_raid_devices;

-		display_devices;

-		display_set;

-		dm_version;

-		erase_metadata;

-		find_set;

-		get_dm_type;

-		get_set_type;

-		get_set_name;

-		get_status;

-		get_type;

-		group_set;

-		init_locking;

-		lc_inc_opt;

-		lc_list;

-		lc_opt;

-		lc_stralloc_opt;

-		lc_strcat_opt;

-		libdmraid_exit;

-		libdmraid_init;

-		libdmraid_date;

-		libdmraid_version;

-		libdmraid_make_table;

-		list_formats;

-		lock_resource;

-		log_alloc_err;

-		plog;

-		process_sets;

-		remove_delimiter;

-		remove_white_space;

-		total_sectors;

-		unlock_resource;

-		add_dev_to_array;

-		delete_raidsets;

-                lib_perform;

-                rebuild_raidset;

-		dso_end_rebuild;

-		hot_spare_add;

-		dso_get_members;

-		dm_register_device;

-		dm_unregister_device;
-		dm_all_monitored;
-	local:

-		*;

-};

-

+Base {
+	global:
+		add_delimiter;
+		add_dev_to_array;
+		change_set;
+		check_valid_format;
+		collapse_delimiter;
+		count_devices;
+		count_devs;
+		count_sets;
+		delete_raidsets;
+		discover_devices;
+		discover_partitions;
+		discover_raid_devices;
+		display_devices;
+		display_set;
+		dm_all_monitored;
+		dm_register_device;
+		dm_unregister_device;
+		dm_version;
+		dso_end_rebuild;
+		dso_get_members;
+		erase_metadata;
+		find_set;
+		get_dm_type;
+		get_set_name;
+		get_set_type;
+		get_status;
+		get_type;
+		group_set;
+		hot_spare_add;
+		init_locking;
+		lc_inc_opt;
+		lc_list;
+		lc_opt;
+		lc_stralloc_opt;
+		lc_strcat_opt;
+		libdmraid_date;
+		libdmraid_exit;
+		libdmraid_init;
+		libdmraid_make_table;
+		libdmraid_version;
+		lib_perform;
+		list_formats;
+		lock_resource;
+		log_alloc_err;
+		plog;
+		process_sets;
+		rebuild_raidset;
+		remove_delimiter;
+		remove_white_space;
+		total_sectors;
+		unlock_resource;
+		_dbg_free;
+		_dbg_malloc;
+		_dbg_realloc;
+		_dbg_strdup;
+	local:
+		*;
+};
+
