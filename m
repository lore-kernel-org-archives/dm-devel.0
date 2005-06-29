From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: mirroring: [patch 8 of 8] device failure tolerance
Date: Wed, 29 Jun 2005 13:40:22 -0500
Message-ID: <fa8a3c0d91263b0b73975520e459f44c@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v622)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Kergon Alasdair <agk@redhat.com>
List-Id: dm-devel.ids

This patch has some minor aesthetic clean-ups.

  brassow

diff -urN linux-2.6.12-007/drivers/md/dm-raid1.c 
linux-2.6.12-008/drivers/md/dm-raid1.c
--- linux-2.6.12-007/drivers/md/dm-raid1.c	2005-06-29 
12:08:09.838784593 -0500
+++ linux-2.6.12-008/drivers/md/dm-raid1.c	2005-06-29 
12:40:44.060997507 -0500
@@ -469,7 +469,6 @@
  	/* Already quiesced ? */
  	if (atomic_read(&reg->pending))
  		list_del_init(&reg->list);
-
  	else {
  		list_del_init(&reg->list);
  		list_add(&reg->list, &rh->quiesced_regions);
@@ -643,7 +642,7 @@
  {
  	int r;
  	unsigned int i;
-	struct io_region from, to[KCOPYD_MAX_REGIONS], *dest;
+	struct io_region from, to[ms->nr_mirrors - 1], *dest;
  	struct mirror *m;
  	unsigned long flags = 0;

@@ -1183,6 +1182,7 @@
  		      unsigned int mirror, char **argv)
  {
  	sector_t offset;
+	struct mirror *m = ms->mirror + mirror;

  	if (sscanf(argv[1], SECTOR_FORMAT, &offset) != 1) {
  		ti->error = "dm-mirror: Invalid offset";
@@ -1190,15 +1190,14 @@
  	}

  	if (dm_get_device(ti, argv[0], offset, ti->len,
-			  dm_table_get_mode(ti->table),
-			  &ms->mirror[mirror].dev)) {
+			  dm_table_get_mode(ti->table), &m->dev)) {
  		ti->error = "dm-mirror: Device lookup failure";
  		return -ENXIO;
  	}

-	ms->mirror[mirror].offset = offset;
-	atomic_set(&(ms->mirror[mirror].error_count), 0);
-	ms->mirror[mirror].ms = ms;
+	m->offset = offset;
+	atomic_set(&m->error_count, 0);
+	m->ms = ms;

  	return 0;
  }
@@ -1287,7 +1286,7 @@
  	argc -= args_used;

  	if (!argc || sscanf(argv[0], "%u", &nr_mirrors) != 1 ||
-	    nr_mirrors < 2 || nr_mirrors > KCOPYD_MAX_REGIONS + 1) {
+	    nr_mirrors < 2 || nr_mirrors > KCOPYD_MAX_REGIONS) {
  		ti->error = "dm-mirror: Invalid number of mirrors";
  		dm_destroy_dirty_log(dl);
  		return -EINVAL;
@@ -1498,9 +1497,11 @@
  {
  	struct mirror_set *ms = (struct mirror_set *) ti->private;
  	struct dirty_log *log = ms->rh.log;
+
  	if (log->type->resume && log->type->resume(log))
  		/* FIXME: need better error handling */
  		DMWARN("log resume failed");
+
  	rh_start_recovery(&ms->rh);
  	atomic_set(&ms->suspended, 0);
  }
