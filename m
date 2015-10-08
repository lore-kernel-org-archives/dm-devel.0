From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 05/18] update multipath rules to deal with
	partition devices
Date: Thu,  8 Oct 2015 14:44:38 -0500
Message-ID: <1444333491-16265-6-git-send-email-bmarzins@redhat.com>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Partition devices should inherit the DM_MULTIPATH_DEVICE_PATH
state of their parents, and if they are part of multipath path devices,
they shouldn't have their own ID_FS_TYPE

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/multipath.rules | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/multipath/multipath.rules b/multipath/multipath.rules
index c76e6b8..c8fb7e6 100644
--- a/multipath/multipath.rules
+++ b/multipath/multipath.rules
@@ -1,14 +1,22 @@
 # Set DM_MULTIPATH_DEVICE_PATH if the device should be handled by multipath
 SUBSYSTEM!="block", GOTO="end_mpath"
+ACTION!="add|change", GOTO="end_mpath"
+KERNEL!="sd*|dasd*", GOTO="end_mpath"
+
+ENV{DEVTYPE}!="partition", GOTO="test_dev"
+IMPORT{parent}="DM_MULTIPATH_DEVICE_PATH"
+ENV{DM_MULTIPATH_DEVICE_PATH}=="1", ENV{ID_FS_TYPE}="none", \
+	ENV{SYSTEMD_READY}="0"
+GOTO="end_mpath"
+
+LABEL="test_dev"
 
 ENV{MPATH_SBIN_PATH}="/sbin"
 TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
 
-SUBSYSTEM=="block", ACTION=="add|change", KERNEL=="sd*|dasd*", \
-	ENV{DM_MULTIPATH_DEVICE_PATH}!="1", \
+ENV{DM_MULTIPATH_DEVICE_PATH}!="1", \
 	PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -u %k", \
-	ENV{DM_MULTIPATH_DEVICE_PATH}="1" \
-	ENV{ID_FS_TYPE}="none" \
+	ENV{DM_MULTIPATH_DEVICE_PATH}="1", ENV{ID_FS_TYPE}="none", \
 	ENV{SYSTEMD_READY}="0"
 
 LABEL="end_mpath"
-- 
1.8.3.1
