From: tang.wenji@zte.com.cn
Subject: [PATCH] mpathpersistent: segment faulty occured in
	mpath_persistent_reserve_in()
Date: Mon, 7 Nov 2016 14:35:16 +0800
Message-ID: <1478500516-9792-1-git-send-email-tang.wenji@zte.com.cn>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, "tang.wenji" <tang.wenji@zte.com.cn>
List-Id: dm-devel.ids

From: "tang.wenji" <tang.wenji@zte.com.cn>

Segment faulty occured when executing "mpathpersist -i -k
    /dev/mapper/mpath1" command.The reason is that an uninitialized global
    variable conf is used in mpath_persistent_reserve_in(). The same
    problem also exists in mpath_persistent_reserve_out().

Signed-off-by: tang.wenji <tang.wenji@zte.com.cn>
---
 libmpathpersist/mpath_persist.c | 22 +++++++++++++++++++---
 libmpathpersist/mpathpr.h       |  4 ----
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index faea2b7..982c795 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -35,7 +35,6 @@
 #define __STDC_FORMAT_MACROS 1
 
 struct udev *udev;
-struct config *conf;
 
 struct config *
 mpath_lib_init (struct udev *udev)
@@ -79,6 +78,7 @@ updatepaths (struct multipath * mpp)
 	int i, j;
 	struct pathgroup * pgp;
 	struct path * pp;
+	struct config *conf;
 
 	if (!mpp->pg)
 		return 0;
@@ -98,16 +98,24 @@ updatepaths (struct multipath * mpp)
 					continue;
 				}
 				pp->mpp = mpp;
+				conf = get_multipath_config();
 				pathinfo(pp, conf, DI_ALL);
+				put_multipath_config(conf);
 				continue;
 			}
 			pp->mpp = mpp;
 			if (pp->state == PATH_UNCHECKED ||
-					pp->state == PATH_WILD)
+					pp->state == PATH_WILD) {
+				conf = get_multipath_config();
 				pathinfo(pp, conf, DI_CHECKER);
+				put_multipath_config(conf);
+			}
 
-			if (pp->priority == PRIO_UNDEF)
+			if (pp->priority == PRIO_UNDEF) {
+				conf = get_multipath_config();
 				pathinfo(pp, conf, DI_PRIO);
+				put_multipath_config(conf);
+			}
 		}
 	}
 	return 0;
@@ -160,8 +168,11 @@ int mpath_persistent_reserve_in (int fd, int rq_servact,
 	int map_present;
 	int major, minor;
 	int ret;
+	struct config *conf;
 
+	conf = get_multipath_config();
 	conf->verbosity = verbose;
+	put_multipath_config(conf);
 
 	if (fstat( fd, &info) != 0){
 		condlog(0, "stat error %d", fd);
@@ -253,8 +264,11 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 	int j;
 	unsigned char *keyp;
 	uint64_t prkey;
+	struct config *conf;
 
+	conf = get_multipath_config();
 	conf->verbosity = verbose;
+	put_multipath_config(conf);
 
 	if (fstat( fd, &info) != 0){
 		condlog(0, "stat error fd=%d", fd);
@@ -321,7 +335,9 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 		goto out1;
 	}
 
+	conf = get_multipath_config();
 	select_reservation_key(conf, mpp);
+	put_multipath_config(conf);
 
 	switch(rq_servact)
 	{
diff --git a/libmpathpersist/mpathpr.h b/libmpathpersist/mpathpr.h
index 056c547..e6c2ded 100644
--- a/libmpathpersist/mpathpr.h
+++ b/libmpathpersist/mpathpr.h
@@ -25,10 +25,6 @@ struct threadinfo {
 	struct prout_param param;
 };
 
-
-extern struct config *conf;
-
-
 int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp * resp, int noisy);
 int prout_do_scsi_ioctl( char * dev, int rq_servact, int rq_scope,
 		unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy);
-- 
2.8.1.windows.1
