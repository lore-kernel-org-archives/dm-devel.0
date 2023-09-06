Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FD49EE14A9
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 22:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694040309;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ljhIJ1uYFQDsIKmKED1k3BEnjcjrg1aARVwav8Cngao=;
	b=ao0niE+L5Qt006S+RwY2rh6uM9azoX1UBAqYpJjHrze9I+vuoRXslLiS9jCuDCFOCOaVyi
	1jalkIKJcooUxHFT3NoPvn11U6EQstdWUkssDaN/Dn0Laa/6aYKin0+yr/JRQSgt1eHt5D
	kqJeKiAtegrHulFKZg9sWWjZ/pu+1M8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-bcDf1g2YO5aJWiFN_wcgZw-1; Wed, 06 Sep 2023 18:45:06 -0400
X-MC-Unique: bcDf1g2YO5aJWiFN_wcgZw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AEF1A1C06EEE;
	Wed,  6 Sep 2023 22:45:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9D31DC03292;
	Wed,  6 Sep 2023 22:45:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4B98A194658D;
	Wed,  6 Sep 2023 22:45:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CBA55194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 22:45:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AEC5A40C84A7; Wed,  6 Sep 2023 22:45:02 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F21440C2070;
 Wed,  6 Sep 2023 22:45:02 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 386Miskm028973;
 Wed, 6 Sep 2023 17:44:54 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 386Mis69028972;
 Wed, 6 Sep 2023 17:44:54 -0500
Date: Wed, 6 Sep 2023 17:44:53 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230906224453.GX7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-14-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230901180235.23980-14-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 13/21] libmultipath: alias.c: move bindings
 related code up
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 01, 2023 at 08:02:26PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> No code changes, just moving code.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/alias.c | 239 ++++++++++++++++++++++---------------------
>  1 file changed, 120 insertions(+), 119 deletions(-)
> 
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index af2f647..5a6cdee 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -9,6 +9,7 @@
>  #include <limits.h>
>  #include <stdio.h>
>  #include <stdbool.h>
> +#include <assert.h>
>  
>  #include "debug.h"
>  #include "util.h"
> @@ -51,6 +52,125 @@
>  
>  static const char bindings_file_header[] = BINDINGS_FILE_HEADER;
>  
> +struct binding {
> +	char *alias;
> +	char *wwid;
> +};
> +
> +/*
> + * Perhaps one day we'll implement this more efficiently, thus use
> + * an abstract type.
> + */
> +typedef struct _vector Bindings;
> +static Bindings global_bindings = { .allocated = 0 };
> +
> +enum {
> +	BINDING_EXISTS,
> +	BINDING_CONFLICT,
> +	BINDING_ADDED,
> +	BINDING_DELETED,
> +	BINDING_NOTFOUND,
> +	BINDING_ERROR,
> +};
> +
> +static void _free_binding(struct binding *bdg)
> +{
> +	free(bdg->wwid);
> +	free(bdg->alias);
> +	free(bdg);
> +}
> +
> +static int add_binding(Bindings *bindings, const char *alias, const char *wwid)
> +{
> +	struct binding *bdg;
> +	int i, cmp = 0;
> +
> +	/*
> +	 * Keep the bindings array sorted by alias.
> +	 * Optimization: Search backwards, assuming that the bindings file is
> +	 * sorted already.
> +	 */
> +	vector_foreach_slot_backwards(bindings, bdg, i) {
> +		if ((cmp = strcmp(bdg->alias, alias)) <= 0)
> +			break;
> +	}
> +
> +	/* Check for exact match */
> +	if (i >= 0 && cmp == 0)
> +		return strcmp(bdg->wwid, wwid) ?
> +			BINDING_CONFLICT : BINDING_EXISTS;
> +
> +	i++;
> +	bdg = calloc(1, sizeof(*bdg));
> +	if (bdg) {
> +		bdg->wwid = strdup(wwid);
> +		bdg->alias = strdup(alias);
> +		if (bdg->wwid && bdg->alias &&
> +		    vector_insert_slot(bindings, i, bdg))
> +			return BINDING_ADDED;
> +		else
> +			_free_binding(bdg);
> +	}
> +
> +	return BINDING_ERROR;
> +}
> +
> +static int write_bindings_file(const Bindings *bindings, int fd)
> +{
> +	struct binding *bnd;
> +	STRBUF_ON_STACK(line);
> +	int i;
> +
> +	if (write(fd, BINDINGS_FILE_HEADER, sizeof(BINDINGS_FILE_HEADER) - 1)
> +	    != sizeof(BINDINGS_FILE_HEADER) - 1)
> +		return -1;
> +
> +	vector_foreach_slot(bindings, bnd, i) {
> +		int len;
> +
> +		if ((len = print_strbuf(&line, "%s %s\n",
> +					bnd->alias, bnd->wwid)) < 0)
> +			return -1;
> +		if (write(fd, get_strbuf_str(&line), len) != len)
> +			return -1;
> +		truncate_strbuf(&line, 0);
> +	}
> +	return 0;
> +}
> +
> +static int update_bindings_file(const struct config *conf,
> +				const Bindings *bindings)
> +{
> +	int rc;
> +	int fd = -1;
> +	char tempname[PATH_MAX];
> +	mode_t old_umask;
> +
> +	if (safe_sprintf(tempname, "%s.XXXXXX", conf->bindings_file))
> +		return -1;
> +	/* coverity: SECURE_TEMP */
> +	old_umask = umask(0077);
> +	if ((fd = mkstemp(tempname)) == -1) {
> +		condlog(1, "%s: mkstemp: %m", __func__);
> +		return -1;
> +	}
> +	umask(old_umask);
> +	pthread_cleanup_push(cleanup_fd_ptr, &fd);
> +	rc = write_bindings_file(bindings, fd);
> +	pthread_cleanup_pop(1);
> +	if (rc == -1) {
> +		condlog(1, "failed to write new bindings file %s",
> +			tempname);
> +		unlink(tempname);
> +		return rc;
> +	}
> +	if ((rc = rename(tempname, conf->bindings_file)) == -1)
> +		condlog(0, "%s: rename: %m", __func__);
> +	else
> +		condlog(1, "updated bindings file %s", conf->bindings_file);
> +	return rc;
> +}
> +
>  int
>  valid_alias(const char *alias)
>  {
> @@ -505,25 +625,6 @@ get_user_friendly_wwid(const char *alias, char *buff, const char *file)
>  	return 0;
>  }
>  
> -struct binding {
> -	char *alias;
> -	char *wwid;
> -};
> -
> -static void _free_binding(struct binding *bdg)
> -{
> -	free(bdg->wwid);
> -	free(bdg->alias);
> -	free(bdg);
> -}
> -
> -/*
> - * Perhaps one day we'll implement this more efficiently, thus use
> - * an abstract type.
> - */
> -typedef struct _vector Bindings;
> -static Bindings global_bindings = { .allocated = 0 };
> -
>  static void free_bindings(Bindings *bindings)
>  {
>  	struct binding *bdg;
> @@ -539,106 +640,6 @@ void cleanup_bindings(void)
>  	free_bindings(&global_bindings);
>  }
>  
> -enum {
> -	BINDING_EXISTS,
> -	BINDING_CONFLICT,
> -	BINDING_ADDED,
> -	BINDING_DELETED,
> -	BINDING_NOTFOUND,
> -	BINDING_ERROR,
> -};
> -
> -static int add_binding(Bindings *bindings, const char *alias, const char *wwid)
> -{
> -	struct binding *bdg;
> -	int i, cmp = 0;
> -
> -	/*
> -	 * Keep the bindings array sorted by alias.
> -	 * Optimization: Search backwards, assuming that the bindings file is
> -	 * sorted already.
> -	 */
> -	vector_foreach_slot_backwards(bindings, bdg, i) {
> -		if ((cmp = strcmp(bdg->alias, alias)) <= 0)
> -			break;
> -	}
> -
> -	/* Check for exact match */
> -	if (i >= 0 && cmp == 0)
> -		return strcmp(bdg->wwid, wwid) ?
> -			BINDING_CONFLICT : BINDING_EXISTS;
> -
> -	i++;
> -	bdg = calloc(1, sizeof(*bdg));
> -	if (bdg) {
> -		bdg->wwid = strdup(wwid);
> -		bdg->alias = strdup(alias);
> -		if (bdg->wwid && bdg->alias &&
> -		    vector_insert_slot(bindings, i, bdg))
> -			return BINDING_ADDED;
> -		else
> -			_free_binding(bdg);
> -	}
> -
> -	return BINDING_ERROR;
> -}
> -
> -static int write_bindings_file(const Bindings *bindings, int fd)
> -{
> -	struct binding *bnd;
> -	STRBUF_ON_STACK(line);
> -	int i;
> -
> -	if (write(fd, BINDINGS_FILE_HEADER, sizeof(BINDINGS_FILE_HEADER) - 1)
> -	    != sizeof(BINDINGS_FILE_HEADER) - 1)
> -		return -1;
> -
> -	vector_foreach_slot(bindings, bnd, i) {
> -		int len;
> -
> -		if ((len = print_strbuf(&line, "%s %s\n",
> -					bnd->alias, bnd->wwid)) < 0)
> -			return -1;
> -		if (write(fd, get_strbuf_str(&line), len) != len)
> -			return -1;
> -		truncate_strbuf(&line, 0);
> -	}
> -	return 0;
> -}
> -
> -static int update_bindings_file(const struct config *conf,
> -				const Bindings *bindings)
> -{
> -	int rc;
> -	int fd = -1;
> -	char tempname[PATH_MAX];
> -	mode_t old_umask;
> -
> -	if (safe_sprintf(tempname, "%s.XXXXXX", conf->bindings_file))
> -		return -1;
> -	/* coverity: SECURE_TEMP */
> -	old_umask = umask(0077);
> -	if ((fd = mkstemp(tempname)) == -1) {
> -		condlog(1, "%s: mkstemp: %m", __func__);
> -		return -1;
> -	}
> -	umask(old_umask);
> -	pthread_cleanup_push(cleanup_fd_ptr, &fd);
> -	rc = write_bindings_file(bindings, fd);
> -	pthread_cleanup_pop(1);
> -	if (rc == -1) {
> -		condlog(1, "failed to write new bindings file %s",
> -			tempname);
> -		unlink(tempname);
> -		return rc;
> -	}
> -	if ((rc = rename(tempname, conf->bindings_file)) == -1)
> -		condlog(0, "%s: rename: %m", __func__);
> -	else
> -		condlog(1, "updated bindings file %s", conf->bindings_file);
> -	return rc;
> -}
> -
>  static int _check_bindings_file(const struct config *conf, FILE *file,
>  				 Bindings *bindings)
>  {
> -- 
> 2.41.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

