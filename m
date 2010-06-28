From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: [PATCH] [RFC] [PATCH] Add alias_prefix to get
 multipath names based on	storage type
Date: Mon, 28 Jun 2010 16:07:37 -0700
Message-ID: <20100628230737.GA17462@us.ibm.com>
References: <b4d519b4bbc657671382.1277260053@malahal>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <b4d519b4bbc657671382.1277260053@malahal>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr, dm-devel@redhat.com
List-Id: dm-devel.ids

Any comments??

Malahal Naineni [malahal@us.ibm.com] wrote:
> The current multipath tools use "mpath" prefix for all LUNs when
> user_friendly_names is set. It would be nice if the names are generated
> based on the storage subsystem. For example, all EMC LUNs would be named
> emc_a, emc_b, elm_c etc., and all IBM's SVC LUNs would be named svc_a,
> svc_b, svc_c. This patch attempts to do that using only multipath.conf.
> Patches can be added to the internal hardware table, if needed.
> 
> Signed-off-by: Malahal Naineni (malahal@us.ibm.com)
> 
> diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/alias.c
> --- a/libmultipath/alias.c	Tue Jun 15 17:23:49 2010 -0700
> +++ b/libmultipath/alias.c	Tue Jun 22 19:25:24 2010 -0700
> @@ -180,34 +180,35 @@ fail:
>  }
> 
>  static int
> -format_devname(char *name, int id, int len)
> +format_devname(char *name, int id, int len, char *prefix)
>  {
>  	int pos;
> +	int prefix_len = strlen(prefix);
> 
>  	memset(name,0, len);
> -	strcpy(name,"mpath");
> -	for (pos = len - 1; pos >= 5; pos--) {
> +	strcpy(name, prefix);
> +	for (pos = len - 1; pos >= prefix_len; pos--) {
>  		name[pos] = 'a' + id % 26;
>  		if (id < 26)
>  			break;
>  		id /= 26;
>  		id--;
>  	}
> -	memmove(name + 5, name + pos, len - pos);
> -	name[5 + len - pos] = '\0';
> -	return (5 + len - pos);
> +	memmove(name + prefix_len, name + pos, len - pos);
> +	name[prefix_len + len - pos] = '\0';
> +	return (prefix_len + len - pos);
>  }
> 
>  static int
> -scan_devname(char *alias)
> +scan_devname(char *alias, char *prefix)
>  {
>  	char *c;
>  	int i, n = 0;
> 
> -	if (strncmp(alias, "mpath", 5))
> +	if (!prefix || strncmp(alias, prefix, strlen(prefix)))
>  		return -1;
> 
> -	c = alias + 5;
> +	c = alias + strlen(prefix);
>  	while (*c != '\0' && *c != ' ' && *c != '\t') {
>  		i = *c - 'a';
>  		n = ( n * 26 ) + i;
> @@ -221,7 +222,7 @@ scan_devname(char *alias)
>  }
> 
>  static int
> -lookup_binding(FILE *f, char *map_wwid, char **map_alias)
> +lookup_binding(FILE *f, char *map_wwid, char **map_alias, char *prefix)
>  {
>  	char buf[LINE_MAX];
>  	unsigned int line_nr = 0;
> @@ -240,7 +241,7 @@ lookup_binding(FILE *f, char *map_wwid, 
>  		alias = strtok(buf, " \t");
>  		if (!alias) /* blank line */
>  			continue;
> -		curr_id = scan_devname(alias);
> +		curr_id = scan_devname(alias, prefix);
>  		if (curr_id >= id)
>  			id = curr_id + 1;
>  		wwid = strtok(NULL, "");
> @@ -284,7 +285,7 @@ rlookup_binding(FILE *f, char **map_wwid
>  		alias = strtok(buf, " \t");
>  		if (!alias) /* blank line */
>  			continue;
> -		curr_id = scan_devname(alias);
> +		curr_id = scan_devname(alias, NULL); /* TBD: Why this call? */
>  		if (curr_id >= id)
>  			id = curr_id + 1;
>  		wwid = strtok(NULL, " \t");
> @@ -309,7 +310,7 @@ rlookup_binding(FILE *f, char **map_wwid
>  }
> 
>  static char *
> -allocate_binding(int fd, char *wwid, int id)
> +allocate_binding(int fd, char *wwid, int id, char *prefix)
>  {
>  	char buf[LINE_MAX];
>  	off_t offset;
> @@ -321,7 +322,7 @@ allocate_binding(int fd, char *wwid, int
>  		return NULL;
>  	}
> 
> -	i = format_devname(buf, id, LINE_MAX);
> +	i = format_devname(buf, id, LINE_MAX, prefix);
>  	c = buf + i;
>  	snprintf(c,LINE_MAX - i, " %s\n", wwid);
>  	buf[LINE_MAX - 1] = '\0';
> @@ -352,7 +353,7 @@ allocate_binding(int fd, char *wwid, int
>  }
> 
>  char *
> -get_user_friendly_alias(char *wwid, char *file)
> +get_user_friendly_alias(char *wwid, char *file, char *prefix)
>  {
>  	char *alias;
>  	int fd, scan_fd, id;
> @@ -385,7 +386,7 @@ get_user_friendly_alias(char *wwid, char
>  		return NULL;
>  	}
> 
> -	id = lookup_binding(f, wwid, &alias);
> +	id = lookup_binding(f, wwid, &alias, prefix);
>  	if (id < 0) {
>  		fclose(f);
>  		close(scan_fd);
> @@ -394,7 +395,7 @@ get_user_friendly_alias(char *wwid, char
>  	}
> 
>  	if (!alias && can_write)
> -		alias = allocate_binding(fd, wwid, id);
> +		alias = allocate_binding(fd, wwid, id, prefix);
> 
>  	fclose(f);
>  	close(scan_fd);
> diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/alias.h
> --- a/libmultipath/alias.h	Tue Jun 15 17:23:49 2010 -0700
> +++ b/libmultipath/alias.h	Tue Jun 22 19:25:24 2010 -0700
> @@ -8,5 +8,5 @@
>  "# alias wwid\n" \
>  "#\n"
> 
> -char *get_user_friendly_alias(char *wwid, char *file);
> +char *get_user_friendly_alias(char *wwid, char *file, char *prefix);
>  char *get_user_friendly_wwid(char *alias, char *file);
> diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/config.c
> --- a/libmultipath/config.c	Tue Jun 15 17:23:49 2010 -0700
> +++ b/libmultipath/config.c	Tue Jun 22 19:25:24 2010 -0700
> @@ -158,6 +158,9 @@ free_hwe (struct hwentry * hwe)
>  	if (hwe->prio_args)
>  		FREE(hwe->prio_args);
> 
> +	if (hwe->alias_prefix)
> +		FREE(hwe->alias_prefix);
> +
>  	if (hwe->bl_product)
>  		FREE(hwe->bl_product);
> 
> @@ -282,6 +285,7 @@ merge_hwe (struct hwentry * hwe1, struct
>  	merge_str(checker_name);
>  	merge_str(prio_name);
>  	merge_str(prio_args);
> +	merge_str(alias_prefix);
>  	merge_str(bl_product);
>  	merge_num(pgpolicy);
>  	merge_num(pgfailback);
> @@ -333,6 +337,9 @@ store_hwe (vector hwtable, struct hwentr
>  	if (dhwe->prio_args && !(hwe->prio_args = set_param_str(dhwe->prio_args)))
>  		goto out;
> 
> +	if (dhwe->alias_prefix && !(hwe->alias_prefix = set_param_str(dhwe->alias_prefix)))
> +		goto out;
> +
>  	hwe->pgpolicy = dhwe->pgpolicy;
>  	hwe->pgfailback = dhwe->pgfailback;
>  	hwe->rr_weight = dhwe->rr_weight;
> @@ -409,6 +416,9 @@ free_config (struct config * conf)
>  	if (conf->prio_name)
>  		FREE(conf->prio_name);
> 
> +	if (conf->alias_prefix)
> +		FREE(conf->alias_prefix);
> +
>  	if (conf->prio_args)
>  		FREE(conf->prio_args);
> 
> diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/config.h
> --- a/libmultipath/config.h	Tue Jun 15 17:23:49 2010 -0700
> +++ b/libmultipath/config.h	Tue Jun 22 19:25:24 2010 -0700
> @@ -25,6 +25,7 @@ struct hwentry {
>  	char * checker_name;
>  	char * prio_name;
>  	char * prio_args;
> +	char * alias_prefix;
> 
>  	int pgpolicy;
>  	int pgfailback;
> @@ -99,6 +100,7 @@ struct config {
>  	char * prio_name;
>  	char * prio_args;
>  	char * checker_name;
> +	char * alias_prefix;
> 
>  	vector keywords;
>  	vector mptable;
> diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/defaults.h
> --- a/libmultipath/defaults.h	Tue Jun 15 17:23:49 2010 -0700
> +++ b/libmultipath/defaults.h	Tue Jun 22 19:25:24 2010 -0700
> @@ -2,6 +2,7 @@
>  #define DEFAULT_UDEVDIR		"/dev"
>  #define DEFAULT_MULTIPATHDIR	"/" LIB_STRING "/multipath"
>  #define DEFAULT_SELECTOR	"round-robin 0"
> +#define DEFAULT_ALIAS_PREFIX	"mpath"
>  #define DEFAULT_FEATURES	"0"
>  #define DEFAULT_HWHANDLER	"0"
>  #define DEFAULT_MINIO		1000
> diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/dict.c
> --- a/libmultipath/dict.c	Tue Jun 15 17:23:49 2010 -0700
> +++ b/libmultipath/dict.c	Tue Jun 22 19:25:24 2010 -0700
> @@ -148,6 +148,17 @@ def_prio_handler(vector strvec)
>  }
> 
>  static int
> +def_alias_prefix_handler(vector strvec)
> +{
> +	conf->alias_prefix = set_value(strvec);
> +
> +	if (!conf->alias_prefix)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static int
>  def_prio_args_handler(vector strvec)
>  {
>  	conf->prio_args = set_value(strvec);
> @@ -831,6 +842,22 @@ hw_prio_handler(vector strvec)
>  }
> 
>  static int
> +hw_alias_prefix_handler(vector strvec)
> +{
> +	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
> +
> +	if (!hwe)
> +		return 1;
> +
> +	hwe->alias_prefix = set_value(strvec);
> +
> +	if (!hwe->alias_prefix)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static int
>  hw_prio_args_handler(vector strvec)
>  {
>  	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
> @@ -1580,6 +1607,19 @@ snprint_hw_prio (char * buff, int len, v
>  }
> 
>  static int
> +snprint_hw_alias_prefix (char * buff, int len, void * data)
> +{
> +	struct hwentry * hwe = (struct hwentry *)data;
> +
> +	if (!hwe->alias_prefix || (strlen(hwe->alias_prefix) == 0))
> +		return 0;
> +	if (conf->alias_prefix && !strcmp(hwe->alias_prefix, conf->alias_prefix))
> +		return 0;
> +
> +	return snprintf(buff, len, "%s", hwe->alias_prefix);
> +}
> +
> +static int
>  snprint_hw_prio_args (char * buff, int len, void * data)
>  {
>  	struct hwentry * hwe = (struct hwentry *)data;
> @@ -2076,6 +2116,16 @@ snprint_def_user_friendly_names (char * 
>  }
> 
>  static int
> +snprint_def_alias_prefix (char * buff, int len, void * data)
> +{
> +	if (!conf->alias_prefix)
> +		return 0;
> +	if (!strcmp(conf->alias_prefix, DEFAULT_ALIAS_PREFIX))
> +		return 0;
> +	return snprintf(buff, len, conf->alias_prefix);
> +}
> +
> +static int
>  snprint_ble_simple (char * buff, int len, void * data)
>  {
>  	struct blentry * ble = (struct blentry *)data;
> @@ -2117,6 +2167,7 @@ init_keywords(void)
>  	install_keyword("features", &def_features_handler, &snprint_def_features);
>  	install_keyword("path_checker", &def_path_checker_handler, &snprint_def_path_checker);
>  	install_keyword("checker", &def_path_checker_handler, &snprint_def_path_checker);
> +	install_keyword("alias_prefix", &def_alias_prefix_handler, &snprint_def_alias_prefix);
>  	install_keyword("failback", &default_failback_handler, &snprint_def_failback);
>  	install_keyword("rr_min_io", &def_minio_handler, &snprint_def_rr_min_io);
>  	install_keyword("max_fds", &max_fds_handler, &snprint_max_fds);
> @@ -2176,6 +2227,7 @@ init_keywords(void)
>  	install_keyword("path_selector", &hw_selector_handler, &snprint_hw_selector);
>  	install_keyword("path_checker", &hw_path_checker_handler, &snprint_hw_path_checker);
>  	install_keyword("checker", &hw_path_checker_handler, &snprint_hw_path_checker);
> +	install_keyword("alias_prefix", &hw_alias_prefix_handler, &snprint_hw_alias_prefix);
>  	install_keyword("features", &hw_features_handler, &snprint_hw_features);
>  	install_keyword("hardware_handler", &hw_handler_handler, &snprint_hw_hardware_handler);
>  	install_keyword("prio", &hw_prio_handler, &snprint_hw_prio);
> diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/propsel.c
> --- a/libmultipath/propsel.c	Tue Jun 15 17:23:49 2010 -0700
> +++ b/libmultipath/propsel.c	Tue Jun 22 19:25:24 2010 -0700
> @@ -215,6 +215,26 @@ select_selector (struct multipath * mp)
>  	return 0;
>  }
> 
> +static void
> +select_alias_prefix (struct multipath * mp)
> +{
> +	if (mp->hwe && mp->hwe->alias_prefix) {
> +		mp->alias_prefix = mp->hwe->alias_prefix;
> +		condlog(3, "%s: alias_prefix = %s (controller setting)",
> +			mp->wwid, mp->alias_prefix);
> +		return;
> +	}
> +	if (conf->alias_prefix) {
> +		mp->alias_prefix = conf->alias_prefix;
> +		condlog(3, "%s: alias_prefix = %s (config file default)",
> +			mp->wwid, mp->alias_prefix);
> +		return;
> +	}
> +	mp->alias_prefix = set_default(DEFAULT_ALIAS_PREFIX);
> +	condlog(3, "%s: alias_prefix = %s (internal default)",
> +		mp->wwid, mp->alias_prefix);
> +}
> +
>  extern int
>  select_alias (struct multipath * mp)
>  {
> @@ -222,9 +242,11 @@ select_alias (struct multipath * mp)
>  		mp->alias = mp->mpe->alias;
>  	else {
>  		mp->alias = NULL;
> -		if (conf->user_friendly_names)
> +		if (conf->user_friendly_names) {
> +			select_alias_prefix(mp);
>  			mp->alias = get_user_friendly_alias(mp->wwid,
> -					conf->bindings_file);
> +					conf->bindings_file, mp->alias_prefix);
> +		}
>  		if (mp->alias == NULL){
>  			char *alias;
>  			if ((alias = MALLOC(WWID_SIZE)) != NULL){
> diff -r 49b7dc2c9d46 -r b4d519b4bbc6 libmultipath/structs.h
> --- a/libmultipath/structs.h	Tue Jun 15 17:23:49 2010 -0700
> +++ b/libmultipath/structs.h	Tue Jun 22 19:25:24 2010 -0700
> @@ -186,6 +186,7 @@ struct multipath {
> 
>  	/* configlet pointers */
>  	char * alias;
> +	char * alias_prefix;
>  	char * selector;
>  	char * features;
>  	char * hwhandler;
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
