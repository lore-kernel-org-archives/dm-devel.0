Return-Path: <SRS0=l+U7=HY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8837CC433DB
	for <dm-devel@archiver.kernel.org>; Mon, 22 Feb 2021 01:32:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1E3EB64F02
	for <dm-devel@archiver.kernel.org>; Mon, 22 Feb 2021 01:32:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E3EB64F02
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1613957532;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cpMI8RbqZ5yojYqB0FSsIk4+Bl4AJinTpOo1TcoRC/k=;
	b=gYWj5Dzu7zx2A1BmE+hFaS9UIRto/csn0o9du2VhnxKwl/CDlVJ8lRn7flKSxXtZsTFaK1
	CC3Ak73FG5AfKX5jrMjWplkHxTgdgYeiiaAXRiyjS+KKYi31jKbm406yHRxqMWLpUhbf5e
	9cwosvcdV+YUcm/dwdnEoN9hTAlTLqg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-IatOAa6UPw-26_clQ5tkKA-1; Sun, 21 Feb 2021 20:32:09 -0500
X-MC-Unique: IatOAa6UPw-26_clQ5tkKA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A5EB1934100;
	Mon, 22 Feb 2021 01:32:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CD6251A44A;
	Mon, 22 Feb 2021 01:32:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CB7E918095CB;
	Mon, 22 Feb 2021 01:32:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11M1VvrU017368 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 21 Feb 2021 20:31:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E7A061A44A; Mon, 22 Feb 2021 01:31:57 +0000 (UTC)
Received: from T590 (ovpn-12-196.pek2.redhat.com [10.72.12.196])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7972B1A867;
	Mon, 22 Feb 2021 01:31:37 +0000 (UTC)
Date: Mon, 22 Feb 2021 09:31:33 +0800
From: Ming Lei <ming.lei@redhat.com>
To: SelvaKumar S <selvakuma.s1@samsung.com>
Message-ID: <YDMJdekWhy/Y1Y1r@T590>
References: <CGME20210219124555epcas5p1334e7c4d64ada5dc4a2ca0feb48c1d44@epcas5p1.samsung.com>
	<20210219124517.79359-1-selvakuma.s1@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20210219124517.79359-1-selvakuma.s1@samsung.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, damien.lemoal@wdc.com, kch@kernel.org, sagi@grimberg.me,
	snitzer@redhat.com, selvajove@gmail.com,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	nj.shetty@samsung.com, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	joshi.k@samsung.com, javier.gonz@samsung.com, kbusch@kernel.org,
	joshiiitr@gmail.com, linux-scsi@vger.kernel.org, hch@lst.de
Subject: Re: [dm-devel] [RFC PATCH v5 0/4] add simple copy support
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Feb 19, 2021 at 06:15:13PM +0530, SelvaKumar S wrote:
> This patchset tries to add support for TP4065a ("Simple Copy Command"),
> v2020.05.04 ("Ratified")
> 
> The Specification can be found in following link.
> https://nvmexpress.org/wp-content/uploads/NVM-Express-1.4-Ratified-TPs-1.zip
> 
> Simple copy command is a copy offloading operation and is  used to copy
> multiple contiguous ranges (source_ranges) of LBA's to a single destination
> LBA within the device reducing traffic between host and device.
> 
> This implementation doesn't add native copy offload support for stacked
> devices rather copy offload is done through emulation. Possible use
> cases are F2FS gc and BTRFS relocation/balance.
> 
> *blkdev_issue_copy* takes source bdev, no of sources, array of source
> ranges (in sectors), destination bdev and destination offset(in sectors).
> If both source and destination block devices are same and copy_offload = 1,
> then copy is done through native copy offloading. Copy emulation is used
> in other cases.
> 
> As SCSI XCOPY can take two different block devices and no of source range is
> equal to 1, this interface can be extended in future to support SCSI XCOPY.

The patchset adds ioctl(BLKCOPY) and two userspace visible data
struture(range_entry, and copy_range), all belong to kabi stuff, and the
interface is generic block layer kabi.

The API has to be allowed to extend for supporting SCSI XCOPY in future or similar
block copy commands without breaking previous application, so please CC linux-scsi
and scsi guys in your next post.


-- 
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

