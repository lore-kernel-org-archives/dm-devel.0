From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] dm: get rid of smp_mb() after set_current_state()
Date: Wed, 10 Aug 2011 13:52:55 +0900
Message-ID: <1312951975-4523-1-git-send-email-namhyung@gmail.com>
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Since set_current_state() contains a memory barrier in it,
an additional barrier isn't needed.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/dm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 52a8fd8eb17f..2fe3017ba97c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2326,7 +2326,6 @@ static int dm_wait_for_completion(struct mapped_device *md, int interruptible)
 	while (1) {
 		set_current_state(interruptible);
 
-		smp_mb();
 		if (!md_in_flight(md))
 			break;
 
-- 
1.7.6
