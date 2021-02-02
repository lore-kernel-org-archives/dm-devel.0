Return-Path: <SRS0=YUkt=HE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7AEC433DB
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 20:40:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DC30764E3F
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 20:40:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC30764E3F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1612298445;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OlI9lMpfYHU+5aDnFWvk6sL4oDXV0cJ93JYOlncg7K4=;
	b=JYLtdKt/P7dnqOmsnCuhK86nrwlQ0I0oEnDJq7a5Mb83y0Y+Wt/EM2Sx1yKLoVTD+Tvjmh
	mkK/z7gG7n/vuDz4fIR3mdaYihDePbLjcWC1VXDT3mB+BtYI5ZBx0n5GRIn6riQFff5xkA
	87qHZ598JfsDRpGdRUggl5utM7qZkvY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-_nI46IaQMEaZCzVgHWkijg-1; Tue, 02 Feb 2021 15:40:43 -0500
X-MC-Unique: _nI46IaQMEaZCzVgHWkijg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10E91801817;
	Tue,  2 Feb 2021 20:40:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B78BB5447B;
	Tue,  2 Feb 2021 20:40:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2201A18095CD;
	Tue,  2 Feb 2021 20:40:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 112KeT2r008517 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Feb 2021 15:40:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 338C910023BD; Tue,  2 Feb 2021 20:40:29 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CA7E8100164C;
	Tue,  2 Feb 2021 20:40:24 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 112KeNQL007964; 
	Tue, 2 Feb 2021 14:40:23 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 112KeMwI007963;
	Tue, 2 Feb 2021 14:40:22 -0600
Date: Tue, 2 Feb 2021 14:40:21 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210202204021.GV15006@octiron.msp.redhat.com>
References: <20210202195744.2384-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210202195744.2384-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] libmultipath: check if adopt_path() really
 added current path
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Feb 02, 2021 at 08:57:44PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The description of 2d32d6f ("libmultipath: adopt_paths(): don't bail out on
> single path failure") said "we need to check after successful call to
> adopt_paths() if that specific path had been actually added, and fail in the
> caller otherwise". But the commit failed to actually implement this check.
> Instead, it just checked if the path was member of the pathvec, which will
> almost always be the case.
> 
> Fix it by checking what actually needs to be checked, membership of the
> path to be added in mpp->paths.
> 
> Fixes: 2d32d6f ("libmultipath: adopt_paths(): don't bail out on single path failure")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> 
> @lixiaokeng, I believe that this fixes the issue you mentioned in your
> post "libmultipath: fix NULL dereference in get_be64".
> 
> ---
>  libmultipath/structs_vec.c | 4 ++--
>  multipathd/main.c          | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index f7f45f1..47b1d03 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -707,8 +707,8 @@ struct multipath *add_map_with_path(struct vectors *vecs, struct path *pp,
>  		goto out;
>  	mpp->size = pp->size;
>  
> -	if (adopt_paths(vecs->pathvec, mpp) ||
> -	    find_slot(vecs->pathvec, pp) == -1)
> +	if (adopt_paths(vecs->pathvec, mpp) || pp->mpp != mpp ||
> +	    find_slot(mpp->paths, pp) == -1)
>  		goto out;
>  
>  	if (add_vec) {
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 134185f..425492a 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1008,8 +1008,8 @@ rescan:
>  	if (mpp) {
>  		condlog(4,"%s: adopting all paths for path %s",
>  			mpp->alias, pp->dev);
> -		if (adopt_paths(vecs->pathvec, mpp) ||
> -		    find_slot(vecs->pathvec, pp) == -1)
> +		if (adopt_paths(vecs->pathvec, mpp) || pp->mpp != mpp ||
> +		    find_slot(mpp->paths, pp) == -1)
>  			goto fail; /* leave path added to pathvec */
>  
>  		verify_paths(mpp);
> -- 
> 2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

