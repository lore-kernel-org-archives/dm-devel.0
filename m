From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: delete examples from
	mpathpersist output
Date: Fri, 26 Jul 2019 21:19:29 +0200
Message-ID: <20190726191930.23630-2-xose.vazquez@gmail.com>
References: <20190726191930.23630-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190726191930.23630-1-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: DM-DEVEL ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

The manual page is more complete and detailed.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 mpathpersist/main.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 5ad06a9..c451855 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -844,12 +844,7 @@ static void usage(void)
 			"    --reserve|-R               PR Out: Reserve\n"
 			"    --transport-id=TIDS|-X TIDS  TransportIDs can be mentioned\n"
 			"                                 in several forms\n"
-			"    --alloc-length=LEN|-l LEN  PR In: maximum allocation length\n"
-			" Examples:\n"
-			"     mpathpersist --out --register --param-sark=123abc --prout-type=5 /dev/mapper/mpath9\n"
-			"     mpathpersist -i -k /dev/mapper/mpath9\n"
-			"     mpathpersist --out --reserve --param-sark=123abc --prout-type=8 -d /dev/mapper/mpath9\n"
-			"     mpathpersist -i -s -d /dev/mapper/mpath9\n");
+			"    --alloc-length=LEN|-l LEN  PR In: maximum allocation length\n");
 }
 
 void
-- 
2.21.0
