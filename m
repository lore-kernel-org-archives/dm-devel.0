From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 7/7] multipathd: only grab conf once for
	filter_path()
Date: Tue, 30 Oct 2018 22:22:49 +0100
Message-ID: <20181030212249.31127-8-mwilck@suse.com>
References: <20181030212249.31127-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181030212249.31127-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

This saves a possibly large number of cleanup push/pop calls and
slightly improves readability.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 2f6aa3f0..6289718d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2334,16 +2334,17 @@ configure (struct vectors * vecs)
 		goto fail;
 	}
 
+	conf = get_multipath_config();
+	pthread_cleanup_push(put_multipath_config, conf);
 	vector_foreach_slot (vecs->pathvec, pp, i){
-		conf = get_multipath_config();
-		pthread_cleanup_push(put_multipath_config, conf);
 		if (filter_path(conf, pp) > 0){
 			vector_del_slot(vecs->pathvec, i);
 			free_path(pp);
 			i--;
 		}
-		pthread_cleanup_pop(1);
 	}
+	pthread_cleanup_pop(1);
+
 	if (map_discovery(vecs)) {
 		condlog(0, "configure failed at map discovery");
 		goto fail;
-- 
2.19.1
