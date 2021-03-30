Return-Path: <SRS0=BXbM=I4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB8C5C433DB
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 06:19:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4295D6198A
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 06:19:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4295D6198A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1617085191;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3ThZMo2SNXd4v3uJx4AZmvC3xTgXQBq3oCOI3cqQgMY=;
	b=Zeks55uYHocw6XU5z2yc2LjjSKbudbmWe+1DfDy9q2zUjQYQzAWaHwholECaGBfm175sxZ
	YO2rGykJr8HtPQ48gg9X5NjJgdFnQg/clAUWe2MEgLrH3gMUHgDpHN2/vACpCkI0erpF1w
	2MpWqNl9f5iUdnLcFji3GdYLkW4snJk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-5dKORAiqPGOWhnSNQrc9Gw-1; Tue, 30 Mar 2021 02:19:48 -0400
X-MC-Unique: 5dKORAiqPGOWhnSNQrc9Gw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3087687504F;
	Tue, 30 Mar 2021 06:19:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED7E210023AF;
	Tue, 30 Mar 2021 06:19:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8878B4BB7C;
	Tue, 30 Mar 2021 06:19:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12U6Jf3G005394 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Mar 2021 02:19:41 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9244619706; Tue, 30 Mar 2021 06:19:41 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E32A819C45;
	Tue, 30 Mar 2021 06:19:38 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 12U6JboM007382; 
	Tue, 30 Mar 2021 01:19:37 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 12U6JbE7007381;
	Tue, 30 Mar 2021 01:19:37 -0500
Date: Tue, 30 Mar 2021 01:19:36 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210330061936.GP15006@octiron.msp.redhat.com>
References: <20210329101255.21373-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210329101255.21373-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] multipathd: reduce log levels in
	cli_add_map()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Mar 29, 2021 at 12:12:55PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Normally "add map" will be used to add a map which doesn't exist
> yet. Thus not finding this map in the first place is not a problem
> indicator and should be logged at level 3 only.
> 
Reviewed-by: Benjamin Marzinsk <bmarzins@redhat.com>

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ----
> Note: 
> 
> I've applied this patch to my "queue" branch by mistake already.
> I thought I'd posted it before. Sorry.
> 
> ---
>  multipathd/cli_handlers.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 7f3e61f..1de6ad8 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -852,14 +852,15 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
>  	}
>  	do {
>  		if (dm_get_major_minor(param, &major, &minor) < 0)
> -			condlog(2, "%s: not a device mapper table", param);
> +			condlog(count ? 2 : 3,
> +				"%s: not a device mapper table", param);
>  		else {
>  			sprintf(dev_path, "dm-%d", minor);
>  			alias = dm_mapname(major, minor);
>  		}
>  		/*if there is no mapname found, we first create the device*/
>  		if (!alias && !count) {
> -			condlog(2, "%s: mapname not found for %d:%d",
> +			condlog(3, "%s: mapname not found for %d:%d",
>  				param, major, minor);
>  			get_refwwid(CMD_NONE, param, DEV_DEVMAP,
>  				    vecs->pathvec, &refwwid);
> -- 
> 2.30.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

