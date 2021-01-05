Return-Path: <SRS0=jKmk=GI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB5B6C433E0
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 05:30:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3EEA722257
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 05:30:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EEA722257
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1609824636;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zHbLsPv8/gIh6r5P4pCIwkFWyzS1GhyIOvsquJs1g+I=;
	b=Qf8E3KekG3lLnQUkoIPvowlCTU69mpIDrEREuE0xDa1hoG8LX2VT68xIgitsvA3ZONDA87
	urmcGhKmGw9KoahbrJ5F+i16OLiTsF4+DS1HWSVS29filrvEwteLW6CIAStI/tn2Sz7oKU
	uNqHB/lDTSe3TTDKbnAXHpekNuo/D0M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-BsQpgEgNMHaWibnAqvyrKA-1; Tue, 05 Jan 2021 00:30:33 -0500
X-MC-Unique: BsQpgEgNMHaWibnAqvyrKA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F230800D55;
	Tue,  5 Jan 2021 05:30:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DDF77046C;
	Tue,  5 Jan 2021 05:30:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DA0FB180954D;
	Tue,  5 Jan 2021 05:30:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1055UJOs016840 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 5 Jan 2021 00:30:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4A81C60C04; Tue,  5 Jan 2021 05:30:19 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AA0B60BFA;
	Tue,  5 Jan 2021 05:30:13 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1055UCe4018834; 
	Mon, 4 Jan 2021 23:30:12 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1055UA26018833;
	Mon, 4 Jan 2021 23:30:10 -0600
Date: Mon, 4 Jan 2021 23:30:10 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: wucy11 <wucy11@chinatelecom.cn>
Message-ID: <20210105053010.GU3103@octiron.msp.redhat.com>
References: <008F6ED7-7117-458B-A573-B7396E4EF537@chinatelecom.cn>
MIME-Version: 1.0
In-Reply-To: <008F6ED7-7117-458B-A573-B7396E4EF537@chinatelecom.cn>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"mwilck@suse.com" <mwilck@suse.com>
Subject: Re: [dm-devel] [PATCH v3] multipathd: fix path checkint not changed
 when path state changed from delay to failed
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Dec 21, 2020 at 11:13:38AM +0800, wucy11 wrote:
> Hi all,
> The new patch shown as below acocording to ben's suggestion,  please ignore v2,
> thanks.
> 
> From 31ec4e9c270ff854b8edc526c5bcc9b24608d751 Mon Sep 17 00:00:00 2001
> From: Chongyun Wu <wucy11@chinatelecom.cn>
> Date: Wed, 16 Dec 2020 13:59:16 +0800
> Subject: [PATCH] multipathd: fix path checkint not changed when path state
>  form delay to failed
> 
> Check_path: when path state change back to failed from delay state, should
> change
> this path's check interval time to the shortest delay to faster path state
> check.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Chongyun Wu <wucy11@chinatelecom.cn>
> ---
>  multipathd/main.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index a4abbb27..9fd34e97 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2166,6 +2166,11 @@ check_path (struct vectors * vecs, struct path * pp,
> unsigned int ticks)
>   (pp->state == PATH_DELAYED)) {
>   /* If path state become failed again cancel path delay state */
>   pp->state = newstate;
> + /*
> + * path state bad again should change the check interval time
> + * to the shortest delay
> + */
> + pp->checkint = checkint;
>   return 1;
>   }
>   if (!pp->mpp) {
> -- 
> 2.29.2.windows.3
> 
> Best Regard,
> Chongyun Wu

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

