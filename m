From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/9] dm: factor out target argument parsing
	helpers
Date: Mon, 27 Jun 2011 15:53:35 -0400
Message-ID: <1309204423-8599-2-git-send-email-snitzer@redhat.com>
References: <1309204423-8599-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1309204423-8599-1-git-send-email-snitzer@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Other targets may need to handle target arguments with a variable
count (as are widely used in the multipath target).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c         |  119 +++++++++++++----------------------------
 drivers/md/dm-table.c         |   40 ++++++++++++++
 include/linux/device-mapper.h |   18 ++++++
 3 files changed, 95 insertions(+), 82 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index a550a05..b5149b9 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -505,69 +505,24 @@ static void trigger_event(struct work_struct *work)
  *      <#paths> <#per-path selector args>
  *         [<path> [<arg>]* ]+ ]+
  *---------------------------------------------------------------*/
-struct param {
-	unsigned min;
-	unsigned max;
-	char *error;
-};
-
-static int read_param(struct param *param, char *str, unsigned *v, char **error)
-{
-	if (!str ||
-	    (sscanf(str, "%u", v) != 1) ||
-	    (*v < param->min) ||
-	    (*v > param->max)) {
-		*error = param->error;
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-struct arg_set {
-	unsigned argc;
-	char **argv;
-};
-
-static char *shift(struct arg_set *as)
-{
-	char *r;
-
-	if (as->argc) {
-		as->argc--;
-		r = *as->argv;
-		as->argv++;
-		return r;
-	}
-
-	return NULL;
-}
-
-static void consume(struct arg_set *as, unsigned n)
-{
-	BUG_ON (as->argc < n);
-	as->argc -= n;
-	as->argv += n;
-}
-
-static int parse_path_selector(struct arg_set *as, struct priority_group *pg,
+static int parse_path_selector(struct dm_arg_set *as, struct priority_group *pg,
 			       struct dm_target *ti)
 {
 	int r;
 	struct path_selector_type *pst;
 	unsigned ps_argc;
 
-	static struct param _params[] = {
+	static struct dm_arg _args[] = {
 		{0, 1024, "invalid number of path selector args"},
 	};
 
-	pst = dm_get_path_selector(shift(as));
+	pst = dm_get_path_selector(dm_shift_arg(as));
 	if (!pst) {
 		ti->error = "unknown path selector type";
 		return -EINVAL;
 	}
 
-	r = read_param(_params, shift(as), &ps_argc, &ti->error);
+	r = dm_read_arg(_args, dm_shift_arg(as), &ps_argc, &ti->error);
 	if (r) {
 		dm_put_path_selector(pst);
 		return -EINVAL;
@@ -587,12 +542,12 @@ static int parse_path_selector(struct arg_set *as, struct priority_group *pg,
 	}
 
 	pg->ps.type = pst;
-	consume(as, ps_argc);
+	dm_consume_args(as, ps_argc);
 
 	return 0;
 }
 
-static struct pgpath *parse_path(struct arg_set *as, struct path_selector *ps,
+static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps,
 			       struct dm_target *ti)
 {
 	int r;
@@ -609,7 +564,7 @@ static struct pgpath *parse_path(struct arg_set *as, struct path_selector *ps,
 	if (!p)
 		return ERR_PTR(-ENOMEM);
 
-	r = dm_get_device(ti, shift(as), dm_table_get_mode(ti->table),
+	r = dm_get_device(ti, dm_shift_arg(as), dm_table_get_mode(ti->table),
 			  &p->path.dev);
 	if (r) {
 		ti->error = "error getting device";
@@ -660,16 +615,16 @@ static struct pgpath *parse_path(struct arg_set *as, struct path_selector *ps,
 	return ERR_PTR(r);
 }
 
-static struct priority_group *parse_priority_group(struct arg_set *as,
+static struct priority_group *parse_priority_group(struct dm_arg_set *as,
 						   struct multipath *m)
 {
-	static struct param _params[] = {
+	static struct dm_arg _args[] = {
 		{1, 1024, "invalid number of paths"},
 		{0, 1024, "invalid number of selector args"}
 	};
 
 	int r;
-	unsigned i, nr_selector_args, nr_params;
+	unsigned i, nr_selector_args, nr_args;
 	struct priority_group *pg;
 	struct dm_target *ti = m->ti;
 
@@ -693,26 +648,26 @@ static struct priority_group *parse_priority_group(struct arg_set *as,
 	/*
 	 * read the paths
 	 */
-	r = read_param(_params, shift(as), &pg->nr_pgpaths, &ti->error);
+	r = dm_read_arg(_args, dm_shift_arg(as), &pg->nr_pgpaths, &ti->error);
 	if (r)
 		goto bad;
 
-	r = read_param(_params + 1, shift(as), &nr_selector_args, &ti->error);
+	r = dm_read_arg(_args + 1, dm_shift_arg(as), &nr_selector_args, &ti->error);
 	if (r)
 		goto bad;
 
-	nr_params = 1 + nr_selector_args;
+	nr_args = 1 + nr_selector_args;
 	for (i = 0; i < pg->nr_pgpaths; i++) {
 		struct pgpath *pgpath;
-		struct arg_set path_args;
+		struct dm_arg_set path_args;
 
-		if (as->argc < nr_params) {
+		if (as->argc < nr_args) {
 			ti->error = "not enough path parameters";
 			r = -EINVAL;
 			goto bad;
 		}
 
-		path_args.argc = nr_params;
+		path_args.argc = nr_args;
 		path_args.argv = as->argv;
 
 		pgpath = parse_path(&path_args, &pg->ps, ti);
@@ -723,7 +678,7 @@ static struct priority_group *parse_priority_group(struct arg_set *as,
 
 		pgpath->pg = pg;
 		list_add_tail(&pgpath->list, &pg->pgpaths);
-		consume(as, nr_params);
+		dm_consume_args(as, nr_args);
 	}
 
 	return pg;
@@ -733,17 +688,17 @@ static struct priority_group *parse_priority_group(struct arg_set *as,
 	return ERR_PTR(r);
 }
 
-static int parse_hw_handler(struct arg_set *as, struct multipath *m)
+static int parse_hw_handler(struct dm_arg_set *as, struct multipath *m)
 {
 	unsigned hw_argc;
 	int ret;
 	struct dm_target *ti = m->ti;
 
-	static struct param _params[] = {
+	static struct dm_arg _args[] = {
 		{0, 1024, "invalid number of hardware handler args"},
 	};
 
-	if (read_param(_params, shift(as), &hw_argc, &ti->error))
+	if (dm_read_arg(_args, dm_shift_arg(as), &hw_argc, &ti->error))
 		return -EINVAL;
 
 	if (!hw_argc)
@@ -754,7 +709,7 @@ static int parse_hw_handler(struct arg_set *as, struct multipath *m)
 		return -EINVAL;
 	}
 
-	m->hw_handler_name = kstrdup(shift(as), GFP_KERNEL);
+	m->hw_handler_name = kstrdup(dm_shift_arg(as), GFP_KERNEL);
 	request_module("scsi_dh_%s", m->hw_handler_name);
 	if (scsi_dh_handler_exist(m->hw_handler_name) == 0) {
 		ti->error = "unknown hardware handler type";
@@ -778,7 +733,7 @@ static int parse_hw_handler(struct arg_set *as, struct multipath *m)
 		for (i = 0, p+=j+1; i <= hw_argc - 2; i++, p+=j+1)
 			j = sprintf(p, "%s", as->argv[i]);
 	}
-	consume(as, hw_argc - 1);
+	dm_consume_args(as, hw_argc - 1);
 
 	return 0;
 fail:
@@ -787,20 +742,20 @@ fail:
 	return ret;
 }
 
-static int parse_features(struct arg_set *as, struct multipath *m)
+static int parse_features(struct dm_arg_set *as, struct multipath *m)
 {
 	int r;
 	unsigned argc;
 	struct dm_target *ti = m->ti;
-	const char *param_name;
+	const char *arg_name;
 
-	static struct param _params[] = {
+	static struct dm_arg _args[] = {
 		{0, 5, "invalid number of feature args"},
 		{1, 50, "pg_init_retries must be between 1 and 50"},
 		{0, 60000, "pg_init_delay_msecs must be between 0 and 60000"},
 	};
 
-	r = read_param(_params, shift(as), &argc, &ti->error);
+	r = dm_read_arg(_args, dm_shift_arg(as), &argc, &ti->error);
 	if (r)
 		return -EINVAL;
 
@@ -808,25 +763,25 @@ static int parse_features(struct arg_set *as, struct multipath *m)
 		return 0;
 
 	do {
-		param_name = shift(as);
+		arg_name = dm_shift_arg(as);
 		argc--;
 
-		if (!strnicmp(param_name, MESG_STR("queue_if_no_path"))) {
+		if (!strnicmp(arg_name, MESG_STR("queue_if_no_path"))) {
 			r = queue_if_no_path(m, 1, 0);
 			continue;
 		}
 
-		if (!strnicmp(param_name, MESG_STR("pg_init_retries")) &&
+		if (!strnicmp(arg_name, MESG_STR("pg_init_retries")) &&
 		    (argc >= 1)) {
-			r = read_param(_params + 1, shift(as),
+			r = dm_read_arg(_args + 1, dm_shift_arg(as),
 				       &m->pg_init_retries, &ti->error);
 			argc--;
 			continue;
 		}
 
-		if (!strnicmp(param_name, MESG_STR("pg_init_delay_msecs")) &&
+		if (!strnicmp(arg_name, MESG_STR("pg_init_delay_msecs")) &&
 		    (argc >= 1)) {
-			r = read_param(_params + 2, shift(as),
+			r = dm_read_arg(_args + 2, dm_shift_arg(as),
 				       &m->pg_init_delay_msecs, &ti->error);
 			argc--;
 			continue;
@@ -842,15 +797,15 @@ static int parse_features(struct arg_set *as, struct multipath *m)
 static int multipath_ctr(struct dm_target *ti, unsigned int argc,
 			 char **argv)
 {
-	/* target parameters */
-	static struct param _params[] = {
+	/* target arguments */
+	static struct dm_arg _args[] = {
 		{0, 1024, "invalid number of priority groups"},
 		{0, 1024, "invalid initial priority group number"},
 	};
 
 	int r;
 	struct multipath *m;
-	struct arg_set as;
+	struct dm_arg_set as;
 	unsigned pg_count = 0;
 	unsigned next_pg_num;
 
@@ -871,11 +826,11 @@ static int multipath_ctr(struct dm_target *ti, unsigned int argc,
 	if (r)
 		goto bad;
 
-	r = read_param(_params, shift(&as), &m->nr_priority_groups, &ti->error);
+	r = dm_read_arg(_args, dm_shift_arg(&as), &m->nr_priority_groups, &ti->error);
 	if (r)
 		goto bad;
 
-	r = read_param(_params + 1, shift(&as), &next_pg_num, &ti->error);
+	r = dm_read_arg(_args + 1, dm_shift_arg(&as), &next_pg_num, &ti->error);
 	if (r)
 		goto bad;
 
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 5570d4b..db75414 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -785,6 +785,46 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 	return r;
 }
 
+/*
+ * Target argument parsing helpers.
+ */
+int dm_read_arg(struct dm_arg *arg, char *str, unsigned *v, char **error)
+{
+	if (!str ||
+	    (sscanf(str, "%u", v) != 1) ||
+	    (*v < arg->min) ||
+	    (*v > arg->max)) {
+		*error = arg->error;
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(dm_read_arg);
+
+char *dm_shift_arg(struct dm_arg_set *as)
+{
+	char *r;
+
+	if (as->argc) {
+		as->argc--;
+		r = *as->argv;
+		as->argv++;
+		return r;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(dm_shift_arg);
+
+void dm_consume_args(struct dm_arg_set *as, unsigned n)
+{
+	BUG_ON (as->argc < n);
+	as->argc -= n;
+	as->argv += n;
+}
+EXPORT_SYMBOL(dm_consume_args);
+
 static int dm_table_set_type(struct dm_table *t)
 {
 	unsigned i;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 5ad7eb7..0e187cb 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -202,6 +202,24 @@ struct dm_target_callbacks {
 int dm_register_target(struct target_type *t);
 void dm_unregister_target(struct target_type *t);
 
+/*
+ * Target argument parsing
+ */
+struct dm_arg_set {
+	unsigned argc;
+	char **argv;
+};
+
+struct dm_arg {
+	unsigned min;
+	unsigned max;
+	char *error;
+};
+
+int dm_read_arg(struct dm_arg *arg, char *str, unsigned *v, char **error);
+char *dm_shift_arg(struct dm_arg_set *as);
+void dm_consume_args(struct dm_arg_set *as, unsigned n);
+
 /*-----------------------------------------------------------------
  * Functions for creating and manipulating mapped devices.
  * Drop the reference with dm_put when you finish with the object.
-- 
1.7.1
