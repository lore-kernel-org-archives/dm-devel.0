Return-Path: <SRS0=xRQ1=F3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 125A3C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 23 Dec 2020 21:32:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 771C822273
	for <dm-devel@archiver.kernel.org>; Wed, 23 Dec 2020 21:31:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 771C822273
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-an85rj3rP32_C5FRFbIpMQ-1; Wed, 23 Dec 2020 16:31:55 -0500
X-MC-Unique: an85rj3rP32_C5FRFbIpMQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D568710054FF;
	Wed, 23 Dec 2020 21:31:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 842472BFE3;
	Wed, 23 Dec 2020 21:31:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C5A7B180954D;
	Wed, 23 Dec 2020 21:31:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BNLVlGo006217 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Dec 2020 16:31:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4CFC31102E05; Wed, 23 Dec 2020 21:31:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 48AB31102E03
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 21:31:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FFC28007D9
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 21:31:45 +0000 (UTC)
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com
	[209.85.166.178]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-449-t2c1PYohNQ6qQAHJxyy0YQ-1; Wed, 23 Dec 2020 16:31:41 -0500
X-MC-Unique: t2c1PYohNQ6qQAHJxyy0YQ-1
Received: by mail-il1-f178.google.com with SMTP id v3so387784ilo.5
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 13:31:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=QbxsWfgRlzCJgOBxqB1SwxZEGeePTfdrMkj+YGC6JAo=;
	b=asHoYByvazcqN2qg47PeCON9KZvIrD4EVwZz8TJqOFDp3OsvqNv3L3xixSpJwBj2LV
	KF9FldF/b6R2RwfKSrASwlz/8S2N2grunbBhFkYk8Awuo3k1EmHkWcK+kFzFy8Mca0D2
	3ilItrVs9X75zE+Vv83OolCZvkuzWTr5YtLc+mxbgu78uNdvrlwUJrSblz3sEpnhH8Op
	KsmI80bN9QTSOZHip/WWBydunDLdiDpseogYzlNXSxfukRZTeMUQjZx3sKZ1zHURg2BI
	GRuKJQtsBIgD3qteUqtmU30Kt7SHMZJMy/YrOc9+2n7iCOxtl+G0NoibN3b8g7eADhYL
	9NiQ==
X-Gm-Message-State: AOAM532UzeKxo2GRj5E5lrjJFeA+up53Nby9lQoDtiluBW5tS6JT41be
	L6IsugFT+ciqMUbTs5UG4pRKQA2zwrBQWi6SXuq6bw==
X-Google-Smtp-Source: ABdhPJw7V/eEElU2vOuKPcbbwjTNnQSkE2GjRl2RJ/IHsDvus/FqzOOyUqBW6cMF5+UWgLfMLa4buvJS20HzeW05lDI=
X-Received: by 2002:a05:6e02:10c3:: with SMTP id
	s3mr27679093ilj.269.1608759100500; 
	Wed, 23 Dec 2020 13:31:40 -0800 (PST)
MIME-Version: 1.0
References: <16ffadab-42ba-f9c7-8203-87fda3dc9b44@maciej.szmigiero.name>
	<74c7129b-a437-ebc4-1466-7fb9f034e006@maciej.szmigiero.name>
	<CALrw=nHiSPxVxxuA1fekwDOqBZX0BGe8_3DTN7TNkrVD2q8rxg@mail.gmail.com>
	<fc27dc51-65a7-f2fa-6b29-01a1d5eaec6c@maciej.szmigiero.name>
In-Reply-To: <fc27dc51-65a7-f2fa-6b29-01a1d5eaec6c@maciej.szmigiero.name>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Wed, 23 Dec 2020 21:31:29 +0000
Message-ID: <CALrw=nEuMx4YDCFEa89kxn-pw+65h61g1grSsvY8sd=JeGAHjA@mail.gmail.com>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mike Snitzer <snitzer@redhat.com>,
	kernel-team <kernel-team@cloudflare.com>, dm-crypt@saout.de,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Nobuto Murata <nobuto.murata@canonical.com>,
	Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
	device-mapper development <dm-devel@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>, Alasdair G Kergon <agk@redhat.com>,
	linux-crypto <linux-crypto@vger.kernel.org>
Subject: Re: [dm-devel] dm-crypt with no_read_workqueue and
 no_write_workqueue + btrfs scrub = BUG()
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 23, 2020 at 9:20 PM Maciej S. Szmigiero
<mail@maciej.szmigiero.name> wrote:
>
> On 23.12.2020 22:09, Ignat Korchagin wrote:
> (..)
> > I've been looking into this for the last couple of days because of
> > other reports [1].
> > Just finished testing a possible solution. Will submit soon.
>
> Thanks for looking into it.
>
> By the way, on a bare metal I am actually hitting a different problem
> (scheduling while atomic) when scrubbing a btrfs filesystem, just as one
> of your users from that GitHub report had [1].

That is because dm-crypt calls "wait_for_completion" in rare cases
when Crypto API (cryptd) backlogs the decryption request. I've
reproduced that one as well (even with no FS).
We never hit these problems in the original testing probably due to
the fact we mostly used xtsproxy custom crypto module, which is
totally synchronous.
I did test it later with standard crypto, but did not encounter these
problems as well most likely because it is also depends which storage
driver underneath we are using: most of them do not submit read
requests to dm-crypt in irq/softirq context in the first place

> I've pasted that backtrace in my original Dec 14 message.
>
> Thanks,
> Maciej
>
> [1]: https://github.com/cloudflare/linux/issues/1#issuecomment-736734243

Regards,
Ignat

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

