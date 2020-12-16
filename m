Return-Path: <SRS0=g9U1=FU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E933C0018C
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 18:28:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EA09F25FA9
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 18:28:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA09F25FA9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-1RCb16v6Mfi6AlQkeeRUjw-1; Wed, 16 Dec 2020 13:28:31 -0500
X-MC-Unique: 1RCb16v6Mfi6AlQkeeRUjw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3016C1005504;
	Wed, 16 Dec 2020 18:28:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 11C9318024;
	Wed, 16 Dec 2020 18:28:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D8C745002D;
	Wed, 16 Dec 2020 18:28:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGIPKLF019471 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 13:25:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 385BCCF628; Wed, 16 Dec 2020 18:25:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3397BCF62E
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 18:25:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B758A186E123
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 18:25:17 +0000 (UTC)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com
	[209.85.167.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-130-FTBKNieqNZ2rKlhYs4zxMA-1; Wed, 16 Dec 2020 13:25:12 -0500
X-MC-Unique: FTBKNieqNZ2rKlhYs4zxMA-1
Received: by mail-lf1-f53.google.com with SMTP id o19so25165246lfo.1;
	Wed, 16 Dec 2020 10:25:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=c3CgEQWtonik7i7WhmRR9yyjT8nXpSj0nE8OYStDFB8=;
	b=NNR/jgc/JAwAORQGN7GBE9f3DuoEvyRqSnt/OoGqs5QjTLYZc+v1J2D2AxO/82Uihy
	SATd6Y8e+lXNSMFOL6BLDnqktUQybpXjLbc+XBy8SurMt3df0JSmky8o4sdWLHfrvMA/
	1+xGOGPinY/IZBXNTGWprPCvbmigERRip5J4rqQXu7iFdsM6GmUOVSnWjlrwmRK1dH54
	Lm93b4kZshmDpqbeZIwg1hGB8vcczIHs6e8jPOj8NGHrGlf15OaqQejf3GTYNXXUPzSH
	tJLibS2zWWmyXtyw5V8Hd8if8maxJ2hosricXJQIhAUGYXWdV5p3/rka25xbryQ4MUSj
	K/Pg==
X-Gm-Message-State: AOAM531NOM6LRHrEYudyXxFrk0gZFe8aicch95TdskttZram1BBminE3
	O6KNM/uA9naWpY169ORCOqSoJvc5rVBm3PRaWaoQgkw4LvY=
X-Google-Smtp-Source: ABdhPJww76Acs8JQrEXmG5podBxo/+oZp9geBXky0wxgfhDEThf2XF6oZuXZwmctBefOoqg5eedFQOcDUQcE0FSLnYk=
X-Received: by 2002:a05:6512:210c:: with SMTP id
	q12mr12982443lfr.601.1608143111015; 
	Wed, 16 Dec 2020 10:25:11 -0800 (PST)
MIME-Version: 1.0
References: <30d39293-80a4-9ef5-92bb-6b6dec464be3@toxicpanda.com>
	<mhng-2da5b1a2-20f9-4b0e-9ffd-7f60a161ebf0@palmerdabbelt-glaptop>
In-Reply-To: <mhng-2da5b1a2-20f9-4b0e-9ffd-7f60a161ebf0@palmerdabbelt-glaptop>
From: Vitaly Mayatskih <v.mayatskih@gmail.com>
Date: Wed, 16 Dec 2020 13:24:59 -0500
Message-ID: <CAGF4SLgDvS7VOih4XZ+sqx6jVK3wBQZan+uZMVsdYdVEPZdrpw@mail.gmail.com>
To: Palmer Dabbelt <palmer@dabbelt.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org, bvanassche@acm.org,
	Mike Snitzer <snitzer@redhat.com>, corbet@lwn.net,
	shuah@kernel.org, linux-doc@vger.kernel.org,
	josef@toxicpanda.com, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	michael.christie@oracle.com, linux-kselftest@vger.kernel.org,
	kernel-team@android.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v1 0/5] dm: dm-user: New target that proxies
 BIOs to userspace
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Dec 14, 2020 at 10:03 PM Palmer Dabbelt <palmer@dabbelt.com> wrote:

> I was really experting someone to say that.  It does seem kind of silly to build
> out the new interface, but not go all the way to a ring buffer.  We just didn't
> really have any way to justify the extra complexity as our use cases aren't
> that high performance.   I kind of like to have benchmarks for this sort of
> thing, though, and I didn't have anyone who had bothered avoiding the last copy
> to compare against.

I worked on something very similar, though performance was one of the
goals. The implementation was floating around lockless ring buffers,
shared memory for zerocopy, multiqueue and error handling. It could be
that every disk storage vendor has to implement something like that in
order to bridge Linux kernel to their own proprietary datapath running
in userspace.

-- 
wbr, Vitaly

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

