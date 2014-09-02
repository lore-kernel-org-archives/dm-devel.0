From: Bernhard Reutner-Fischer <rep.dot.nop@gmail.com>
Subject: [PATCH] libmultipath: Typo in condlog in
	select_flush_on_last_del
Date: Tue,  2 Sep 2014 12:27:40 +0200
Message-ID: <1409653660-21574-1-git-send-email-rep.dot.nop@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: christophe.varoqui@opensvc.com
Cc: Bernhard Reutner-Fischer <rep.dot.nop@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

s/controler/controller/g

Signed-off-by: Bernhard Reutner-Fischer <rep.dot.nop@gmail.com>
---
 libmultipath/propsel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index ee6cea6..e23d65c 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -630,7 +630,7 @@ select_flush_on_last_del(struct multipath *mp)
 	}
 	if (mp->hwe && mp->hwe->flush_on_last_del != FLUSH_UNDEF) {
 		mp->flush_on_last_del = mp->hwe->flush_on_last_del;
-		condlog(3, "%s: flush_on_last_del = %i (controler setting)",
+		condlog(3, "%s: flush_on_last_del = %i (controller setting)",
 			mp->alias, mp->flush_on_last_del);
 		return 0;
 	}
-- 
1.7.10.4
