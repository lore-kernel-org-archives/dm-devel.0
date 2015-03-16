From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/78] libmultipath: Skip paths with empty wwid
Date: Mon, 16 Mar 2015 13:35:54 +0100
Message-ID: <1426509425-15978-8-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

If the WWID is empty this is pretty much a terminal error, as
we don't have anything to identify the multipath device.
So skip those devices during discovery.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 3e0afc4..948fa49 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1230,7 +1230,8 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 	if ((mask & DI_WWID) && !strlen(pp->wwid))
 		get_uid(pp);
 	if (mask & DI_BLACKLIST && mask & DI_WWID) {
-		if (filter_wwid(conf->blist_wwid, conf->elist_wwid,
+		if (!strlen(pp->wwid) ||
+		    filter_wwid(conf->blist_wwid, conf->elist_wwid,
 				pp->wwid) > 0) {
 			return PATHINFO_SKIPPED;
 		}
@@ -1244,6 +1245,8 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 		if (pp->state != PATH_DOWN || pp->priority == PRIO_UNDEF) {
 			if (!strlen(pp->wwid))
 				get_uid(pp);
+			if (!strlen(pp->wwid))
+				return PATHINFO_SKIPPED;
 			get_prio(pp);
 		}
 	}
-- 
1.8.4.5
