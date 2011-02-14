From: Miklos Vajna <vmiklos@ulx.hu>
Subject: Re: Improving dm-mirror as a final year project
Date: Mon, 14 Feb 2011 18:33:52 +0100
Message-ID: <20110214173352.GJ5980@genesis.frugalware.org>
References: <20110125155342.GG26864@genesis.frugalware.org>
	<63C70D40-54EE-40A2-98B9-82E06A956941@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="pQjS7IR0m4/DQQ0Q"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <63C70D40-54EE-40A2-98B9-82E06A956941@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--pQjS7IR0m4/DQQ0Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 01, 2011 at 10:12:36AM -0600, Jonathan Brassow <jbrassow@redhat.com> wrote:
> > I do not yet have the right to send those patches (I do this in
> > university time, so the copyright is not mine), but I hope to be  
> > able to
> > do so - to get them reviewed.

Hi,

I'm attaching the two patches. I tested these on RHEL5, but I don't
think there are major changes in newer versions, either.

If that's the only problem, I can test it on latest linux-2.6.git.

Any feedback is welcome. :)

Thanks,

Miklos

--pQjS7IR0m4/DQQ0Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-dm-mirror-allow-setting-ios-count-to-0.patch"

From 2a5aaeef1caed0019abdce92fdb6e6a4413677f8 Mon Sep 17 00:00:00 2001
From: Miklos Vajna <vmiklos@ulx.hu>
Date: Sat, 25 Sep 2010 14:56:28 +0200
Subject: [PATCH] dm-mirror: allow setting ios count to 0

Always read from the default_mirror in that case. This can help in case
the default_mirror is way faster than the other data leg.

Signed-off-by: Miklos Vajna <vmiklos@ulx.hu>
---
 drivers/md/dm-raid1.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 23c1d65..318899e 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -849,6 +849,15 @@ static struct mirror *choose_mirror(struct mirror_set *ms)
 	 * the first we tried, so we know when we're done.
 	 */
 	ret = start_mirror = ms->read_mirror;
+
+	/*
+	 * If MIN_READS is zero, then always use the default one.
+	 */
+	if (!atomic_read(&ms->rr_ios_set)) {
+		ret = ms->default_mirror;
+		goto use_mirror;
+	}
+
 	do {
 		if (likely(!atomic_read(&ret->error_count) &&
 			   !atomic_dec_and_test(&ms->rr_ios)))
@@ -1848,8 +1857,10 @@ static int mirror_message(struct dm_target *ti, unsigned argc, char **argv)
 
 	if (sscanf(argv[3], "%u", &rr_ios_set) != 1 ||
 	    rr_ios_set < 2) {
-		DMERR("Round robin read ios have to be > 1");
-		return -EINVAL;
+		if (rr_ios_set != 0) {
+			DMERR("Round robin read ios have to be > 1 or 0");
+			return -EINVAL;
+		}
 	}
 
 	md = dm_table_get_md(ti->table);
-- 
1.5.5.6


--pQjS7IR0m4/DQQ0Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-dm-mirror-allow-setting-the-default-mirror.patch"

From 02c399b2171dec66d7c014caa1efbc58c0ba8ee1 Mon Sep 17 00:00:00 2001
From: Miklos Vajna <vmiklos@ulx.hu>
Date: Sat, 25 Sep 2010 17:16:11 +0200
Subject: [PATCH] dm-mirror: allow setting the default mirror

This can help in case an other data leg is faster than the default one
and the ios count is set to zero.

Signed-off-by: Miklos Vajna <vmiklos@ulx.hu>
---
 drivers/md/dm-raid1.c |   54 +++++++++++++++++++++++++++++++-----------------
 1 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 318899e..b746b0c 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1845,31 +1845,47 @@ static void mirror_resume(struct dm_target *ti)
 /* Set round robin ios via message. */
 static int mirror_message(struct dm_target *ti, unsigned argc, char **argv)
 {
-	unsigned rr_ios_set;
 	struct mirror_set *ms = ti->private;
 	struct mapped_device *md;
 
-	if (argc != 4 ||
-	    strncmp(argv[0], "io_balance", strlen(argv[0])) ||
-	    strncmp(argv[1], "round_robin", strlen(argv[1])) ||
-	    strncmp(argv[2], "ios", strlen(argv[2])))
-		return -EINVAL;
-
-	if (sscanf(argv[3], "%u", &rr_ios_set) != 1 ||
-	    rr_ios_set < 2) {
-		if (rr_ios_set != 0) {
-			DMERR("Round robin read ios have to be > 1 or 0");
-			return -EINVAL;
+	if (argc == 4 &&
+	    !strncmp(argv[0], "io_balance", strlen(argv[0])) &&
+	    !strncmp(argv[1], "round_robin", strlen(argv[1])) &&
+	    !strncmp(argv[2], "ios", strlen(argv[2]))) {
+		unsigned rr_ios_set;
+		if (sscanf(argv[3], "%u", &rr_ios_set) != 1 ||
+				rr_ios_set < 2) {
+			if (rr_ios_set != 0) {
+				DMERR("Round robin read ios have to be > 1 or 0");
+				return -EINVAL;
+			}
 		}
+
+		md = dm_table_get_md(ti->table);
+		DMINFO("Setting round robin read ios for \"%s\" to %u",
+				dm_device_name(md), rr_ios_set);
+		dm_put(md);
+		atomic_set(&ms->rr_ios_set, rr_ios_set);
+		atomic_set(&ms->rr_ios, rr_ios_set);
+		return 0;
 	}
 
-	md = dm_table_get_md(ti->table);
-	DMINFO("Setting round robin read ios for \"%s\" to %u",
-	        dm_device_name(md), rr_ios_set);
-	dm_put(md);
-	atomic_set(&ms->rr_ios_set, rr_ios_set);
-	atomic_set(&ms->rr_ios, rr_ios_set);
-	return 0;
+	if (argc == 3 &&
+		!strncmp(argv[0], "io_balance", strlen(argv[0])) &&
+		!strncmp(argv[1], "default", strlen(argv[1]))) {
+		unsigned int m;
+		for (m = 0; m < ms->nr_mirrors; m++)
+			if (!strncmp(argv[2], ms->mirror[m].dev->name, strlen(argv[2]))) {
+				ms->default_mirror = &ms->mirror[m];
+				md = dm_table_get_md(ti->table);
+				DMINFO("Setting default device for \"%s\" to \"%s\"",
+						dm_device_name(md), argv[2]);
+				dm_put(md);
+				return 0;
+			}
+	}
+
+	return -EINVAL;
 }
 
 /*
-- 
1.5.5.6


--pQjS7IR0m4/DQQ0Q
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--pQjS7IR0m4/DQQ0Q--
