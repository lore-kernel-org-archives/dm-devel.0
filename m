From: zhengbin <zhengbin13@huawei.com>
Subject: [PATCH 2/4] dm bio prison v2: use true,
	false for bool variable
Date: Tue, 24 Dec 2019 14:38:01 +0800
Message-ID: <1577169483-138896-3-git-send-email-zhengbin13@huawei.com>
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

drivers/md/dm-bio-prison-v2.c:327:2-22: WARNING: Assignment of 0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/md/dm-bio-prison-v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-bio-prison-v2.c b/drivers/md/dm-bio-prison-v2.c
index 8ee019e..9dec3b6 100644
--- a/drivers/md/dm-bio-prison-v2.c
+++ b/drivers/md/dm-bio-prison-v2.c
@@ -324,7 +324,7 @@ static bool __unlock(struct dm_bio_prison_v2 *prison,
 	bio_list_init(&cell->bios);

 	if (cell->shared_count) {
-		cell->exclusive_lock = 0;
+		cell->exclusive_lock = false;
 		return false;
 	}

--
2.7.4
