From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [dmraid 1/4] Parse "-cc" as required by man page.
Date: Thu, 17 Dec 2009 17:50:07 +0100
Message-ID: <1261068607.3772.20.camel@o>
References: <20091217054410.410634166@suse.de>
	<20091217054515.427662058@suse.de>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091217054515.427662058@suse.de>
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
List-Id: dm-devel.ids


Neil,

what do you think of the following to handle all such multi-opt cases
more generically? Would allow for not neing stuch to just 'c' with
future extensions.

Heinz

Index: lib/metadata/metadata.c
===================================================================
RCS file: /cvs/dm/dmraid/lib/metadata/metadata.c,v
retrieving revision 1.8
diff -u -r1.8 metadata.c
--- lib/metadata/metadata.c	4 Nov 2009 13:06:36 -0000	1.8
+++ lib/metadata/metadata.c	17 Dec 2009 16:42:21 -0000
@@ -82,8 +82,8 @@
 	enum args args;		/* Arguments allowed ? */
 
 	/* Function to call on hit or NULL */
-	int (*f_set) (struct lib_context * lc, int arg);
-	int arg;		/* Argument for above function call */
+	int (*f_set) (struct lib_context * lc, struct actions *action);
+	int arg;		/* Argument for above function call. */
 };
 
 /*************************************/
Index: tools/commands.c
===================================================================
RCS file: /cvs/dm/dmraid/tools/commands.c,v
retrieving revision 1.4
diff -u -r1.4 commands.c
--- tools/commands.c	16 Sep 2009 11:45:18 -0000	1.4
+++ tools/commands.c	17 Dec 2009 16:42:21 -0000
@@ -108,7 +108,7 @@
 
 /* Check activate/deactivate option arguments. */
 static int
-check_activate(struct lib_context *lc, int arg)
+check_activate(struct lib_context *lc, struct actions *a)
 {
 	struct optarg_def def[] = {
 		{ "yes", ACTIVATE},
@@ -122,7 +122,7 @@
 #ifndef	DMRAID_MINI
 /* Check active/inactive option arguments. */
 static int
-check_active(struct lib_context *lc, int arg)
+check_active(struct lib_context *lc, struct actions *a)
 {
 	struct optarg_def def[] = {
 		{ "active",   ACTIVE},
@@ -134,9 +134,8 @@
 	return check_optarg(lc, 's', def);
 }
 
-/* Check and store option arguments. */
-static int
-check_identifiers(struct lib_context *lc, int o)
+/* lc_inc_opt wrapper to allow for (struct actions) call interface. */
+static int _lc_inc_opt(struct lib_context *lc, struct actions *a)
 {
 	if (optarg) {
 		const char delim = *OPT_STR_SEPARATOR(lc);
@@ -144,17 +143,40 @@
 
 		p = remove_white_space(lc, p, strlen(p));
 		p = collapse_delimiter(lc, p, strlen(p), delim);
-		if (!lc_strcat_opt(lc, o, p, delim))
+
+		/* Hack to handle eg. "-cc". */
+		while (*p == a->option) {
+			lc_inc_opt(lc, a->arg);
+			p++;
+		}
+	}
+
+	lc_inc_opt(lc, a->arg);
+	return 1;
+}
+
+/* Check and store option arguments. */
+static int
+check_identifiers(struct lib_context *lc, struct actions *a)
+{
+	if (optarg) {
+		char *p = optarg;
+
+		_lc_inc_opt(lc, a);
+		p += lc_opt(lc, a->arg) - 1;
+		if (*p && !lc_strcat_opt(lc, a->arg, p, *OPT_STR_SEPARATOR(lc)))
 			return 0;
+
+		return 1;
 	}
 
-	lc_inc_opt(lc, o);
+	lc_inc_opt(lc, a->arg);
 	return 1;
 }
 
 /* Check and store option argument/output field separator. */
 static int
-check_separator(struct lib_context *lc, int arg)
+check_separator(struct lib_context *lc, struct actions *a)
 {
 	if (strlen(optarg) != 1)
 		LOG_ERR(lc, 0, "invalid separator \"%s\"", optarg);
@@ -164,7 +186,7 @@
 
 /* Check create option arguments. */
 static int
-check_create_argument(struct lib_context *lc, int arg)
+check_create_argument(struct lib_context *lc, struct actions *a)
 {
 	size_t len;
 
@@ -175,31 +197,32 @@
 	if (*optarg == '-')
 		LOG_ERR(lc, 0, "the raid set name is missing");
 
-	lc_inc_opt(lc, arg);
+	lc_inc_opt(lc, a->arg);
 	return 1;
 }
 
 /* 'Check' spare option argument. */
 static int
-check_spare_argument(struct lib_context *lc, int arg)
+check_spare_argument(struct lib_context *lc, struct actions *a)
 {
-	lc_inc_opt(lc, arg);
+	lc_inc_opt(lc, a->arg);
 	return 1;
 }
 #endif
 
 /* Check and store option for partition separator. */
 static int
-check_part_separator(struct lib_context *lc, int arg)
+check_part_separator(struct lib_context *lc, struct actions *a)
 {
 	/* We're not actually checking that it's only one character... if
 	   somebody wants to use more, it shouldn't hurt anything. */
 	return lc_stralloc_opt(lc, LC_PARTCHAR, optarg) ? 1 : 0;
 }
 
+
 /* Display help information */
 static int
-help(struct lib_context *lc, int arg)
+help(struct lib_context *lc, struct actions *a)
 {
 	char *c = lc->cmd;
 
@@ -342,7 +365,7 @@
 	 UNDEF,
 	 COLUMN | DBG | HELP | IGNORELOCKING | SEPARATOR | VERBOSE,
 	 ARGS,
-	 lc_inc_opt,
+	 _lc_inc_opt,
 	 LC_DEVICES,
 	 },
 
@@ -363,7 +386,7 @@
 	 ALL_FLAGS,
 	 ALL_FLAGS,
 	 ARGS,
-	 lc_inc_opt,
+	 _lc_inc_opt,
 	 LC_DEBUG,
 	 },
 
@@ -373,7 +396,7 @@
 	 RAID_DEVICES,
 	 COLUMN | DBG | FORMAT | HELP | IGNORELOCKING | SEPARATOR | VERBOSE,
 	 ARGS,
-	 lc_inc_opt,
+	 _lc_inc_opt,
 	 LC_DUMP,
 	 },
 
@@ -394,7 +417,7 @@
 	 ACTIVE | INACTIVE | DBG | COLUMN | FORMAT | HELP | IGNORELOCKING
 	 | SEPARATOR | VERBOSE,
 	 ARGS,
-	 lc_inc_opt,
+	 _lc_inc_opt,
 	 LC_GROUP,
 	 },
 
@@ -415,7 +438,7 @@
 	 UNDEF,
 	 ALL_FLAGS,
 	 ARGS,
-	 lc_inc_opt,
+	 _lc_inc_opt,
 	 LC_IGNORELOCKING,
 	 },
 
@@ -529,7 +552,7 @@
 	 ACTIVATE | DEACTIVATE | DBG | FORMAT | HELP | IGNORELOCKING |
 	 NOPARTITIONS | VERBOSE,
 	 ARGS,
-	 lc_inc_opt,
+	 _lc_inc_opt,
 	 LC_TEST,
 	 },
 
@@ -539,7 +562,7 @@
 	 ALL_FLAGS,
 	 ALL_FLAGS,
 	 ARGS,
-	 lc_inc_opt,
+	 _lc_inc_opt,
 	 LC_VERBOSE,
 	 },
 #endif /* #ifndef DMRAID_MINI */
@@ -602,7 +625,7 @@
 			a->allowed |= a->needed;
 
 			if (a->f_set)	/* Optionally call function. */
-				return a->f_set(lc, a->arg);
+				return a->f_set(lc, a);
 
 			break;
 		}
Index: tools/commands.h
===================================================================
RCS file: /cvs/dm/dmraid/tools/commands.h,v
retrieving revision 1.3
diff -u -r1.3 commands.h
--- tools/commands.h	20 Jun 2008 21:52:19 -0000	1.3
+++ tools/commands.h	17 Dec 2009 16:42:21 -0000
@@ -33,8 +33,8 @@
 	enum args args;		/* Arguments allowed ? */
 
 	/* Function to call on hit or NULL */
-	int (*f_set) (struct lib_context * lc, int arg);
-	int arg;		/* Argument for above function call */
+	int (*f_set) (struct lib_context * lc, struct actions *action);
+	int arg;		/* Argument for above function call. */
 };
 
 int handle_args(struct lib_context *lc, int argc, char ***argv);
Index: tools/dmraid.c
===================================================================
RCS file: /cvs/dm/dmraid/tools/dmraid.c,v
retrieving revision 1.2
diff -u -r1.2 dmraid.c
--- tools/dmraid.c	20 Jun 2008 21:52:19 -0000	1.2
+++ tools/dmraid.c	17 Dec 2009 16:42:21 -0000
@@ -33,7 +33,8 @@
 		 * If both are ok -> perform the required action.
 		 */
 		ret = handle_args(lc, argc, &argv) &&
-			init_locking(lc) && perform(lc, argv);
+		      init_locking(lc) &&
+		      perform(lc, argv);
 
 		/* Cleanup the library context. */
 		libdmraid_exit(lc);




On Thu, 2009-12-17 at 16:44 +1100, neilb@suse.de wrote:
> plain text document attachment (dmraid_duplicate_args.patch)
> This is a bit of a hack but....
> 
> The man page says that "-cc" will provide 'CSV' style output.
> The code only provides this if "-c -c" is given.
> This hack effectively maps "-cc" to "-c -c".
> 
> patch extracted from openSUSE package
> 
> From: hare@suse.de
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> ---
>  tools/commands.c |   16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> --- dmraid.orig/tools/commands.c
> +++ dmraid/tools/commands.c
> @@ -142,10 +142,18 @@ check_identifiers(struct lib_context *lc
>  		const char delim = *OPT_STR_SEPARATOR(lc);
>  		char *p = optarg;
>  
> -		p = remove_white_space(lc, p, strlen(p));
> -		p = collapse_delimiter(lc, p, strlen(p), delim);
> -		if (!lc_strcat_opt(lc, o, p, delim))
> -			return 0;
> +		if (o == LC_COLUMN) {
> +			while (p && *p == 'c') {
> +				lc_inc_opt(lc, o);
> +				p++;
> +			}
> +		}
> +		if (p && *p) {
> +			p = remove_white_space(lc, p, strlen(p));
> +			p = collapse_delimiter(lc, p, strlen(p), delim);
> +			if (!lc_strcat_opt(lc, o, p, delim))
> +				return 0;
> +		}
>  	}
>  
>  	lc_inc_opt(lc, o);
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
