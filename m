Return-Path: <SRS0=PkBB=IC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85720C433E0
	for <dm-devel@archiver.kernel.org>; Thu,  4 Mar 2021 22:43:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0D97664FEB
	for <dm-devel@archiver.kernel.org>; Thu,  4 Mar 2021 22:43:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D97664FEB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-A_oExi35PQ-JtVUcBhoL8w-1; Thu, 04 Mar 2021 17:43:29 -0500
X-MC-Unique: A_oExi35PQ-JtVUcBhoL8w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1E101084D6B;
	Thu,  4 Mar 2021 22:43:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 68E2518B42;
	Thu,  4 Mar 2021 22:43:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EE8603CA8;
	Thu,  4 Mar 2021 22:43:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 124MhGxh005045 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Mar 2021 17:43:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 084A97145A2; Thu,  4 Mar 2021 22:43:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 02A5C71255E
	for <dm-devel@redhat.com>; Thu,  4 Mar 2021 22:43:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8203A85A5B5
	for <dm-devel@redhat.com>; Thu,  4 Mar 2021 22:43:13 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-468-JMp5lnJ2NgiSOSZex4QWVQ-1;
	Thu, 04 Mar 2021 17:42:54 -0500
X-MC-Unique: JMp5lnJ2NgiSOSZex4QWVQ-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF7D764FF4;
	Thu,  4 Mar 2021 22:42:52 +0000 (UTC)
Date: Thu, 4 Mar 2021 14:42:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20210304224250.GF3419940@magnolia>
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com>
	<20210208105530.3072869-3-ruansy.fnst@cn.fujitsu.com>
	<20210210132139.GC30109@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210210132139.GC30109@lst.de>
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
Cc: y-goto@fujitsu.com, qi.fuli@fujitsu.com,
	Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>, snitzer@redhat.com,
	linux-nvdimm@lists.01.org, rgoldwyn@suse.de,
	darrick.wong@oracle.com, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v3 02/11] blk: Introduce ->corrupted_range()
 for block device
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 10, 2021 at 02:21:39PM +0100, Christoph Hellwig wrote:
> On Mon, Feb 08, 2021 at 06:55:21PM +0800, Shiyang Ruan wrote:
> > In fsdax mode, the memory failure happens on block device.  So, it is
> > needed to introduce an interface for block devices.  Each kind of block
> > device can handle the memory failure in ther own ways.
> 
> As told before: DAX operations please do not add anything to the block
> device.  We've been working very hard to decouple DAX from the block
> device, and while we're not done regressing the split should not happen.

I agree with you (Christoph) that (strictly speaking) within the scope of
the DAX work this isn't needed; xfs should be able to consume the
->memory_failure events directly and DTRT.

My vision here, however, is to establish upcalls for /both/ types of
stroage.

Regular block devices can use ->corrupted_range to push error
notifications upwards through the block stack to a filesystem, and we
can finally do a teensy bit more with scsi sense data about media
errors, or thinp wanting to warn the filesystem that it's getting low on
space and maybe this would be an agreeable time to self-FITRIM, or raid
noticing that a mirror is inconsistent and can the fs do something to
resolve the dispute, etc.  Maybe we can use this mechanism to warn a
filesystem that someone did "echo 1 > /sys/block/sda/device/delete" and
we had better persist everything while we still can.

Memory devices will use ->memory_failure to tell us about ADR errors,
and I guess upcoming and past hotremove events.  For fsdax you'd
probably have to send the announcement and invalidate the current ptes
to force filesystem pagefaults and the like.

Either way, I think this piece is fine, but I would change the dax
side to send the ->memory_failure events directly to xfs.

A gap here is that xfs can attach to rt/log devices but we don't
currently plumb in enough information that get_active_super can find
the correct filesystem.

I dunno, maybe we should add this to the thread here[1]?

[1] https://lore.kernel.org/linux-xfs/CAPcyv4g3ZwbdLFx8bqMcNvXyrob8y6sBXXu=xPTmTY0VSk5HCw@mail.gmail.com/T/#m55a5c67153d0d10f3ff05a69d7e502914d97ac9d

--D

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

