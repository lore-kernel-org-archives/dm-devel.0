From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 13/20] multipath -u: change output to
	environment/key format
Date: Mon, 19 Mar 2018 16:01:48 +0100
Message-ID: <20180319150155.5363-14-mwilck@suse.com>
References: <20180319150155.5363-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180319150155.5363-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

... instead of free format. This provides more flexibility
for udev rule processing for the future. Adapt code in multipath.rules.
The exit status remains as usual. This affects "multipath -c", too.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c          | 11 +++++------
 multipath/multipath.rules |  6 +++---
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index ea4a3d44493a..f93cad2abde0 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -350,15 +350,14 @@ out:
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
@@ -520,7 +519,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 
 print_valid:
 	if (cmd == CMD_VALID_PATH)
-		print_cmd_valid(devpath, r);
+		print_cmd_valid(r);
 
 out:
 	if (refwwid)
diff --git a/multipath/multipath.rules b/multipath/multipath.rules
index 6f8ee2be0a58..aab64dc7182c 100644
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
