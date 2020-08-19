From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v3 85/87] libmultipath: alias.c: use
 strtok_r() instead of strtok()
Date: Wed, 19 Aug 2020 17:16:33 -0500
Message-ID: <20200819221633.GV19233@octiron.msp.redhat.com>
References: <20200819131819.13493-1-mwilck@suse.com>
	<20200819131819.13493-3-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200819131819.13493-3-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: mwilck@suse.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Aug 19, 2020 at 03:18:17PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> ... for thread-safety.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/alias.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index df44bdc..de28f25 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -141,14 +141,14 @@ lookup_binding(FILE *f, const char *map_wwid, char **map_alias,
>  	rewind(f);
>  	while (fgets(buf, LINE_MAX, f)) {
>  		const char *alias, *wwid;
> -		char *c;
> +		char *c, *saveptr;
>  		int curr_id;
>  
>  		line_nr++;
>  		c = strpbrk(buf, "#\n\r");
>  		if (c)
>  			*c = '\0';
> -		alias = strtok(buf, " \t");
> +		alias = strtok_r(buf, " \t", &saveptr);
>  		if (!alias) /* blank line */
>  			continue;
>  		curr_id = scan_devname(alias, prefix);
> @@ -164,7 +164,7 @@ lookup_binding(FILE *f, const char *map_wwid, char **map_alias,
>  			biggest_id = curr_id;
>  		if (curr_id > id && curr_id < smallest_bigger_id)
>  			smallest_bigger_id = curr_id;
> -		wwid = strtok(NULL, " \t");
> +		wwid = strtok_r(NULL, " \t", &saveptr);
>  		if (!wwid){
>  			condlog(3,
>  				"Ignoring malformed line %u in bindings file",
> @@ -206,17 +206,17 @@ rlookup_binding(FILE *f, char *buff, const char *map_alias)
>  	buff[0] = '\0';
>  
>  	while (fgets(line, LINE_MAX, f)) {
> -		char *c;
> +		char *c, *saveptr;
>  		const char *alias, *wwid;
>  
>  		line_nr++;
>  		c = strpbrk(line, "#\n\r");
>  		if (c)
>  			*c = '\0';
> -		alias = strtok(line, " \t");
> +		alias = strtok_r(line, " \t", &saveptr);
>  		if (!alias) /* blank line */
>  			continue;
> -		wwid = strtok(NULL, " \t");
> +		wwid = strtok_r(NULL, " \t", &saveptr);
>  		if (!wwid){
>  			condlog(3,
>  				"Ignoring malformed line %u in bindings file",
> @@ -582,23 +582,23 @@ static int _check_bindings_file(const struct config *conf, FILE *file,
>  
>  	pthread_cleanup_push(free, line);
>  	while ((n = getline(&line, &line_len, file)) >= 0) {
> -		char *c, *alias, *wwid;
> +		char *c, *alias, *wwid, *saveptr;
>  		const char *mpe_wwid;
>  
>  		linenr++;
>  		c = strpbrk(line, "#\n\r");
>  		if (c)
>  			*c = '\0';
> -		alias = strtok(line, " \t");
> +		alias = strtok_r(line, " \t", &saveptr);
>  		if (!alias) /* blank line */
>  			continue;
> -		wwid = strtok(NULL, " \t");
> +		wwid = strtok_r(NULL, " \t", &saveptr);
>  		if (!wwid) {
>  			condlog(1, "invalid line %d in bindings file, missing WWID",
>  				linenr);
>  			continue;
>  		}
> -		c = strtok(NULL, " \t");
> +		c = strtok_r(NULL, " \t", &saveptr);
>  		if (c)
>  			/* This is non-fatal */
>  			condlog(1, "invalid line %d in bindings file, extra args \"%s\"",
> -- 
> 2.28.0
