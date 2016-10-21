From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 07/15] libmpathpersist: Remove an unused function
Date: Fri, 21 Oct 2016 11:43:50 -0700
Message-ID: <8a90c01d-bbdd-7eea-9549-c0af172d54f1@sandisk.com>
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
 libmpathpersist/mpath_persist.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 7501651..edd4246 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -414,17 +414,6 @@ get_mpvec (vector curmp, vector pathvec, char * refwwid)
 	return MPATH_PR_SUCCESS ;
 }
 
-void * mpath_prin_pthread_fn (void *p)
-{
-	int ret;
-	struct prin_param * pparam = (struct prin_param *)p;
-
-	ret = prin_do_scsi_ioctl(pparam->dev, pparam->rq_servact,
-				 pparam->resp,  pparam->noisy);
-	pparam->status = ret;
-	pthread_exit(NULL);
-}
-
 int mpath_send_prin_activepath (char * dev, int rq_servact,
 				struct prin_resp * resp, int noisy)
 {
-- 
2.10.1
