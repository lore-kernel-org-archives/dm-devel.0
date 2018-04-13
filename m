From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 12/22] multipath -u: change output to
	environment/key format
Date: Sat, 14 Apr 2018 00:00:05 +0200
Message-ID: <20180413220015.7032-13-mwilck@suse.com>
References: <20180413220015.7032-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

... instead of free format. This provides more flexibility
for udev rule processing for the future. Adapt code in multipath.rules.
The exit status remains as usual. This affects "multipath -c", too.

The parameters "pathvec" and "conf" for print_cmd_valid are currently
unused, but will be in follow-up patches.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/main.c          | 14 ++++++++------
 multipath/multipath.rules |  6 +++---
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index bf28735f..59a72ed0 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -350,13 +350,15 @@ out:
 	return r;
 }
 
-static int print_cmd_valid(const char *devpath, int k)
+static int print_cmd_valid(int k, const vector pathvec,
+			   struct config *conf)
 {
-	if (k < 0 || k > 1)
+	static const int vals[] = { 1, 0 };
+
+	if (k < 0 || k >= sizeof(vals))
 		return 1;
 
-	printf("%s is%s a valid multipath device path\n",
-	       devpath, k ? "" : " not");
+	printf("DM_MULTIPATH_DEVICE_PATH=\"%d\"\n", vals[k]);
 	return k == 1;
 }
 
@@ -514,7 +516,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 
 print_valid:
 	if (cmd == CMD_VALID_PATH)
-		r = print_cmd_valid(devpath, r);
+		r = print_cmd_valid(r, pathvec, conf);
 
 out:
 	if (refwwid)
@@ -851,7 +853,7 @@ main (int argc, char *argv[])
 		if (fd == -1) {
 			condlog(3, "%s: daemon is not running", dev);
 			if (!systemd_service_enabled(dev)) {
-				r = print_cmd_valid(dev, 1);
+				r = print_cmd_valid(1, NULL, conf);
 				goto out;
 			}
 		} else
diff --git a/multipath/multipath.rules b/multipath/multipath.rules
index 6f8ee2be..aab64dc7 100644
--- a/multipath/multipath.rules
+++ b/multipath/multipath.rules
@@ -19,9 +19,9 @@ LABEL="test_dev"
 ENV{MPATH_SBIN_PATH}="/sbin"
 TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
 
-ENV{DM_MULTIPATH_DEVICE_PATH}!="1", \
-	PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -u %k", \
-	ENV{DM_MULTIPATH_DEVICE_PATH}="1", ENV{ID_FS_TYPE}="mpath_member", \
+# multipath -u sets DM_MULTIPATH_DEVICE_PATH
+ENV{DM_MULTIPATH_DEVICE_PATH}!="1", IMPORT{program}="$env{MPATH_SBIN_PATH}/multipath -u %k"
+ENV{DM_MULTIPATH_DEVICE_PATH}=="1", ENV{ID_FS_TYPE}="mpath_member", \
 	ENV{SYSTEMD_READY}="0"
 
 LABEL="end_mpath"
-- 
2.16.1
