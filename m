From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 11/15] libmpathpersist: Move the definition of a
 global variable from .h to .c
Date: Fri, 21 Oct 2016 11:45:32 -0700
Message-ID: <480d817e-7139-445d-756f-cf20bd9f1cde@sandisk.com>
References: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmpathpersist/mpath_persist.c | 1 +
 libmpathpersist/mpathpr.h       | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index edd4246..6cc6dbc 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -35,6 +35,7 @@
 #define __STDC_FORMAT_MACROS 1
 
 struct udev *udev;
+struct config *conf;
 
 struct config *
 mpath_lib_init (struct udev *udev)
diff --git a/libmpathpersist/mpathpr.h b/libmpathpersist/mpathpr.h
index cd58201..056c547 100644
--- a/libmpathpersist/mpathpr.h
+++ b/libmpathpersist/mpathpr.h
@@ -26,7 +26,7 @@ struct threadinfo {
 };
 
 
-struct config * conf;
+extern struct config *conf;
 
 
 int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp * resp, int noisy);
-- 
2.10.1
