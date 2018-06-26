From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: update Hitachi maintainer email
Date: Tue, 26 Jun 2018 15:52:31 +0200
Message-ID: <20180626135231.10793-1-xose.vazquez@gmail.com>
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
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>, Matthias Rudolph <matthias.rudolph@hds.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, DM-DEV ML <dm-devel@redhat.com>
List-Id: dm-devel.ids

Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Cc: Matthias Rudolph <matthias.rudolph@hds.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEV ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 287d501..07dd6b6 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -392,10 +392,10 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 10,
 	},
 	/*
-	 * Hitachi
+	 * Hitachi Vantara
 	 *
 	 * Maintainer : Matthias Rudolph
-	 * Mail : matthias.rudolph@hds.com
+	 * Mail : Matthias.Rudolph@hitachivantara.com
 	 */
 	{
 		/* USP-V, HUS VM, VSP, VSP G1X00 and VSP GX00 families / HP XP */
-- 
2.17.1
