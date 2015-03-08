From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 10/15] multipath: blacklist virtio-blk devices
Date: Sat,  7 Mar 2015 21:31:41 -0600
Message-ID: <1425785506-20419-11-git-send-email-bmarzins@redhat.com>
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

virtio-blk devices don't report anything to use as a WWID, so
multipath shouldn't waste it's time checking them.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/blacklist.c | 2 +-
 multipath.conf.defaults  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 05f1697..cea128c 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -178,7 +178,7 @@ setup_default_blist (struct config * conf)
 	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
 		return 1;
 
-	str = STRDUP("^(td|hd)[a-z]");
+	str = STRDUP("^(td|hd|vd)[a-z]");
 	if (!str)
 		return 1;
 	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
diff --git a/multipath.conf.defaults b/multipath.conf.defaults
index cf8cfdb..5e46fd8 100644
--- a/multipath.conf.defaults
+++ b/multipath.conf.defaults
@@ -29,7 +29,7 @@
 #}
 #blacklist {
 #	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
-#	devnode "^hd[a-z]"
+#	devnode "^(td|hd|vd)[a-z]"
 #	devnode "^dcssblk[0-9]*"
 #	devnode "^nvme.*"
 #	device {
-- 
1.8.3.1
