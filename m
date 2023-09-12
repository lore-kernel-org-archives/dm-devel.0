Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F7F3EE3F3F
	for <dm-devel@archiver.kernel.org>; Tue, 12 Sep 2023 23:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694559673;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NlssvyIg7fZvoBfkj2fv+v45ezEfgm9iR2DwM9RMR3I=;
	b=Mxo4Y2l/obSmC1nPpjQuK6DBNvrqzbt3EIquEnIJ6pQhxDerMqATbr5jOUBXt8wX0oE3Wx
	CCyBdrDvj5rJeUfEnUWqX9s5X8MFyH7VsxblQDcaBN1LohVfYaXv2JdfmJ5z7Vew5tZJ4A
	sc8KzKqcsosmuprJBHtY0ICHkSiW2aA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-M7hxSgFCM-6fK49muED-BQ-1; Tue, 12 Sep 2023 19:01:10 -0400
X-MC-Unique: M7hxSgFCM-6fK49muED-BQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E2628BEBA2;
	Tue, 12 Sep 2023 23:01:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 684BD1006E0B;
	Tue, 12 Sep 2023 23:01:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2B0B919465A8;
	Tue, 12 Sep 2023 23:01:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AD99A194658D
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Sep 2023 23:00:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8EA5B40C6EBF; Tue, 12 Sep 2023 23:00:47 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 64DE140C6EA8;
 Tue, 12 Sep 2023 23:00:47 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 38CN0dEj031061;
 Tue, 12 Sep 2023 18:00:39 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 38CN0cIP031060;
 Tue, 12 Sep 2023 18:00:38 -0500
Date: Tue, 12 Sep 2023 18:00:38 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230912230038.GQ7412@octiron.msp.redhat.com>
References: <20230911163846.27197-1-mwilck@suse.com>
 <20230911163846.27197-19-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230911163846.27197-19-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v2 18/37] libmultipath: keep bindings in
 memory
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 11, 2023 at 06:38:27PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Rather than opening the bindings file every time we must retrieve
> a binding, keep the contents in memory and write the file only
> if additions have been made. This simplifies the code, and should speed up
> alias lookups significantly. As a side effect, the aliases will be stored
> sorted by alias, which changes the way aliases are allocated if there are
> unused "holes" in the sequence of aliases. For example, if the bindings file
> contains mpathb, mpathy, and mpatha, in this order, the next new alias used to
> be mpathz and is now mpathc.
> 
> Another side effect is that multipathd will not automatically pick up changes
> to the bindings file at runtime without a reconfigure operation. It is
> questionable whether these on-the-fly changes were a good idea in the first
> place, as inconsistent configurations may easily come to pass. It desired,
> it would be feasible to implement automatic update of the bindings using the
> existing inotify approach.
> 
> The new implementation of get_user_friendly_alias() is slightly different
> than before. The logic is summarized in a comment in the code. Unit tests
> will be provided that illustrate the changes.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/alias.c     | 359 ++++++++++++++++-----------------------
>  libmultipath/alias.h     |   2 +-
>  libmultipath/configure.c |   3 +-
>  3 files changed, 148 insertions(+), 216 deletions(-)
> 
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index ad83ca0..d656374 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -50,8 +50,6 @@
>  "# alias wwid\n" \
>  "#\n"
>  
> -static const char bindings_file_header[] = BINDINGS_FILE_HEADER;
> -
>  struct binding {
>  	char *alias;
>  	char *wwid;
> @@ -80,6 +78,45 @@ static void _free_binding(struct binding *bdg)
>  	free(bdg);
>  }
>  
> +static const struct binding *get_binding_for_alias(const Bindings *bindings,
> +						   const char *alias)
> +{
> +	const struct binding *bdg;
> +	int i;
> +
> +	if (!alias)
> +		return NULL;
> +	vector_foreach_slot(bindings, bdg, i) {
> +		if (!strncmp(bdg->alias, alias, WWID_SIZE)) {
> +			condlog(3, "Found matching alias [%s] in bindings file."
> +				" Setting wwid to %s", alias, bdg->wwid);
> +			return bdg;
> +		}
> +	}
> +
> +	condlog(3, "No matching alias [%s] in bindings file.", alias);
> +	return NULL;
> +}
> +
> +static const struct binding *get_binding_for_wwid(const Bindings *bindings,
> +						  const char *wwid)
> +{
> +	const struct binding *bdg;
> +	int i;
> +
> +	if (!wwid)
> +		return NULL;
> +	vector_foreach_slot(bindings, bdg, i) {
> +		if (!strncmp(bdg->wwid, wwid, WWID_SIZE)) {
> +			condlog(3, "Found matching wwid [%s] in bindings file."
> +				" Setting alias to %s", wwid, bdg->alias);
> +			return bdg;
> +		}
> +	}
> +	condlog(3, "No matching wwid [%s] in bindings file.", wwid);
> +	return NULL;
> +}
> +
>  static int add_binding(Bindings *bindings, const char *alias, const char *wwid)
>  {
>  	struct binding *bdg;
> @@ -115,6 +152,24 @@ static int add_binding(Bindings *bindings, const char *alias, const char *wwid)
>  	return BINDING_ERROR;
>  }
>  
> +static int delete_binding(Bindings *bindings, const char *wwid)
> +{
> +	struct binding *bdg;
> +	int i;
> +
> +	vector_foreach_slot(bindings, bdg, i) {
> +		if (!strncmp(bdg->wwid, wwid, WWID_SIZE)) {
> +			_free_binding(bdg);
> +			break;
> +		}
> +	}
> +	if (i >= VECTOR_SIZE(bindings))
> +		return BINDING_NOTFOUND;
> +
> +	vector_del_slot(bindings, i);
> +	return BINDING_DELETED;
> +}
> +
>  static int write_bindings_file(const Bindings *bindings, int fd)
>  {
>  	struct binding *bnd;
> @@ -267,38 +322,15 @@ static bool id_already_taken(int id, const char *prefix, const char *map_wwid)
>  	return alias_already_taken(alias, map_wwid);
>  }
>  
> -/*
> - * Returns: 0   if matching entry in WWIDs file found
> - *         -1   if an error occurs
> - *         >0   a free ID that could be used for the WWID at hand
> - * *map_alias is set to a freshly allocated string with the matching alias if
> - * the function returns 0, or to NULL otherwise.
> - */
> -static int
> -lookup_binding(FILE *f, const char *map_wwid, char **map_alias,
> -	       const char *prefix, int check_if_taken)
> +int get_free_id(const Bindings *bindings, const char *prefix, const char *map_wwid)
>  {
> -	char buf[LINE_MAX];
> -	unsigned int line_nr = 0;
> -	int id = 1;
> +	const struct binding *bdg;
> +	int i, id = 1;
>  	int biggest_id = 1;
>  	int smallest_bigger_id = INT_MAX;
>  
> -	*map_alias = NULL;
> -
> -	rewind(f);
> -	while (fgets(buf, LINE_MAX, f)) {
> -		const char *alias, *wwid;
> -		char *c, *saveptr;
> -		int curr_id;
> -
> -		line_nr++;
> -		c = strpbrk(buf, "#\n\r");
> -		if (c)
> -			*c = '\0';
> -		alias = strtok_r(buf, " \t", &saveptr);
> -		if (!alias) /* blank line */
> -			continue;
> +	vector_foreach_slot(bindings, bdg, i) {
> +		int curr_id = scan_devname(bdg->alias, prefix);
>  
>  		/*
>  		 * Find an unused index - explanation of the algorithm
> @@ -333,8 +365,6 @@ lookup_binding(FILE *f, const char *map_wwid, char **map_alias,
>  		 * biggest_id is always > smallest_bigger_id, except in the
>  		 * "perfectly ordered" case.
>  		 */
> -
> -		curr_id = scan_devname(alias, prefix);
>  		if (curr_id == id) {
>  			if (id < INT_MAX)
>  				id++;
> @@ -345,36 +375,15 @@ lookup_binding(FILE *f, const char *map_wwid, char **map_alias,
>  		}
>  		if (curr_id > biggest_id)
>  			biggest_id = curr_id;
> +
>  		if (curr_id > id && curr_id < smallest_bigger_id)
>  			smallest_bigger_id = curr_id;
> -		wwid = strtok_r(NULL, " \t", &saveptr);
> -		if (!wwid){
> -			condlog(3,
> -				"Ignoring malformed line %u in bindings file",
> -				line_nr);
> -			continue;
> -		}
> -		if (strcmp(wwid, map_wwid) == 0){
> -			condlog(3, "Found matching wwid [%s] in bindings file."
> -				" Setting alias to %s", wwid, alias);
> -			*map_alias = strdup(alias);
> -			if (*map_alias == NULL) {
> -				condlog(0, "Cannot copy alias from bindings "
> -					"file: out of memory");
> -				return -1;
> -			}
> -			return 0;
> -		}
>  	}
> -	if (!prefix && check_if_taken)
> -		id = -1;
> -	if (id >= smallest_bigger_id) {
> -		if (biggest_id < INT_MAX)
> -			id = biggest_id + 1;
> -		else
> -			id = -1;
> -	}
> -	if (id > 0 && check_if_taken) {
> +
> +	if (id >= smallest_bigger_id)
> +		id = biggest_id < INT_MAX ? biggest_id + 1 : -1;
> +
> +	if (id > 0) {
>  		while(id_already_taken(id, prefix, map_wwid)) {
>  			if (id == INT_MAX) {
>  				id = -1;
> @@ -391,64 +400,17 @@ lookup_binding(FILE *f, const char *map_wwid, char **map_alias,
>  			}
>  		}
>  	}
> -	if (id < 0) {
> +
> +	if (id < 0)
>  		condlog(0, "no more available user_friendly_names");
> -		return -1;
> -	} else
> -		condlog(3, "No matching wwid [%s] in bindings file.", map_wwid);
>  	return id;
>  }
>  
> -static int
> -rlookup_binding(FILE *f, char *buff, const char *map_alias)
> -{
> -	char line[LINE_MAX];
> -	unsigned int line_nr = 0;
> -
> -	buff[0] = '\0';
> -
> -	while (fgets(line, LINE_MAX, f)) {
> -		char *c, *saveptr;
> -		const char *alias, *wwid;
> -
> -		line_nr++;
> -		c = strpbrk(line, "#\n\r");
> -		if (c)
> -			*c = '\0';
> -		alias = strtok_r(line, " \t", &saveptr);
> -		if (!alias) /* blank line */
> -			continue;
> -		wwid = strtok_r(NULL, " \t", &saveptr);
> -		if (!wwid){
> -			condlog(3,
> -				"Ignoring malformed line %u in bindings file",
> -				line_nr);
> -			continue;
> -		}
> -		if (strlen(wwid) > WWID_SIZE - 1) {
> -			condlog(3,
> -				"Ignoring too large wwid at %u in bindings file", line_nr);
> -			continue;
> -		}
> -		if (strcmp(alias, map_alias) == 0){
> -			condlog(3, "Found matching alias [%s] in bindings file."
> -				" Setting wwid to %s", alias, wwid);
> -			strlcpy(buff, wwid, WWID_SIZE);
> -			return 0;
> -		}
> -	}
> -	condlog(3, "No matching alias [%s] in bindings file.", map_alias);
> -
> -	return -1;
> -}
> -
>  static char *
> -allocate_binding(int fd, const char *wwid, int id, const char *prefix)
> +allocate_binding(const char *filename, const char *wwid, int id, const char *prefix)
>  {
>  	STRBUF_ON_STACK(buf);
> -	off_t offset;
> -	ssize_t len;
> -	char *alias, *c;
> +	char *alias;
>  
>  	if (id <= 0) {
>  		condlog(0, "%s: cannot allocate new binding for id %d",
> @@ -460,164 +422,135 @@ allocate_binding(int fd, const char *wwid, int id, const char *prefix)
>  	    format_devname(&buf, id) == -1)
>  		return NULL;
>  
> -	if (print_strbuf(&buf, " %s\n", wwid) < 0)
> -		return NULL;
> -
> -	offset = lseek(fd, 0, SEEK_END);
> -	if (offset < 0){
> -		condlog(0, "Cannot seek to end of bindings file : %s",
> -			strerror(errno));
> -		return NULL;
> -	}
> -
> -	len = get_strbuf_len(&buf);
>  	alias = steal_strbuf_str(&buf);
>  
> -	if (write(fd, alias, len) != len) {
> -		condlog(0, "Cannot write binding to bindings file : %s",
> -			strerror(errno));
> -		/* clear partial write */
> -		if (ftruncate(fd, offset))
> -			condlog(0, "Cannot truncate the header : %s",
> -				strerror(errno));
> +	if (add_binding(&global_bindings, alias, wwid) != BINDING_ADDED) {
> +		condlog(0, "%s: cannot allocate new binding %s for %s",
> +			__func__, alias, wwid);
> +		free(alias);
> +		return NULL;
> +	}
> +
> +	if (update_bindings_file(&global_bindings, filename) == -1) {
> +		condlog(1, "%s: deleting binding %s for %s", __func__, alias, wwid);
> +		delete_binding(&global_bindings, wwid);
>  		free(alias);
>  		return NULL;
>  	}
> -	c = strchr(alias, ' ');
> -	if (c)
> -		*c = '\0';
>  
>  	condlog(3, "Created new binding [%s] for WWID [%s]", alias, wwid);
>  	return alias;
>  }
>  
> +/*
> + * get_user_friendly_alias() action table
> + *
> + * The table shows the various cases, the actions taken, and the CI
> + * functions from tests/alias.c that represent them.
> + *
> + *  - O: old alias given
> + *  - A: old alias in table (y: yes, correct WWID; X: yes, wrong WWID)
> + *  - W: wwid in table
> + *
> + *  | No | O | A | W | action                                     | function gufa_X              |
> + *  |----+---+---+---+--------------------------------------------+------------------------------|
> + *  |  1 | n | - | n | get new alias                              | nomatch_Y                    |
> + *  |  2 | n | - | y | use alias from bindings                    | match_a_Y                    |
> + *  |  3 | y | n | n | add binding for old alias                  | old_nomatch_nowwidmatch      |
> + *  |  4 | y | n | y | use alias from bindings (avoid duplicates) | old_nomatch_wwidmatch        |
> + *  |  5 | y | y | n | [ impossible ]                             | -                            |
> + *  |  6 | y | y | y | use old alias == alias from bindings       | old_match                    |
> + *  |  7 | y | X | n | get new alias                              | old_match_other              |
> + *  |  8 | y | X | y | use alias from bindings                    | old_match_other_wwidmatch    |
> + *
> + * Notes:
> + *  - "use alias from bindings" means that the alias from the bindings file will
> + *    be tried; if it is in use, the alias selection will fail. No other
> + *    bindings will be attempted.
> + *  - "get new alias" fails if all aliases are used up, or if writing the
> + *    bindings file fails.
> + *  - if "alias_old" is set, it can't be bound to a different map. alias_old is
> + *    initialized in find_existing_alias() by scanning the mpvec. We trust
> + *    that the mpvec corrcectly represents kernel state.
> + */
> +
>  char *get_user_friendly_alias(const char *wwid, const char *file, const char *alias_old,
>  			      const char *prefix, bool bindings_read_only)
>  {
>  	char *alias = NULL;
>  	int id = 0;
> -	int fd, can_write;
>  	bool new_binding = false;
> -	char buff[WWID_SIZE];
> -	FILE *f;
> +	const struct binding *bdg;
>  
> -	fd = open_file(file, &can_write, bindings_file_header);
> -	if (fd < 0)
> -		return NULL;
> -
> -	f = fdopen(fd, "r");
> -	if (!f) {
> -		condlog(0, "cannot fdopen on bindings file descriptor");
> -		close(fd);
> -		return NULL;
> -	}
> -
> -	if (!strlen(alias_old))
> +	if (!*alias_old)
>  		goto new_alias;
>  
> -	/* lookup the binding. if it exists, the wwid will be in buff
> -	 * either way, id contains the id for the alias
> -	 */
> -	rlookup_binding(f, buff, alias_old);
> -
> -	if (strlen(buff) > 0) {
> -		/* If buff is our wwid, it's already allocated correctly. */
> -		if (strcmp(buff, wwid) == 0) {
> +	/* See if there's a binding matching both alias_old and wwid */
> +	bdg = get_binding_for_alias(&global_bindings, alias_old);
> +	if (bdg) {
> +		if (!strcmp(bdg->wwid, wwid)) {
>  			alias = strdup(alias_old);
>  			goto out;
> -
>  		} else {
>  			condlog(0, "alias %s already bound to wwid %s, cannot reuse",
> -				alias_old, buff);
> -			goto new_alias;		     ;
> +				alias_old, bdg->wwid);
> +			goto new_alias;
>  		}
>  	}
>  
> -	/*
> -	 * Look for an existing alias in the bindings file.
> -	 * Pass prefix = NULL, so lookup_binding() won't try to allocate a new id.
> -	 */
> -	lookup_binding(f, wwid, &alias, NULL, 0);
> -	if (alias) {
> -		if (alias_already_taken(alias, wwid)) {
> -			free(alias);
> -			alias = NULL;
> -		} else
> -			condlog(3, "Use existing binding [%s] for WWID [%s]",
> -				alias, wwid);
> -		goto out;
> -	}
> -
> -	/* alias_old is already taken by our WWID, update bindings file. */
> +	/* allocate the existing alias in the bindings file */
>  	id = scan_devname(alias_old, prefix);
>  
>  new_alias:
> +	/* Check for existing binding of WWID */
> +	bdg = get_binding_for_wwid(&global_bindings, wwid);
> +	if (bdg) {
> +		if (!alias_already_taken(bdg->alias, wwid)) {
> +			condlog(3, "Use existing binding [%s] for WWID [%s]",
> +				bdg->alias, wwid);
> +			alias = strdup(bdg->alias);
> +		}
> +		goto out;
> +	}
> +
>  	if (id <= 0) {
>  		/*
>  		 * no existing alias was provided, or allocating it
>  		 * failed. Try a new one.
>  		 */
> -		id = lookup_binding(f, wwid, &alias, prefix, 1);
> -		if (id == 0 && alias_already_taken(alias, wwid)) {
> -			free(alias);
> -			alias = NULL;
> -		}
> +		id = get_free_id(&global_bindings, prefix, wwid);
>  		if (id <= 0)
>  			goto out;
>  		else
>  			new_binding = true;
>  	}
>  
> -	if (fflush(f) != 0) {
> -		condlog(0, "cannot fflush bindings file stream : %s",
> -			strerror(errno));
> -		goto out;
> -	}
> +	if (!bindings_read_only && id > 0)
> +		alias = allocate_binding(file, wwid, id, prefix);
>  
> -	if (can_write && !bindings_read_only) {
> -		alias = allocate_binding(fd, wwid, id, prefix);
> -		if (alias && !new_binding)
> -			condlog(2, "Allocated existing binding [%s] for WWID [%s]",
> -				alias, wwid);
> -	}
> +	if (alias && !new_binding)
> +		condlog(2, "Allocated existing binding [%s] for WWID [%s]",
> +			alias, wwid);
>  
>  out:
> -	pthread_cleanup_push(free, alias);
> -	fclose(f);
> -	pthread_cleanup_pop(0);
>  	return alias;
>  }
>  
> -int
> -get_user_friendly_wwid(const char *alias, char *buff, const char *file)
> +int get_user_friendly_wwid(const char *alias, char *buff)
>  {
> -	int fd, unused;
> -	FILE *f;
> +	const struct binding *bdg;
>  
>  	if (!alias || *alias == '\0') {
>  		condlog(3, "Cannot find binding for empty alias");
>  		return -1;
>  	}
>  
> -	fd = open_file(file, &unused, bindings_file_header);
> -	if (fd < 0)
> -		return -1;
> -
> -	f = fdopen(fd, "r");
> -	if (!f) {
> -		condlog(0, "cannot fdopen on bindings file descriptor : %s",
> -			strerror(errno));
> -		close(fd);
> +	bdg = get_binding_for_alias(&global_bindings, alias);
> +	if (!bdg) {
> +		*buff = '\0';
>  		return -1;
>  	}
> -
> -	rlookup_binding(f, buff, alias);
> -	if (!strlen(buff)) {
> -		fclose(f);
> -		return -1;
> -	}
> -
> -	fclose(f);
> +	strlcpy(buff, bdg->wwid, WWID_SIZE);
>  	return 0;
>  }
>  
> diff --git a/libmultipath/alias.h b/libmultipath/alias.h
> index 37b49d9..5ef6720 100644
> --- a/libmultipath/alias.h
> +++ b/libmultipath/alias.h
> @@ -2,7 +2,7 @@
>  #define _ALIAS_H
>  
>  int valid_alias(const char *alias);
> -int get_user_friendly_wwid(const char *alias, char *buff, const char *file);
> +int get_user_friendly_wwid(const char *alias, char *buff);
>  char *get_user_friendly_alias(const char *wwid, const char *file,
>  			      const char *alias_old,
>  			      const char *prefix, bool bindings_read_only);
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 029fbbd..d809490 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -1378,8 +1378,7 @@ static int _get_refwwid(enum mpath_cmds cmd, const char *dev,
>  			refwwid = tmpwwid;
>  
>  		/* or may be a binding */
> -		else if (get_user_friendly_wwid(dev, tmpwwid,
> -						conf->bindings_file) == 0)
> +		else if (get_user_friendly_wwid(dev, tmpwwid) == 0)
>  			refwwid = tmpwwid;
>  
>  		/* or may be an alias */
> -- 
> 2.42.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

