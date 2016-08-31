From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 5/9] dm: Add two lockdep_assert_held() statements
Date: Wed, 31 Aug 2016 15:17:04 -0700
Message-ID: <7036781c-db50-de26-a883-ab7e4fd34436@sandisk.com>
References: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Document the locking assumptions for the __bind() and __dm_suspend()
functions.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 090ef31..0775411 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1648,6 +1648,8 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 	struct request_queue *q = md->queue;
 	sector_t size;
 
+	lockdep_assert_held(&md->suspend_lock);
+
 	size = dm_table_get_size(t);
 
 	/*
@@ -2089,6 +2091,8 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
 	bool noflush = suspend_flags & DM_SUSPEND_NOFLUSH_FLAG;
 	int r;
 
+	lockdep_assert_held(&md->suspend_lock);
+
 	/*
 	 * DMF_NOFLUSH_SUSPENDING must be set before presuspend.
 	 * This flag is cleared before dm_suspend returns.
-- 
2.9.3
