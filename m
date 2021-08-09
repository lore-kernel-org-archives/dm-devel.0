Return-Path: <SRS0=ry1C=NA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 939E4C4338F
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 23:32:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1FBA160295
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 23:32:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1FBA160295
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1628551925;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=zbcdx4WVVLgmWC/KtEFL8OyrU8SrsNKsJ82jt8qpc/s=;
	b=J+tqNBFk65ZN+22KGP3gru7/FNvRM3SwGgPZphh/IHh76ULofHV28lB7ncbR80jjEptnQo
	+uwSQ5RGE2jc2osr0Sdn/VhQxjQnPlXw3+03iWCZKwBSsrOe2wUyW2TDOobGrmMRFGxR+w
	CdLHuaBQirHXE3Y7EjQJUrlvXLtfn9A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-QX0C3TIKOb2OpF9ibITUzw-1; Mon, 09 Aug 2021 19:32:04 -0400
X-MC-Unique: QX0C3TIKOb2OpF9ibITUzw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FB87760C0;
	Mon,  9 Aug 2021 23:31:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 02D1E5C1D5;
	Mon,  9 Aug 2021 23:31:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6A5261800FFC;
	Mon,  9 Aug 2021 23:31:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 179NVqS1031673 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 9 Aug 2021 19:31:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 20ED86A056; Mon,  9 Aug 2021 23:31:52 +0000 (UTC)
Received: from agk-cloud1.hosts.prod.upshift.rdu2.redhat.com
	(agk-cloud1.hosts.prod.upshift.rdu2.redhat.com [10.0.13.154])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2573460854;
	Mon,  9 Aug 2021 23:31:42 +0000 (UTC)
Received: by agk-cloud1.hosts.prod.upshift.rdu2.redhat.com (Postfix,
	from userid 3883)
	id 493FE42C4190; Tue, 10 Aug 2021 00:31:43 +0100 (BST)
Date: Tue, 10 Aug 2021 00:31:43 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20210809233143.GA101480@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	prajnoha@redhat.com
MIME-Version: 1.0
In-Reply-To: <20210804094147.459763-8-hch@lst.de>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod Street,
	Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, prajnoha@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH 7/8] dm: delay registering the gendisk
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Aug 04, 2021 at 11:41:46AM +0200, Christoph Hellwig wrote:
> device mapper is currently the only outlier that tries to call
> register_disk after add_disk, leading to fairly inconsistent state
> of these block layer data structures.  

> Note that this introduces a user visible change: the dm kobject is
> now only visible after the initial table has been loaded.

Indeed.  We should try to document the userspace implications of this
change in a bit more detail.  While lvm2 and any other tools that
followed our recommendations about how to use dm should be OK, there's
always the chance that some other less robustly-written code will need
to make adjustments.

Currently to make a dm device, 3 ioctls are called in sequence:

1. DM_DEV_CREATE  - triggers 'add' uevents
2. DM_TABLE_LOAD
3. DM_SUSPEND     - triggers 'change' uevent

After this patch we have:

1. DM_DEV_CREATE  
2. DM_TABLE_LOAD  - triggers 'add' uevents
3. DM_SUSPEND     - triggers 'change' uevent

The equivalent dmsetup commands for a simple test device are
0. udevadm monitor --kernel --env &   # View the uevents as they happen
1. dmsetup create dev1 --notable
2. dmsetup load --table "0 1 error" dev1
3. dmsetup resume dev1

  => Anyone with a udev rule that relies on 'add' needs to check if they
     need to change their code.

The udev rules that lvm2 uses to synchronise what it is doing rely
only on the 'change' event - which is not moving.  The 'add' event
gets ignored.  

When loading tables, our tools also always refer to devices using
the 'major:minor' format, which isn't affected, rather than using
pathnames in /dev which might not exist now after this change if a table
hasn't been loaded into a referenced device yet.  Previously this was
permissible but we always recommended against it to avoid a pointless
pathname lookup that's subject to races and delays.

So again, any tools that followed our recommendations ought to be
unaffected.

Here's an example of poor code that previously worked but will fail now:
  dmsetup create dev1 --notable
  dmsetup create dev2 --notable
  dmsetup ls  <-- get the minor number of dev1 (say it's 1 corresponding
to dm-1)
  dmsetup load dev2 --table '0 1 linear /dev/dm-1 0'
  ...

Peter - have I missed anything?

Alasdair

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

