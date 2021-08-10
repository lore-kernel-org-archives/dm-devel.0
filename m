Return-Path: <SRS0=j8cp=NB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F6DC4338F
	for <dm-devel@archiver.kernel.org>; Tue, 10 Aug 2021 14:42:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E348E60F02
	for <dm-devel@archiver.kernel.org>; Tue, 10 Aug 2021 14:42:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E348E60F02
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1628606543;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DAdGRAGaWfJABr8I/oXdSHzzpw5W76bZLPD2x8S4dHM=;
	b=EK7sY3SyzRe1rRjiCdFwF8L/TAP4Od1NKz+yWr/r3eXrMasC2X4nu/JS94n7MT8Svjm+wZ
	TNCxQrAsX5c0abKAqCtuXEBFDm5mcm+Zeuverf2RPzg7qjfd0RoUecEhzWsAVVSEgST8X0
	h9FQtUsapuGTPyzzCrLFzub58/y2mxs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-MSvH7oHLONWJXuyeCbwIkA-1; Tue, 10 Aug 2021 10:42:21 -0400
X-MC-Unique: MSvH7oHLONWJXuyeCbwIkA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1574A87D542;
	Tue, 10 Aug 2021 14:42:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE8846F97F;
	Tue, 10 Aug 2021 14:42:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CEC644BB7C;
	Tue, 10 Aug 2021 14:42:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17AEgB6p004666 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 10 Aug 2021 10:42:11 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2E6E813AD3; Tue, 10 Aug 2021 14:42:11 +0000 (UTC)
Received: from agk-cloud1.hosts.prod.upshift.rdu2.redhat.com
	(agk-cloud1.hosts.prod.upshift.rdu2.redhat.com [10.0.13.154])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0CA7C5D9C6;
	Tue, 10 Aug 2021 14:41:54 +0000 (UTC)
Received: by agk-cloud1.hosts.prod.upshift.rdu2.redhat.com (Postfix,
	from userid 3883)
	id 38A2141FBD38; Tue, 10 Aug 2021 15:41:55 +0100 (BST)
Date: Tue, 10 Aug 2021 15:41:55 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	dm-devel@redhat.com
Message-ID: <20210810144155.GA101710@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com
References: <20210804094147.459763-1-hch@lst.de>
	<20210810003608.GB101579@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210810003608.GB101579@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod Street,
	Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] use regular gendisk registration in device mapper v2
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

On Tue, Aug 10, 2021 at 01:36:08AM +0100, Alasdair G Kergon wrote:
> On Wed, Aug 04, 2021 at 11:41:39AM +0200, Christoph Hellwig wrote:
> > allows device mapper to use the normal scheme
> > of calling add_disk when it is ready to accept I/O.
> For clarity, even after this patchset, the device is not ready to accept
> I/O when add_disk is called.  

The question then arises: could we go beyond this patchset and move the
add_disk further to the first resume to make the statement true?  (From
step 2 to 3 in my earlier response. DM_TABLE_CLEAR then also enters the
mix for testing.)

In the early days, in practice userspace did have to resume a device
before it could be referenced in a table and lvm2 and other tools were
designed with that in mind - they should always resume a device before
loading a table that references it.  This was because the device
reference performed a size check - to make sure the access was within
the device, and the device size isn't defined until a table becomes live
when the device is resumed.  But some multipath tables had to be set up
referencing devices with not-yet-defined sizes, so the code got relaxed
to accept references to zero-sized devices.  (At the back of my mind I
think there was some non-multipath code that found this a convenient
short-cut too.)

So since this "must resume before referencing in a table" hasn't been
enforced for so long, I can't really say how much userspace code, if
any, might now not be doing it.  We and others would need to do some
testing to see if we could get away with making such a change.

Alasdair

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

