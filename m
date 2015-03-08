From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 14/15] Fix doublee free of alias after map add
	failure
Date: Sat,  7 Mar 2015 21:31:45 -0600
Message-ID: <1425785506-20419-15-git-send-email-bmarzins@redhat.com>
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

In ev_add_map(), if add_map_without_path() fails, the alias will have
been freed by free_multipath(), so you can't access it anymore. Also,
if the multipath device already exists, but you fail to register it,
there's no point in trying to create the device. It will fail.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index aac8a19..62339ae 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -314,10 +314,15 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
 	/*
 	 * now we can register the map
 	 */
-	if (map_present && (mpp = add_map_without_path(vecs, alias))) {
-		sync_map_state(mpp);
-		condlog(2, "%s: devmap %s registered", alias, dev);
-		return 0;
+	if (map_present) {
+		if ((mpp = add_map_without_path(vecs, alias))) {
+			sync_map_state(mpp);
+			condlog(2, "%s: devmap %s registered", alias, dev);
+			return 0;
+		} else {
+			condlog(2, "%s: uev_add_map failed", dev);
+			return 1;
+		}
 	}
 	r = get_refwwid(dev, DEV_DEVMAP, vecs->pathvec, &refwwid);
 
-- 
1.8.3.1
