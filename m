From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: Better number validation in sscanf
Date: Wed, 22 Feb 2012 10:53:40 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1202221052450.19488@hs20-bc2-1.build.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

dm: Better number validation in sscanf

Device mapper uses sscanf to convert arguments to numbers. The problem is that
sscanf ignores additional unmatched characters in the scanned string.

For example, this `if (sscanf(string, "%d", &number) == 1)' will match a number,
but also it will match number with some garbage appended, like "123abc".

sscanf is used this way at a lot of places in the device mapper and
as a result, device mapper accepts garbage after some numbers, for example
the command `dmsetup create vg1-new --table "0 16384 linear 254:1bla 34816bla"'
will pass without an error.

This patch fixes all sscanf uses in device mapper. The patch appends "%c" with
a pointer to a dummy character variable to every sscanf statement.

The construct `if (sscanf(string, "%d%c", &number, &dummy) == 1)' succeeds
only if string is a null-terminated number (optinally preceeded by some
whitespace characters). If there is some character appended after the number,
sscanf matches "%c", writes the character to the dummy variable and returns 2.
We check the return value for 1, consequently we reject numbers with some
garbage appended.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c        |    8 +++++---
 drivers/md/dm-delay.c        |    9 +++++----
 drivers/md/dm-flakey.c       |    3 ++-
 drivers/md/dm-ioctl.c        |    5 +++--
 drivers/md/dm-linear.c       |    3 ++-
 drivers/md/dm-log.c          |    3 ++-
 drivers/md/dm-mpath.c        |    6 ++++--
 drivers/md/dm-queue-length.c |    3 ++-
 drivers/md/dm-raid1.c        |   12 ++++++++----
 drivers/md/dm-round-robin.c  |    3 ++-
 drivers/md/dm-service-time.c |    5 +++--
 drivers/md/dm-stripe.c       |    3 ++-
 drivers/md/dm-table.c        |    6 ++++--
 13 files changed, 44 insertions(+), 25 deletions(-)

Index: linux-3.2.7-fast/drivers/md/dm-crypt.c
===================================================================
--- linux-3.2.7-fast.orig/drivers/md/dm-crypt.c	2012-02-22 16:31:43.000000000 +0100
+++ linux-3.2.7-fast/drivers/md/dm-crypt.c	2012-02-22 16:33:39.000000000 +0100
@@ -1413,6 +1413,7 @@ static int crypt_ctr_cipher(struct dm_ta
 	char *tmp, *cipher, *chainmode, *ivmode, *ivopts, *keycount;
 	char *cipher_api = NULL;
 	int cpu, ret = -EINVAL;
+	char dummy;
 
 	/* Convert to crypto api definition? */
 	if (strchr(cipher_in, '(')) {
@@ -1434,7 +1435,7 @@ static int crypt_ctr_cipher(struct dm_ta
 
 	if (!keycount)
 		cc->tfms_count = 1;
-	else if (sscanf(keycount, "%u", &cc->tfms_count) != 1 ||
+	else if (sscanf(keycount, "%u%c", &cc->tfms_count, &dummy) != 1 ||
 		 !is_power_of_2(cc->tfms_count)) {
 		ti->error = "Bad cipher key count specification";
 		return -EINVAL;
@@ -1579,6 +1580,7 @@ static int crypt_ctr(struct dm_target *t
 	int ret;
 	struct dm_arg_set as;
 	const char *opt_string;
+	char dummy;
 
 	static struct dm_arg _args[] = {
 		{0, 1, "Invalid number of feature args"},
@@ -1636,7 +1638,7 @@ static int crypt_ctr(struct dm_target *t
 	}
 
 	ret = -EINVAL;
-	if (sscanf(argv[2], "%llu", &tmpll) != 1) {
+	if (sscanf(argv[2], "%llu%c", &tmpll, &dummy) != 1) {
 		ti->error = "Invalid iv_offset sector";
 		goto bad;
 	}
@@ -1647,7 +1649,7 @@ static int crypt_ctr(struct dm_target *t
 		goto bad;
 	}
 
-	if (sscanf(argv[4], "%llu", &tmpll) != 1) {
+	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) != 1) {
 		ti->error = "Invalid device sector";
 		goto bad;
 	}
Index: linux-3.2.7-fast/drivers/md/dm-delay.c
===================================================================
--- linux-3.2.7-fast.orig/drivers/md/dm-delay.c	2012-02-22 16:31:43.000000000 +0100
+++ linux-3.2.7-fast/drivers/md/dm-delay.c	2012-02-22 16:33:39.000000000 +0100
@@ -131,6 +131,7 @@ static int delay_ctr(struct dm_target *t
 {
 	struct delay_c *dc;
 	unsigned long long tmpll;
+	char dummy;
 
 	if (argc != 3 && argc != 6) {
 		ti->error = "requires exactly 3 or 6 arguments";
@@ -145,13 +146,13 @@ static int delay_ctr(struct dm_target *t
 
 	dc->reads = dc->writes = 0;
 
-	if (sscanf(argv[1], "%llu", &tmpll) != 1) {
+	if (sscanf(argv[1], "%llu%c", &tmpll, &dummy) != 1) {
 		ti->error = "Invalid device sector";
 		goto bad;
 	}
 	dc->start_read = tmpll;
 
-	if (sscanf(argv[2], "%u", &dc->read_delay) != 1) {
+	if (sscanf(argv[2], "%u%c", &dc->read_delay, &dummy) != 1) {
 		ti->error = "Invalid delay";
 		goto bad;
 	}
@@ -166,13 +167,13 @@ static int delay_ctr(struct dm_target *t
 	if (argc == 3)
 		goto out;
 
-	if (sscanf(argv[4], "%llu", &tmpll) != 1) {
+	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) != 1) {
 		ti->error = "Invalid write device sector";
 		goto bad_dev_read;
 	}
 	dc->start_write = tmpll;
 
-	if (sscanf(argv[5], "%u", &dc->write_delay) != 1) {
+	if (sscanf(argv[5], "%u%c", &dc->write_delay, &dummy) != 1) {
 		ti->error = "Invalid write delay";
 		goto bad_dev_read;
 	}
Index: linux-3.2.7-fast/drivers/md/dm-flakey.c
===================================================================
--- linux-3.2.7-fast.orig/drivers/md/dm-flakey.c	2012-02-22 16:31:43.000000000 +0100
+++ linux-3.2.7-fast/drivers/md/dm-flakey.c	2012-02-22 16:33:39.000000000 +0100
@@ -160,6 +160,7 @@ static int flakey_ctr(struct dm_target *
 	unsigned long long tmpll;
 	struct dm_arg_set as;
 	const char *devname;
+	char dummy;
 
 	as.argc = argc;
 	as.argv = argv;
@@ -178,7 +179,7 @@ static int flakey_ctr(struct dm_target *
 
 	devname = dm_shift_arg(&as);
 
-	if (sscanf(dm_shift_arg(&as), "%llu", &tmpll) != 1) {
+	if (sscanf(dm_shift_arg(&as), "%llu%c", &tmpll, &dummy) != 1) {
 		ti->error = "Invalid device sector";
 		goto bad;
 	}
Index: linux-3.2.7-fast/drivers/md/dm-ioctl.c
===================================================================
--- linux-3.2.7-fast.orig/drivers/md/dm-ioctl.c	2012-02-22 16:31:43.000000000 +0100
+++ linux-3.2.7-fast/drivers/md/dm-ioctl.c	2012-02-22 16:33:39.000000000 +0100
@@ -880,6 +880,7 @@ static int dev_set_geometry(struct dm_io
 	struct hd_geometry geometry;
 	unsigned long indata[4];
 	char *geostr = (char *) param + param->data_start;
+	char dummy;
 
 	md = find_device(param);
 	if (!md)
@@ -891,8 +892,8 @@ static int dev_set_geometry(struct dm_io
 		goto out;
 	}
 
-	x = sscanf(geostr, "%lu %lu %lu %lu", indata,
-		   indata + 1, indata + 2, indata + 3);
+	x = sscanf(geostr, "%lu %lu %lu %lu%c", indata,
+		   indata + 1, indata + 2, indata + 3, &dummy);
 
 	if (x != 4) {
 		DMWARN("Unable to interpret geometry settings.");
Index: linux-3.2.7-fast/drivers/md/dm-linear.c
===================================================================
--- linux-3.2.7-fast.orig/drivers/md/dm-linear.c	2012-02-22 16:31:43.000000000 +0100
+++ linux-3.2.7-fast/drivers/md/dm-linear.c	2012-02-22 16:33:39.000000000 +0100
@@ -29,6 +29,7 @@ static int linear_ctr(struct dm_target *
 {
 	struct linear_c *lc;
 	unsigned long long tmp;
+	char dummy;
 
 	if (argc != 2) {
 		ti->error = "Invalid argument count";
@@ -41,7 +42,7 @@ static int linear_ctr(struct dm_target *
 		return -ENOMEM;
 	}
 
-	if (sscanf(argv[1], "%llu", &tmp) != 1) {
+	if (sscanf(argv[1], "%llu%c", &tmp, &dummy) != 1) {
 		ti->error = "dm-linear: Invalid device sector";
 		goto bad;
 	}
Index: linux-3.2.7-fast/drivers/md/dm-log.c
===================================================================
--- linux-3.2.7-fast.orig/drivers/md/dm-log.c	2012-02-22 16:31:43.000000000 +0100
+++ linux-3.2.7-fast/drivers/md/dm-log.c	2012-02-22 16:33:39.000000000 +0100
@@ -369,6 +369,7 @@ static int create_log_context(struct dm_
 	unsigned int region_count;
 	size_t bitset_size, buf_size;
 	int r;
+	char dummy;
 
 	if (argc < 1 || argc > 2) {
 		DMWARN("wrong number of arguments to dirty region log");
@@ -387,7 +388,7 @@ static int create_log_context(struct dm_
 		}
 	}
 
-	if (sscanf(argv[0], "%u", &region_size) != 1 ||
+	if (sscanf(argv[0], "%u%c", &region_size, &dummy) != 1 ||
 	    !_check_region_size(ti, region_size)) {
 		DMWARN("invalid region size %s", argv[0]);
 		return -EINVAL;
Index: linux-3.2.7-fast/drivers/md/dm-mpath.c
===================================================================
--- linux-3.2.7-fast.orig/drivers/md/dm-mpath.c	2012-02-22 16:31:43.000000000 +0100
+++ linux-3.2.7-fast/drivers/md/dm-mpath.c	2012-02-22 16:33:39.000000000 +0100
@@ -1054,8 +1054,9 @@ static int switch_pg_num(struct multipat
 	struct priority_group *pg;
 	unsigned pgnum;
 	unsigned long flags;
+	char dummy;
 
-	if (!pgstr || (sscanf(pgstr, "%u", &pgnum) != 1) || !pgnum ||
+	if (!pgstr || (sscanf(pgstr, "%u%c", &pgnum, &dummy) != 1) || !pgnum ||
 	    (pgnum > m->nr_priority_groups)) {
 		DMWARN("invalid PG number supplied to switch_pg_num");
 		return -EINVAL;
@@ -1085,8 +1086,9 @@ static int bypass_pg_num(struct multipat
 {
 	struct priority_group *pg;
 	unsigned pgnum;
+	char dummy;
 
-	if (!pgstr || (sscanf(pgstr, "%u", &pgnum) != 1) || !pgnum ||
+	if (!pgstr || (sscanf(pgstr, "%u%c", &pgnum, &dummy) != 1) || !pgnum ||
 	    (pgnum > m->nr_priority_groups)) {
 		DMWARN("invalid PG number supplied to bypass_pg");
 		return -EINVAL;
Index: linux-3.2.7-fast/drivers/md/dm-queue-length.c
===================================================================
--- linux-3.2.7-fast.orig/drivers/md/dm-queue-length.c	2012-02-22 16:31:43.000000000 +0100
+++ linux-3.2.7-fast/drivers/md/dm-queue-length.c	2012-02-22 16:33:39.000000000 +0100
@@ -112,6 +112,7 @@ static int ql_add_path(struct path_selec
 	struct selector *s = ps->context;
 	struct path_info *pi;
 	unsigned repeat_count = QL_MIN_IO;
+	char dummy;
 
 	/*
 	 * Arguments: [<repeat_count>]
@@ -123,7 +124,7 @@ static int ql_add_path(struct path_selec
 		return -EINVAL;
 	}
 
-	if ((argc == 1) && (sscanf(argv[0], "%u", &repeat_count) != 1)) {
+	if ((argc == 1) && (sscanf(argv[0], "%u%c", &repeat_count, &dummy) != 1)) {
 		*error = "queue-length ps: invalid repeat count";
 		return -EINVAL;
 	}
Index: linux-3.2.7-fast/drivers/md/dm-raid1.c
===================================================================
--- linux-3.2.7-fast.orig/drivers/md/dm-raid1.c	2012-02-22 16:31:43.000000000 +0100
+++ linux-3.2.7-fast/drivers/md/dm-raid1.c	2012-02-22 16:33:39.000000000 +0100
@@ -927,8 +927,9 @@ static int get_mirror(struct mirror_set 
 		      unsigned int mirror, char **argv)
 {
 	unsigned long long offset;
+	char dummy;
 
-	if (sscanf(argv[1], "%llu", &offset) != 1) {
+	if (sscanf(argv[1], "%llu%c", &offset, &dummy) != 1) {
 		ti->error = "Invalid offset";
 		return -EINVAL;
 	}
@@ -956,13 +957,14 @@ static struct dm_dirty_log *create_dirty
 {
 	unsigned param_count;
 	struct dm_dirty_log *dl;
+	char dummy;
 
 	if (argc < 2) {
 		ti->error = "Insufficient mirror log arguments";
 		return NULL;
 	}
 
-	if (sscanf(argv[1], "%u", &param_count) != 1) {
+	if (sscanf(argv[1], "%u%c", &param_count, &dummy) != 1) {
 		ti->error = "Invalid mirror log argument count";
 		return NULL;
 	}
@@ -989,13 +991,14 @@ static int parse_features(struct mirror_
 {
 	unsigned num_features;
 	struct dm_target *ti = ms->ti;
+	char dummy;
 
 	*args_used = 0;
 
 	if (!argc)
 		return 0;
 
-	if (sscanf(argv[0], "%u", &num_features) != 1) {
+	if (sscanf(argv[0], "%u%c", &num_features, &dummy) != 1) {
 		ti->error = "Invalid number of features";
 		return -EINVAL;
 	}
@@ -1039,6 +1042,7 @@ static int mirror_ctr(struct dm_target *
 	unsigned int nr_mirrors, m, args_used;
 	struct mirror_set *ms;
 	struct dm_dirty_log *dl;
+	char dummy;
 
 	dl = create_dirty_log(ti, argc, argv, &args_used);
 	if (!dl)
@@ -1047,7 +1051,7 @@ static int mirror_ctr(struct dm_target *
 	argv += args_used;
 	argc -= args_used;
 
-	if (!argc || sscanf(argv[0], "%u", &nr_mirrors) != 1 ||
+	if (!argc || sscanf(argv[0], "%u%c", &nr_mirrors, &dummy) != 1 ||
 	    nr_mirrors < 2 || nr_mirrors > DM_KCOPYD_MAX_REGIONS + 1) {
 		ti->error = "Invalid number of mirrors";
 		dm_dirty_log_destroy(dl);
Index: linux-3.2.7-fast/drivers/md/dm-round-robin.c
===================================================================
--- linux-3.2.7-fast.orig/drivers/md/dm-round-robin.c	2012-02-22 16:31:43.000000000 +0100
+++ linux-3.2.7-fast/drivers/md/dm-round-robin.c	2012-02-22 16:33:39.000000000 +0100
@@ -114,6 +114,7 @@ static int rr_add_path(struct path_selec
 	struct selector *s = (struct selector *) ps->context;
 	struct path_info *pi;
 	unsigned repeat_count = RR_MIN_IO;
+	char dummy;
 
 	if (argc > 1) {
 		*error = "round-robin ps: incorrect number of arguments";
@@ -121,7 +122,7 @@ static int rr_add_path(struct path_selec
 	}
 
 	/* First path argument is number of I/Os before switching path */
-	if ((argc == 1) && (sscanf(argv[0], "%u", &repeat_count) != 1)) {
+	if ((argc == 1) && (sscanf(argv[0], "%u%c", &repeat_count, &dummy) != 1)) {
 		*error = "round-robin ps: invalid repeat count";
 		return -EINVAL;
 	}
Index: linux-3.2.7-fast/drivers/md/dm-service-time.c
===================================================================
--- linux-3.2.7-fast.orig/drivers/md/dm-service-time.c	2012-02-22 16:31:43.000000000 +0100
+++ linux-3.2.7-fast/drivers/md/dm-service-time.c	2012-02-22 16:33:39.000000000 +0100
@@ -110,6 +110,7 @@ static int st_add_path(struct path_selec
 	struct path_info *pi;
 	unsigned repeat_count = ST_MIN_IO;
 	unsigned relative_throughput = 1;
+	char dummy;
 
 	/*
 	 * Arguments: [<repeat_count> [<relative_throughput>]]
@@ -128,13 +129,13 @@ static int st_add_path(struct path_selec
 		return -EINVAL;
 	}
 
-	if (argc && (sscanf(argv[0], "%u", &repeat_count) != 1)) {
+	if (argc && (sscanf(argv[0], "%u%c", &repeat_count, &dummy) != 1)) {
 		*error = "service-time ps: invalid repeat count";
 		return -EINVAL;
 	}
 
 	if ((argc == 2) &&
-	    (sscanf(argv[1], "%u", &relative_throughput) != 1 ||
+	    (sscanf(argv[1], "%u%c", &relative_throughput, &dummy) != 1 ||
 	     relative_throughput > ST_MAX_RELATIVE_THROUGHPUT)) {
 		*error = "service-time ps: invalid relative_throughput value";
 		return -EINVAL;
Index: linux-3.2.7-fast/drivers/md/dm-stripe.c
===================================================================
--- linux-3.2.7-fast.orig/drivers/md/dm-stripe.c	2012-02-22 16:31:43.000000000 +0100
+++ linux-3.2.7-fast/drivers/md/dm-stripe.c	2012-02-22 16:33:39.000000000 +0100
@@ -75,8 +75,9 @@ static int get_stripe(struct dm_target *
 		      unsigned int stripe, char **argv)
 {
 	unsigned long long start;
+	char dummy;
 
-	if (sscanf(argv[1], "%llu", &start) != 1)
+	if (sscanf(argv[1], "%llu%c", &start, &dummy) != 1)
 		return -EINVAL;
 
 	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
Index: linux-3.2.7-fast/drivers/md/dm-table.c
===================================================================
--- linux-3.2.7-fast.orig/drivers/md/dm-table.c	2012-02-22 16:31:44.000000000 +0100
+++ linux-3.2.7-fast/drivers/md/dm-table.c	2012-02-22 16:33:39.000000000 +0100
@@ -464,10 +464,11 @@ int dm_get_device(struct dm_target *ti, 
 	struct dm_dev_internal *dd;
 	unsigned int major, minor;
 	struct dm_table *t = ti->table;
+	char dummy;
 
 	BUG_ON(!t);
 
-	if (sscanf(path, "%u:%u", &major, &minor) == 2) {
+	if (sscanf(path, "%u:%u%c", &major, &minor, &dummy) == 2) {
 		/* Extract the major/minor numbers */
 		dev = MKDEV(major, minor);
 		if (MAJOR(dev) != major || MINOR(dev) != minor)
@@ -842,9 +843,10 @@ static int validate_next_arg(struct dm_a
 			     unsigned *value, char **error, unsigned grouped)
 {
 	const char *arg_str = dm_shift_arg(arg_set);
+	char dummy;
 
 	if (!arg_str ||
-	    (sscanf(arg_str, "%u", value) != 1) ||
+	    (sscanf(arg_str, "%u%c", value, &dummy) != 1) ||
 	    (*value < arg->min) ||
 	    (*value > arg->max) ||
 	    (grouped && arg_set->argc < *value)) {
