Return-Path: <SRS0=/g2B=HM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB94EC433DB
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 18:35:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6280E64E0B
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 18:35:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6280E64E0B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1612982101;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2g0KxIx1kb8wq7Jb/0/c+AJi2AMQ5Xx2TUKWNbp/sRg=;
	b=GOSdW6CvbVD7DJ/RluBhs9TdKdYRnexCfG8hZUbW+Cx2jBjXvoC2BxAP/CxQLzcTtkO+/f
	Yqh3Z9PkSWIfrPNM2wtg2X6NPmLZbGKqyVzprVyDJp2SvwZJcIT6U4Pxo5JciG/IedXIAh
	wuPc+8qVh3xKSxOgqq4Bocc4GKQePSI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-JGIxwwQBPD6TEQS44q3gfA-1; Wed, 10 Feb 2021 13:34:58 -0500
X-MC-Unique: JGIxwwQBPD6TEQS44q3gfA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 079376D4F6;
	Wed, 10 Feb 2021 18:34:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EB4260C0F;
	Wed, 10 Feb 2021 18:34:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 01EED85F0;
	Wed, 10 Feb 2021 18:34:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11AIYVaQ031125 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Feb 2021 13:34:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D95FB18EC5; Wed, 10 Feb 2021 18:34:31 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A7D960C5C;
	Wed, 10 Feb 2021 18:34:31 +0000 (UTC)
Date: Wed, 10 Feb 2021 13:34:30 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Hung Tsai <mtsai@redhat.com>
Message-ID: <20210210183430.GB7904@redhat.com>
References: <20210122152556.24822-1-ntsironis@arrikto.com>
	<CALjSBEuWgLHiPwkrMCpUWWV3VOOO98ZydCrzs1_qvCjSnyO5GQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjSBEuWgLHiPwkrMCpUWWV3VOOO98ZydCrzs1_qvCjSnyO5GQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, agk@redhat.com, ntsironis@arrikto.com,
	Edward Thornber <ejt@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/4] dm era: Various minor fixes
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 10 2021 at 12:56pm -0500,
Ming Hung Tsai <mtsai@redhat.com> wrote:

> On Fri, Jan 22, 2021 at 11:30 PM Nikos Tsironis <ntsironis@arrikto.com> wrote:
> >
> > While working on fixing the bugs that cause lost writes, for which I
> > have sent separate emails, I bumped into several other minor issues that
> > I fix in this patch set.
> >
> > In particular, this series of commits introduces the following fixes:
> >
> > 1. Add explicit check that the data block size hasn't changed
> > 2. Fix bitset memory leaks. The in-core bitmaps were never freed.
> > 3. Fix the writeset tree equality test function to use the right value
> >    size.
> > 4. Remove unreachable resize operation in pre-resume function.
> >
> > More information about the fixes can be found in their commit messages.
> >
> > Nikos Tsironis (4):
> >   dm era: Verify the data block size hasn't changed
> >   dm era: Fix bitset memory leaks
> >   dm era: Use correct value size in equality function of writeset tree
> >   dm era: Remove unreachable resize operation in pre-resume function
> >
> >  drivers/md/dm-era-target.c | 27 ++++++++++++++++-----------
> >  1 file changed, 16 insertions(+), 11 deletions(-)
> 
> For the series, except 4/4 where I haven't tried other solutions.
> 
> Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>

patchwork doesn't parse this, so it falls on me to backfill tags like
this.  In the future, please reply to each patch with your desired tag.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

