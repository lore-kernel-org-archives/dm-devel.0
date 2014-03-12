From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Disable partitions scan for multipathed devices
Date: Wed, 12 Mar 2014 12:48:56 +0100
Message-ID: <1394624936-118530-1-git-send-email-hare@suse.de>
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
To: Alasdair Kergon <agk@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

When multipath devices are being used as disks for VM Guests
any partition scanning / setup should be done within the VM Guest,
not from host. So we need to switch off partitions scanning via
kpartx there.
For this I've implemented a new feature 'no_partitions' which
just serves as a notifier to kpartx to _not_ create partitions
on these devices.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 422a9fd..93154ec 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -88,6 +88,7 @@ struct multipath {
 	unsigned saved_queue_if_no_path:1; /* Saved state during suspension */
 	unsigned retain_attached_hw_handler:1; /* If there's already a hw_handler present, don't change it. */
 	unsigned pg_init_disabled:1;	/* pg_init is not currently allowed */
+	unsigned no_partitions:1;	/* Disable partition scan for kpartx */
 
 	unsigned pg_init_retries;	/* Number of times to retry pg_init */
 	unsigned pg_init_count;		/* Number of times pg_init called */
@@ -818,6 +819,11 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 			continue;
 		}
 
+		if (!strcasecmp(arg_name, "no_partitions")) {
+			m->no_partitions = 1;
+			continue;
+		}
+
 		if (!strcasecmp(arg_name, "pg_init_retries") &&
 		    (argc >= 1)) {
 			r = dm_read_arg(_args + 1, as, &m->pg_init_retries, &ti->error);
@@ -1438,11 +1444,14 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 		DMEMIT("%u ", m->queue_if_no_path +
 			      (m->pg_init_retries > 0) * 2 +
 			      (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT) * 2 +
-			      m->retain_attached_hw_handler);
+			      m->retain_attached_hw_handler +
+			      m->no_partitions);
 		if (m->queue_if_no_path)
 			DMEMIT("queue_if_no_path ");
 		if (m->pg_init_retries)
 			DMEMIT("pg_init_retries %u ", m->pg_init_retries);
+		if (m->no_partitions)
+			DMEMIT("no_partitions ");
 		if (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT)
 			DMEMIT("pg_init_delay_msecs %u ", m->pg_init_delay_msecs);
 		if (m->retain_attached_hw_handler)
-- 
1.7.12.4
