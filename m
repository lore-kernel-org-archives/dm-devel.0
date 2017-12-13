From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/2] libmultipath: don't update path queueing on
	reload
Date: Wed, 13 Dec 2017 12:08:07 -0600
Message-ID: <1513188487-31852-2-git-send-email-bmarzins@redhat.com>
References: <1513188487-31852-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1513188487-31852-1-git-send-email-bmarzins@redhat.com>
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

With the fix to the features handling code, the multipath device should
already be reloaded with the correct value for queue_if_no_path, so
there's no need to go reset it immediately afterwards.

Cc: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index bfa5048..6f28f45 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1351,12 +1351,6 @@ int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh,
 			"for reload map", mpp->alias, r);
 		return 1;
 	}
-	if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF) {
-		if (mpp->no_path_retry == NO_PATH_RETRY_FAIL)
-			dm_queue_if_no_path(mpp->alias, 0);
-		else
-			dm_queue_if_no_path(mpp->alias, 1);
-	}
 
 	return 0;
 }
-- 
2.7.4
