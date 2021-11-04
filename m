Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E093DC433FE
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 13:15:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 69D6461108
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 13:15:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 69D6461108
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=interlog.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226--Kil_oduMbG28tYtvYtIAg-1; Fri, 05 Nov 2021 09:15:30 -0400
X-MC-Unique: -Kil_oduMbG28tYtvYtIAg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09D3219057A1;
	Fri,  5 Nov 2021 13:15:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 79A835D9DE;
	Fri,  5 Nov 2021 13:15:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6CA254EA2A;
	Fri,  5 Nov 2021 13:15:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4FMf44020806 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 11:22:41 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7811D21568A4; Thu,  4 Nov 2021 15:22:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C26221568A1
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 15:22:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D87F811E99
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 15:22:34 +0000 (UTC)
Received: from mail-1.ca.inter.net (mail-1.ca.inter.net [208.85.220.69]) by
	relay.mimecast.com with ESMTP id us-mta-269-BE3Pb5BNMuK7s9m8aaTLNQ-1;
	Thu, 04 Nov 2021 11:22:30 -0400
X-MC-Unique: BE3Pb5BNMuK7s9m8aaTLNQ-1
Received: from mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19])
	by mail-1.ca.inter.net (Postfix) with ESMTP id 61BD72EA1BD;
	Thu,  4 Nov 2021 11:16:45 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
	by mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19])
	(amavisd-new, port 10024)
	with ESMTP id eveuZKOwWI_I; Thu,  4 Nov 2021 11:16:44 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-208-241.dyn.295.ca [45.58.208.241])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: dgilbert@interlog.com)
	by mail-1.ca.inter.net (Postfix) with ESMTPSA id 78D192EA1A2;
	Thu,  4 Nov 2021 11:16:42 -0400 (EDT)
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	dm-devel@redhat.com
References: <20211104064634.4481-1-chaitanyak@nvidia.com>
From: Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <7f734d14-c107-daa3-aaa8-0eda3c592add@interlog.com>
Date: Thu, 4 Nov 2021 11:16:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211104064634.4481-1-chaitanyak@nvidia.com>
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
X-Mailman-Approved-At: Fri, 05 Nov 2021 09:15:20 -0400
Cc: snitzer@redhat.com, ebiggers@google.com, djwong@kernel.org, clm@fb.com,
	adilger.kernel@dilger.ca, osandov@fb.com, agk@redhat.com,
	javier@javigon.com, sagi@grimberg.me, dongli.zhang@oracle.com,
	willy@infradead.org, hch@lst.de, danil.kipnis@cloud.ionos.com,
	idryomov@gmail.com, jinpu.wang@cloud.ionos.com,
	Chaitanya Kulkarni <kch@nvidia.com>, jejb@linux.ibm.com,
	josef@toxicpanda.com, ming.lei@redhat.com, dsterba@suse.com,
	viro@zeniv.linux.org.uk, jefflexu@linux.alibaba.com,
	bvanassche@acm.org, axboe@kernel.dk, tytso@mit.edu,
	martin.petersen@oracle.com, song@kernel.org,
	johannes.thumshirn@wdc.com, jlayton@kernel.org,
	kbusch@kernel.org, jack@suse.com
Subject: Re: [dm-devel] [RFC PATCH 0/8] block: add support for REQ_OP_VERIFY
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
Reply-To: dgilbert@interlog.com
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
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 2021-11-04 2:46 a.m., Chaitanya Kulkarni wrote:
> From: Chaitanya Kulkarni <kch@nvidia.com>
> 
> Hi,
> 
> One of the responsibilities of the Operating System, along with managing
> resources, is to provide a unified interface to the user by creating
> hardware abstractions. In the Linux Kernel storage stack that
> abstraction is created by implementing the generic request operations
> such as REQ_OP_READ/REQ_OP_WRITE or REQ_OP_DISCARD/REQ_OP_WRITE_ZEROES,
> etc that are mapped to the specific low-level hardware protocol commands
> e.g. SCSI or NVMe.
> 
> With that in mind, this RFC patch-series implements a new block layer
> operation to offload the data verification on to the controller if
> supported or emulate the operation if not. The main advantage is to free
> up the CPU and reduce the host link traffic since, for some devices,
> their internal bandwidth is higher than the host link and offloading this
> operation can improve the performance of the proactive error detection
> applications such as file system level scrubbing.
> 
> * Background *
> -----------------------------------------------------------------------
> 
> NVMe Specification provides a controller level Verify command [1] which
> is similar to the ATA Verify [2] command where the controller is
> responsible for data verification without transferring the data to the
> host. (Offloading LBAs verification). This is designed to proactively
> discover any data corruption issues when the device is free so that
> applications can protect sensitive data and take corrective action
> instead of waiting for failure to occur.
> 
> The NVMe Verify command is added in order to provide low level media
> scrubbing and possibly moving the data to the right place in case it has
> correctable media degradation. Also, this provides a way to enhance
> file-system level scrubbing/checksum verification and optinally offload
> this task, which is CPU intensive, to the kernel (when emulated), over
> the fabric, and to the controller (when supported).
> 
> This is useful when the controller's internal bandwidth is higher than
> the host's bandwith showing a sharp increase in the performance due to
> _no host traffic or host CPU involvement_.
> 
> * Implementation *
> -----------------------------------------------------------------------
> 
> Right now there is no generic interface which can be used by the
> in-kernel components such as file-system or userspace application
> (except passthru commands or some combination of write/read/compare) to
> issue verify command with the central block layer API. This can lead to
> each userspace applications having protocol specific IOCTL which
> defeates the purpose of having the OS provide a H/W abstraction.
> 
> This patch series introduces a new block layer payloadless request
> operation REQ_OP_VERIFY that allows in-kernel components & userspace
> applications to verify the range of the LBAs by offloading checksum
> scrubbing/verification to the controller that is directly attached to
> the host. For direct attached devices this leads to decrease in the host
> DMA traffic and CPU usage and for the fabrics attached device over the
> network that leads to a decrease in the network traffic and CPU usage
> for both host & target.
> 
> * Scope *
> -----------------------------------------------------------------------
> 
> Please note this only covers the operating system level overhead.
> Analyzing controller verify command performance for common protocols
> (SCSI/NVMe) is out of scope for REQ_OP_VERIFY.
> 
> * Micro Benchmarks *
> -----------------------------------------------------------------------
> 
> When verifing 500GB of data on NVMeOF with nvme-loop and null_blk as a
> target backend block device results show almost a 80% performance
> increase :-
> 
> With Verify resulting in REQ_OP_VERIFY to null_blk :-
> 
> real	2m3.773s
> user	0m0.000s
> sys	0m59.553s
> 
> With Emulation resulting in REQ_OP_READ null_blk :-
> 
> real	12m18.964s
> user	0m0.002s
> sys	1m15.666s
> 
> 
> A detailed test log is included at the end of the cover letter.
> Each of the following was tested:
> 
> 1. Direct Attached REQ_OP_VERIFY.
> 2. Fabrics Attached REQ_OP_VERIFY.
> 3. Multi-device (md) REQ_OP_VERIFY.
> 
> * The complete picture *
> -----------------------------------------------------------------------
> 
>    For the completeness the whole kernel stack support is divided into
>    two phases :-
>   
>    Phase I :-
>   
>     Add and stabilize the support for the Block layer & low level drivers
>     such as SCSI, NVMe, MD, and NVMeOF, implement necessary emulations in
>     the block layer if needed and provide block level tools such as
>     _blkverify_. Also, add appropriate testcases for code-coverage.
> 
>    Phase II :-
>   
>     Add and stabilize the support for upper layer kernel components such
>     as file-systems and provide userspace tools such _fsverify_ to route
>     the request from file systems to block layer to Low level device
>     drivers.
> 
> 
> Please note that the interfaces for blk-lib.c REQ_OP_VERIFY emulation
> will change in future I put together for the scope of RFC.
> 
> Any comments are welcome.

Hi,
You may also want to consider higher level support for the NVME COMPARE
and SCSI VERIFY(BYTCHK=1) commands. Since PCIe and SAS transports are
full duplex, replacing two READs (plus a memcmp in host memory) with
one READ and one COMPARE may be a win on a bandwidth constrained
system. It is a safe to assume the data-in transfers on a storage transport
exceed (probably by a significant margin) the data-out transfers. An
offloaded COMPARE switches one of those data-in transfers to a data-out
transfer, so it should improve the bandwidth utilization.

I did some brief benchmarking on a NVME SSD's COMPARE command (its optional)
and the results were underwhelming. OTOH using my own dd variants (which
can do compare instead of copy) and a scsi_debug target (i.e. RAM) I have
seen compare times of > 15 GBps while a copy rarely exceeds 9 GBps.


BTW The SCSI VERIFY(BYTCHK=3) command compares one block sent from
the host with a sequence of logical blocks on the media. So, for example,
it would be a quick way of checking that a sequence of blocks contained
zero-ed data.

Doug Gilbert

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

