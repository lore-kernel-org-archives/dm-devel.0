Return-Path: <SRS0=3FFM=KT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66274C47085
	for <dm-devel@archiver.kernel.org>; Mon, 24 May 2021 15:56:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E69C16141F
	for <dm-devel@archiver.kernel.org>; Mon, 24 May 2021 15:56:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E69C16141F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1621871779;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0hUqW5hjlEO0GmRQGsGVGRJ9FHdJ+X2kMLC2cgYTZ2E=;
	b=V3MkN1oSPf+XRkYzs5C81B3za4489bhrdMUk8zqWFx7UpTChH0/GSEFc8Kz282noBjDGdA
	2PlgHjsR1DNZq96EQEbwxcZUJaQfi3EcbiCQ9qLCcNEXMx2cLjwtCXSlSLlL840TP4KwUf
	7zkqlMtYpgxAhfvS0laOjFA19xI12Ow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-rVLX3jfYMJ6ErlGxBH5r1w-1; Mon, 24 May 2021 11:56:17 -0400
X-MC-Unique: rVLX3jfYMJ6ErlGxBH5r1w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA662107ACCA;
	Mon, 24 May 2021 15:56:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 80C692B3DC;
	Mon, 24 May 2021 15:56:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7DC281801029;
	Mon, 24 May 2021 15:56:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14OFu2h9031696 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 24 May 2021 11:56:02 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 881C95D74F; Mon, 24 May 2021 15:56:02 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 11F9E5D71D;
	Mon, 24 May 2021 15:55:58 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 14OFtv3h024645; 
	Mon, 24 May 2021 10:55:57 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 14OFtuak024644;
	Mon, 24 May 2021 10:55:56 -0500
Date: Mon, 24 May 2021 10:55:56 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210524155556.GT25887@octiron.msp.redhat.com>
References: <20210520195208.30542-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210520195208.30542-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [dm-devel] [PATCH] libmultipath: fix build without
	LIBDM_API_DEFERRED
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, May 20, 2021 at 09:52:08PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Build fails on distributions that don't support DM_DEFERRED_REMOVE
> (libdevmapper < 1.02.89). Fix it.
> 
> Resolves: https://github.com/opensvc/multipath-tools/issues/7
> Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/devmapper.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 095cbc0..47a6d60 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -49,6 +49,9 @@ static int dm_conf_verbosity;
>  
>  #ifdef LIBDM_API_DEFERRED
>  static int dm_cancel_remove_partmaps(const char * mapname);
> +#define __DR_UNUSED__ /* empty */
> +#else
> +#define __DR_UNUSED__ __attribute__((unused))
>  #endif
>  
>  static int do_foreach_partmaps(const char * mapname,
> @@ -384,7 +387,8 @@ libmp_dm_task_create(int task)
>  #define do_deferred(x) ((x) == DEFERRED_REMOVE_ON || (x) == DEFERRED_REMOVE_IN_PROGRESS)
>  
>  static int
> -dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t udev_flags, int deferred_remove) {
> +dm_simplecmd (int task, const char *name, int no_flush, int need_sync,
> +	      uint16_t udev_flags, int deferred_remove __DR_UNUSED__) {
>  	int r = 0;
>  	int udev_wait_flag = ((need_sync || udev_flags) &&
>  			      (task == DM_DEVICE_RESUME ||
> @@ -1122,7 +1126,8 @@ dm_flush_map_nopaths(const char * mapname, int deferred_remove)
>  #else
>  
>  int
> -dm_flush_map_nopaths(const char * mapname, int deferred_remove)
> +dm_flush_map_nopaths(const char * mapname,
> +		     int deferred_remove __attribute__((unused)))
>  {
>  	return _dm_flush_map(mapname, 1, 0, 0, 0);
>  }
> @@ -1573,7 +1578,7 @@ dm_cancel_deferred_remove (struct multipath *mpp)
>  #else
>  
>  int
> -dm_cancel_deferred_remove (struct multipath *mpp)
> +dm_cancel_deferred_remove (struct multipath *mpp __attribute__((unused)))
>  {
>  	return 0;
>  }
> -- 
> 2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

