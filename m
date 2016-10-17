From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: replace static value with
	default_variable for flush_on_last_del
Date: Mon, 17 Oct 2016 19:09:49 +0200
Message-ID: <20161017170949.27523-1-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index a48b8af..92e4deb 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -597,7 +597,7 @@ load_config (char * file)
 	conf->wwids_file = set_default(DEFAULT_WWIDS_FILE);
 	conf->multipath_dir = set_default(DEFAULT_MULTIPATHDIR);
 	conf->features = set_default(DEFAULT_FEATURES);
-	conf->flush_on_last_del = 0;
+	conf->flush_on_last_del = DEFAULT_FLUSH;
 	conf->attribute_flags = 0;
 	conf->reassign_maps = DEFAULT_REASSIGN_MAPS;
 	conf->checkint = DEFAULT_CHECKINT;
-- 
2.10.1
