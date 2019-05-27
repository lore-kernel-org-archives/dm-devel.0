From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 7/9] libmpathpersist: don't bother with
	priorities
Date: Mon, 27 May 2019 14:59:40 +0200
Message-ID: <20190527125942.8366-8-mwilck@suse.com>
References: <20190527125942.8366-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190527125942.8366-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

We send our PR commands to every active path, regardless of priority.
Thus we can save the effort to obtain priorities.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index ce72da67..599c5e9e 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -114,12 +114,6 @@ updatepaths (struct multipath * mpp)
 				pathinfo(pp, conf, DI_CHECKER);
 				put_multipath_config(conf);
 			}
-
-			if (pp->priority == PRIO_UNDEF) {
-				conf = get_multipath_config();
-				pathinfo(pp, conf, DI_PRIO);
-				put_multipath_config(conf);
-			}
 		}
 	}
 	return 0;
@@ -413,7 +407,6 @@ get_mpvec (vector curmp, vector pathvec, char * refwwid)
 		 * about them
 		 */
 		updatepaths(mpp);
-		mpp->bestpg = select_path_group (mpp);
 		disassemble_status (status, mpp);
 
 	}
-- 
2.21.0
