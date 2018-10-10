From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 5/6] mpathpersist: fix registration rollback issue
Date: Wed, 10 Oct 2018 13:01:12 -0500
Message-ID: <1539194473-6243-6-git-send-email-bmarzins@redhat.com>
References: <1539194473-6243-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539194473-6243-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

When mpathpersist tries to rollback the registration, it copies
the SARK to the RK, and clears the SARK. However, it repeated this step
for each thread. This means that the first rollback thread correctly
had the RK set to the SARK used during registration. However, if more
than one registration needed to be rolled back, later threads would have
both the RK and SARK cleared. This commit fixes that by only copying and
clearing the SARK once.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 29e7fb4..2ffe56e 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -559,11 +559,10 @@ int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
 	}
 	if (rollback && ((rq_servact == MPATH_PROUT_REG_SA) && sa_key != 0 )){
 		condlog (3, "%s: ERROR: initiating pr out rollback", mpp->wwid);
+		memcpy(&paramp->key, &paramp->sa_key, 8);
+		memset(&paramp->sa_key, 0, 8);
 		for( i=0 ; i < count ; i++){
 			if(thread[i].param.status == MPATH_PR_SUCCESS) {
-				memcpy(&thread[i].param.paramp->key, &thread[i].param.paramp->sa_key, 8);
-				memset(&thread[i].param.paramp->sa_key, 0, 8);
-				thread[i].param.status = MPATH_PR_SUCCESS;
 				rc = pthread_create(&thread[i].id, &attr, mpath_prout_pthread_fn,
 						(void *)(&thread[i].param));
 				if (rc){
-- 
2.7.4
