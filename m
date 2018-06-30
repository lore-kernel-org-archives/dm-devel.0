From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add directio path_checker for
	DASD devices
Date: Sun,  1 Jul 2018 00:50:01 +0200
Message-ID: <20180630225001.15354-1-xose.vazquez@gmail.com>
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

tur(default) is only for SCSI devices.

CC: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEV ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 8499c2f..f012dea 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -625,6 +625,7 @@ static struct hwentry default_hw[] = {
 		.uid_attribute = "ID_UID",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = MULTIBUS,
+		.checker_name  = DIRECTIO,
 	},
 	{
 		/* DS6000/DS8000 DASD FBA */
@@ -634,6 +635,7 @@ static struct hwentry default_hw[] = {
 		.uid_attribute = "ID_UID",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = MULTIBUS,
+		.checker_name  = DIRECTIO,
 	},
 	{
 		/* Power RAID */
-- 
2.17.1
