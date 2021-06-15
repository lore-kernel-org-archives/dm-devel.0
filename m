Return-Path: <SRS0=rgwX=LJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0150BC48BE5
	for <dm-devel@archiver.kernel.org>; Tue, 15 Jun 2021 17:11:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 973F56188B
	for <dm-devel@archiver.kernel.org>; Tue, 15 Jun 2021 17:11:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 973F56188B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1623777070;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=n9S50tyNdpanlkB4jBySbeGNszO3lES3XocK/ZS7ys0=;
	b=HejI1D6IIYs6Nq1UbcybZOa6sdX2Y2Jwf4HykKYCoabaXThvYj1MmunncwOehM0G3Kaho5
	tXLCczP4Xg8A+C+jmYJ0kUnoKMS8kUiosdm9TNgPjjYs8MKOyad6F+FVmh6BrnadO8n2Ix
	i1HWsMgBq00dxFJCyk+i9YsumayX9T8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-t0nTRn4ZMce_WZAM3rvlIQ-1; Tue, 15 Jun 2021 13:11:08 -0400
X-MC-Unique: t0nTRn4ZMce_WZAM3rvlIQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1F271850600;
	Tue, 15 Jun 2021 17:11:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DA16A5D9CA;
	Tue, 15 Jun 2021 17:11:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E22EA4A717;
	Tue, 15 Jun 2021 17:11:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15FHAwP3028579 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Jun 2021 13:10:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4911D21EC5CB; Tue, 15 Jun 2021 17:10:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4454A21EC5C4
	for <dm-devel@redhat.com>; Tue, 15 Jun 2021 17:10:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F37C800883
	for <dm-devel@redhat.com>; Tue, 15 Jun 2021 17:10:55 +0000 (UTC)
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com
	[209.85.160.181]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-239-NYpONAuSMSGQxhRKk0O_JA-1; Tue, 15 Jun 2021 13:10:53 -0400
X-MC-Unique: NYpONAuSMSGQxhRKk0O_JA-1
Received: by mail-qt1-f181.google.com with SMTP id a15so11761438qtx.13;
	Tue, 15 Jun 2021 10:10:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=XOndezn7TQBTma5ivSk1iPTUGdSJkv/aNqYrkqV3kxQ=;
	b=DfyM/LMEoSZ8vkvROmSkJtiTfXUAMt29GAs2hcS2/53sgFonX/N/tfMrpLqI0IRKM3
	3+MVa2YJMEznWLDC88NqQ67o4CRTaCeHrNMfBWtdGQPMVoAKxxKxTCf34gAKM3/fojtU
	KviBdQVudoO/EjcR72S7dvfWhfbHj5A5W6GT9WflnzZJm+LTG6DodXdwU6ex8JXLE08n
	OnooUIVNXlMxOiiQgl50zpOzP1jV+fqV7lrsCQcaJ4781HJ98lCxf/b7x6+6lXw8l5hP
	/L5jq4BDgllqmINW+JgAPUOtqZrNNS+JLxfPpqvXJjWJdA3cWtLTcgYTZiKiCsMNArfk
	tqAA==
X-Gm-Message-State: AOAM532n/qpU2NtDpZRk6nBB7lGtqbPpzY7uCndhKYtrfwnI4+D319iM
	QxIcD3JL/cGjvNOCMV7rpJQ=
X-Google-Smtp-Source: ABdhPJxpP3AZyscKz83ej7vAoqFQXtCu7dUHKDdrqJykfdOQM1q88/h9tvKkZsSNgCcqQKq19AG3Vw==
X-Received: by 2002:ac8:57cf:: with SMTP id w15mr643442qta.145.1623777052270; 
	Tue, 15 Jun 2021 10:10:52 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	w195sm4966891qkb.127.2021.06.15.10.10.51
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 15 Jun 2021 10:10:51 -0700 (PDT)
Date: Tue, 15 Jun 2021 13:10:50 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: mwilck@suse.com
Message-ID: <YMjfGh9hJjLkol9V@redhat.com>
References: <20210611202509.5426-1-mwilck@suse.com>
	<20210611202509.5426-3-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210611202509.5426-3-mwilck@suse.com>
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
Cc: linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Bart Van Assche <Bart.VanAssche@sandisk.com>,
	Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v3 2/2] dm: add CONFIG_DM_MULTIPATH_SG_IO -
 failover for SG_IO on dm-multipath
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jun 11 2021 at  4:25P -0400,
mwilck@suse.com <mwilck@suse.com> wrote:

> From: Martin Wilck <mwilck@suse.com>
> 
> In virtual deployments, SCSI passthrough over dm-multipath devices is a
> common setup. The qemu "pr-helper" was specifically invented for it. I
> believe that this is the most important real-world scenario for sending
> SG_IO ioctls to device-mapper devices.
> 
> In this configuration, guests send SCSI IO to the hypervisor in the form of
> SG_IO ioctls issued by qemu. But on the device-mapper level, these SCSI
> ioctls aren't treated like regular IO. Until commit 2361ae595352 ("dm mpath:
> switch paths in dm_blk_ioctl() code path"), no path switching was done at
> all. Worse though, if an SG_IO call fails because of a path error,
> dm-multipath doesn't retry the IO on a another path; rather, the failure is
> passed back to the guest, and paths are not marked as faulty.  This is in
> stark contrast with regular block IO of guests on dm-multipath devices, and
> certainly comes as a surprise to users who switch to SCSI passthrough in
> qemu. In general, users of dm-multipath devices would probably expect failover
> to work at least in a basic way.
> 
> This patch fixes this by taking a special code path for SG_IO on request-
> based device mapper targets if CONFIG_DM_MULTIPATH_SG_IO is set.  Rather then
> just choosing a single path, sending the IO to it, and failing to the caller
> if the IO on the path failed, it retries the same IO on another path for
> certain error codes, using blk_path_error() to determine if a retry would
> make sense for the given error code. Moreover, it sends a message to the
> multipath target to mark the path as failed.
> 
> One problem remains open: if all paths in a multipath map are failed,
> normal multipath IO may switch to queueing mode (depending on
> configuration). This isn't possible for SG_IO, as SG_IO requests can't
> easily be queued like regular block I/O. Thus in the "no path" case, the
> guest will still see an error.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  block/scsi_ioctl.c         |   5 +-
>  drivers/md/Kconfig         |  11 ++++
>  drivers/md/Makefile        |   4 ++
>  drivers/md/dm-core.h       |   5 ++
>  drivers/md/dm-rq.h         |  11 ++++
>  drivers/md/dm-scsi_ioctl.c | 127 +++++++++++++++++++++++++++++++++++++
>  drivers/md/dm.c            |  20 +++++-
>  include/linux/blkdev.h     |   2 +
>  8 files changed, 180 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/md/dm-scsi_ioctl.c
> 
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index b39e0835600f..38771f4bcf18 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -279,8 +279,8 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
>  	return ret;
>  }
>  
> -static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
> -		struct sg_io_hdr *hdr, fmode_t mode)
> +int sg_io(struct request_queue *q, struct gendisk *bd_disk,
> +	  struct sg_io_hdr *hdr, fmode_t mode)
>  {
>  	unsigned long start_time;
>  	ssize_t ret = 0;
> @@ -365,6 +365,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
>  	blk_put_request(rq);
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(sg_io);
>  
>  /**
>   * sg_scsi_ioctl  --  handle deprecated SCSI_IOCTL_SEND_COMMAND ioctl
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index f2014385d48b..f28f29e3bd11 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -473,6 +473,17 @@ config DM_MULTIPATH_IOA
>  
>  	  If unsure, say N.
>  
> +config DM_MULTIPATH_SG_IO
> +       bool "Retry SCSI generic I/O on multipath devices"
> +       depends on DM_MULTIPATH && BLK_SCSI_REQUEST
> +       help
> +	 With this option, SCSI generic (SG) requests issued on multipath
> +	 devices will behave similar to regular block I/O: upon failure,
> +	 they are repeated on a different path, and the erroring device
> +	 is marked as failed.
> +
> +	 If unsure, say N.
> +

Given how this is all about multipath, there is no reason to bolt this
on to DM core and then play games to issuing multipath target specific
DM message ("fail_path") from generic code.

So the SG_IO ioctl handling code should be in dm-mpath.c and the DM
target interface extended as needed.

>  config DM_DELAY
>  	tristate "I/O delaying target"
>  	depends on BLK_DEV_DM
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index ef7ddc27685c..187ea469f64a 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -88,6 +88,10 @@ ifeq ($(CONFIG_DM_INIT),y)
>  dm-mod-objs			+= dm-init.o
>  endif
>  
> +ifeq ($(CONFIG_DM_MULTIPATH_SG_IO),y)
> +dm-mod-objs			+= dm-scsi_ioctl.o
> +endif
> +
>  ifeq ($(CONFIG_DM_UEVENT),y)
>  dm-mod-objs			+= dm-uevent.o
>  endif
> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> index 5953ff2bd260..8bd8a8e3916e 100644
> --- a/drivers/md/dm-core.h
> +++ b/drivers/md/dm-core.h
> @@ -189,4 +189,9 @@ extern atomic_t dm_global_event_nr;
>  extern wait_queue_head_t dm_global_eventq;
>  void dm_issue_global_event(void);
>  
> +int __dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
> +		       struct block_device **bdev,
> +		       struct dm_target **target);
> +void dm_unprepare_ioctl(struct mapped_device *md, int srcu_idx);
> +
>  #endif
> diff --git a/drivers/md/dm-rq.h b/drivers/md/dm-rq.h
> index 1eea0da641db..c6d2853e4d1d 100644
> --- a/drivers/md/dm-rq.h
> +++ b/drivers/md/dm-rq.h
> @@ -44,4 +44,15 @@ ssize_t dm_attr_rq_based_seq_io_merge_deadline_show(struct mapped_device *md, ch
>  ssize_t dm_attr_rq_based_seq_io_merge_deadline_store(struct mapped_device *md,
>  						     const char *buf, size_t count);
>  
> +#ifdef CONFIG_DM_MULTIPATH_SG_IO
> +int dm_sg_io_ioctl(struct block_device *bdev, fmode_t mode,
> +		   unsigned int cmd, unsigned long uarg);
> +#else
> +static inline int dm_sg_io_ioctl(struct block_device *bdev, fmode_t mode,
> +				 unsigned int cmd, unsigned long uarg)
> +{
> +	return -ENOTTY;
> +}
> +#endif
> +
>  #endif

There is no reason, that I can see, why bio-based dm-multipath
shouldn't handle SG_IO too.  Why did you constrain it to
request-based?


> diff --git a/drivers/md/dm-scsi_ioctl.c b/drivers/md/dm-scsi_ioctl.c
> new file mode 100644
> index 000000000000..a696e2a6557e
> --- /dev/null
> +++ b/drivers/md/dm-scsi_ioctl.c
> @@ -0,0 +1,127 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2021 Martin Wilck, SUSE LLC
> + */
> +
> +#include "dm-core.h"
> +#include <linux/types.h>
> +#include <linux/errno.h>
> +#include <linux/kernel.h>
> +#include <linux/uaccess.h>
> +#include <linux/blk_types.h>
> +#include <linux/blkdev.h>
> +#include <linux/device-mapper.h>
> +#include <scsi/sg.h>
> +#include <scsi/scsi_cmnd.h>
> +
> +#define DM_MSG_PREFIX "sg_io"
> +
> +int dm_sg_io_ioctl(struct block_device *bdev, fmode_t mode,
> +		   unsigned int cmd, unsigned long uarg)
> +{
> +	struct mapped_device *md = bdev->bd_disk->private_data;
> +	struct sg_io_hdr hdr;
> +	void __user *arg = (void __user *)uarg;
> +	int rc, srcu_idx;
> +	char path_name[BDEVNAME_SIZE];
> +
> +	if (cmd != SG_IO)
> +		return -ENOTTY;
> +
> +	if (copy_from_user(&hdr, arg, sizeof(hdr)))
> +		return -EFAULT;
> +
> +	if (hdr.interface_id != 'S')
> +		return -EINVAL;
> +
> +	if (hdr.dxfer_len > (queue_max_hw_sectors(bdev->bd_disk->queue) << 9))
> +		return -EIO;
> +
> +	for (;;) {
> +		struct dm_target *tgt;
> +		struct sg_io_hdr rhdr;
> +
> +		rc = __dm_prepare_ioctl(md, &srcu_idx, &bdev, &tgt);
> +		if (rc < 0) {
> +			DMERR("%s: failed to get path: %d",
> +			      __func__, rc);
> +			goto out;
> +		}
> +
> +		rhdr = hdr;
> +
> +		rc = sg_io(bdev->bd_disk->queue, bdev->bd_disk, &rhdr, mode);
> +
> +		DMDEBUG("SG_IO via %s: rc = %d D%02xH%02xM%02xS%02x",
> +			bdevname(bdev, path_name), rc,
> +			rhdr.driver_status, rhdr.host_status,
> +			rhdr.msg_status, rhdr.status);
> +
> +		/*
> +		 * Errors resulting from invalid parameters shouldn't be retried
> +		 * on another path.
> +		 */
> +		switch (rc) {
> +		case -ENOIOCTLCMD:
> +		case -EFAULT:
> +		case -EINVAL:
> +		case -EPERM:
> +			goto out;
> +		default:
> +			break;
> +		}
> +
> +		if (rhdr.info & SG_INFO_CHECK) {
> +			int result;
> +			blk_status_t sts;
> +
> +			result = rhdr.status |
> +				(rhdr.msg_status << 8) |
> +				(rhdr.host_status << 16) |
> +				(rhdr.driver_status << 24);
> +
> +			sts = __scsi_result_to_blk_status(&result, result);
> +			rhdr.host_status = host_byte(result);

It is the open-coded SCSI specific sg_io_hdr and result work that
feels like it doesn't belong open-coded in DM.  So maybe the above
code from this SG_INFO_CHECK block could go into an
block/scsi_ioctl.c:sg_io_info_check() method?

> +
> +			/* See if this is a target or path error. */
> +			if (sts == BLK_STS_OK)
> +				rc = 0;
> +			else if (blk_path_error(sts))
> +				rc = -EIO;
> +			else {
> +				rc = blk_status_to_errno(sts);
> +				goto out;
> +			}
> +		}
> +
> +		if (rc == 0) {
> +			/* success */
> +			if (copy_to_user(arg, &rhdr, sizeof(rhdr)))
> +				rc = -EFAULT;
> +			goto out;
> +		}
> +
> +		/* Failure - fail path by sending a message to the target */
> +		if (!tgt->type->message) {
> +			DMWARN("invalid target!");
> +			rc = -EIO;
> +			goto out;
> +		} else {
> +			char bdbuf[BDEVT_SIZE];
> +			char *argv[2] = { "fail_path", bdbuf };
> +
> +			scnprintf(bdbuf, sizeof(bdbuf), "%u:%u",
> +				  MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
> +
> +			DMDEBUG("sending \"%s %s\" to target", argv[0], argv[1]);
> +			rc = tgt->type->message(tgt, 2, argv, NULL, 0);
> +			if (rc < 0)
> +				goto out;
> +		}

If you factor things how I suggest below (introducing
dm-mpath.c:dm_mpath_ioctl) then you'll have direct access to
dm-mpath.c:fail_path() so need need to mess around with constructing
DM messages from kernel code.

> +
> +		dm_unprepare_ioctl(md, srcu_idx);
> +	}
> +out:
> +	dm_unprepare_ioctl(md, srcu_idx);
> +	return rc;
> +}
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index ca2aedd8ee7d..29b93fb3929e 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -522,8 +522,9 @@ static int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
>  #define dm_blk_report_zones		NULL
>  #endif /* CONFIG_BLK_DEV_ZONED */
>  
> -static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
> -			    struct block_device **bdev)
> +int __dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
> +		       struct block_device **bdev,
> +		       struct dm_target **target)
>  {
>  	struct dm_target *tgt;
>  	struct dm_table *map;
> @@ -553,10 +554,19 @@ static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
>  		goto retry;
>  	}
>  
> +	if (r >= 0 && target)
> +		*target = tgt;
> +
>  	return r;
>  }

For dm-multipath you can leverage md->immutable_target always being
multipath.

So after dm_blk_ioctl's dm_prepare_ioctl: 

if (cmd == SG_IO && md->immutable_target &&
    md->immutable_target->ioctl)
    r = md->immutable_target->ioctl(bdev, mode, cmd, arg);

(doing check for SG_IO here just avoids needless call into ->ioctl for
now, but it could be other ioctls will need specialization in future
so checking 'cmd' should be pushed down to md->immutable_target->ioctl
at that time?)

But I'm not following you use of a for (;;) in dm_sg_io_ioctl() --
other than to retry infinitely (you aren't checking for no paths!?,
etc).

Anyway, best to have md->immutable_target->ioctl return
-EAGAIN and goto top of dm_blk_ioctl as needed?

>  
> -static void dm_unprepare_ioctl(struct mapped_device *md, int srcu_idx)
> +static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
> +			    struct block_device **bdev)
> +{
> +	return __dm_prepare_ioctl(md, srcu_idx, bdev, NULL);
> +}
> +
> +void dm_unprepare_ioctl(struct mapped_device *md, int srcu_idx)
>  {
>  	dm_put_live_table(md, srcu_idx);
>  }
> @@ -567,6 +577,10 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
>  	struct mapped_device *md = bdev->bd_disk->private_data;
>  	int r, srcu_idx;
>  
> +	if ((dm_get_md_type(md) == DM_TYPE_REQUEST_BASED) &&
> +	    ((r = dm_sg_io_ioctl(bdev, mode, cmd, arg)) != -ENOTTY))
> +		return r;
> +

Again, bio-based multipath should work fine with SG_IO too.

>  	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
>  	if (r < 0)
>  		goto out;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 48497a77428d..b8f1d603cc7a 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -923,6 +923,8 @@ extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,
>  			  unsigned int, void __user *);
>  extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
>  			 struct scsi_ioctl_command __user *);
> +extern int sg_io(struct request_queue *, struct gendisk *,
> +		 struct sg_io_hdr *, fmode_t);
>  extern int get_sg_io_hdr(struct sg_io_hdr *hdr, const void __user *argp);
>  extern int put_sg_io_hdr(const struct sg_io_hdr *hdr, void __user *argp);
>  
> -- 
> 2.31.1
> 

Think adding block/scsi_ioctl.c:sg_io_info_check() and exporting it
and sg_io() via blkdev.h should be done as a separate patch 2.

Then patch 3 is purely DM changes to use sg_io() and
sg_io_info_check()

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

