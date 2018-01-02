From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH -next] dm raid: make local symbol raid_sets static
Date: Tue, 2 Jan 2018 06:18:10 +0000
Message-ID: <1514873890-69039-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Fixes the following sparse warning:

drivers/md/dm-raid.c:33:1: warning:
 symbol 'raid_sets' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index a96ca44..7ef469e 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -30,7 +30,7 @@
 #define	MIN_RAID456_JOURNAL_SPACE (4*2048)
 
 /* Global list of all raid sets */
-LIST_HEAD(raid_sets);
+static LIST_HEAD(raid_sets);
 
 static bool devices_handle_discard_safely = false;
