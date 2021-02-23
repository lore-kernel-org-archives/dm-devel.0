Return-Path: <SRS0=Sgdu=HZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BDA4C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 09:01:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CDA5364D5D
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 09:01:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDA5364D5D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-fRUS8Y1RNl6cr1LuRQwNCA-1; Tue, 23 Feb 2021 04:01:10 -0500
X-MC-Unique: fRUS8Y1RNl6cr1LuRQwNCA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4704801977;
	Tue, 23 Feb 2021 09:01:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B2F7A5D9D0;
	Tue, 23 Feb 2021 09:01:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1DCAC18095CB;
	Tue, 23 Feb 2021 09:00:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11N90pZW020896 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Feb 2021 04:00:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8A001F3D0C; Tue, 23 Feb 2021 09:00:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 83841F3D20
	for <dm-devel@redhat.com>; Tue, 23 Feb 2021 09:00:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F435800C81
	for <dm-devel@redhat.com>; Tue, 23 Feb 2021 09:00:48 +0000 (UTC)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com
	[209.85.218.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-101-n-4LtqkIOv6DCvj73BIkyA-1; Tue, 23 Feb 2021 04:00:45 -0500
X-MC-Unique: n-4LtqkIOv6DCvj73BIkyA-1
Received: by mail-ej1-f46.google.com with SMTP id do6so33393636ejc.3;
	Tue, 23 Feb 2021 01:00:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=UBuOsk/6YaKiWbipxxhr4dk5OJqSkgV3eAHh9xNc/Jg=;
	b=FSMQJA07GdSpWrFXoXWwiUXFNdlPPpoZXi/fuymXkILogP/8ZWNuNVM2AyGgrwpJZz
	N4vAHEHZxHJb+LIiicYshqQfmS0jQxhWb3BvXMixYKUx44nqGXh54rvSjGkaQyOh9CYv
	hiPcY1wWvqOJF24TtHyoOA0wkGA18jX6Hgy2VIEPSUxhCkCe/lx6SBqgycpWAzzwvASV
	tPSMsHILf5wvgs/ezLxNt2++SjVmBioVXf3InA4mCmByxeYAY3ZQb9wp80l8yubBXOG5
	cpY9bu/L3Z1NuwKZaSWQdTkCko3t2T4z7sKjbwutY5r+tXtGcuP6tZ/jgUBNtXYhaKYN
	EnRw==
X-Gm-Message-State: AOAM530bssSUbYZ1CV1ImjkuaBM4wjlNVS09C9919BBGJwJb2zbSGnLl
	AybXe4B74Ql5qhC4eP0CevEvChTdW180HZBcnSM=
X-Google-Smtp-Source: ABdhPJyc8rYcjw3M+gQXj1/kYlhA8uQ+5Ce9q4pofI8m2Z+lfWQOgHSBB50MFzG1SnlnX7L+wTc0CB58vsGNn2qpxZw=
X-Received: by 2002:a17:906:2c45:: with SMTP id
	f5mr10111593ejh.40.1614070843584; 
	Tue, 23 Feb 2021 01:00:43 -0800 (PST)
MIME-Version: 1.0
References: <CGME20210219124555epcas5p1334e7c4d64ada5dc4a2ca0feb48c1d44@epcas5p1.samsung.com>
	<20210219124517.79359-1-selvakuma.s1@samsung.com>
	<lfbgr3ur.fsf@damenly.su>
In-Reply-To: <lfbgr3ur.fsf@damenly.su>
From: Selva Jove <selvajove@gmail.com>
Date: Tue, 23 Feb 2021 14:30:29 +0530
Message-ID: <CAHqX9vbdtNiRvAHSy+1+rD6FEp6zBqmH2P_99P-+dgMZDbMZsA@mail.gmail.com>
To: Su Yue <l@damenly.su>
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
Cc: axboe@kernel.dk, Damien Le Moal <damien.lemoal@wdc.com>, kch@kernel.org,
	SelvaKumar S <selvakuma.s1@samsung.com>, sagi@grimberg.me,
	snitzer@redhat.com, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, nj.shetty@samsung.com,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, joshi.k@samsung.com,
	javier.gonz@samsung.com, Keith Busch <kbusch@kernel.org>,
	joshiiitr@gmail.com, hch@lst.de
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Thanks Su Yue. I'll update the link in the next series.

On Mon, Feb 22, 2021 at 12:23 PM Su Yue <l@damenly.su> wrote:
>
>
> On Fri 19 Feb 2021 at 20:45, SelvaKumar S
> <selvakuma.s1@samsung.com> wrote:
>
> > This patchset tries to add support for TP4065a ("Simple Copy
> > Command"),
> > v2020.05.04 ("Ratified")
> >
> > The Specification can be found in following link.
> > https://nvmexpress.org/wp-content/uploads/NVM-Express-1.4-Ratified-TPs-1.zip
> >
>
> 404 not found.
> Should it be
> https://nvmexpress.org/wp-content/uploads/NVM-Express-1.4-Ratified-TPs.zip
> ?
>
> > Simple copy command is a copy offloading operation and is  used
> > to copy
> > multiple contiguous ranges (source_ranges) of LBA's to a single
> > destination
> > LBA within the device reducing traffic between host and device.
> >
> > This implementation doesn't add native copy offload support for
> > stacked
> > devices rather copy offload is done through emulation. Possible
> > use
> > cases are F2FS gc and BTRFS relocation/balance.
> >
> > *blkdev_issue_copy* takes source bdev, no of sources, array of
> > source
> > ranges (in sectors), destination bdev and destination offset(in
> > sectors).
> > If both source and destination block devices are same and
> > copy_offload = 1,
> > then copy is done through native copy offloading. Copy emulation
> > is used
> > in other cases.
> >
> > As SCSI XCOPY can take two different block devices and no of
> > source range is
> > equal to 1, this interface can be extended in future to support
> > SCSI XCOPY.
> >
> > For devices supporting native simple copy, attach the control
> > information
> > as payload to the bio and submit to the device. For devices
> > without native
> > copy support, copy emulation is done by reading each source
> > range into memory
> > and writing it to the destination. Caller can choose not to try
> > emulation if copy offload is not supported by setting
> > BLKDEV_COPY_NOEMULATION flag.
> >
> > Following limits are added to queue limits and are exposed in
> > sysfs
> > to userspace
> >       - *copy_offload* controls copy_offload. set 0 to disable copy
> >               offload, 1 to enable native copy offloading support.
> >       - *max_copy_sectors* limits the sum of all source_range length
> >       - *max_copy_nr_ranges* limits the number of source ranges
> >       - *max_copy_range_sectors* limit the maximum number of sectors
> >               that can constitute a single source range.
> >
> >       max_copy_sectors = 0 indicates the device doesn't support copy
> > offloading.
> >
> >       *copy offload* sysfs entry is configurable and can be used
> > toggle
> > between emulation and native support depending upon the usecase.
> >
> > Changes from v4
> >
> > 1. Extend dm-kcopyd to leverage copy-offload, while copying
> > within the
> > same device. The other approach was to have copy-emulation by
> > moving
> > dm-kcopyd to block layer. But it also required moving core dm-io
> > infra,
> > causing a massive churn across multiple dm-targets.
> >
> > 2. Remove export in bio_map_kern()
> > 3. Change copy_offload sysfs to accept 0 or else
> > 4. Rename copy support flag to QUEUE_FLAG_SIMPLE_COPY
> > 5. Rename payload entries, add source bdev field to be used
> > while
> > partition remapping, remove copy_size
> > 6. Change the blkdev_issue_copy() interface to accept
> > destination and
> > source values in sector rather in bytes
> > 7. Add payload to bio using bio_map_kern() for copy_offload case
> > 8. Add check to return error if one of the source range length
> > is 0
> > 9. Add BLKDEV_COPY_NOEMULATION flag to allow user to not try
> > copy
> > emulation incase of copy offload is not supported. Caller can
> > his use
> > his existing copying logic to complete the io.
> > 10. Bug fix copy checks and reduce size of rcu_lock()
> >
> > Planned for next:
> > - adding blktests
> > - handling larger (than device limits) copy
> > - decide on ioctl interface (man-page etc.)
> >
> > Changes from v3
> >
> > 1. gfp_flag fixes.
> > 2. Export bio_map_kern() and use it to allocate and add pages to
> > bio.
> > 3. Move copy offload, reading to buf, writing from buf to
> > separate functions.
> > 4. Send read bio of copy offload by chaining them and submit
> > asynchronously.
> > 5. Add gendisk->part0 and part->bd_start_sect changes to
> > blk_check_copy().
> > 6. Move single source range limit check to blk_check_copy()
> > 7. Rename __blkdev_issue_copy() to blkdev_issue_copy and remove
> > old helper.
> > 8. Change blkdev_issue_copy() interface generic to accepts
> > destination bdev
> >       to support XCOPY as well.
> > 9. Add invalidate_kernel_vmap_range() after reading data for
> > vmalloc'ed memory.
> > 10. Fix buf allocoation logic to allocate buffer for the total
> > size of copy.
> > 11. Reword patch commit description.
> >
> > Changes from v2
> >
> > 1. Add emulation support for devices not supporting copy.
> > 2. Add *copy_offload* sysfs entry to enable and disable
> > copy_offload
> >       in devices supporting simple copy.
> > 3. Remove simple copy support for stacked devices.
> >
> > Changes from v1:
> >
> > 1. Fix memory leak in __blkdev_issue_copy
> > 2. Unmark blk_check_copy inline
> > 3. Fix line break in blk_check_copy_eod
> > 4. Remove p checks and made code more readable
> > 5. Don't use bio_set_op_attrs and remove op and set
> >    bi_opf directly
> > 6. Use struct_size to calculate total_size
> > 7. Fix partition remap of copy destination
> > 8. Remove mcl,mssrl,msrc from nvme_ns
> > 9. Initialize copy queue limits to 0 in nvme_config_copy
> > 10. Remove return in QUEUE_FLAG_COPY check
> > 11. Remove unused OCFS
> >
> > SelvaKumar S (4):
> >   block: make bio_map_kern() non static
> >   block: add simple copy support
> >   nvme: add simple copy support
> >   dm kcopyd: add simple copy offload support
> >
> >  block/blk-core.c          | 102 +++++++++++++++--
> >  block/blk-lib.c           | 223
> >  ++++++++++++++++++++++++++++++++++++++
> >  block/blk-map.c           |   2 +-
> >  block/blk-merge.c         |   2 +
> >  block/blk-settings.c      |  10 ++
> >  block/blk-sysfs.c         |  47 ++++++++
> >  block/blk-zoned.c         |   1 +
> >  block/bounce.c            |   1 +
> >  block/ioctl.c             |  33 ++++++
> >  drivers/md/dm-kcopyd.c    |  49 ++++++++-
> >  drivers/nvme/host/core.c  |  87 +++++++++++++++
> >  include/linux/bio.h       |   1 +
> >  include/linux/blk_types.h |  14 +++
> >  include/linux/blkdev.h    |  17 +++
> >  include/linux/nvme.h      |  43 +++++++-
> >  include/uapi/linux/fs.h   |  13 +++
> >  16 files changed, 627 insertions(+), 18 deletions(-)
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

