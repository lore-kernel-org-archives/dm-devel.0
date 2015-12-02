From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/4] dm verity: separate function for parsing opt args
Date: Wed, 2 Dec 2015 15:16:06 -0500
Message-ID: <20151202201606.GA51353@redhat.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
 <1446688954-29589-3-git-send-email-samitolvanen@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1446688954-29589-3-git-send-email-samitolvanen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids

On Wed, Nov 04 2015 at  9:02P -0500,
Sami Tolvanen <samitolvanen@google.com> wrote:

> Move optional argument parsing into a separate function to make it
> easier to add more of them without making verity_ctr even longer.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

I've taken this patch, for Linux 4.5, but I've applied the following
incremental patch ontop to make verity's optional argument parsing
follow establish DM patterns (the code is very similar to
dm-mpath.c:parse_features).  Your follow-on patches will obviously need
to be rebased on this, but the code will be much cleaner.

diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 3b09e50..2b0008f 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -723,19 +723,42 @@ static void verity_dtr(struct dm_target *ti)
 	kfree(v);
 }
 
-static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
-				 const char *opt_string)
+static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v)
 {
-	if (!strcasecmp(opt_string, DM_VERITY_OPT_LOGGING)) {
-		v->mode = DM_VERITY_MODE_LOGGING;
-		return 0;
-	} else if (!strcasecmp(opt_string, DM_VERITY_OPT_RESTART)) {
-		v->mode = DM_VERITY_MODE_RESTART;
+	int r;
+	unsigned argc;
+	struct dm_target *ti = v->ti;
+	const char *arg_name;
+
+	static struct dm_arg _args[] = {
+		{0, DM_VERITY_OPTS_MAX, "Invalid number of feature args"},
+	};
+
+	r = dm_read_arg_group(_args, &as, &argc, &ti->error);
+	if (r)
+		return -EINVAL;
+
+	if (!argc)
 		return 0;
-	}
 
-	v->ti->error = "Invalid feature arguments";
-	return -EINVAL;
+	do {
+		arg_name = dm_shift_arg(&as);
+		argc--;
+
+		if (!strcasecmp(arg_name, DM_VERITY_OPT_LOGGING)) {
+			v->mode = DM_VERITY_MODE_LOGGING;
+			continue;
+
+		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_RESTART)) {
+			v->mode = DM_VERITY_MODE_RESTART;
+			continue;
+		}
+
+		ti->error = "Unrecognized verity feature request";
+		return -EINVAL;
+	} while (argc && !r);
+
+	return r;
 }
 
 /*
@@ -757,17 +780,13 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	struct dm_verity *v;
 	struct dm_arg_set as;
 	const char *opt_string;
-	unsigned int num, opt_params;
+	unsigned int num;
 	unsigned long long num_ll;
 	int r;
 	int i;
 	sector_t hash_position;
 	char dummy;
 
-	static struct dm_arg _args[] = {
-		{0, DM_VERITY_OPTS_MAX, "Invalid number of feature args"},
-	};
-
 	v = kzalloc(sizeof(struct dm_verity), GFP_KERNEL);
 	if (!v) {
 		ti->error = "Cannot allocate verity structure";
@@ -912,25 +931,9 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		as.argc = argc;
 		as.argv = argv;
 
-		r = dm_read_arg_group(_args, &as, &opt_params, &ti->error);
-		if (r)
+		r = verity_parse_opt_args(&as, v);
+		if (r < 0)
 			goto bad;
-
-		while (opt_params) {
-			opt_params--;
-			opt_string = dm_shift_arg(&as);
-			if (!opt_string) {
-				ti->error = "Not enough feature arguments";
-				r = -EINVAL;
-				goto bad;
-			}
-
-			r = verity_parse_opt_args(&as, v, opt_string);
-			if (r < 0)
-				goto bad;
-
-			opt_params -= r;
-		}
 	}
 
 	v->hash_per_block_bits =
