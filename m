Return-Path: <SRS0=xRQ1=F3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81DBFC433E0
	for <dm-devel@archiver.kernel.org>; Wed, 23 Dec 2020 21:10:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E1F95223E4
	for <dm-devel@archiver.kernel.org>; Wed, 23 Dec 2020 21:10:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1F95223E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-8wzQ8kWYMVWIZlblOIErDQ-1; Wed, 23 Dec 2020 16:10:24 -0500
X-MC-Unique: 8wzQ8kWYMVWIZlblOIErDQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9323E1842141;
	Wed, 23 Dec 2020 21:10:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 466EF5D9CD;
	Wed, 23 Dec 2020 21:10:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 84C05180954D;
	Wed, 23 Dec 2020 21:10:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BNLAE1v004161 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Dec 2020 16:10:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EEE8794620; Wed, 23 Dec 2020 21:10:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E91C6A9EE2
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 21:10:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9AD13800198
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 21:10:11 +0000 (UTC)
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com
	[209.85.166.173]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-421-1wsCaLDmOICWhHHjJfF2nw-1; Wed, 23 Dec 2020 16:10:07 -0500
X-MC-Unique: 1wsCaLDmOICWhHHjJfF2nw-1
Received: by mail-il1-f173.google.com with SMTP id 2so319764ilg.9
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 13:10:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=0ZMUDMR4pTmJNoSoaiKNNtdLIWf0D/EJ1+mQ+sQxsp0=;
	b=g66gmqyfVMZa7BivHgv24lxkUiQrfHaNEibtsOZmF5mb/TuKWeIuwz2/foeu0bz43P
	hW1pjaw7wYwkTLdEPPvrzdVWF95SC75vfpl3psKHRNkeTw1ijHK5HW49yNH+dxmnIR8b
	J/lWruXmv9odmdGm6VmUqPDwP/lEC7lpq9OWYosyIESZLQadIgYaMu+PTlKnnFN1xMfx
	vi22jRxnrM8hIDaNHJ518bb6uAKg/rMwSQ4GOT6r7jx7PUt36Mk2AItEulnjeUmcAnjr
	aaun50PIfvmgt6mOEVA1OQp+vZjrBYLoV7T5jkOv/JFebnbM5+y5ZJWIq2ZHijTZzhJJ
	QWhQ==
X-Gm-Message-State: AOAM533OOJjGghz4Z16ZoYmLXCotaDr0JrMu1pouhyfM8O4j34hcHOTa
	tO6o6YNlpD/cjDydNEEhicrBxCTKbduTxKltG5JNc8T6ZemxImbaE+4=
X-Google-Smtp-Source: ABdhPJzNMVq9HFYERLK48OHfmHGpl1yXYcBtCKLKrJO6mwP08aLtzgcpsEJd5GjYz8k/7Jf8usy1WJOz+pl5KzRZLA4=
X-Received: by 2002:a05:6e02:5c2:: with SMTP id
	l2mr26473575ils.231.1608757806552; 
	Wed, 23 Dec 2020 13:10:06 -0800 (PST)
MIME-Version: 1.0
References: <16ffadab-42ba-f9c7-8203-87fda3dc9b44@maciej.szmigiero.name>
	<74c7129b-a437-ebc4-1466-7fb9f034e006@maciej.szmigiero.name>
In-Reply-To: <74c7129b-a437-ebc4-1466-7fb9f034e006@maciej.szmigiero.name>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Wed, 23 Dec 2020 21:09:55 +0000
Message-ID: <CALrw=nHiSPxVxxuA1fekwDOqBZX0BGe8_3DTN7TNkrVD2q8rxg@mail.gmail.com>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 23, 2020 at 3:37 PM Maciej S. Szmigiero
<mail@maciej.szmigiero.name> wrote:
>
> On 14.12.2020 19:11, Maciej S. Szmigiero wrote:
> > Hi,
> >
> > I hit a reproducible BUG() when scrubbing a btrfs fs on top of
> > a dm-crypt device with no_read_workqueue and no_write_workqueue
> > flags enabled.
>
> Still happens on the current torvalds/master.
>
> Due to this bug it is not possible to use btrfs on top of
> a dm-crypt device with no_read_workqueue and no_write_workqueue
> flags enabled.
>
> @Ignat:
> Can you have a look at this as the person who added these flags?

I've been looking into this for the last couple of days because of
other reports [1].
Just finished testing a possible solution. Will submit soon.

> It looks like to me that the skcipher API might not be safe to
> call from a softirq context, after all.

It is less about skcipher API and more about how dm-crypt uses it as
well as some assumptions that it is always running in context which
can sleep.

> Maciej

Ignat

[1]: https://github.com/cloudflare/linux/issues/1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

