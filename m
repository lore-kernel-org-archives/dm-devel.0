From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 14/16] libmultipath: blacklist blktap devices
Date: Wed, 11 Dec 2013 00:43:08 -0600
Message-ID: <1386744190-1295-15-git-send-email-bmarzins@redhat.com>
References: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
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

Multipath can't run on top of blktap devices, so it should just ignore them.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/blacklist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index d597350..79ddcde 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -164,7 +164,7 @@ setup_default_blist (struct config * conf)
 	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
 		return 1;
 
-	str = STRDUP("^hd[a-z]");
+	str = STRDUP("^(td|hd)[a-z]");
 	if (!str)
 		return 1;
 	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
-- 
1.8.4.2
