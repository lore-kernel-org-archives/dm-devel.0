From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 09/13] dm-mpath: Verify locking assumptions at
	runtime
Date: Wed, 26 Apr 2017 11:37:24 -0700
Message-ID: <20170426183728.10821-10-bart.vanassche@sandisk.com>
References: <20170426183728.10821-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170426183728.10821-1-bart.vanassche@sandisk.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

Verify at runtime that __pg_init_all_paths() is called with
multipath.lock held if lockdep is enabled.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/md/dm-mpath.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index fb4b7228fe5f..312d4fc34430 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -298,6 +298,8 @@ static int __pg_init_all_paths(struct multipath *m)
 	struct pgpath *pgpath;
 	unsigned long pg_init_delay = 0;
 
+	lockdep_assert_held(&m->lock);
+
 	if (atomic_read(&m->pg_init_in_progress) || test_bit(MPATHF_PG_INIT_DISABLED, &m->flags))
 		return 0;
 
-- 
2.12.2
