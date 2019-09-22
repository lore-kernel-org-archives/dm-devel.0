From: Maged Mokhtar <mmokhtar@petasan.org>
Subject: [PATCH] dm-writecache: change config parameters using
 messages
Date: Sun, 22 Sep 2019 21:39:06 +0200
Message-ID: <fa95f1f0-67d6-d02e-6999-ba1f90d70fe2@petasan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mpatocka@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Support changing configuration parameters using device-mapper messages
E.g.
    dmsetup message vg1/lv1 0 high_watermark 60

Signed-off-by: Maged Mokhtar <mmokhtar@petasan.org>
---
  drivers/md/dm-writecache.c |   68 +++++++++++++++++++++++++++++++++++
  1 file changed, 68 insertions(+)

--- a/drivers/md/dm-writecache.c	2019-08-25 16:13:54.000000000 +0200
+++ b/drivers/md/dm-writecache.c	2019-09-21 16:22:23.000000000 +0200
@@ -1009,6 +1009,69 @@ static int process_flush_on_suspend_mesg
  	return 0;
  }

+static int set_config_value(struct dm_writecache *wc, char *key, char *val)
+{
+	unsigned v,x;
+	if (sscanf(val, "%u", &v) != 1)
+		return -EINVAL;
+	if (!strcasecmp(key, "high_watermark")) {
+		if (v < 0 || v > 100)
+			return -EINVAL;
+		wc_lock(wc);
+		x = (uint64_t)wc->n_blocks * (100 - v);
+		x += 50;
+		do_div(x, 100);
+		if (wc->freelist_low_watermark < x) {
+			wc_unlock(wc);
+			return -EINVAL;
+		}
+		wc->freelist_high_watermark = x;
+		wc->high_wm_percent_set = true;
+		if (wc->freelist_size + wc->writeback_size
+			<= wc->freelist_high_watermark)
+			queue_work(wc->writeback_wq, &wc->writeback_work);
+		wc_unlock(wc);
+	}
+	else if (!strcasecmp(key, "low_watermark")) {
+		if (v < 0 || v > 100)
+			return -EINVAL;
+		wc_lock(wc);
+		x = (uint64_t)wc->n_blocks * (100 - v);
+		x += 50;
+		do_div(x, 100);
+		if (x < wc->freelist_high_watermark) {
+			wc_unlock(wc);
+			return -EINVAL;
+		}
+		wc->freelist_low_watermark = x;
+		wc->low_wm_percent_set = true;
+		wc_unlock(wc);
+	}
+	else if (!strcasecmp(key, "writeback_jobs")) {
+		wc_lock(wc);
+		wc->max_writeback_jobs = v;
+		wc->max_writeback_jobs_set = true;
+		wc_unlock(wc);
+	}
+	else if (!strcasecmp(key, "autocommit_blocks")) {
+		wc_lock(wc);
+		wc->autocommit_blocks = v;
+		wc->autocommit_blocks_set = true;
+		wc_unlock(wc);
+	}
+	else if (!strcasecmp(key, "autocommit_time")) {
+		if (v < 1 || v > 3600000)
+			return -EINVAL;
+		wc_lock(wc);
+		wc->autocommit_jiffies = msecs_to_jiffies(v);
+		wc->autocommit_time_set = true;
+		wc_unlock(wc);
+	}
+	else
+		return -EINVAL;
+	return 0;
+}
+
  static int writecache_message(struct dm_target *ti, unsigned argc, 
char **argv,
  			      char *result, unsigned maxlen)
  {
@@ -1019,6 +1082,11 @@ static int writecache_message(struct dm_
  		r = process_flush_mesg(argc, argv, wc);
  	else if (!strcasecmp(argv[0], "flush_on_suspend"))
  		r = process_flush_on_suspend_mesg(argc, argv, wc);
+	else if (argc==2) {
+		r = set_config_value(wc, argv[0], argv[1]);
+		if (r==-EINVAL)
+			DMERR("invalid message received: %s %s", argv[0], argv[1]);
+	}
  	else
  		DMERR("unrecognised message received: %s", argv[0]);
