From: Sheetal <2396sheetal@gmail.com>
Subject: [PATCH] md : dm: Fixed a brace coding style issue
Date: Fri, 10 May 2019 23:18:37 +0530
Message-ID: <20190510174838.1968-1-2396sheetal@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: person@a.com, Sheetal <2396sheetal@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Fixed a coding style issue.
---
 drivers/md/dm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 043f0761e4a0..2a8820bd581d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -781,7 +781,8 @@ static void close_table_device(struct table_device *td, struct mapped_device *md
 }
 
 static struct table_device *find_table_device(struct list_head *l, dev_t dev,
-					      fmode_t mode) {
+					      fmode_t mode)
+{
 	struct table_device *td;
 
 	list_for_each_entry(td, l, list)
-- 
2.17.1
