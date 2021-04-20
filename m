Return-Path: <SRS0=vg7B=JR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C86C5C433B4
	for <dm-devel@archiver.kernel.org>; Tue, 20 Apr 2021 15:46:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 39A05613B0
	for <dm-devel@archiver.kernel.org>; Tue, 20 Apr 2021 15:46:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39A05613B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618933611;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=utLXWMMQtX43jyw1TXcW91EZR+tb27QWF5rkVu3nw4s=;
	b=gA5r7ZmHHrSr5cZIZed8j/6TR5rTDIteZmwDhfub+qm2OnJmItBsX7FHc8OmfOTJ6Lxt/1
	bATJyp8vIn8AqW9kRQH2ZqpMENYDiBZyVnbORL60a3c/3ziSKc6wLSP8BhdVENDmReeeCe
	IfaFTOrcCsqQfmNlUDI5VpQpUP9RzPw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-X7GqAvmrO9-l7xOAIw33ZQ-1; Tue, 20 Apr 2021 11:46:43 -0400
X-MC-Unique: X7GqAvmrO9-l7xOAIw33ZQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66E5F18B6141;
	Tue, 20 Apr 2021 15:46:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9958660CFB;
	Tue, 20 Apr 2021 15:46:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E3F5B1806D16;
	Tue, 20 Apr 2021 15:46:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13KFkYUM014733 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 20 Apr 2021 11:46:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6FF981000D98; Tue, 20 Apr 2021 15:46:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B4CB1002969
	for <dm-devel@redhat.com>; Tue, 20 Apr 2021 15:46:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B0927183B3CB
	for <dm-devel@redhat.com>; Tue, 20 Apr 2021 15:46:30 +0000 (UTC)
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
	[209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-431-fz7S8y-4NtabzSxrXxBTtA-1; Tue, 20 Apr 2021 11:46:28 -0400
X-MC-Unique: fz7S8y-4NtabzSxrXxBTtA-1
Received: by mail-qv1-f72.google.com with SMTP id
	el4-20020ad459c40000b029019a47ec7a9dso7973347qvb.21
	for <dm-devel@redhat.com>; Tue, 20 Apr 2021 08:46:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
	:references:mime-version:content-transfer-encoding;
	bh=j1INruBx24Ua8mW5n6gn035HvblxXMh5qaFfcyHwj6A=;
	b=QccSAlg2GhihtUxwb+xtrX/vOrRa0Ttm+RPL2v6TJo9i00ipcPwk7XAyK8O2uie9Df
	FpdRxmj37DWphDX11cxjWs+0oB+J+zgb9DxqoWQxVudvNXYpaO66EhEiZF7kXBSXvDEV
	ft4JqLhcNhz2nQK50zP0pPiuxu+ijxUM/sJvYRCJIaOvjSZf2zZg18TaraBsqD/IU8MM
	1ymwsWj0xvQqD7g80uIs+1MS/ny+ZzpwtR1lKwBrYzOMMYeLvOvA0kDZj3dPtjDIhuxi
	xxFGnkG6ohnTnhtlMAoaH6WK9soDWN7dC8YqHdZln1jHdF5ZDRBWoM15IhugZE5ykRyp
	vl8Q==
X-Gm-Message-State: AOAM530cQJ2OUvGAmH4xkKuLCGb0HIcNaKPXYn2ejYkj+ztSzQBC/Tvp
	QjIfPLbn4wxgKe9Tj650hRR2JxjnrLZI6PepvMfvsC0nrvVyRfZE4PYaNMGuyn9Ik6CywxkR05I
	BMvBwz0NT44x92Yo=
X-Received: by 2002:a37:38f:: with SMTP id 137mr17412124qkd.498.1618933588210; 
	Tue, 20 Apr 2021 08:46:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6NYuKtuKMEt8biboxN/WNrnfdnbDSXSGpiw0EYoPPbYA8ddcMRMsZxP29zxNos+pDvYXujw==
X-Received: by 2002:a37:38f:: with SMTP id 137mr17412079qkd.498.1618933587905; 
	Tue, 20 Apr 2021 08:46:27 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e7f:cee0:ccad:a4ca:9a69:d8bc])
	by smtp.gmail.com with ESMTPSA id
	k22sm12373407qkh.28.2021.04.20.08.46.27
	(version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
	Tue, 20 Apr 2021 08:46:27 -0700 (PDT)
Message-ID: <6a22337b0d15830d9117640bd227711ba8c8aef8.camel@redhat.com>
From: Laurence Oberman <loberman@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>
Date: Tue, 20 Apr 2021 11:46:26 -0400
In-Reply-To: <20210420143852.GB14523@redhat.com>
References: <20210416235329.49234-1-snitzer@redhat.com>
	<20210420093720.GA28874@lst.de> <20210420143852.GB14523@redhat.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, linux-nvme@lists.infradead.org
Subject: Re: [dm-devel] [PATCH v3 0/4] nvme: improve error handling and
 ana_state to work well with dm-multipath
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 2021-04-20 at 10:38 -0400, Mike Snitzer wrote:
> On Tue, Apr 20 2021 at  5:37am -0400,
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > > RHEL9 is coming, would really prefer that these changes land
> > > upstream
> > > rather than carry them within RHEL.
> > 
> > We've told from the very beginning that dm-multipth on nvme is not
> > a support configuration.
> 
> You have some high quality revisionist history there. But other than
> pointing that out I'm not going to dwell on our past discussions on
> how
> NVMe multipathing would be.
> 
> > Red Hat decided to ignore that and live with the pain.
> 
> Red Hat supports both native nvme-multipath _and_ DM-multipath on
> NVMe.
> 
> The only "pain" I've been living with is trying to get you to be
> impartial and allow others to provide Linux multipathing as they see
> fit.
> 
> > Your major version change is a chance to fix this up on the Red Hat
> > side, not to resubmit bogus patches upstream.
> 
> Please spare me the vapid and baseless assertion about patches you
> refuse to review technically without political motivation.
> 
> > In other words: please get your house in order NOW.
> 
> My simple 3 patch submission was an attempt to do so. Reality is the
> Linux NVMe maintainers need to get their collective house in order.
> 
> Until sanity prevails these NVMe changes will be carried in RHEL. And
> if
> you go out of your way to cause trivial, or elaborate, conflicts now
> that you _know_ that changes that are being carried it will be
> handled
> without issue.
> 
> Sad this is where we are but it is what it is.
> 
> Linux is about choice that is founded upon need. Hostile action that
> unilaterally limits choice is antithetical to Linux and Open Source.
> 
> Mike
> 

Hello

Let me add some reasons why as primarily a support person that this is
important and try avoid another combative situation. 

Customers depend on managing device-mapper-multipath the way it is now
even with the advent of nvme-over-F/C. Years of administration and
management for multiple Enterprise O/S vendor customers (Suse/Red Hat,
Oracle) all depend on managing multipath access in a transparent way.

I respect everybody's point of view here but native does change log
alerting and recovery and that is what will take time for customers to
adopt. 

It is going to take time for Enterprise customers to transition so all
we want is an option for them. At some point they will move to native
but we always like to keep in step with upstream as much as possible.

Of course we could live with RHEL-only for while but that defeats our
intention to be as close to upstream as possible.

If we could have this accepted upstream for now perhaps when customers
are ready to move to native only we could phase this out.

Any technical reason why this would not fly is of course important to
consider but perhaps for now we have a parallel option until we dont.

With due respect to all concerned.

Laurence Oberman

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

