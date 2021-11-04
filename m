Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98418C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 13:18:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2EBB6610FD
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 13:18:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2EBB6610FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=opensource.wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-DeEb0UXwPd-9w5IMbLi_ug-1; Fri, 05 Nov 2021 09:18:20 -0400
X-MC-Unique: DeEb0UXwPd-9w5IMbLi_ug-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CAAF18A0734;
	Fri,  5 Nov 2021 13:18:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 10ED3100239F;
	Fri,  5 Nov 2021 13:18:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D707B4EA2F;
	Fri,  5 Nov 2021 13:18:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4CYJt5004325 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 08:34:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AA1692166B26; Thu,  4 Nov 2021 12:34:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A3F632166B25
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 12:34:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F3E8899EC3
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 12:34:16 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-364-wgvqclfePgqRtbD340bNkA-2; Thu, 04 Nov 2021 08:34:15 -0400
X-MC-Unique: wgvqclfePgqRtbD340bNkA-2
X-IronPort-AV: E=Sophos;i="5.87,208,1631548800"; d="scan'208";a="189493701"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 04 Nov 2021 20:33:08 +0800
IronPort-SDR: dmhnRkl9ubN5OtKbX0+5iWlM17PCgbmqjbdG7uKdPCkpR0o8NxylqHF8pPMhc7upjr2Sf/U3g/
	w3RnYIrlVag2ZK37JzqkW8Vko0LjVrCmW+B++tonJ870ugIkJYM4O81fC8r6EGoZ88NLWjU7wI
	ZsJ66djn40YtG8wIqW77Nj0NwOPk4yjrtnRcwXK9ZxwK+PWjNK+67wkKC6GMXa3+8RWjcJVaJ8
	TEn8yPTvss1BQoc+iOtTZIBO4sdThs1RvkeM6GXpY3ATob+mSydx+2CeRsnqFwv369dtXg7nPT
	FnUp4tFsdTFufHTKomJhxJg/
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	04 Nov 2021 05:08:27 -0700
IronPort-SDR: K3a7oRnmuf1tN3WAHYy2WqsdLU261ZpacoeEOS0+n/tpLxI5DBowlABX1bVjEWiC52iYJJK+Nk
	ujLOdFlbDnBSbBo51u8EprmGjcXWRiAdN6H9CN+DNxNFP0Nhq/GYVdM8e7fQw7dv8bRHT00VaC
	La6Jtcg+bsaSYNR+p6CtoFPTHXWjZHO3+Olvvw3VQg0/NmSsIKiSJiyV0uB3lqYITePDuRFuJG
	0YLc3tv/mJwa4hu3S2GG6+ZRmRB/hlD3sAkkBitQ00Z8wydIoMeWgvjQRelCY531RMlzYZ0AIs
	MuE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
	by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	04 Nov 2021 05:33:09 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HlNMm72vhz1RtVx
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 05:33:08 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
	by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	(amavisd-new, port 10026)
	with ESMTP id trtzx6nmejvD for <dm-devel@redhat.com>;
	Thu,  4 Nov 2021 05:33:07 -0700 (PDT)
Received: from [10.225.54.48] (unknown [10.225.54.48])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HlNMd5TBrz1RtVl;
	Thu,  4 Nov 2021 05:33:01 -0700 (PDT)
Message-ID: <bd36ee58-8273-cd0a-295e-0c66b0142bcd@opensource.wdc.com>
Date: Thu, 4 Nov 2021 21:33:00 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
	Gecko/20100101 Thunderbird/91.2.1
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	dm-devel@redhat.com
References: <20211104064634.4481-1-chaitanyak@nvidia.com>
	<20211104064634.4481-3-chaitanyak@nvidia.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211104064634.4481-3-chaitanyak@nvidia.com>
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
Subject: Re: [dm-devel] [RFC PATCH 2/8] scsi: add REQ_OP_VERIFY support
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/11/04 15:46, Chaitanya Kulkarni wrote:
> From: Chaitanya Kulkarni <kch@nvidia.com>
> 
> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>  drivers/scsi/sd.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/sd.h |  1 +
>  2 files changed, 53 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index a3d2d4bc4a3d..7f2c4eb98cf8 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -106,6 +106,7 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
>  
>  static void sd_config_discard(struct scsi_disk *, unsigned int);
>  static void sd_config_write_same(struct scsi_disk *);
> +static void sd_config_verify(struct scsi_disk *sdkp);
>  static int  sd_revalidate_disk(struct gendisk *);
>  static void sd_unlock_native_capacity(struct gendisk *disk);
>  static int  sd_probe(struct device *);
> @@ -995,6 +996,41 @@ static blk_status_t sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
>  	return sd_setup_write_same10_cmnd(cmd, false);
>  }
>  
> +static void sd_config_verify(struct scsi_disk *sdkp)
> +{
> +	struct request_queue *q = sdkp->disk->queue;
> +
> +	/* XXX: use same pattern as sd_config_write_same(). */
> +	blk_queue_max_verify_sectors(q, UINT_MAX >> 9);

VERIFY 10, 12, 16 and 32 commands are optional and may not be implemented by a
device. So setting this unconditionally is wrong.
At the very least you must have an "if (sdkp->verify_16)" here, and call
"blk_queue_max_verify_sectors(q, 0);" if the device does not support verify.

> +}
> +
> +static blk_status_t sd_setup_verify_cmnd(struct scsi_cmnd *cmd)
> +{
> +       struct request *rq = cmd->request;
> +       struct scsi_device *sdp = cmd->device;
> +       struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
> +       u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
> +       u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
> +
> +       if (!sdkp->verify_16)
> +	       return BLK_STS_NOTSUPP;

I think this should be "return BLK_STS_TARGET;"

> +
> +       cmd->cmd_len = 16;
> +       cmd->cmnd[0] = VERIFY_16;

And what if the device supports VERIFY 10 or 12 but not VERIFY 16 ?

> +       /* skip veprotect / dpo / bytchk */
> +       cmd->cmnd[1] = 0;
> +       put_unaligned_be64(lba, &cmd->cmnd[2]);
> +       put_unaligned_be32(nr_blocks, &cmd->cmnd[10]);
> +       cmd->cmnd[14] = 0;
> +       cmd->cmnd[15] = 0;
> +
> +       cmd->allowed = SD_MAX_RETRIES;
> +       cmd->sc_data_direction = DMA_NONE;
> +       cmd->transfersize = 0;
> +
> +       return BLK_STS_OK;
> +}
> +
>  static void sd_config_write_same(struct scsi_disk *sdkp)
>  {
>  	struct request_queue *q = sdkp->disk->queue;
> @@ -1345,6 +1381,8 @@ static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
>  		}
>  	case REQ_OP_WRITE_ZEROES:
>  		return sd_setup_write_zeroes_cmnd(cmd);
> +	case REQ_OP_VERIFY:
> +		return sd_setup_verify_cmnd(cmd);
>  	case REQ_OP_WRITE_SAME:
>  		return sd_setup_write_same_cmnd(cmd);
>  	case REQ_OP_FLUSH:
> @@ -2029,6 +2067,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
>  	switch (req_op(req)) {
>  	case REQ_OP_DISCARD:
>  	case REQ_OP_WRITE_ZEROES:
> +	case REQ_OP_VERIFY:
>  	case REQ_OP_WRITE_SAME:
>  	case REQ_OP_ZONE_RESET:
>  	case REQ_OP_ZONE_RESET_ALL:
> @@ -3096,6 +3135,17 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
>  		sdkp->ws10 = 1;
>  }
>  
> +static void sd_read_verify(struct scsi_disk *sdkp, unsigned char *buffer)
> +{
> +       struct scsi_device *sdev = sdkp->device;
> +
> +       sd_printk(KERN_INFO, sdkp, "VERIFY16 check.\n");

Remove this message please.

> +       if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, VERIFY_16) == 1) {
> +	       sd_printk(KERN_INFO, sdkp, " VERIFY16 in ON .\n");

And this one too.

> +               sdkp->verify_16 = 1;

Why not checking for VERIFY 10 and 12 if VERIFY 16 is not supported ?
Also, why don't you call "blk_queue_max_verify_sectors(q, UINT_MAX >> 9);" here
instead of adding the not so useful sd_config_verify() helper ?

> +       }
> +}
> +
>  static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
>  {
>  	struct scsi_device *sdev = sdkp->device;
> @@ -3224,6 +3274,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  		sd_read_cache_type(sdkp, buffer);
>  		sd_read_app_tag_own(sdkp, buffer);
>  		sd_read_write_same(sdkp, buffer);
> +		sd_read_verify(sdkp, buffer);
>  		sd_read_security(sdkp, buffer);
>  	}
>  
> @@ -3265,6 +3316,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  
>  	set_capacity_and_notify(disk, logical_to_sectors(sdp, sdkp->capacity));
>  	sd_config_write_same(sdkp);
> +	sd_config_verify(sdkp);
>  	kfree(buffer);
>  
>  	/*
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index b59136c4125b..94a86bf6dac4 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -120,6 +120,7 @@ struct scsi_disk {
>  	unsigned	lbpvpd : 1;
>  	unsigned	ws10 : 1;
>  	unsigned	ws16 : 1;
> +	unsigned        verify_16 : 1;

See right above this line how write same supports the 10 and 16 variants. I
think you need the same here. And very likely, you also need the 32 version in
case the device has DIF/DIX (type 2 protection).

>  	unsigned	rc_basis: 2;
>  	unsigned	zoned: 2;
>  	unsigned	urswrz : 1;
> 


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

