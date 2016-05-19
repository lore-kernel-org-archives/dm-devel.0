From: heinzm@redhat.com
Subject: [PATCH 04/11] dm-raid: check constructor arguments for
	invalid raid level/argument combinations
Date: Thu, 19 May 2016 18:49:27 +0200
Message-ID: <1463676574-12596-5-git-send-email-heinzm@redhat.com>
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
To: dm-devel@redhat.com
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Reject invalid flag combinations to avoid potential
data corruption or failing raid set construction:

 - add definitions for constructor flag combinations and invalid flags per level

 - add bool test functions for the various raid types
   (also will be used by future reshaping enhancements) 

 - introduce rs_check_for_invalid_flags() and _invalid_flags()
   to perform the validity checks

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 133 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 132 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index c99ef1b..ba04db4 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -64,6 +64,61 @@ struct raid_dev {
 #define CTR_FLAG_RAID10_COPIES     0x400 /* 2 */ /* Only with raid10 */
 #define CTR_FLAG_RAID10_FORMAT     0x800 /* 2 */ /* Only with raid10 */
 
+/*
+ * Definitions of various constructor flags to
+ * be used in checks of valid / invalid flags
+ * per raid level.
+ */
+/* Define all any sync flags */
+#define	CTR_FLAGS_ANY_SYNC		(CTR_FLAG_SYNC | CTR_FLAG_NOSYNC)
+
+/* Define flags for options without argument (e.g. 'nosync') */
+#define	CTR_FLAG_OPTIONS_NO_ARGS	CTR_FLAGS_ANY_SYNC
+
+/* Define flags for options with one argument (e.g. 'delta_disks +2') */
+#define CTR_FLAG_OPTIONS_ONE_ARG (CTR_FLAG_REBUILD | \
+				  CTR_FLAG_WRITE_MOSTLY | \
+				  CTR_FLAG_DAEMON_SLEEP | \
+				  CTR_FLAG_MIN_RECOVERY_RATE | \
+				  CTR_FLAG_MAX_RECOVERY_RATE | \
+				  CTR_FLAG_MAX_WRITE_BEHIND | \
+				  CTR_FLAG_STRIPE_CACHE | \
+				  CTR_FLAG_REGION_SIZE | \
+				  CTR_FLAG_RAID10_COPIES | \
+				  CTR_FLAG_RAID10_FORMAT)
+
+/* All ctr optional arguments */
+#define ALL_CTR_FLAGS		(CTR_FLAG_OPTIONS_NO_ARGS | \
+				 CTR_FLAG_OPTIONS_ONE_ARG)
+
+/* Invalid options definitions per raid level... */
+
+/* "raid0" does not accept any options */
+#define RAID0_INVALID_FLAGS ALL_CTR_FLAGS
+
+/* "raid1" does not accept stripe cache or any raid10 options */
+#define RAID1_INVALID_FLAGS	(CTR_FLAG_STRIPE_CACHE | \
+				 CTR_FLAG_RAID10_COPIES | \
+				 CTR_FLAG_RAID10_FORMAT)
+
+/* "raid10" does not accept any raid1 or stripe cache options */
+#define RAID10_INVALID_FLAGS	(CTR_FLAG_WRITE_MOSTLY | \
+				 CTR_FLAG_MAX_WRITE_BEHIND | \
+				 CTR_FLAG_STRIPE_CACHE)
+/*
+ * "raid4/5/6" do not accept any raid1 or raid10 specific options
+ *
+ * "raid6" does not accept "nosync", because it is not guaranteed
+ * that both parity and q-syndrome are being written properly with
+ * any writes
+ */
+#define RAID45_INVALID_FLAGS	(CTR_FLAG_WRITE_MOSTLY | \
+				 CTR_FLAG_MAX_WRITE_BEHIND | \
+				 CTR_FLAG_RAID10_FORMAT | \
+				 CTR_FLAG_RAID10_COPIES)
+#define RAID6_INVALID_FLAGS	(CTR_FLAG_NOSYNC | RAID45_INVALID_FLAGS)
+/* ...invalid options definitions per raid level */
+
 struct raid_set {
 	struct dm_target *ti;
 
@@ -167,6 +222,41 @@ static const char *_argname_by_flag(const uint32_t flag)
 }
 
 /*
+ * bool helpers to test for various raid levels of a raid type
+ */
+
+/* Return true, if raid type in @rt is raid0 */
+static bool rt_is_raid0(struct raid_type *rt)
+{
+	return !rt->level;
+}
+
+/* Return true, if raid type in @rt is raid1 */
+static bool rt_is_raid1(struct raid_type *rt)
+{
+	return rt->level == 1;
+}
+
+/* Return true, if raid type in @rt is raid10 */
+static bool rt_is_raid10(struct raid_type *rt)
+{
+	return rt->level == 10;
+}
+
+/* Return true, if raid type in @rt is raid4/5 */
+static bool rt_is_raid45(struct raid_type *rt)
+{
+	return _in_range(rt->level, 4, 5);
+}
+
+/* Return true, if raid type in @rt is raid6 */
+static bool rt_is_raid6(struct raid_type *rt)
+{
+	return rt->level == 6;
+}
+/* END: raid level bools */
+
+/*
  * Convenience functions to set ti->error to @errmsg and
  * return @r in order to shorten code in a lot of places
  */
@@ -182,6 +272,46 @@ static int ti_error_einval(struct dm_target *ti, const char *errmsg)
 }
 /* END: convenience functions to set ti->error to @errmsg... */
 
+/* Return invalid ctr flags for the raid level of @rs */
+static uint32_t _invalid_flags(struct raid_set *rs)
+{
+	if (rt_is_raid0(rs->raid_type))
+		return RAID0_INVALID_FLAGS;
+	else if (rt_is_raid1(rs->raid_type))
+		return RAID1_INVALID_FLAGS;
+	else if (rt_is_raid10(rs->raid_type))
+		return RAID10_INVALID_FLAGS;
+	else if (rt_is_raid45(rs->raid_type))
+		return RAID45_INVALID_FLAGS;
+	else if (rt_is_raid6(rs->raid_type))
+		return RAID6_INVALID_FLAGS;
+
+	DMERR("%s BUG();called on bogus raid set!", __func__);
+
+	return ~0;
+}
+
+/*
+ * Check for any invalid flags set on @rs defined by bitset @invalid_flags
+ *
+ * Has to be called after parsing of the ctr flags!
+ */
+static int rs_check_for_invalid_flags(struct raid_set *rs)
+{
+	unsigned int ctr_flags = rs->ctr_flags, flag = 0;
+	const uint32_t invalid_flags = _invalid_flags(rs);
+
+	while ((ctr_flags &= ~flag)) {
+		flag = 1 << __ffs(ctr_flags);
+
+		if (_test_flag(flag, rs->ctr_flags) &&
+		    _test_flag(flag, invalid_flags))
+			return ti_error_einval(rs->ti, "Invalid flag combined");
+	}
+
+	return 0;
+}
+
 static char *raid10_md_layout_to_format(int layout)
 {
 	/*
@@ -806,7 +936,8 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 	rs->md.persistent = 0;
 	rs->md.external = 1;
 
-	return 0;
+	/* Check, if any invalid ctr arguments have been passed in for the raid level */
+	return rs_check_for_invalid_flags(rs);
 }
 
 static void do_table_event(struct work_struct *ws)
-- 
2.5.5
