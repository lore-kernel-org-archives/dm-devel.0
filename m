From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 12/16] multipath -u/-c: change output to
	environment/key format
Date: Fri, 19 Jan 2018 01:29:12 +0100
Message-ID: <20180119002916.10323-13-mwilck@suse.com>
References: <20180119002916.10323-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180119002916.10323-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

... instead of free format. This provides more flexibility
for udev rule processing for the future. Adapt code in multipath.rules.
The exit status remains as usual.
---
 multipath/main.c          | 11 +++++------
 multipath/multipath.rules |  6 +++---
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 4b3d3a94b282..2127daebcb8f 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -336,15 +336,14 @@ out:
 	return r;
 }
 
-static void print_cmd_valid(const char *devpath, int k)
+static void print_cmd_valid(int k)
 {
-	const char *msg[] = { "is", "is not" };
+	int vals[] = { 1, 0 };
 
-	if (k < 0 || k >= sizeof(msg))
+	if (k < 0 || k >= sizeof(vals))
 		return;
 
-	printf("%s %s a valid multipath device path\n",
-	       devpath, msg[k]);
+	printf("DM_MULTIPATH_DEVICE_PATH=\"%d\"\n", vals[k]);
 }
 
 /*
@@ -499,7 +498,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 
 print_valid:
 	if (cmd == CMD_VALID_PATH)
-		print_cmd_valid(devpath, r);
+		print_cmd_valid(r);
 
 out:
 	if (refwwid)
diff --git a/multipath/multipath.rules b/multipath/multipath.rules
index 6f8ee2be0a58..5b3c3c9c1135 100644
--- a/multipath/multipath.rules
+++ b/multipath/multipath.rules
@@ -19,9 +19,9 @@ LABEL="test_dev"
 ENV{MPATH_SBIN_PATH}="/sbin"
 TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
 
-ENV{DM_MULTIPATH_DEVICE_PATH}!="1", \
-	PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -u %k", \
-	ENV{DM_MULTIPATH_DEVICE_PATH}="1", ENV{ID_FS_TYPE}="mpath_member", \
+# multipath -u sets DM_MULTIPATH_DEVICE_PATH
+ENV{DM_MULTIPATH_DEVICE_PATH}!="1", IMPORT="$env{MPATH_SBIN_PATH}/multipath -u %k"
+ENV{DM_MULTIPATH_DEVICE_PATH}=="1", ENV{ID_FS_TYPE}="mpath_member", \
 	ENV{SYSTEMD_READY}="0"
 
 LABEL="end_mpath"
-- 
2.15.1
