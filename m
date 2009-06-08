From: Kiyoshi Ueda via agk <k-ueda@ct.jp.nec.com>
Subject: rqdm-dlb-04-service-time-dlb-maxlen-type-fix.patch
Date: Mon, 8 Jun 2009 23:04:16 +0100
Message-ID: <20090608220416.GC647@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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


Use 'unsigned' instead of 'unsigned int' for maxlen in dm-service-time.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm-service-time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6.30-rc5/drivers/md/dm-service-time.c
===================================================================
--- 2.6.30-rc5.orig/drivers/md/dm-service-time.c
+++ 2.6.30-rc5/drivers/md/dm-service-time.c
@@ -72,7 +72,7 @@ static void st_destroy(struct path_selec
 }
 
 static int st_status(struct path_selector *ps, struct dm_path *path,
-		     status_type_t type, char *result, unsigned int maxlen)
+		     status_type_t type, char *result, unsigned maxlen)
 {
 	unsigned sz = 0;
 	struct path_info *pi;
