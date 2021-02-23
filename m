Return-Path: <SRS0=Sgdu=HZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74941C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 20:54:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B6EAF64E2E
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 20:54:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6EAF64E2E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1614113696;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VLwMnpi6EXaw3q1810C2h0rGou03wYeVK5HCVHgwuu0=;
	b=aMpYp3Fp/cH0Bv2vYnyuKBKlyhJjn4R3OX88+JwkI/d2DlO41UTJ996FUV8PtS1CW+dvPZ
	kT3pZoUiwUINZ9XDETq9/mAp6FAqgPlwjhN01qcXK2TIuMgkT4xrRGO3R1kf5f+LJWWiKg
	CfOCMttWaxcQHRO8qfJFiX71m47iqFs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-GRcoSnBhM4eln3_LT2YLXw-1; Tue, 23 Feb 2021 15:54:54 -0500
X-MC-Unique: GRcoSnBhM4eln3_LT2YLXw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F07B7835E3C;
	Tue, 23 Feb 2021 20:54:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9071A10016DB;
	Tue, 23 Feb 2021 20:54:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6E8BE50033;
	Tue, 23 Feb 2021 20:54:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11NKsim0032341 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Feb 2021 15:54:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D29585D9D7; Tue, 23 Feb 2021 20:54:44 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 51A6D5D9D3;
	Tue, 23 Feb 2021 20:54:35 +0000 (UTC)
Date: Tue, 23 Feb 2021 15:54:34 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <20210223205434.GB25684@redhat.com>
References: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
	<e3b3fc0a-cd07-a09c-5a8d-2d81c5d00435@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <e3b3fc0a-cd07-a09c-5a8d-2d81c5d00435@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, caspar@linux.alibaba.com, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
	ming.lei@redhat.com, hch@lst.de
Subject: Re: [dm-devel] [PATCH v4 00/12] dm: support IO polling
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

On Mon, Feb 22 2021 at 10:55pm -0500,
JeffleXu <jefflexu@linux.alibaba.com> wrote:

> 
> 
> On 2/20/21 7:06 PM, Jeffle Xu wrote:
> > [Changes since v3]
> > - newly add patch 7 and patch 11, as a new optimization improving
> > performance of multiple polling processes. Now performance of multiple
> > polling processes can be as scalable as single polling process (~30%).
> > Refer to the following [Performance] chapter for more details.
> > 
> 
> Hi Mike, would please evaluate this new version patch set? I think this
> mechanism is near maturity, since multi-thread performance is as
> scalable as single-thread (~30%) now.

OK, can do. But first I think you need to repost with a v5 that
addresses Mikulas' v3 feedback:

https://listman.redhat.com/archives/dm-devel/2021-February/msg00254.html
https://listman.redhat.com/archives/dm-devel/2021-February/msg00255.html

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

