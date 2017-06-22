From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] dm: constify argument arrays
Date: Thu, 22 Jun 2017 11:32:45 -0700
Message-ID: <20170622183245.48678-1-ebiggers3@gmail.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>, Eric Biggers <ebiggers@google.com>
List-Id: dm-devel.ids

From: Eric Biggers <ebiggers@google.com>

The arrays of 'struct dm_arg' are never modified by the device-mapper
core, so constify them so that they are placed in .rodata.

(Exception: the args array in dm-raid cannot be constified because it is
allocated on the stack and modified.)

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-cache-target.c  |  4 ++--
 drivers/md/dm-crypt.c         |  2 +-
 drivers/md/dm-flakey.c        |  4 ++--
 drivers/md/dm-integrity.c     |  2 +-
 drivers/md/dm-mpath.c         | 10 +++++-----
 drivers/md/dm-switch.c        |  2 +-
 drivers/md/dm-table.c         |  7 ++++---
 drivers/md/dm-thin.c          |  2 +-
 drivers/md/dm-verity-target.c |  2 +-
 include/linux/device-mapper.h |  4 ++--
 10 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index d682a0511381..484fbe0327b4 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2305,7 +2305,7 @@ static void init_features(struct cache_features *cf)
 static int parse_features(struct cache_args *ca, struct dm_arg_set *as,
 			  char **error)
 {
-	static struct dm_arg _args[] = {
+	static const struct dm_arg _args[] = {
 		{0, 2, "Invalid number of cache feature arguments"},
 	};
 
@@ -2347,7 +2347,7 @@ static int parse_features(struct cache_args *ca, struct dm_arg_set *as,
 static int parse_policy(struct cache_args *ca, struct dm_arg_set *as,
 			char **error)
 {
-	static struct dm_arg _args[] = {
+	static const struct dm_arg _args[] = {
 		{0, 1024, "Invalid number of policy arguments"},
 	};
 
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index ebf9e72d479b..95c5faf05391 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2514,7 +2514,7 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
 {
 	struct crypt_config *cc = ti->private;
 	struct dm_arg_set as;
-	static struct dm_arg _args[] = {
+	static const struct dm_arg _args[] = {
 		{0, 6, "Invalid number of feature args"},
 	};
 	unsigned int opt_params, val;
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 13305a182611..56cc3fba3eaa 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -51,7 +51,7 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 	unsigned argc;
 	const char *arg_name;
 
-	static struct dm_arg _args[] = {
+	static const struct dm_arg _args[] = {
 		{0, 6, "Invalid number of feature args"},
 		{1, UINT_MAX, "Invalid corrupt bio byte"},
 		{0, 255, "Invalid corrupt value to write into bio byte (0-255)"},
@@ -178,7 +178,7 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
  */
 static int flakey_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
-	static struct dm_arg _args[] = {
+	static const struct dm_arg _args[] = {
 		{0, UINT_MAX, "Invalid up interval"},
 		{0, UINT_MAX, "Invalid down interval"},
 	};
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 7910bfe50da4..866714c1dee1 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2763,7 +2763,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	int r;
 	unsigned extra_args;
 	struct dm_arg_set as;
-	static struct dm_arg _args[] = {
+	static const struct dm_arg _args[] = {
 		{0, 9, "Invalid number of feature args"},
 	};
 	unsigned journal_sectors, interleave_sectors, buffer_sectors, journal_watermark, sync_msec;
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 3df056b73b66..93f2a5bca918 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -691,7 +691,7 @@ static int parse_path_selector(struct dm_arg_set *as, struct priority_group *pg,
 	struct path_selector_type *pst;
 	unsigned ps_argc;
 
-	static struct dm_arg _args[] = {
+	static const struct dm_arg _args[] = {
 		{0, 1024, "invalid number of path selector args"},
 	};
 
@@ -815,7 +815,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 static struct priority_group *parse_priority_group(struct dm_arg_set *as,
 						   struct multipath *m)
 {
-	static struct dm_arg _args[] = {
+	static const struct dm_arg _args[] = {
 		{1, 1024, "invalid number of paths"},
 		{0, 1024, "invalid number of selector args"}
 	};
@@ -891,7 +891,7 @@ static int parse_hw_handler(struct dm_arg_set *as, struct multipath *m)
 	int ret;
 	struct dm_target *ti = m->ti;
 
-	static struct dm_arg _args[] = {
+	static const struct dm_arg _args[] = {
 		{0, 1024, "invalid number of hardware handler args"},
 	};
 
@@ -943,7 +943,7 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 	struct dm_target *ti = m->ti;
 	const char *arg_name;
 
-	static struct dm_arg _args[] = {
+	static const struct dm_arg _args[] = {
 		{0, 8, "invalid number of feature args"},
 		{1, 50, "pg_init_retries must be between 1 and 50"},
 		{0, 60000, "pg_init_delay_msecs must be between 0 and 60000"},
@@ -1012,7 +1012,7 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 {
 	/* target arguments */
-	static struct dm_arg _args[] = {
+	static const struct dm_arg _args[] = {
 		{0, 1024, "invalid number of priority groups"},
 		{0, 1024, "invalid initial priority group number"},
 	};
diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
index 871c18fe000d..83a371d54412 100644
--- a/drivers/md/dm-switch.c
+++ b/drivers/md/dm-switch.c
@@ -251,7 +251,7 @@ static void switch_dtr(struct dm_target *ti)
  */
 static int switch_ctr(struct dm_target *ti, unsigned argc, char **argv)
 {
-	static struct dm_arg _args[] = {
+	static const struct dm_arg _args[] = {
 		{1, (KMALLOC_MAX_SIZE - sizeof(struct switch_ctx)) / sizeof(struct switch_path), "Invalid number of paths"},
 		{1, UINT_MAX, "Invalid region size"},
 		{0, 0, "Invalid number of optional args"},
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 5f5eae41f804..15249a6b1741 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -770,7 +770,8 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 /*
  * Target argument parsing helpers.
  */
-static int validate_next_arg(struct dm_arg *arg, struct dm_arg_set *arg_set,
+static int validate_next_arg(const struct dm_arg *arg,
+			     struct dm_arg_set *arg_set,
 			     unsigned *value, char **error, unsigned grouped)
 {
 	const char *arg_str = dm_shift_arg(arg_set);
@@ -788,14 +789,14 @@ static int validate_next_arg(struct dm_arg *arg, struct dm_arg_set *arg_set,
 	return 0;
 }
 
-int dm_read_arg(struct dm_arg *arg, struct dm_arg_set *arg_set,
+int dm_read_arg(const struct dm_arg *arg, struct dm_arg_set *arg_set,
 		unsigned *value, char **error)
 {
 	return validate_next_arg(arg, arg_set, value, error, 0);
 }
 EXPORT_SYMBOL(dm_read_arg);
 
-int dm_read_arg_group(struct dm_arg *arg, struct dm_arg_set *arg_set,
+int dm_read_arg_group(const struct dm_arg *arg, struct dm_arg_set *arg_set,
 		      unsigned *value, char **error)
 {
 	return validate_next_arg(arg, arg_set, value, error, 1);
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 17ad50daed08..08d945d0fc10 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3043,7 +3043,7 @@ static int parse_pool_features(struct dm_arg_set *as, struct pool_features *pf,
 	unsigned argc;
 	const char *arg_name;
 
-	static struct dm_arg _args[] = {
+	static const struct dm_arg _args[] = {
 		{0, 4, "Invalid number of pool feature arguments"},
 	};
 
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 1ec9b2c51c07..efd3f05383bd 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -839,7 +839,7 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v)
 	struct dm_target *ti = v->ti;
 	const char *arg_name;
 
-	static struct dm_arg _args[] = {
+	static const struct dm_arg _args[] = {
 		{0, DM_VERITY_OPTS_MAX, "Invalid number of feature args"},
 	};
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index f4c639c0c362..9ad8eb3384ec 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -375,7 +375,7 @@ struct dm_arg {
  * Validate the next argument, either returning it as *value or, if invalid,
  * returning -EINVAL and setting *error.
  */
-int dm_read_arg(struct dm_arg *arg, struct dm_arg_set *arg_set,
+int dm_read_arg(const struct dm_arg *arg, struct dm_arg_set *arg_set,
 		unsigned *value, char **error);
 
 /*
@@ -383,7 +383,7 @@ int dm_read_arg(struct dm_arg *arg, struct dm_arg_set *arg_set,
  * arg->min and arg->max further arguments. Either return the size as
  * *num_args or, if invalid, return -EINVAL and set *error.
  */
-int dm_read_arg_group(struct dm_arg *arg, struct dm_arg_set *arg_set,
+int dm_read_arg_group(const struct dm_arg *arg, struct dm_arg_set *arg_set,
 		      unsigned *num_args, char **error);
 
 /*
-- 
2.13.1.611.g7e3b11ae1-goog
