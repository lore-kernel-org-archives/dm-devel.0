Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 201B3C2D0E4
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 02:50:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 80B0A20719
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 02:50:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GoeHhe64"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80B0A20719
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1606186240;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sq+Br3u+MqujgjQ97KD6P3r80CZawDELoIJVi9f1qdQ=;
	b=GoeHhe64LUrDWYPOMxidXaXY+UvymRJYGclxih7ikRHReL4cadwywzuDTmIwtim4MvYXDn
	/a9I/ddgVlnq4RI/SnERz8bQ47MIBTCARkdzCRLMr4CJKzDl2NE3CK2wcrSTbvlg+mfB4L
	byCJau0HQNtWTU2xLOsrbLg6sbTbQdc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-SQcsBQZYODiC6iiu5Y3h0g-1; Mon, 23 Nov 2020 21:50:38 -0500
X-MC-Unique: SQcsBQZYODiC6iiu5Y3h0g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 016921005E43;
	Tue, 24 Nov 2020 02:50:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FC625D6A1;
	Tue, 24 Nov 2020 02:50:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6E5C3180954D;
	Tue, 24 Nov 2020 02:50:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AO2oKNY002824 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 23 Nov 2020 21:50:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E55985D9CC; Tue, 24 Nov 2020 02:50:20 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E574C5D9CA;
	Tue, 24 Nov 2020 02:50:17 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0AO2oGMf024965; 
	Mon, 23 Nov 2020 20:50:16 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0AO2oFxi024964;
	Mon, 23 Nov 2020 20:50:15 -0600
Date: Mon, 23 Nov 2020 20:50:15 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Message-ID: <20201124025015.GC3103@octiron.msp.redhat.com>
References: <1604963562-31905-1-git-send-email-bmarzins@redhat.com>
MIME-Version: 1.0
In-Reply-To: <1604963562-31905-1-git-send-email-bmarzins@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [dm-devel] [PATCH] mpathpersist: Fix Register and Ignore with
 0x00 SARK
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

On Mon, Nov 09, 2020 at 05:12:42PM -0600, Benjamin Marzinski wrote:
> When the Register and Ignore command is run with sg_persist, if a 0x00
> Service Action Reservation Key is given or the --param-sark option is
> not used at all, sg_persist will clear the registration.  mpathpersist
> will fail with an error.  This patch fixes mpathpersist to work like
> sg_persist in this case.
>

NACK. This only fixes the case where "reservation_key" is set to "file".
It also needlessly clears the key in the prkeys file twice. I'll send
a fixed version.

-Ben
 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmpathpersist/mpath_persist.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
> index 79322e86..703f8e13 100644
> --- a/libmpathpersist/mpath_persist.c
> +++ b/libmpathpersist/mpath_persist.c
> @@ -289,8 +289,8 @@ int __mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
>  	put_multipath_config(conf);
>  
>  	memcpy(&prkey, paramp->sa_key, 8);
> -	if (mpp->prkey_source == PRKEY_SOURCE_FILE && prkey &&
> -	    ((!get_be64(mpp->reservation_key) &&
> +	if (mpp->prkey_source == PRKEY_SOURCE_FILE &&
> +	    ((!get_be64(mpp->reservation_key) && prkey &&
>  	      rq_servact == MPATH_PROUT_REG_SA) ||
>  	     rq_servact == MPATH_PROUT_REG_IGN_SA)) {
>  		memcpy(&mpp->reservation_key, paramp->sa_key, 8);
> -- 
> 2.17.2
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

