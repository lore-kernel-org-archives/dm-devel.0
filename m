From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 15/15] libmultipath: autodetect ALUA CLARiiON
	configurations
Date: Sat,  7 Mar 2015 21:31:46 -0600
Message-ID: <1425785506-20419-16-git-send-email-bmarzins@redhat.com>
References: <1425785506-20419-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1425785506-20419-1-git-send-email-bmarzins@redhat.com>
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

This patch enables ALUA autodetection on EMC CLARiiON devices. EMC has
tested the change.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/hwtable.c  | 2 ++
 multipath.conf.defaults | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index bf2c2ca..d51dcb8 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -272,6 +272,8 @@ static struct hwentry default_hw[] = {
 		.checker_name  = EMC_CLARIION,
 		.prio_name     = PRIO_EMC,
 		.prio_args     = NULL,
+		.retain_hwhandler = RETAIN_HWHANDLER_ON,
+		.detect_prio   = DETECT_PRIO_ON,
 	},
 	{
 		.vendor        = "EMC",
diff --git a/multipath.conf.defaults b/multipath.conf.defaults
index 5f43c57..a12a4f4 100644
--- a/multipath.conf.defaults
+++ b/multipath.conf.defaults
@@ -263,6 +263,8 @@
 #		failback "immediate"
 #		rr_weight "uniform"
 #		no_path_retry 60
+#		retain_attached_hw_handler yes
+#		detect_prio yes
 #	}
 #	device {
 #		vendor "EMC"
-- 
1.8.3.1
