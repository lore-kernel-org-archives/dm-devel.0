From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH RFC] multipath-tools: add cciss_tur checker to
	CCISS arrays
Date: Thu,  5 Jul 2018 20:56:22 +0200
Message-ID: <20180705185622.5996-1-xose.vazquez@gmail.com>
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
Cc: DM-DEV ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

In cf87a17ee840aafbbc6166f663963e5213573de7 Hannes says:
   
  The 'normal' SG_IO tur checker has some issues with cciss, so
  we'd better use a dedicated path checker here.

CC: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEV ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---

cciss(block) driver was replaced by hpsa(scsi) in
253d2464df446456c0bba5ed4137a7be0b278aa8 the last year.

Should cciss be removed from multipath-tools?

---
 libmultipath/hwtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index d3a8d9b..c460d29 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -199,11 +199,12 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* Smart Array */
+		/* Smart Array CCISS */
 		.vendor        = "HP",
 		.product       = "LOGICAL VOLUME",
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 12,
+		.checker_name  = CCISS_TUR,
 	},
 	{
 		/* P2000 family */
-- 
2.17.1
