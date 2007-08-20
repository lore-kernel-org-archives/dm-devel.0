From: Kay Sievers <kay.sievers@vrfy.org>
Subject: dmsetup export option
Date: Mon, 20 Aug 2007 03:12:55 +0200
Message-ID: <1187572375.4419.127.camel@lov.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-tTHngaJTO8mZjXqbpzzg"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--=-tTHngaJTO8mZjXqbpzzg
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Here is the "export" patch we currently use to import device mapper
properties into the udev event environment.

It looks like this:
  $ dmsetup export luks
  DM_NAME=luks
  DM_STATE=ACTIVE
  DM_TABLE_STATE=LIVE
  DM_OPENCOUNT=0
  DM_LAST_EVENT_NR=0
  DM_MAJOR=254
  DM_MINOR=0
  DM_TARGET_COUNT=1
  DM_TARGET_TYPES=crypt

Alasdair, I remember vaguely while we talked about that at OLS, you
wanted to see that implemented using some other backend functions. Let
me know, if I need to change something.

Thanks,
Kay

--=-tTHngaJTO8mZjXqbpzzg
Content-Disposition: inline; filename=device-mapper-dmsetup-export.patch
Content-Type: message/rfc822; name=device-mapper-dmsetup-export.patch

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: add export command to print status in environment key-value format
Date: Mon, 20 Aug 2007 03:00:04 +0200
Message-Id: <1187571604.4419.115.camel@lov.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 dmsetup/dmsetup.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/dmsetup.8     |    9 ++++-
 2 files changed, 97 insertions(+), 1 deletion(-)

--- a/dmsetup/dmsetup.c
+++ b/dmsetup/dmsetup.c
@@ -1055,6 +1055,94 @@
 	return r;
 }
 
+static int _export(int argc, char **argv, void *data)
+{
+	int r = 0;
+	struct dm_task *dmt = NULL;
+	void *next = NULL;
+	uint64_t start, length;
+	char *target_type = NULL;
+	char *params;
+	struct dm_names *names = (struct dm_names *) data;
+	const char *name = NULL;
+	const char *uuid = NULL;
+	struct dm_info info;
+
+	if (data)
+		name = names->name;
+	else if (argc == 2)
+		name = argv[1];
+
+	if (!(dmt = dm_task_create(DM_DEVICE_STATUS)))
+		goto out;
+
+	if (!_set_task_device(dmt, name, 0))
+		goto out;
+
+	if (!dm_task_run(dmt))
+		goto out;
+
+	if (!dm_task_get_info(dmt, &info) || !info.exists)
+		goto out;
+
+	if (!name)
+		name = dm_task_get_name(dmt);
+
+	uuid = dm_task_get_uuid(dmt);
+	printf("DM_NAME=%s\n", name);
+
+	if ((uuid = dm_task_get_uuid(dmt)) && *uuid)
+		printf("DM_UUID=%s\n", uuid);
+
+	if (!info.exists) {
+		printf("DM_STATE=NOTPRESENT\n");
+		goto out;
+	}
+
+	printf("DM_STATE=%s\n",
+	       info.suspended ? "SUSPENDED" :
+	       (info.read_only ? " READONLY" : "ACTIVE"));
+
+	if (!info.live_table && !info.inactive_table)
+		printf("DM_TABLE_STATE=NONE\n");
+	else
+		printf("DM_TABLE_STATE=%s%s%s\n",
+		       info.live_table ? "LIVE" : "",
+		       info.live_table && info.inactive_table ? "/" : "",
+		       info.inactive_table ? "INACTIVE" : "");
+
+	if (info.open_count != -1)
+		printf("DM_OPENCOUNT=%d\n", info.open_count);
+
+	printf("DM_LAST_EVENT_NR=%" PRIu32 "\n", info.event_nr);
+
+	printf("DM_MAJOR=%d\n", info.major);
+	printf("DM_MINOR=%d\n", info.minor);
+
+	if (info.target_count != -1)
+		printf("DM_TARGET_COUNT=%d\n", info.target_count);
+
+	/* export all table types */
+	next = dm_get_next_target(dmt, next, &start, &length,
+				  &target_type, &params);
+	if (target_type) {
+		printf("DM_TARGET_TYPES=%s", target_type);
+		while (next) {
+			next = dm_get_next_target(dmt, next, &start, &length,
+						  &target_type, &params);
+			if (target_type)
+				printf(",%s", target_type);
+		}
+		printf("\n");
+	}
+
+	r = 1;
+      out:
+	if (dmt)
+		dm_task_destroy(dmt);
+	return r;
+}
+
 /* Show target names and their version numbers */
 static int _targets(int argc __attribute((unused)), char **argv __attribute((unused)), void *data __attribute((unused)))
 {
@@ -1994,6 +2082,7 @@
 	{"info", "[<device>]", 0, 1, _info},
 	{"deps", "[<device>]", 0, 1, _deps},
 	{"status", "[<device>] [--target <target_type>]", 0, 1, _status},
+	{"export", "[<device>]", 0, 1, _export},
 	{"table", "[<device>] [--target <target_type>] [--showkeys]", 0, 1, _status},
 	{"wait", "<device> [<event_nr>]", 0, 2, _wait},
 	{"mknodes", "[<device>]", 0, 1, _mknodes},
--- a/man/dmsetup.8
+++ b/man/dmsetup.8
@@ -39,13 +39,16 @@
 .B dmsetup ls
 .I [--target target_type] [--exec command] [--tree [-o options]]
 .br
-.B dmsetup info 
+.B dmsetup info
 .I [device_name]
 .br
 .B dmsetup info -c|-C|--columns
 .I [--noheadings] [--separator separator] [-o fields] [-O|--sort sort_fields]
 .I [device_name]
 .br
+.B dmsetup export
+.I [device_name]
+.br
 .B dmsetup deps
 .I [device_name]
 .br
@@ -138,6 +141,10 @@
 If successful a device will appear as
 /dev/device-mapper/<device-name>.  
 See below for information on the table format.
+.IP \fBexport
+.I [device_name]
+.br
+Outputs information in key/value format to be imported by other programs.
 .IP \fBdeps
 .I [device_name]
 .br

--=-tTHngaJTO8mZjXqbpzzg
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-tTHngaJTO8mZjXqbpzzg--
