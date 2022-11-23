Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 609D8C4332F
	for <dm-devel@archiver.kernel.org>; Wed, 23 Nov 2022 08:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669191968;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=GpQHwSVe8lrqWSHRFoF5VDK5hB6qS7Kh+KV6n2tqg3g=;
	b=Ft80TCKXCW5EYaAMc76n+kc6juKYrlewF9LznO2AfsaJb+wns4g+WJjzN3guQGuHkD4Bra
	7ywUM6tsaF3bnnk3DdYNjGsG7CjJm/CNOaTaX0oUyC30oBoiZFprdPKnxY/1cxn/Yus6i7
	9HlqUpMxz9W8AAxNuAezwM2HNxMc1+E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-QfKjX-ZWNmiYh4SblzYbkg-1; Wed, 23 Nov 2022 03:26:04 -0500
X-MC-Unique: QfKjX-ZWNmiYh4SblzYbkg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A99E806001;
	Wed, 23 Nov 2022 08:25:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1833E2028E8F;
	Wed, 23 Nov 2022 08:25:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 02221194658D;
	Wed, 23 Nov 2022 08:25:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EC2571946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Nov 2022 08:22:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CCBAC111E413; Wed, 23 Nov 2022 08:22:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C44BD111E40B
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 08:22:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0631800186
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 08:22:58 +0000 (UTC)
Received: from out30-57.freemail.mail.aliyun.com
 (out30-57.freemail.mail.aliyun.com [115.124.30.57]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256)
 id us-mta-644-A14x6_qnPLqPxooPpiktCg-1; Wed, 23 Nov 2022 03:22:55 -0500
X-MC-Unique: A14x6_qnPLqPxooPpiktCg-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R181e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045176;
 MF=kanie@linux.alibaba.com; NM=1; PH=DS; RN=23; SR=0;
 TI=SMTPD_---0VVW49T._1669191464
Received: from 30.178.80.175(mailfrom:kanie@linux.alibaba.com
 fp:SMTPD_---0VVW49T._1669191464) by smtp.aliyun-inc.com;
 Wed, 23 Nov 2022 16:17:47 +0800
Message-ID: <482586a3-f45d-a17b-7630-341fb0e1ee96@linux.alibaba.com>
Date: Wed, 23 Nov 2022 16:17:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
From: Guixin Liu <kanie@linux.alibaba.com>
To: Nitesh Shetty <nj.shetty@samsung.com>, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, dm-devel@redhat.com, kbusch@kernel.org, hch@lst.de,
 sagi@grimberg.me, james.smart@broadcom.com, kch@nvidia.com,
 damien.lemoal@opensource.wdc.com, naohiro.aota@wdc.com, jth@kernel.org,
 viro@zeniv.linux.org.uk
References: <20221123055827.26996-1-nj.shetty@samsung.com>
 <CGME20221123061031epcas5p3745558c2caffd2fd21d15feff00495e9@epcas5p3.samsung.com>
 <20221123055827.26996-7-nj.shetty@samsung.com>
In-Reply-To: <20221123055827.26996-7-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Wed, 23 Nov 2022 08:25:56 +0000
Subject: Re: [dm-devel] [PATCH v5 06/10] nvmet: add copy command support for
 bdev and file ns
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: p.raghav@samsung.com, joshi.k@samsung.com, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============2286033874053230736=="

This is a multi-part message in MIME format.
--===============2286033874053230736==
Content-Type: multipart/alternative;
 boundary="------------vpt2AA06hN0gx55eaAKWEYTH"

This is a multi-part message in MIME format.
--------------vpt2AA06hN0gx55eaAKWEYTH
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2022/11/23 13:58, Nitesh Shetty 写道:
> Add support for handling target command on target.
> For bdev-ns we call into blkdev_issue_copy, which the block layer
> completes by a offloaded copy request to backend bdev or by emulating the
> request.
>
> For file-ns we call vfs_copy_file_range to service our request.
>
> Currently target always shows copy capability by setting
> NVME_CTRL_ONCS_COPY in controller ONCS.
>
> Signed-off-by: Nitesh Shetty<nj.shetty@samsung.com>
> Signed-off-by: Anuj Gupta<anuj20.g@samsung.com>
> ---
>   drivers/nvme/target/admin-cmd.c   |  9 +++-
>   drivers/nvme/target/io-cmd-bdev.c | 79 +++++++++++++++++++++++++++++++
>   drivers/nvme/target/io-cmd-file.c | 51 ++++++++++++++++++++
>   drivers/nvme/target/loop.c        |  6 +++
>   drivers/nvme/target/nvmet.h       |  2 +
>   5 files changed, 145 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
> index c8a061ce3ee5..5ae509ff4b19 100644
> --- a/drivers/nvme/target/admin-cmd.c
> +++ b/drivers/nvme/target/admin-cmd.c
> @@ -431,8 +431,7 @@ static void nvmet_execute_identify_ctrl(struct nvmet_req *req)
>   	id->nn = cpu_to_le32(NVMET_MAX_NAMESPACES);
>   	id->mnan = cpu_to_le32(NVMET_MAX_NAMESPACES);
>   	id->oncs = cpu_to_le16(NVME_CTRL_ONCS_DSM |
> -			NVME_CTRL_ONCS_WRITE_ZEROES);
> -
> +			NVME_CTRL_ONCS_WRITE_ZEROES | NVME_CTRL_ONCS_COPY);
>   	/* XXX: don't report vwc if the underlying device is write through */
>   	id->vwc = NVME_CTRL_VWC_PRESENT;
>   
> @@ -534,6 +533,12 @@ static void nvmet_execute_identify_ns(struct nvmet_req *req)
>   
>   	if (req->ns->bdev)
>   		nvmet_bdev_set_limits(req->ns->bdev, id);
> +	else {
> +		id->msrc = (u8)to0based(BIO_MAX_VECS - 1);
> +		id->mssrl = cpu_to_le16(BIO_MAX_VECS <<
> +				(PAGE_SHIFT - SECTOR_SHIFT));
> +		id->mcl = cpu_to_le32(le16_to_cpu(id->mssrl));
> +	}
>   
>   	/*
>   	 * We just provide a single LBA format that matches what the
> diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
> index c2d6cea0236b..01f0160125fb 100644
> --- a/drivers/nvme/target/io-cmd-bdev.c
> +++ b/drivers/nvme/target/io-cmd-bdev.c
> @@ -46,6 +46,19 @@ void nvmet_bdev_set_limits(struct block_device *bdev, struct nvme_id_ns *id)
>   	id->npda = id->npdg;
>   	/* NOWS = Namespace Optimal Write Size */
>   	id->nows = to0based(bdev_io_opt(bdev) / bdev_logical_block_size(bdev));
> +
> +	/*Copy limits*/
> +	if (bdev_max_copy_sectors(bdev)) {
> +		id->msrc = id->msrc;
> +		id->mssrl = cpu_to_le16((bdev_max_copy_sectors(bdev) <<
> +				SECTOR_SHIFT) / bdev_logical_block_size(bdev));
> +		id->mcl = cpu_to_le32(id->mssrl);
> +	} else {
> +		id->msrc = (u8)to0based(BIO_MAX_VECS - 1);
> +		id->mssrl = cpu_to_le16((BIO_MAX_VECS << PAGE_SHIFT) /
> +				bdev_logical_block_size(bdev));
> +		id->mcl = cpu_to_le32(id->mssrl);
> +	}

Based on my understanding of the NVMe protocol 2.0,  the mssrl is the 
max length per single range entry,

the mcl is the total max copy length in one copy command, may I ask why 
mcl = msssrl? not mcl = mssrl * msrc?

Best Regards,

Guixin Liu

>   }
>   
>   void nvmet_bdev_ns_disable(struct nvmet_ns *ns)
> @@ -184,6 +197,23 @@ static void nvmet_bio_done(struct bio *bio)
>   	nvmet_req_bio_put(req, bio);
>   }
>   
> +static void nvmet_bdev_copy_end_io(void *private, int status)
> +{
> +	struct nvmet_req *req = (struct nvmet_req *)private;
> +	int id;
> +
> +	if (status) {
> +		for (id = 0 ; id < req->nr_range; id++) {
> +			if (req->ranges[id].len != req->ranges[id].comp_len) {
> +				req->cqe->result.u32 = cpu_to_le32(id);
> +				break;
> +			}
> +		}
> +	}
> +	kfree(req->ranges);
> +	nvmet_req_complete(req, errno_to_nvme_status(req, status));
> +}
> +
>   #ifdef CONFIG_BLK_DEV_INTEGRITY
>   static int nvmet_bdev_alloc_bip(struct nvmet_req *req, struct bio *bio,
>   				struct sg_mapping_iter *miter)
> @@ -450,6 +480,51 @@ static void nvmet_bdev_execute_write_zeroes(struct nvmet_req *req)
>   	}
>   }
>   
> +static void nvmet_bdev_execute_copy(struct nvmet_req *req)
> +{
> +	struct nvme_copy_range range;
> +	struct range_entry *ranges;
> +	struct nvme_command *cmnd = req->cmd;
> +	sector_t dest, dest_off = 0;
> +	int ret, id, nr_range;
> +
> +	nr_range = cmnd->copy.nr_range + 1;
> +	dest = le64_to_cpu(cmnd->copy.sdlba) << req->ns->blksize_shift;
> +	ranges = kmalloc_array(nr_range, sizeof(*ranges), GFP_KERNEL);
> +
> +	for (id = 0 ; id < nr_range; id++) {
> +		ret = nvmet_copy_from_sgl(req, id * sizeof(range),
> +					&range, sizeof(range));
> +		if (ret)
> +			goto out;
> +
> +		ranges[id].dst = dest + dest_off;
> +		ranges[id].src = le64_to_cpu(range.slba) <<
> +					req->ns->blksize_shift;
> +		ranges[id].len = (le16_to_cpu(range.nlb) + 1) <<
> +					req->ns->blksize_shift;
> +		ranges[id].comp_len = 0;
> +		dest_off += ranges[id].len;
> +	}
> +	req->ranges = ranges;
> +	req->nr_range = nr_range;
> +	ret = blkdev_issue_copy(req->ns->bdev, req->ns->bdev, ranges, nr_range,
> +			nvmet_bdev_copy_end_io, (void *)req, GFP_KERNEL);
> +	if (ret) {
> +		for (id = 0 ; id < nr_range; id++) {
> +			if (ranges[id].len != ranges[id].comp_len) {
> +				req->cqe->result.u32 = cpu_to_le32(id);
> +				break;
> +			}
> +		}
> +		goto out;
> +	} else
> +		return;
> +out:
> +	kfree(ranges);
> +	nvmet_req_complete(req, errno_to_nvme_status(req, ret));
> +}
> +
>   u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
>   {
>   	switch (req->cmd->common.opcode) {
> @@ -468,6 +543,10 @@ u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
>   	case nvme_cmd_write_zeroes:
>   		req->execute = nvmet_bdev_execute_write_zeroes;
>   		return 0;
> +	case nvme_cmd_copy:
> +		req->execute = nvmet_bdev_execute_copy;
> +		return 0;
> +
>   	default:
>   		return nvmet_report_invalid_opcode(req);
>   	}
> diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
> index 64b47e2a4633..a81d38796e17 100644
> --- a/drivers/nvme/target/io-cmd-file.c
> +++ b/drivers/nvme/target/io-cmd-file.c
> @@ -338,6 +338,48 @@ static void nvmet_file_dsm_work(struct work_struct *w)
>   	}
>   }
>   
> +static void nvmet_file_copy_work(struct work_struct *w)
> +{
> +	struct nvmet_req *req = container_of(w, struct nvmet_req, f.work);
> +	int nr_range;
> +	loff_t pos;
> +	struct nvme_command *cmnd = req->cmd;
> +	int ret = 0, len = 0, src, id;
> +
> +	nr_range = cmnd->copy.nr_range + 1;
> +	pos = le64_to_cpu(req->cmd->copy.sdlba) << req->ns->blksize_shift;
> +	if (unlikely(pos + req->transfer_len > req->ns->size)) {
> +		nvmet_req_complete(req, errno_to_nvme_status(req, -ENOSPC));
> +		return;
> +	}
> +
> +	for (id = 0 ; id < nr_range; id++) {
> +		struct nvme_copy_range range;
> +
> +		ret = nvmet_copy_from_sgl(req, id * sizeof(range), &range,
> +					sizeof(range));
> +		if (ret)
> +			goto out;
> +
> +		len = (le16_to_cpu(range.nlb) + 1) << (req->ns->blksize_shift);
> +		src = (le64_to_cpu(range.slba) << (req->ns->blksize_shift));
> +		ret = vfs_copy_file_range(req->ns->file, src, req->ns->file,
> +					pos, len, 0);
> +out:
> +		if (ret != len) {
> +			pos += ret;
> +			req->cqe->result.u32 = cpu_to_le32(id);
> +			nvmet_req_complete(req, ret < 0 ?
> +					errno_to_nvme_status(req, ret) :
> +					errno_to_nvme_status(req, -EIO));
> +			return;
> +
> +		} else
> +			pos += len;
> +}
> +	nvmet_req_complete(req, ret);
> +
> +}
>   static void nvmet_file_execute_dsm(struct nvmet_req *req)
>   {
>   	if (!nvmet_check_data_len_lte(req, nvmet_dsm_len(req)))
> @@ -346,6 +388,12 @@ static void nvmet_file_execute_dsm(struct nvmet_req *req)
>   	queue_work(nvmet_wq, &req->f.work);
>   }
>   
> +static void nvmet_file_execute_copy(struct nvmet_req *req)
> +{
> +	INIT_WORK(&req->f.work, nvmet_file_copy_work);
> +	queue_work(nvmet_wq, &req->f.work);
> +}
> +
>   static void nvmet_file_write_zeroes_work(struct work_struct *w)
>   {
>   	struct nvmet_req *req = container_of(w, struct nvmet_req, f.work);
> @@ -392,6 +440,9 @@ u16 nvmet_file_parse_io_cmd(struct nvmet_req *req)
>   	case nvme_cmd_write_zeroes:
>   		req->execute = nvmet_file_execute_write_zeroes;
>   		return 0;
> +	case nvme_cmd_copy:
> +		req->execute = nvmet_file_execute_copy;
> +		return 0;
>   	default:
>   		return nvmet_report_invalid_opcode(req);
>   	}
> diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
> index b45fe3adf015..55802632b407 100644
> --- a/drivers/nvme/target/loop.c
> +++ b/drivers/nvme/target/loop.c
> @@ -146,6 +146,12 @@ static blk_status_t nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
>   		return ret;
>   
>   	blk_mq_start_request(req);
> +	if (unlikely((req->cmd_flags & REQ_COPY) &&
> +				(req_op(req) == REQ_OP_READ))) {
> +		blk_mq_set_request_complete(req);
> +		blk_mq_end_request(req, BLK_STS_OK);
> +		return BLK_STS_OK;
> +	}
>   	iod->cmd.common.flags |= NVME_CMD_SGL_METABUF;
>   	iod->req.port = queue->ctrl->port;
>   	if (!nvmet_req_init(&iod->req, &queue->nvme_cq,
> diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
> index dfe3894205aa..3b4c7d2ee45d 100644
> --- a/drivers/nvme/target/nvmet.h
> +++ b/drivers/nvme/target/nvmet.h
> @@ -391,6 +391,8 @@ struct nvmet_req {
>   	struct device		*p2p_client;
>   	u16			error_loc;
>   	u64			error_slba;
> +	struct range_entry *ranges;
> +	unsigned int nr_range;
>   };
>   
>   extern struct workqueue_struct *buffered_io_wq;
--------------vpt2AA06hN0gx55eaAKWEYTH
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">在 2022/11/23 13:58, Nitesh Shetty 写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20221123055827.26996-7-nj.shetty@samsung.com">
      <pre class="moz-quote-pre" wrap="">Add support for handling target command on target.
For bdev-ns we call into blkdev_issue_copy, which the block layer
completes by a offloaded copy request to backend bdev or by emulating the
request.

For file-ns we call vfs_copy_file_range to service our request.

Currently target always shows copy capability by setting
NVME_CTRL_ONCS_COPY in controller ONCS.

Signed-off-by: Nitesh Shetty <a class="moz-txt-link-rfc2396E" href="mailto:nj.shetty@samsung.com">&lt;nj.shetty@samsung.com&gt;</a>
Signed-off-by: Anuj Gupta <a class="moz-txt-link-rfc2396E" href="mailto:anuj20.g@samsung.com">&lt;anuj20.g@samsung.com&gt;</a>
---
 drivers/nvme/target/admin-cmd.c   |  9 +++-
 drivers/nvme/target/io-cmd-bdev.c | 79 +++++++++++++++++++++++++++++++
 drivers/nvme/target/io-cmd-file.c | 51 ++++++++++++++++++++
 drivers/nvme/target/loop.c        |  6 +++
 drivers/nvme/target/nvmet.h       |  2 +
 5 files changed, 145 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index c8a061ce3ee5..5ae509ff4b19 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -431,8 +431,7 @@ static void nvmet_execute_identify_ctrl(struct nvmet_req *req)
 	id-&gt;nn = cpu_to_le32(NVMET_MAX_NAMESPACES);
 	id-&gt;mnan = cpu_to_le32(NVMET_MAX_NAMESPACES);
 	id-&gt;oncs = cpu_to_le16(NVME_CTRL_ONCS_DSM |
-			NVME_CTRL_ONCS_WRITE_ZEROES);
-
+			NVME_CTRL_ONCS_WRITE_ZEROES | NVME_CTRL_ONCS_COPY);
 	/* XXX: don't report vwc if the underlying device is write through */
 	id-&gt;vwc = NVME_CTRL_VWC_PRESENT;
 
@@ -534,6 +533,12 @@ static void nvmet_execute_identify_ns(struct nvmet_req *req)
 
 	if (req-&gt;ns-&gt;bdev)
 		nvmet_bdev_set_limits(req-&gt;ns-&gt;bdev, id);
+	else {
+		id-&gt;msrc = (u8)to0based(BIO_MAX_VECS - 1);
+		id-&gt;mssrl = cpu_to_le16(BIO_MAX_VECS &lt;&lt;
+				(PAGE_SHIFT - SECTOR_SHIFT));
+		id-&gt;mcl = cpu_to_le32(le16_to_cpu(id-&gt;mssrl));
+	}
 
 	/*
 	 * We just provide a single LBA format that matches what the
diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index c2d6cea0236b..01f0160125fb 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -46,6 +46,19 @@ void nvmet_bdev_set_limits(struct block_device *bdev, struct nvme_id_ns *id)
 	id-&gt;npda = id-&gt;npdg;
 	/* NOWS = Namespace Optimal Write Size */
 	id-&gt;nows = to0based(bdev_io_opt(bdev) / bdev_logical_block_size(bdev));
+
+	/*Copy limits*/
+	if (bdev_max_copy_sectors(bdev)) {
+		id-&gt;msrc = id-&gt;msrc;
+		id-&gt;mssrl = cpu_to_le16((bdev_max_copy_sectors(bdev) &lt;&lt;
+				SECTOR_SHIFT) / bdev_logical_block_size(bdev));
+		id-&gt;mcl = cpu_to_le32(id-&gt;mssrl);
+	} else {
+		id-&gt;msrc = (u8)to0based(BIO_MAX_VECS - 1);
+		id-&gt;mssrl = cpu_to_le16((BIO_MAX_VECS &lt;&lt; PAGE_SHIFT) /
+				bdev_logical_block_size(bdev));
+		id-&gt;mcl = cpu_to_le32(id-&gt;mssrl);
+	}</pre>
    </blockquote>
    <p><span class="ne-text" style="color: rgb(0, 0, 0); font-size:
        16px">Based on my understanding of the NVMe protocol</span>
      2.0,  the mssrl is the max length per single range entry, <br>
    </p>
    <p>the mcl is the total max copy length in one copy command, may I
      ask why mcl = msssrl? not mcl = mssrl * msrc?</p>
    <p>Best Regards,</p>
    <p>Guixin Liu<br>
    </p>
    <blockquote type="cite"
      cite="mid:20221123055827.26996-7-nj.shetty@samsung.com">
      <pre class="moz-quote-pre" wrap=""> }
 
 void nvmet_bdev_ns_disable(struct nvmet_ns *ns)
@@ -184,6 +197,23 @@ static void nvmet_bio_done(struct bio *bio)
 	nvmet_req_bio_put(req, bio);
 }
 
+static void nvmet_bdev_copy_end_io(void *private, int status)
+{
+	struct nvmet_req *req = (struct nvmet_req *)private;
+	int id;
+
+	if (status) {
+		for (id = 0 ; id &lt; req-&gt;nr_range; id++) {
+			if (req-&gt;ranges[id].len != req-&gt;ranges[id].comp_len) {
+				req-&gt;cqe-&gt;result.u32 = cpu_to_le32(id);
+				break;
+			}
+		}
+	}
+	kfree(req-&gt;ranges);
+	nvmet_req_complete(req, errno_to_nvme_status(req, status));
+}
+
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 static int nvmet_bdev_alloc_bip(struct nvmet_req *req, struct bio *bio,
 				struct sg_mapping_iter *miter)
@@ -450,6 +480,51 @@ static void nvmet_bdev_execute_write_zeroes(struct nvmet_req *req)
 	}
 }
 
+static void nvmet_bdev_execute_copy(struct nvmet_req *req)
+{
+	struct nvme_copy_range range;
+	struct range_entry *ranges;
+	struct nvme_command *cmnd = req-&gt;cmd;
+	sector_t dest, dest_off = 0;
+	int ret, id, nr_range;
+
+	nr_range = cmnd-&gt;copy.nr_range + 1;
+	dest = le64_to_cpu(cmnd-&gt;copy.sdlba) &lt;&lt; req-&gt;ns-&gt;blksize_shift;
+	ranges = kmalloc_array(nr_range, sizeof(*ranges), GFP_KERNEL);
+
+	for (id = 0 ; id &lt; nr_range; id++) {
+		ret = nvmet_copy_from_sgl(req, id * sizeof(range),
+					&amp;range, sizeof(range));
+		if (ret)
+			goto out;
+
+		ranges[id].dst = dest + dest_off;
+		ranges[id].src = le64_to_cpu(range.slba) &lt;&lt;
+					req-&gt;ns-&gt;blksize_shift;
+		ranges[id].len = (le16_to_cpu(range.nlb) + 1) &lt;&lt;
+					req-&gt;ns-&gt;blksize_shift;
+		ranges[id].comp_len = 0;
+		dest_off += ranges[id].len;
+	}
+	req-&gt;ranges = ranges;
+	req-&gt;nr_range = nr_range;
+	ret = blkdev_issue_copy(req-&gt;ns-&gt;bdev, req-&gt;ns-&gt;bdev, ranges, nr_range,
+			nvmet_bdev_copy_end_io, (void *)req, GFP_KERNEL);
+	if (ret) {
+		for (id = 0 ; id &lt; nr_range; id++) {
+			if (ranges[id].len != ranges[id].comp_len) {
+				req-&gt;cqe-&gt;result.u32 = cpu_to_le32(id);
+				break;
+			}
+		}
+		goto out;
+	} else
+		return;
+out:
+	kfree(ranges);
+	nvmet_req_complete(req, errno_to_nvme_status(req, ret));
+}
+
 u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
 {
 	switch (req-&gt;cmd-&gt;common.opcode) {
@@ -468,6 +543,10 @@ u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
 	case nvme_cmd_write_zeroes:
 		req-&gt;execute = nvmet_bdev_execute_write_zeroes;
 		return 0;
+	case nvme_cmd_copy:
+		req-&gt;execute = nvmet_bdev_execute_copy;
+		return 0;
+
 	default:
 		return nvmet_report_invalid_opcode(req);
 	}
diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 64b47e2a4633..a81d38796e17 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -338,6 +338,48 @@ static void nvmet_file_dsm_work(struct work_struct *w)
 	}
 }
 
+static void nvmet_file_copy_work(struct work_struct *w)
+{
+	struct nvmet_req *req = container_of(w, struct nvmet_req, f.work);
+	int nr_range;
+	loff_t pos;
+	struct nvme_command *cmnd = req-&gt;cmd;
+	int ret = 0, len = 0, src, id;
+
+	nr_range = cmnd-&gt;copy.nr_range + 1;
+	pos = le64_to_cpu(req-&gt;cmd-&gt;copy.sdlba) &lt;&lt; req-&gt;ns-&gt;blksize_shift;
+	if (unlikely(pos + req-&gt;transfer_len &gt; req-&gt;ns-&gt;size)) {
+		nvmet_req_complete(req, errno_to_nvme_status(req, -ENOSPC));
+		return;
+	}
+
+	for (id = 0 ; id &lt; nr_range; id++) {
+		struct nvme_copy_range range;
+
+		ret = nvmet_copy_from_sgl(req, id * sizeof(range), &amp;range,
+					sizeof(range));
+		if (ret)
+			goto out;
+
+		len = (le16_to_cpu(range.nlb) + 1) &lt;&lt; (req-&gt;ns-&gt;blksize_shift);
+		src = (le64_to_cpu(range.slba) &lt;&lt; (req-&gt;ns-&gt;blksize_shift));
+		ret = vfs_copy_file_range(req-&gt;ns-&gt;file, src, req-&gt;ns-&gt;file,
+					pos, len, 0);
+out:
+		if (ret != len) {
+			pos += ret;
+			req-&gt;cqe-&gt;result.u32 = cpu_to_le32(id);
+			nvmet_req_complete(req, ret &lt; 0 ?
+					errno_to_nvme_status(req, ret) :
+					errno_to_nvme_status(req, -EIO));
+			return;
+
+		} else
+			pos += len;
+}
+	nvmet_req_complete(req, ret);
+
+}
 static void nvmet_file_execute_dsm(struct nvmet_req *req)
 {
 	if (!nvmet_check_data_len_lte(req, nvmet_dsm_len(req)))
@@ -346,6 +388,12 @@ static void nvmet_file_execute_dsm(struct nvmet_req *req)
 	queue_work(nvmet_wq, &amp;req-&gt;f.work);
 }
 
+static void nvmet_file_execute_copy(struct nvmet_req *req)
+{
+	INIT_WORK(&amp;req-&gt;f.work, nvmet_file_copy_work);
+	queue_work(nvmet_wq, &amp;req-&gt;f.work);
+}
+
 static void nvmet_file_write_zeroes_work(struct work_struct *w)
 {
 	struct nvmet_req *req = container_of(w, struct nvmet_req, f.work);
@@ -392,6 +440,9 @@ u16 nvmet_file_parse_io_cmd(struct nvmet_req *req)
 	case nvme_cmd_write_zeroes:
 		req-&gt;execute = nvmet_file_execute_write_zeroes;
 		return 0;
+	case nvme_cmd_copy:
+		req-&gt;execute = nvmet_file_execute_copy;
+		return 0;
 	default:
 		return nvmet_report_invalid_opcode(req);
 	}
diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index b45fe3adf015..55802632b407 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -146,6 +146,12 @@ static blk_status_t nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		return ret;
 
 	blk_mq_start_request(req);
+	if (unlikely((req-&gt;cmd_flags &amp; REQ_COPY) &amp;&amp;
+				(req_op(req) == REQ_OP_READ))) {
+		blk_mq_set_request_complete(req);
+		blk_mq_end_request(req, BLK_STS_OK);
+		return BLK_STS_OK;
+	}
 	iod-&gt;cmd.common.flags |= NVME_CMD_SGL_METABUF;
 	iod-&gt;req.port = queue-&gt;ctrl-&gt;port;
 	if (!nvmet_req_init(&amp;iod-&gt;req, &amp;queue-&gt;nvme_cq,
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index dfe3894205aa..3b4c7d2ee45d 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -391,6 +391,8 @@ struct nvmet_req {
 	struct device		*p2p_client;
 	u16			error_loc;
 	u64			error_slba;
+	struct range_entry *ranges;
+	unsigned int nr_range;
 };
 
 extern struct workqueue_struct *buffered_io_wq;
</pre>
    </blockquote>
  </body>
</html>

--------------vpt2AA06hN0gx55eaAKWEYTH--

--===============2286033874053230736==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============2286033874053230736==--

