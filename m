Return-Path: <SRS0=wQ+j=IQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A35C433E0
	for <dm-devel@archiver.kernel.org>; Thu, 18 Mar 2021 14:48:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D4D2C64EFD
	for <dm-devel@archiver.kernel.org>; Thu, 18 Mar 2021 14:48:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4D2C64EFD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1616078889;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tJYh/O9mYhBdvg4pL6991l17c1edE+uvgFkt+EuAxAk=;
	b=MdOL9tbJDDbcyfreWqulv9hWkLQZsFR2vE7gdm5Pw74/BKPqjPdnKuhN6R/IKcW/UBn5MU
	NFHrvCuOgwyK3OLchYh45XCC93aVovGWL9jNZJ98URDtG6yLS48yKyvPNKFLxHpGaidLy9
	695nAQx281L4ciPH21yV5Gif+BMWkwU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-oHK59FKdM0iYm68gXrQWNw-1; Thu, 18 Mar 2021 10:48:07 -0400
X-MC-Unique: oHK59FKdM0iYm68gXrQWNw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20CBF180FCAB;
	Thu, 18 Mar 2021 14:48:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 959F4610F0;
	Thu, 18 Mar 2021 14:47:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B32BF1809C83;
	Thu, 18 Mar 2021 14:47:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12IElrXV011388 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Mar 2021 10:47:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4F66F19D9B; Thu, 18 Mar 2021 14:47:53 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 386871975E;
	Thu, 18 Mar 2021 14:47:49 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 12IEllGk017863; 
	Thu, 18 Mar 2021 09:47:47 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 12IEllKh017862;
	Thu, 18 Mar 2021 09:47:47 -0500
Date: Thu, 18 Mar 2021 09:47:46 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210318144746.GA15006@octiron.msp.redhat.com>
References: <20210318091413.28027-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210318091413.28027-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 1/3] libmultipath: merge
 update_multipath_table() and update_multipath_status()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 18, 2021 at 10:14:11AM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Since 378cb66 ("multipath: use update_pathvec_from_dm()"),
> we remove paths and even pathgroups from multipathd's data structures
> in update_multipath_table() if these paths are found to be non-existent.
> But update_multipath_status() is called afterwards, and it
> uses the kernel's mapping of pathgroups and paths, which won't match
> any more if any members had been removed. disassemble_status() returns
> an error if the number of path groups doesn't match, causing the
> entire structure setup to fail. And because disassemble_status()
> doesn't check the dev_t against the corresponding values in multipathd's
> data structures, it may assign wrong DM state to paths.
> 
> Fix this by calling disassemble_status() before making any changes to
> the data structure in update_pathvec_from_dm(). This can be easily
> done, because every call to update_multipath_status() is preceded
> by a call to update_multipath_table() anyway, and vice versa. So
> we simply merge the two functions into one. This actually simplifies
> the code for all callers.
> 
> As we remove a symbol, the major library version must be bumped.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
> Changes v1 -> v2:
>  - log errors at -v2 in update_multipath_table() (Ben)
>  - return error in update_multipath_strings() if
>    update_multipath_table() fails (Ben)
> 
> ---
>  libmpathpersist/mpath_persist.c   |  1 -
>  libmultipath/libmultipath.version | 30 ++++++++----------------
>  libmultipath/structs_vec.c        | 38 ++++++++-----------------------
>  multipath/main.c                  |  6 ++---
>  multipathd/main.c                 |  5 +---
>  5 files changed, 21 insertions(+), 59 deletions(-)
> 
> diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
> index 5c95af2..190e970 100644
> --- a/libmpathpersist/mpath_persist.c
> +++ b/libmpathpersist/mpath_persist.c
> @@ -408,7 +408,6 @@ get_mpvec (vector curmp, vector pathvec, char * refwwid)
>  			continue;
>  
>  		if (update_multipath_table(mpp, pathvec, DI_CHECKER) != DMP_OK ||
> -		    update_multipath_status(mpp) != DMP_OK ||
>  		    update_mpp_paths(mpp, pathvec)) {
>  			condlog(1, "error parsing map %s", mpp->wwid);
>  			remove_map(mpp, pathvec, curmp, PURGE_VEC);
> diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
> index e9b4608..0cff311 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -31,7 +31,7 @@
>   *   The new version inherits the previous ones.
>   */
>  
> -LIBMULTIPATH_4.0.0 {
> +LIBMULTIPATH_5.0.0 {
>  global:
>  	/* symbols referenced by multipath and multipathd */
>  	add_foreign;
> @@ -198,7 +198,6 @@ global:
>  	uevent_is_mpath;
>  	uevent_listen;
>  	update_mpp_paths;
> -	update_multipath_status;
>  	update_multipath_strings;
>  	update_multipath_table;
>  	update_pathvec_from_dm;
> @@ -256,33 +255,22 @@ global:
>  	libmultipath_init;
>  	libmultipath_exit;
>  
> -local:
> -	*;
> -};
> -
> -LIBMULTIPATH_4.1.0 {
> -global:
> +	/* added in 4.1.0 */
>  	libmp_verbosity;
> -} LIBMULTIPATH_4.0.0;
>  
> -LIBMULTIPATH_4.2.0 {
> -global:
> +	/* added in 4.2.0 */
>  	dm_prereq;
>  	skip_libmp_dm_init;
> -} LIBMULTIPATH_4.1.0;
>  
> -LIBMULTIPATH_4.3.0 {
> -global:
> +	/* added in 4.3.0 */
>  	start_checker_thread;
> -} LIBMULTIPATH_4.2.0;
>  
> -LIBMULTIPATH_4.4.0 {
> -global:
> +	/* added in 4.4.0 */
>  	get_next_string;
> -} LIBMULTIPATH_4.3.0;
>  
> -LIBMULITIPATH_4.5.0 {
> -global:
> +	/* added in 4.5.0 */
>  	get_vpd_sgio;
>  	trigger_partitions_udev_change;
> -} LIBMULTIPATH_4.4.0;
> +local:
> +	*;
> +};
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 57cd88a..0b069f4 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -423,44 +423,27 @@ update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
>  
>  	r = dm_get_map(mpp->alias, &mpp->size, params);
>  	if (r != DMP_OK) {
> -		condlog(3, "%s: %s", mpp->alias, (r == DMP_ERR)? "error getting table" : "map not present");
> +		condlog(2, "%s: %s", mpp->alias, (r == DMP_ERR)? "error getting table" : "map not present");
>  		return r;
>  	}
>  
>  	if (disassemble_map(pathvec, params, mpp)) {
> -		condlog(3, "%s: cannot disassemble map", mpp->alias);
> +		condlog(2, "%s: cannot disassemble map", mpp->alias);
>  		return DMP_ERR;
>  	}
>  
> +	*params = '\0';
> +	if (dm_get_status(mpp->alias, params) != DMP_OK)
> +		condlog(2, "%s: %s", mpp->alias, (r == DMP_ERR)? "error getting status" : "map not present");
> +	else if (disassemble_status(params, mpp))
> +		condlog(2, "%s: cannot disassemble status", mpp->alias);
> +
>  	/* FIXME: we should deal with the return value here */
>  	update_pathvec_from_dm(pathvec, mpp, flags);
>  
>  	return DMP_OK;
>  }
>  
> -int
> -update_multipath_status (struct multipath *mpp)
> -{
> -	int r = DMP_ERR;
> -	char status[PARAMS_SIZE] = {0};
> -
> -	if (!mpp)
> -		return r;
> -
> -	r = dm_get_status(mpp->alias, status);
> -	if (r != DMP_OK) {
> -		condlog(3, "%s: %s", mpp->alias, (r == DMP_ERR)? "error getting status" : "map not present");
> -		return r;
> -	}
> -
> -	if (disassemble_status(status, mpp)) {
> -		condlog(3, "%s: cannot disassemble status", mpp->alias);
> -		return DMP_ERR;
> -	}
> -
> -	return DMP_OK;
> -}
> -
>  static struct path *find_devt_in_pathgroups(const struct multipath *mpp,
>  					    const char *dev_t)
>  {
> @@ -538,11 +521,8 @@ update_multipath_strings(struct multipath *mpp, vector pathvec)
>  	r = update_multipath_table(mpp, pathvec, 0);
>  	if (r != DMP_OK)
>  		return r;
> -	sync_paths(mpp, pathvec);
>  
> -	r = update_multipath_status(mpp);
> -	if (r != DMP_OK)
> -		return r;
> +	sync_paths(mpp, pathvec);
>  
>  	vector_foreach_slot(mpp->pg, pgp, i)
>  		if (pgp->paths)
> diff --git a/multipath/main.c b/multipath/main.c
> index 3f97582..ef89c7c 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -196,8 +196,7 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
>  			continue;
>  		}
>  
> -		if (update_multipath_table(mpp, pathvec, flags) != DMP_OK ||
> -		    update_multipath_status(mpp) != DMP_OK) {
> +		if (update_multipath_table(mpp, pathvec, flags) != DMP_OK) {
>  			condlog(1, "error parsing map %s", mpp->wwid);
>  			remove_map(mpp, pathvec, curmp, PURGE_VEC);
>  			i--;
> @@ -263,8 +262,7 @@ static int check_usable_paths(struct config *conf,
>  	if (mpp == NULL)
>  		goto free;
>  
> -	if (update_multipath_table(mpp, pathvec, 0) != DMP_OK ||
> -		    update_multipath_status(mpp) != DMP_OK)
> +	if (update_multipath_table(mpp, pathvec, 0) != DMP_OK)
>  		    goto free;
>  
>  	vector_foreach_slot (mpp->pg, pg, i) {
> diff --git a/multipathd/main.c b/multipathd/main.c
> index e0797cc..154a4ee 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -559,8 +559,6 @@ add_map_without_path (struct vectors *vecs, const char *alias)
>  
>  	if (update_multipath_table(mpp, vecs->pathvec, 0) != DMP_OK)
>  		goto out;
> -	if (update_multipath_status(mpp) != DMP_OK)
> -		goto out;
>  
>  	if (!vector_alloc_slot(vecs->mpvec))
>  		goto out;
> @@ -1469,8 +1467,7 @@ map_discovery (struct vectors * vecs)
>  		return 1;
>  
>  	vector_foreach_slot (vecs->mpvec, mpp, i)
> -		if (update_multipath_table(mpp, vecs->pathvec, 0) != DMP_OK ||
> -		    update_multipath_status(mpp) != DMP_OK) {
> +		if (update_multipath_table(mpp, vecs->pathvec, 0) != DMP_OK) {
>  			remove_map(mpp, vecs->pathvec, vecs->mpvec, PURGE_VEC);
>  			i--;
>  		}
> -- 
> 2.30.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

