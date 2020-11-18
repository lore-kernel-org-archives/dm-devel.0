Return-Path: <SRS0=/Nun=EY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11307C56202
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 09:32:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5F75F20855
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 09:32:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F75F20855
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-rZdONjJwOmONloHNqd8u9g-1; Wed, 18 Nov 2020 04:32:31 -0500
X-MC-Unique: rZdONjJwOmONloHNqd8u9g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2FF68042A4;
	Wed, 18 Nov 2020 09:32:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1988D18426;
	Wed, 18 Nov 2020 09:32:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 738C65813B;
	Wed, 18 Nov 2020 09:32:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AI9WOkg024913 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Nov 2020 04:32:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2761AB17D9; Wed, 18 Nov 2020 09:32:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22146B17DB
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 09:32:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BF74185A78B
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 09:32:21 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-444-c4wY8jFvN2aavp-IvtYbEg-1;
	Wed, 18 Nov 2020 04:32:19 -0500
X-MC-Unique: c4wY8jFvN2aavp-IvtYbEg-1
Received: from localhost (unknown [89.205.136.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 651A320855;
	Wed, 18 Nov 2020 09:32:15 +0000 (UTC)
Date: Wed, 18 Nov 2020 10:32:12 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Jan Beulich <jbeulich@suse.com>
Message-ID: <X7TqHNotTX6W/bmT@kroah.com>
References: <20201118084800.2339180-1-hch@lst.de>
	<22ca5396-0253-f286-9eab-d417b2e0b3ad@suse.com>
	<20201118085804.GA20384@lst.de>
	<1ded2079-f1be-6d5d-01df-65754447df78@suse.com>
	<X7Tky/6dDN8+DrU7@kroah.com>
	<61044f85-cd41-87b5-3f41-36e3dffb6f2a@suse.com>
MIME-Version: 1.0
In-Reply-To: <61044f85-cd41-87b5-3f41-36e3dffb6f2a@suse.com>
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
Cc: linux-bcache@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	linux-mm@kvack.org, Jan Kara <jack@suse.com>,
	Tejun Heo <tj@kernel.org>, xen-devel@lists.xenproject.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] merge struct block_device and struct hd_struct
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

On Wed, Nov 18, 2020 at 10:23:51AM +0100, Jan Beulich wrote:
> On 18.11.2020 10:09, Greg KH wrote:
> > On Wed, Nov 18, 2020 at 10:04:04AM +0100, Jan Beulich wrote:
> >> On 18.11.2020 09:58, Christoph Hellwig wrote:
> >>> On Wed, Nov 18, 2020 at 09:56:11AM +0100, Jan Beulich wrote:
> >>>> since this isn't the first series from you recently spamming
> >>>> xen-devel, may I ask that you don't Cc entire series to lists
> >>>> which are involved with perhaps just one out of the many patches?
> >>>> IMO Cc lists should be compiled on a per-patch basis; the cover
> >>>> letter may of course be sent to the union of all of them.
> >>>
> >>> No way.  Individual CCs are completely broken as they don't provide
> >>> the reviewer a context.
> >>
> >> That's the view of some people, but not all. Context can be easily
> >> established by those who care going to one of the many archives on
> >> which the entire series lands. Getting spammed, however, can't be
> >> avoided by the dozens or hundreds of list subscribers.
> > 
> > kernel patches are never "spam", sorry, but for developers to try to
> > determine which lists/maintainers want to see the whole series and which
> > do not is impossible.
> > 
> > Patches in a series are easily deleted from sane mail clients with a
> > single click/keystroke all at once, they aren't a problem that needs to
> > be reduced in volume.
> 
> This doesn't scale, neither in the dimension of recipients nor in
> the dimension of possible sources of such series.

Again, trying to figure out what subsystem does, and does not, want
stuff like this does not scale either.  Remember, we had 4000 developers
last year, how are you going to tell all of them what the special rules
are for your subsystem and how they differ from any other subsystem?

And why does it matter?  We are all working on the same project, why
wouldn't you want to see core block device handling patches?  What
hurts with that, someone might notice something in one of them that a
different developer did not.

> While it may seem small, it's also a waste of resources to have mails
> sent to hundreds of even thousands of people. So while from a
> technical content perspective I surely agree with you saying 'kernel
> patches are never "spam"', they still are from the perspective of
> what "spam mail" originally means: Mail the recipients did not want
> to receive.

Anyone on a kernel subsystem mailing list should expect to see kernel
patches, that's part of the process, and always has been.

Kernel subsystems are not silos, people on them should be aware of what
else is going on in order to stay informed.  And again, if it's a huge
problem, one click/keystroke and they are gone, no waste.

thanks,

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

