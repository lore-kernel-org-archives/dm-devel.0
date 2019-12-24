From: zhengbin <zhengbin13@huawei.com>
Subject: [PATCH 1/4] dm mpath: use true,false for bool variable
Date: Tue, 24 Dec 2019 14:38:00 +0800
Message-ID: <1577169483-138896-2-git-send-email-zhengbin13@huawei.com>
References: <1577169483-138896-1-git-send-email-zhengbin13@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1577169483-138896-1-git-send-email-zhengbin13@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: zhengbin13@huawei.com
List-Id: dm-devel.ids

Fixes coccicheck warning:

drivers/md/dm-mpath.c:1447:2-13: WARNING: Assignment of 0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/md/dm-mpath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index e0c3279..97c0952 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1444,7 +1444,7 @@ static void pg_init_done(void *data, int errors)
 		break;
 	case SCSI_DH_RETRY:
 		/* Wait before retrying. */
-		delay_retry = 1;
+		delay_retry = true;
 		/* fall through */
 	case SCSI_DH_IMM_RETRY:
 	case SCSI_DH_RES_TEMP_UNAVAIL:
--
2.7.4
