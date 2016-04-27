From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 41/57] multipathd: accept zero-size paths in
	ev_add_path()
Date: Wed, 27 Apr 2016 13:10:42 +0200
Message-ID: <1461755458-29225-42-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Paths in ALUA 'standby' state are not required to support
READ CAPACITY, and hence might report a size of '0'. However,
they are valid devices and should be added to the existing
topology.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index c1b94bd..c56672a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -560,7 +560,7 @@ ev_add_path (struct path * pp, struct vectors * vecs)
 	pp->mpp = mpp;
 rescan:
 	if (mpp) {
-		if (mpp->size != pp->size) {
+		if (pp->size && mpp->size != pp->size) {
 			condlog(0, "%s: failed to add new path %s, "
 				"device size mismatch",
 				mpp->alias, pp->dev);
-- 
2.6.6
