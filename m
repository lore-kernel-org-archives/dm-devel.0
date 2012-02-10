From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: don't remove map twice
Date: Fri, 10 Feb 2012 12:13:12 -0600
Message-ID: <20120210181312.GO1241@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

If setup_mutipath fails, it removes the map itself, so don't try to again.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: multipath-tools-120123/multipathd/main.c
===================================================================
--- multipath-tools-120123.orig/multipathd/main.c
+++ multipath-tools-120123/multipathd/main.c
@@ -518,7 +518,7 @@ rescan:
 	 * update our state from kernel regardless of create or reload
 	 */
 	if (setup_multipath(vecs, mpp))
-		goto fail_map;
+		goto fail; /* if setup_multipath fails, it removes the map */
 
 	sync_map_state(mpp);
 
