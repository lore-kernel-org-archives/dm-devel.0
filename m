From: "Milan P. Gandhi" <mgandhi@redhat.com>
Subject: [PATCH] multipath/main.c fix a minor typo
Date: Fri, 1 Jul 2016 16:47:02 +0530
Message-ID: <1911e0e1-006d-1946-e157-afa8b9a5b4df@redhat.com>
Reply-To: mgandhi@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello, Below patch fixes a minor typo in multipath/main.c

Thanks,
Milan.

Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
---

diff --git a/multipath/main.c b/multipath/main.c
index aadebec..7d23521 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -288,7 +288,7 @@ configure (void)
 			if (failed == 2 && conf->cmd == CMD_VALID_PATH)
 				printf("%s is not a valid multipath device path\n", conf->dev);
 			else
-				condlog(3, "scope is nul");
+				condlog(3, "scope is null");
 			goto out;
 		}
 		if (conf->cmd == CMD_REMOVE_WWID) {
@@ -360,7 +360,7 @@ configure (void)
 
 
 	if (conf->cmd == CMD_VALID_PATH) {
-		/* This only happens if find_multipaths is and
+		/* This only happens if find_multipaths and
 		 * ignore_wwids is set.
 		 * If there is currently a multipath device matching
 		 * the refwwid, or there is more than one path matching
