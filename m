From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] Add barrier support to dm-raid
Date: Tue, 28 Feb 2012 07:57:29 -0600
Message-ID: <1330437449.9910.2.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org
Cc: agk@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

Add barrier support to dm-raid.

MD has support for barriers.  DM core has support for barriers.  Set the
variable necessary to indicate to DM core that it is ok to pass down
barrier requests - which dm-raid will simply pass along to MD.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/dm-raid.c
===================================================================
--- linux-upstream.orig/drivers/md/dm-raid.c
+++ linux-upstream/drivers/md/dm-raid.c
@@ -971,6 +971,7 @@ static int raid_ctr(struct dm_target *ti
 
 	INIT_WORK(&rs->md.event_work, do_table_event);
 	ti->private = rs;
+	ti->num_flush_requests = 1;
 
 	mutex_lock(&rs->md.reconfig_mutex);
 	ret = md_run(&rs->md);


