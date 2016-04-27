From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 49/57] multipathd: do not flush maps on startup
Date: Wed, 27 Apr 2016 13:10:50 +0200
Message-ID: <1461755458-29225-50-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

When the daemon is started prior to udev the paths are not present
(yet). However, the maps themselves will be read from device-mapper.
This causes existing maps to be dropped in coalesce_maps(), only
to be reinstated later when all paths are discovered.
To avoid this we should be checking for a valid hardware entry
per multipath map; if there is none we're in startup and shouldn't
drop any maps.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 1141fb6..33a3503 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -155,7 +155,7 @@ coalesce_maps(struct vectors *vecs, vector nmpv)
 
 	vector_foreach_slot (ompv, ompp, i) {
 		condlog(3, "%s: coalesce map", ompp->alias);
-		if (!find_mp_by_wwid(nmpv, ompp->wwid)) {
+		if (ompp->hwe && !find_mp_by_wwid(nmpv, ompp->wwid)) {
 			/*
 			 * remove all current maps not allowed by the
 			 * current configuration
-- 
2.6.6
