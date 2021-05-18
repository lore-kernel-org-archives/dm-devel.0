Return-Path: <SRS0=UUgV=KN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD51C433ED
	for <dm-devel@archiver.kernel.org>; Tue, 18 May 2021 00:15:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EFACC61360
	for <dm-devel@archiver.kernel.org>; Tue, 18 May 2021 00:15:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFACC61360
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-qt_59e5LMGC2tPJY1nMnWA-1; Mon, 17 May 2021 20:15:40 -0400
X-MC-Unique: qt_59e5LMGC2tPJY1nMnWA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C69F802939;
	Tue, 18 May 2021 00:15:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 87A5C1A868;
	Tue, 18 May 2021 00:15:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 21A4C55350;
	Tue, 18 May 2021 00:15:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14I0FPdD010811 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 17 May 2021 20:15:25 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E874121602B8; Tue, 18 May 2021 00:15:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E39CB2166B1B
	for <dm-devel@redhat.com>; Tue, 18 May 2021 00:15:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EE9E101A531
	for <dm-devel@redhat.com>; Tue, 18 May 2021 00:15:22 +0000 (UTC)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com
	[209.85.210.179]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-593-xa2UzDPOOtmVKA5PsqM0EQ-1; Mon, 17 May 2021 20:15:18 -0400
X-MC-Unique: xa2UzDPOOtmVKA5PsqM0EQ-1
Received: by mail-pf1-f179.google.com with SMTP id x18so1812806pfi.9;
	Mon, 17 May 2021 17:15:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:subject:to:cc:references:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=ma0y+AVUF5FMxdqp11h4WFBWrewppi+BP0ptgmZXHNY=;
	b=moQmJNBkenfaVAV+Vq3clLgIb9UsGHYdxvvj+4ycbyM1GcyV/A0ieTJNVcOsXGgDHU
	yl3OgV5fRVG41uujtLoyQ8redZdrMjeu5n4UEuzJl99lCc67+3eewiK6KmzIpEZ7VJhC
	BCsJ4fiUbHmRMnTuCXhiaN6W0HdmU7KiS4ytJZpWbAoaLpBSCbfW+ZzQumm6Yw6TZoZA
	dbLAZjC4mn9IRPYl1CzWM9YgDTkr9qIAmmywPLLQII0Ed76fVHA1kedWyJc04Fo3/qBu
	aooHo6rcxAC1DtAEXesQbYbG7ZvZf9QKFWbD00i111gY8d6+8WhSqAYdPp9sBQRE+/gH
	ZJTw==
X-Gm-Message-State: AOAM5331pLCYc4WgoxZjUyDhfVI1f0dqBdhyGDMt6HwtJxFOqrc5/v9h
	w9lLa28BPAq1cRi83coIOVc=
X-Google-Smtp-Source: ABdhPJwRgqjZwa+aml3zeF/6QupA23QGawzuRvsXsHqBnEjcM+kPVN9ffwKUcYegX+/ZwO/OZBf4Vg==
X-Received: by 2002:a65:48c5:: with SMTP id o5mr2168498pgs.101.1621296915872; 
	Mon, 17 May 2021 17:15:15 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:9781:8633:8854:8704?
	([2601:647:4000:d7:9781:8633:8854:8704])
	by smtp.gmail.com with ESMTPSA id 10sm5158247pgl.39.2021.05.17.17.15.12
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 17 May 2021 17:15:14 -0700 (PDT)
From: Bart Van Assche <bvanassche@acm.org>
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
Message-ID: <0cfa9399-701a-9fa2-3225-3b54007462e7@acm.org>
Date: Mon, 17 May 2021 17:15:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	"msnitzer@redhat.com" <msnitzer@redhat.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"rwheeler@redhat.com" <rwheeler@redhat.com>, "hch@lst.de" <hch@lst.de>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
	Offload
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/10/21 5:15 PM, Chaitanya Kulkarni wrote:
> I'd like to propose a session to go over this topic to understand :-
> 
> 1. What are the blockers for Copy Offload implementation ?
> 2. Discussion about having a file system interface.
> 3. Discussion about having right system call for user-space.
> 4. What is the right way to move this work forward ?
> 5. How can we help to contribute and move this work forward ?

We need to achieve agreement about an approach. The text below is my
attempt at guiding the discussion. A HTML version is available at
https://github.com/bvanassche/linux-kernel-copy-offload. As usual,
feedback is welcome.

Bart.


# Implementing Copy Offloading in the Linux Kernel

## Introduction

Efforts to add copy offloading support in the Linux kernel started considerable
time ago. Despite this copy offloading support is not yet upstream and there is
no detailed plan yet of how to implement copy offloading.

This document outlines a possible implementation. The purpose of this document
is to help guiding the conversations around copy offloading.

## Block Layer

We need an interface to pass copy offload requests from user space or file
systems to block drivers. Although the first implementation of copy offloading
added a single operation to the block layer for copy offloading, there seems
to be agreement today to implement copy offloading as two operations,
namely `REQ_COPY_IN` and `REQ_COPY_OUT`.

A possible approach is as follows:

* Fall back to a non-offloaded copy operation if necessary, e.g. if copy
  offloading is not supported or if data is encrypted and the ciphertext
  depends on the LBA. The following code may be a good starting point:
  `drivers/md/dm-kcopyd.c`.
* If the block driver supports copy offloading, submit the `REQ_COPY_IN`
  operation first. The block driver stores the data ranges associated with the
  `REQ_COPY_IN` operation.
* Wait for completion of the `REQ_COPY_IN` operation.
* After the `REQ_COPY_IN` operation has completed, submit the `REQ_COPY_OUT`
  operation and include a reference to the `REQ_COPY_IN` operation. If the
  block driver that receives the `REQ_COPY_OUT` operation receives a matching
  `REQ_COPY_IN` operation, offload the copy operation. Otherwise report that no
  data has been copied and let the block layer perform a non-offloaded copy
  operation.

The operation type is stored in the top bits of the `bi_opf` member of struct
bio.  With each bio a single data buffer and a single contiguous byte range on
the storage medium are associated. Pointers to the data buffer occur in
`bi_io_vec[]`. The affected byte range is represented by `bi_iter.bi_sector` and
`bi_iter.bi_size`.

While the NVMe and SCSI copy offload commands both support multiple source
ranges, XCOPY supports multiple destination ranges while the NVMe simple copy
command supports a single destination range.

Possible approaches for passing the data ranges involved in a copy operation
from the block layer to block drivers are as follows:

* Attach a bio to each copy offload request and encode all relevant copy
  offload parameters in that data buffer. These parameters include source
  device and source ranges for `REQ_COPY_IN` and destination device and
  destination ranges for `REQ_COPY_OUT`. Let the block drivers translate these
  parameters into something the storage device understands (NVMe simple copy
  parameters or SCSI XCOPY parameters). Fill in the parameter structure size
  in `bi_iter.bi_size`. Set `bi_vcnt` to 1 and fill in `bio->bi_io_vec[0]`.
* Map each source range and each destination range onto a different bio. Link
  all the bios with the `bi_next` pointer and attach these bios to the copy
  offload requests. Leave `bi_vcnt` zero. This is related but not identical to
  the approach followed by `__blkdev_issue_discard()`.

I think that the first approach would require more changes in the device mapper
than the second approach since the device mapper code knows how to split bios
but not how to split a buffer with LBA range descriptors.

The following code needs to be modified no matter how copy offloading is
implemented:

* Request cloning. The code for checking the limits before request are cloned
  compares `blk_rq_sectors()` with `max_sectors`. This is inappropriate for
  `REQ_COPY_*` requests.
* Request splitting. `bio_split()` assumes that `bi_iter.bi_size` represents
  the number of bytes affected on the medium.
* Code related to retrying the original requests of a merged request with
  mixed failfast attributes, e.g. `blk_rq_err_bytes()`.
* Code related to partially completing a request, e.g. `blk_update_request()`.
* The code for merging block layer requests.
* `blk_mq_end_request()` since it calls `blk_update_request()` and
  `blk_rq_bytes()`.
* The plugging code because of the following test in the plugging code:
  `blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE`.
* The I/O accounting code (task_io_account_read()) since that code uses
  bio_has_data() and hence skips discard, secure erase and write zeroes
  requests:
```
static inline bool bio_has_data(struct bio *bio)
{
	return bio && bio->bi_iter.bi_size &&
	    bio_op(bio) != REQ_OP_DISCARD &&
	    bio_op(bio) != REQ_OP_SECURE_ERASE &&
	    bio_op(bio) != REQ_OP_WRITE_ZEROESy;
}
```

Block drivers will need to use the `special_vec` member of struct request to
pass the copy offload parameters to the storage device. That member is used
e.g. when a REQ_OP_DISCARD operation is submitted to an NVMe driver. The SCSI
sd driver uses `special_vec` while processing an UNMAP or WRITE SAME command.

## Device Mapper

The device mapper may have to split a request. As an example, LVM is
based on the dm-linear driver. A request that is submitted to an LVM volume
has to be split if it affects multiple block devices. Copy offload requests
that affect multiple block devices should be split or should be onloaded.

The call chain for bio-based dm drivers is as follows:
```
dm_submit_bio(bio)
-> __split_and_process_bio(md, map, bio)
  -> __split_and_process_non_flush(clone_info)
    -> __clone_and_map_data_bio(clone_info, target_info, sector, len)
      -> clone_bio(dm_target_io, bio, sector, len)
      -> __map_bio(dm_target_io)
        -> ti->type->map(dm_target_io, clone)
```

## NVMe

Process copy offload commands by translating REQ_COPY_OUT requests into simple
copy commands.

## SCSI

>From inside `sd_revalidate_disk()`, query the third-party copy VPD page. Extract
the following parameters (see also SPC-6):

* MAXIMUM CSCD DESCRIPTOR COUNT
* MAXIMUM SEGMENT DESCRIPTOR COUNT
* MAXIMUM DESCRIPTOR LIST LENGTH
* Supported third-party copy commands.
* SUPPORTED CSCD DESCRIPTOR ID (0 or more)
* ROD type descriptor (0 or more)
* TOTAL CONCURRENT COPIES
* MAXIMUM IDENTIFIED CONCURRENT COPIES
* MAXIMUM SEGMENT LENGTH

>From inside `sd_init_command()`, translate REQ_COPY_OUT into either EXTENDED
COPY or POPULATE TOKEN + WRITE USING TOKEN.

Set the parameters in the copy offload commands as follows:

* We may have to set the STR bit. From SPC-6: "A sequential striped (STR) bit
  set to one specifies to the copy manager that the majority of the block
  device references in the parameter list represent sequential access of
  several block devices that are striped. This may be used by the copy manager
  to perform reads from a copy source block device at any time and in any
  order during processing of an EXTENDED COPY command as described in
  6.6.5.3. A STR bit set to zero specifies to the copy manager that disk
  references, if any, may not be sequential."
* Set the LIST ID USAGE field to 3 and the LIST ID to 0. This means that
  neither "held data" nor the RECEIVE COPY STATUS command are supported. This
  improves security because the data that is being copied cannot be accessed
  via the LIST ID.
* We may have to set the G_SENSE (good with sense data) bit. From SPC-6: " If
  the G _SENSE bit is set to one and the copy manager completes the EXTENDED
  COPY command with GOOD status, then the copy manager shall include sense
  data with the GOOD status in which the sense key is set to COMPLETED, the
  additional sense code is set to EXTENDED COPY INFORMATION AVAILABLE, and the
  COMMAND-SPECIFIC INFORMATION field is set to the number of segment
  descriptors the copy manager has processed."
* Clear the IMMED bit.

## System Call Interface

To submit copy offload requests from user space, we need:

* A system call for passing these requests, e.g. copy_file_range() or io_uring.
* Add a copy offload parameter format description to the user space ABI. The
  parameters include source device, source ranges, destination device and
  destination ranges.
* A flag that indicates whether or not it is acceptable to fall back to
  onloading the copy operation.

## Sysfs Interface

To do: define which aspects of copy offloading should be configurable through
new sysfs parameters under /sys/block/*/queue/.

## See Also

* Martin Petersen, [Copy
  Offload](https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg28998.html),
  linux-scsi, 28 May 2014.
* Mikulas Patocka, [ANNOUNCE: SCSI XCOPY support for the kernel and device
  mapper](https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg686111.html),
  15 July 2014.
* [kcopyd documentation](https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/kcopyd.html), kernel.org.
* Martin K. Petersen, [Copy Offload - Here Be Dragons](http://mkp.net/pubs/xcopy.pdf), 2019-08-21.
* Martin K. Petersen, [Re: [dm-devel] [RFC PATCH v2 1/2] block: add simple copy
support](https://lore.kernel.org/linux-nvme/yq1blf3smcl.fsf@ca-mkp.ca.oracle.com/), linux-nvme mailing list, 2020-12-08.
* NVM Express Organization, [NVMe - TP 4065b Simple Copy Command 2021.01.25 -
  Ratified.pdf](https://workspace.nvmexpress.org/apps/org/workgroup/allmembers/download.php/4773/NVMe%20-%20TP%204065b%20Simple%20Copy%20Command%202021.01.25%20-%20Ratified.pdf), 2021-01-25.
* Selvakumar S, [[RFC PATCH v5 0/4] add simple copy
  support](https://lore.kernel.org/linux-nvme/20210219124517.79359-1-selvakuma.s1@samsung.com/),
  linux-nvme, 2021-02-19.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

