Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E908C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 13:15:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3B653610FD
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 13:15:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3B653610FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-t8XoM_TdPiePXvaYZxk0UQ-1; Fri, 05 Nov 2021 09:15:44 -0400
X-MC-Unique: t8XoM_TdPiePXvaYZxk0UQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A317101F7BA;
	Fri,  5 Nov 2021 13:15:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3564816A31;
	Fri,  5 Nov 2021 13:15:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B73CA4EA30;
	Fri,  5 Nov 2021 13:15:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4MjA5d001537 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 18:45:11 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D2EE41121319; Thu,  4 Nov 2021 22:45:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CE9681121315
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 22:45:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0532B802A67
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 22:45:07 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-15-e7uyicBWOg-uEjjWcWjFcA-1; 
	Thu, 04 Nov 2021 18:45:05 -0400
X-MC-Unique: e7uyicBWOg-uEjjWcWjFcA-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34F0561220;
	Thu,  4 Nov 2021 22:45:01 +0000 (UTC)
Date: Thu, 4 Nov 2021 15:44:59 -0700
From: Keith Busch <kbusch@kernel.org>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <20211104224459.GB2655721@dhcp-10-100-145-180.wdc.com>
References: <20211104064634.4481-1-chaitanyak@nvidia.com>
	<20211104064634.4481-4-chaitanyak@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20211104064634.4481-4-chaitanyak@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 05 Nov 2021 09:15:20 -0400
Cc: snitzer@redhat.com, ebiggers@google.com, djwong@kernel.org,
	linux-nvme@lists.infradead.org, song@kernel.org,
	dm-devel@redhat.com, target-devel@vger.kernel.org,
	adilger.kernel@dilger.ca, hch@lst.de, agk@redhat.com,
	javier@javigon.com, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, dongli.zhang@oracle.com,
	willy@infradead.org, osandov@fb.com,
	danil.kipnis@cloud.ionos.com, idryomov@gmail.com,
	jinpu.wang@cloud.ionos.com, Chaitanya Kulkarni <kch@nvidia.com>,
	jejb@linux.ibm.com, josef@toxicpanda.com, ming.lei@redhat.com,
	linux-raid@vger.kernel.org, dsterba@suse.com,
	viro@zeniv.linux.org.uk, jefflexu@linux.alibaba.com,
	sagi@grimberg.me, axboe@kernel.dk, linux-block@vger.kernel.org,
	tytso@mit.edu, martin.petersen@oracle.com, clm@fb.com,
	johannes.thumshirn@wdc.com, jlayton@kernel.org,
	linux-xfs@vger.kernel.org, jack@suse.com, linux-fsdevel@vger.kernel.org
Subject: Re: [dm-devel] [RFC PATCH 3/8] nvme: add support for the Verify
	command
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

On Wed, Nov 03, 2021 at 11:46:29PM -0700, Chaitanya Kulkarni wrote:
> +static inline blk_status_t nvme_setup_verify(struct nvme_ns *ns,
> +		struct request *req, struct nvme_command *cmnd)
> +{

Due to recent driver changes, you need a "memset(cmnd, 0, sizeof(*cmnd))"
prior to setting up the rest of the command, or you need to set each
command dword individually.

> +	cmnd->verify.opcode = nvme_cmd_verify;
> +	cmnd->verify.nsid = cpu_to_le32(ns->head->ns_id);
> +	cmnd->verify.slba =
> +		cpu_to_le64(nvme_sect_to_lba(ns, blk_rq_pos(req)));
> +	cmnd->verify.length =
> +		cpu_to_le16((blk_rq_bytes(req) >> ns->lba_shift) - 1);
> +	cmnd->verify.control = 0;
> +	return BLK_STS_OK;
> +}

> +static void nvme_config_verify(struct gendisk *disk, struct nvme_ns *ns)
> +{
> +	u64 max_blocks;
> +
> +	if (!(ns->ctrl->oncs & NVME_CTRL_ONCS_VERIFY))
> +		return;
> +
> +	if (ns->ctrl->max_hw_sectors == UINT_MAX)
> +		max_blocks = (u64)USHRT_MAX + 1;
> +	else
> +		max_blocks = ns->ctrl->max_hw_sectors + 1;

If supported by the controller, this maximum is defined in the non-mdts
command limits in NVM command set specific Identify Controller VSL field.

> +
> +	/* keep same as discard */
> +	if (blk_queue_flag_test_and_set(QUEUE_FLAG_VERIFY, disk->queue))
> +		return;
> +
> +	blk_queue_max_verify_sectors(disk->queue,
> +				     nvme_lba_to_sect(ns, max_blocks));
> +
> +}

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

