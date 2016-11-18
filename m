From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 09/14] dm-mpath: Verify 'm->lock' locking
 assumptions at runtime
Date: Fri, 18 Nov 2016 14:28:49 -0800
Message-ID: <afac3382-c159-db83-f057-086a68897a27@sandisk.com>
References: <32edbd52-5b1a-b093-0195-2ec6fa73cd6f@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <32edbd52-5b1a-b093-0195-2ec6fa73cd6f@sandisk.com>
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

Verify at runtime that __pg_init_all_paths() is called with
multipath.lock held if lockdep is enabled.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm-mpath.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index e477af8..f1e226d 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -348,6 +348,8 @@ static int __pg_init_all_paths(struct multipath *m)
 	struct pgpath *pgpath;
 	unsigned long pg_init_delay = 0;
 
+	lockdep_assert_held(&m->lock);
+
 	if (atomic_read(&m->pg_init_in_progress) || test_bit(MPATHF_PG_INIT_DISABLED, &m->flags))
 		return 0;
 
-- 
2.10.1
