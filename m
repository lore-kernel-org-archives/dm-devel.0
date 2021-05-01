Return-Path: <SRS0=QF+r=J4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0141BC433ED
	for <dm-devel@archiver.kernel.org>; Sat,  1 May 2021 15:19:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8937461613
	for <dm-devel@archiver.kernel.org>; Sat,  1 May 2021 15:19:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8937461613
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1619882384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=13Fin81BPGKEUVSFlAm4MkDW1SmgTMe+c3z4nMVRYVI=;
	b=EpD6gWKOk78xsuHBDnyIIwxoZK9sUUwKcn3FihNHDknu+dI9x5RAixPXYF/+RPFIQ5EXp0
	l6NoMerFuFd8w88jSrtt0QJMKl4dJaair+ydyOlXdkoi1iXzg+q8elh347bN39NZdPQcE1
	KVZ8zprFE7IH8JAKIZhxLm3ecUD6aTo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-sBFEk0THMlinOWSP6uHVAw-1; Sat, 01 May 2021 11:19:42 -0400
X-MC-Unique: sBFEk0THMlinOWSP6uHVAw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12E18107ACCA;
	Sat,  1 May 2021 15:19:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 04E8160C5E;
	Sat,  1 May 2021 15:19:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8132418095C4;
	Sat,  1 May 2021 15:19:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 141FJXKm004004 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 1 May 2021 11:19:33 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 280582B8BF; Sat,  1 May 2021 15:19:33 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C7202B1D0;
	Sat,  1 May 2021 15:19:29 +0000 (UTC)
Date: Sat, 1 May 2021 11:19:28 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Message-ID: <20210501151928.GA12518@redhat.com>
References: <20210416235329.49234-1-snitzer@redhat.com>
	<20210420093720.GA28874@lst.de> <20210420143852.GB14523@redhat.com>
	<6a22337b0d15830d9117640bd227711ba8c8aef8.camel@redhat.com>
	<f2df22ef-583e-1d80-6ea7-2edfe61b9b53@suse.de>
MIME-Version: 1.0
In-Reply-To: <f2df22ef-583e-1d80-6ea7-2edfe61b9b53@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Laurence Oberman <loberman@redhat.com>,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, May 01 2021 at  7:58am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 4/20/21 5:46 PM, Laurence Oberman wrote:
> [ .. ]
> >
> >Let me add some reasons why as primarily a support person that this is
> >important and try avoid another combative situation.
> >
> >Customers depend on managing device-mapper-multipath the way it is now
> >even with the advent of nvme-over-F/C. Years of administration and
> >management for multiple Enterprise O/S vendor customers (Suse/Red Hat,
> >Oracle) all depend on managing multipath access in a transparent way.
> >
> >I respect everybody's point of view here but native does change log
> >alerting and recovery and that is what will take time for customers to
> >adopt.
> >
> >It is going to take time for Enterprise customers to transition so all
> >we want is an option for them. At some point they will move to native
> >but we always like to keep in step with upstream as much as possible.
> >
> >Of course we could live with RHEL-only for while but that defeats our
> >intention to be as close to upstream as possible.
> >
> >If we could have this accepted upstream for now perhaps when customers
> >are ready to move to native only we could phase this out.
> >
> >Any technical reason why this would not fly is of course important to
> >consider but perhaps for now we have a parallel option until we dont.
> >
> Curiously, we (as in we as SLES developers) have found just the opposite.
> NVMe is a new technology, and out of necessity there will not be any
> existing installations where we have to be compatible with.
> We have switched to native NVMe multipathing with SLE15, and decided
> to educate customers that NVMe is a different concept than SCSI, and
> one shouldn't try treat both the same way.

As you well know: dm-multipath was first engineered to handle SCSI, and
it was too tightly coupled at the start, but the scsi_dh interface
provided sorely missing abstraction. With NVMe, dm-multipath was
further enhanced to not do work only needed for SCSI.

Seems SUSE has forgotten that dm-multipath has taken strides to properly
abstract away SCSI specific details, at least this patchset forgot it
(because proper layering/abstraction is too hard? that mantra is what
gave native NVMe multipath life BTW):
https://patchwork.kernel.org/project/dm-devel/list/?series=475271

Long story short, there is utility in dm-multipath being transport
agnostic with specialized protocol specific bits properly abstracted.

If you or others don't care about any of that anymore, that's fine! But
it doesn't mean others don't. Thankfully both can exist perfectly fine,
sadly that clearly isn't possible without absurd tribal fighting (at
least in the context of NVMe).

And to be clear Hannes: your quick review of this patchset couldn't have
been less helpful or informed. Yet it enabled NVMe maintainers to ignore
technical review (you gave them cover).

The lack of proper technical review of this patchset was astonishing but
hch's dysfunctional attack that took its place really _should_ concern
others. Seems it doesn't, must be nice to not have a dog in the fight
other than philosophical ideals that enable turning a blind eye.

> This was helped by the
> fact the SLE15 is a new release, so customers were accustomed to
> having to change bits and pieces in their infrastructure to support
> new releases.

Sounds like you either have very few customers and/or they don't use
layers that were engineered with dm-multipath being an integral layer
in the IO stack. That's fine, but that doesn't prove anything other
than your limited experience.

> Overall it worked reasonably well; we sure found plenty of bugs, but
> that was kind of expected, and for bad or worse nearly all of them
> turned out to be upstream issues. Which was good for us (nothing
> beats being able to blame things on upstream, if one is careful to
> not linger too much on the fact that one is part of upstream); and
> upstream these things will need to be fixed anyway.
> So we had a bit of a mixed experience, but customers seemed to be
> happy enough with this step.
> 
> Sorry about that :-)

Nothing to be sorry about, good on you and the others at SUSE
engineering for improving native NVMe multipathing. Red Hat supports it
too, so your and others' efforts are appreciated there.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

