Return-Path: <SRS0=HcGL=N5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95FABC433F5
	for <dm-devel@archiver.kernel.org>; Tue,  7 Sep 2021 21:52:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1483660238
	for <dm-devel@archiver.kernel.org>; Tue,  7 Sep 2021 21:52:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1483660238
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631051534;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tkHnaUh5mS0X0b0QTzNQkAPdIxvWeyGZepZ4SjOMdZ8=;
	b=ITiyx7NxGhcvHGB82llgxkZU8XbkCaIxeFnd9VFFE43eO0wxbU8Lvn35GlWxWyeeKNrxW+
	HGN8Xvguxxckfnvowlz4Aa65FYZpmsNzUwRFcYx5KffhkhEKUwcMDuUAU4hpBU5LuLooIX
	APX9hqXqSTrvkuFpczedBejFO4s1MVg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-WaAeoUHKPoO2ywhGof-dYg-1; Tue, 07 Sep 2021 17:52:12 -0400
X-MC-Unique: WaAeoUHKPoO2ywhGof-dYg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73868800FF3;
	Tue,  7 Sep 2021 21:52:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 56B951002391;
	Tue,  7 Sep 2021 21:52:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 173C24EE0C;
	Tue,  7 Sep 2021 21:52:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 187Lq1JV032589 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 7 Sep 2021 17:52:02 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F15B06A8E4; Tue,  7 Sep 2021 21:52:01 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DEDC86A908;
	Tue,  7 Sep 2021 21:51:58 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 187LpuMa014609; 
	Tue, 7 Sep 2021 16:51:56 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 187Lptwl014608;
	Tue, 7 Sep 2021 16:51:55 -0500
Date: Tue, 7 Sep 2021 16:51:55 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210907215155.GI3087@octiron.msp.redhat.com>
References: <20210907065636.22937-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210907065636.22937-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 0/3] multipath-tools: final touces before
	next PR
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

On Tue, Sep 07, 2021 at 08:56:33AM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

for the set.

> 
> Hello Christophe, hello Ben,
> 
> here are a few final small fixes for the next multipath-tools PR:
> https://github.com/opensvc/multipath-tools/pull/13
> 
> (Christophe, please give Ben a few days for review before merging).
> 
> Notes:
> 
>  - The patch for libmultipath.version differs from the one I posted
>    previously (https://listman.redhat.com/archives/dm-devel/2021-September/msg00011.html).
>    In the previous one I hadn't sticked to the guide line I had
>    set up myself (bumping the version of every symbol in the ABI
>    for incompatible changes). The previous patch (bumping only the
>    version of the symbols that had actually changed) has some advantages,
>    in particular being able to track which symbols actually differ between
>    versions. We may want to discuss changing the policy towards
>    this procedure in the future, but we can't do it silently like I did
>    in the first version of this patch.
>  - I wrote previously that "libmultipath: drop unnecessary parameter 
>    from remove_map()" broke the directio test, but that was a braino.
>    It broke the dmevents tests. The fix is in this series.
> 
> Regards,
> Martin
> 
> Martin Wilck (3):
>   libmultipath.version: adapt to changes in remove_map
>   multipath-tools tests: fix dmevents test
>   Update .gitignore
> 
>  .gitignore                        |  4 ++++
>  libmultipath/libmultipath.version | 17 +++++++----------
>  tests/dmevents.c                  |  4 +---
>  3 files changed, 12 insertions(+), 13 deletions(-)
> 
> -- 
> 2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

