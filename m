Return-Path: <SRS0=kRAg=EI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD57C00A89
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 22:00:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C5BCD22275
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 22:00:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Geqie37Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5BCD22275
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604354403;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xHjlaX87d/yeANbhdbt9S7678Vq03JoG22hb3HqOVd8=;
	b=Geqie37QUlaYzMj6hg0rWMssWt5WsdLZb+U+wGWbfqdWinhe1Crb7uEcssD95kzuLqweT6
	PMAbNzwfzsVD6J+DrYRmKR8hwtSAlQlUyuepwLcIi2j+XR0vKuQMzNec3HBNIKkOf94ok7
	JADjKsFOMmeET00//x96D4v+fbgU0ic=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-wW4gqU-tPnmiKeVo6Jzq1g-1; Mon, 02 Nov 2020 17:00:00 -0500
X-MC-Unique: wW4gqU-tPnmiKeVo6Jzq1g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4ACCB188C122;
	Mon,  2 Nov 2020 21:59:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 941C91002C21;
	Mon,  2 Nov 2020 21:59:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AFA5044A43;
	Mon,  2 Nov 2020 21:59:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A2LxjxZ016884 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 2 Nov 2020 16:59:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0A66B1002C24; Mon,  2 Nov 2020 21:59:45 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EC3D1002C21;
	Mon,  2 Nov 2020 21:59:41 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0A2LxeER012194; 
	Mon, 2 Nov 2020 15:59:40 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0A2Lxdmt012193;
	Mon, 2 Nov 2020 15:59:39 -0600
Date: Mon, 2 Nov 2020 15:59:38 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <20201102215938.GU3384@octiron.msp.redhat.com>
References: <fd96f23b-63ff-4933-b112-667e5adce0b5@huawei.com>
MIME-Version: 1.0
In-Reply-To: <fd96f23b-63ff-4933-b112-667e5adce0b5@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	dm-devel mailing list <dm-devel@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH v3] libmultipath: fix memory leaks in
	coalesce_paths
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 02, 2020 at 10:41:22AM +0800, lixiaokeng wrote:
> When multipath -F are executed first and multipath -v2 or
> -d are executed later, asan will warn memory leaks. The
> reason is that the mpp allocated in coalesce_paths isn't
> freed. Here we use newmp to store mpp. If mpvec is NULL,
> we free newmp at the end of the func.
> 
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Linfeilong <linfeilong@huawei.com>
> ---
>  libmultipath/configure.c | 40 +++++++++++++++++++++++++++++-----------
>  1 file changed, 29 insertions(+), 11 deletions(-)
> 
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 6fb477fc..649002c3 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -1132,7 +1132,7 @@ out:
>   * FORCE_RELOAD_WEAK: existing maps are compared to the current conf and only
>   * reloaded in DM if there's a difference. This is useful during startup.
>   */
> -int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
> +int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
>  		    int force_reload, enum mpath_cmds cmd)
>  {
>  	int ret = CP_FAIL;
> @@ -1144,10 +1144,20 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
>  	struct path * pp2;
>  	vector curmp = vecs->mpvec;
>  	vector pathvec = vecs->pathvec;
> +	vector newmp;
>  	struct config *conf;
>  	int allow_queueing;
>  	struct bitfield *size_mismatch_seen;
> 
> +	if (mpvec)
> +		newmp = mpvec;
> +	else
> +		newmp = vector_alloc();
> +	if (!newmp) {
> +		condlog(0, "can not allocate newmp");
> +		return ret;
> +	}
> +

It's possible that this patch is based on different code than I am
looking at, but otherwise, You should either move this code below the
code that checks the pathvec size and allocates the bitfield, or make
the failure path for that code free newmp, if necessary. Otherwise, you
could leak newmp on those failures.

-Ben

>  	/* ignore refwwid if it's empty */
>  	if (refwwid && !strlen(refwwid))
>  		refwwid = NULL;
> @@ -1270,8 +1280,14 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
>  				goto out;
>  			}
>  		}
> -		if (r == DOMAP_DRY)
> +		if (r == DOMAP_DRY) {
> +			if (!vector_alloc_slot(newmp)) {
> +				remove_map(mpp, vecs->pathvec, vecs->mpvec, KEEP_VEC);
> +				goto out;
> +			}
> +			vector_set_slot(newmp, mpp);
>  			continue;
> +		}
> 
>  		if (r == DOMAP_EXIST && mpp->action == ACT_NOTHING &&
>  		    force_reload == FORCE_RELOAD_WEAK)
> @@ -1307,22 +1323,22 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
>  			print_multipath_topology(mpp, verbosity);
>  		}
> 
> -		if (newmp) {
> -			if (mpp->action != ACT_REJECT) {
> -				if (!vector_alloc_slot(newmp))
> -					goto out;
> -				vector_set_slot(newmp, mpp);
> +		if (mpp->action != ACT_REJECT) {
> +			if (!vector_alloc_slot(newmp)) {
> +				remove_map(mpp, vecs->pathvec, vecs->mpvec, KEEP_VEC);
> +				goto out;
>  			}
> -			else
> -				remove_map(mpp, vecs->pathvec, vecs->mpvec,
> -					   KEEP_VEC);
> +			vector_set_slot(newmp, mpp);
>  		}
> +		else
> +			remove_map(mpp, vecs->pathvec, vecs->mpvec,
> +				   KEEP_VEC);
>  	}
>  	/*
>  	 * Flush maps with only dead paths (ie not in sysfs)
>  	 * Keep maps with only failed paths
>  	 */
> -	if (newmp) {
> +	if (mpvec) {
>  		vector_foreach_slot (newmp, mpp, i) {
>  			char alias[WWID_SIZE];
> 
> @@ -1345,6 +1361,8 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
>  	ret = CP_OK;
>  out:
>  	free(size_mismatch_seen);
> +	if (!mpvec)
> +		free_multipathvec(newmp, KEEP_PATHS);
>  	return ret;
>  }

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

