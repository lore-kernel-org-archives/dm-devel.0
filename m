Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC3FEC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 16 Feb 2022 13:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1645018390;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cc83lCXl7OhMem9d0jTXkKxyWeUAH2Gq0SLAJs+0Bss=;
	b=S4TDPx6Oxvebao7dVihOMpxj6pKYHvEU1eznvA7VqTW+/8aiFxp0cgFQ09OMG4uDVTAAtc
	69Wv3DGB0NlQAGw8XoUzObHe8uQJADDgMSknwlv0XKfCRw/fnWuxo+acS2vqx8M0eKnc9a
	9Hw0YamTZRrFJaWi4DdnIG/FHG2Vo2U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-486-KsEojVZtNLCkUpen3u3LTQ-1; Wed, 16 Feb 2022 08:33:06 -0500
X-MC-Unique: KsEojVZtNLCkUpen3u3LTQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C36DE1091DA1;
	Wed, 16 Feb 2022 13:33:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CED912AA93;
	Wed, 16 Feb 2022 13:32:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AC60A4BB7C;
	Wed, 16 Feb 2022 13:32:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21GDWonp030315 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Feb 2022 08:32:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DB9682AA9C; Wed, 16 Feb 2022 13:32:50 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DFDB32AA93;
	Wed, 16 Feb 2022 13:32:47 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 21GDWli7022921; Wed, 16 Feb 2022 08:32:47 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 21GDWjiY022917; Wed, 16 Feb 2022 08:32:46 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Wed, 16 Feb 2022 08:32:45 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Nitesh Shetty <nj.shetty@samsung.com>
In-Reply-To: <20220207141348.4235-6-nj.shetty@samsung.com>
Message-ID: <alpine.LRH.2.02.2202160830150.22021@file01.intranet.prod.int.rdu2.redhat.com>
References: <CAOSviJ0HmT9iwdHdNtuZ8vHETCosRMpR33NcYGVWOV0ki3EYgw@mail.gmail.com>
	<20220207141348.4235-1-nj.shetty@samsung.com>
	<CGME20220207141930epcas5p2bcbff65f78ad1dede64648d73ddb3770@epcas5p2.samsung.com>
	<20220207141348.4235-6-nj.shetty@samsung.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
	dm-devel@redhat.com, osandov@fb.com, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org, hch@lst.de,
	roland@purestorage.com, zach.brown@ni.com, chaitanyak@nvidia.com,
	msnitzer@redhat.com, josef@toxicpanda.com,
	linux-block@vger.kernel.org, dsterba@suse.com, kbusch@kernel.org,
	Frederick.Knight@netapp.com, axboe@kernel.dk, tytso@mit.edu,
	joshi.k@samsung.com, martin.petersen@oracle.com,
	arnav.dawn@samsung.com, jack@suse.com,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
Subject: Re: [dm-devel] [PATCH v2 05/10] block: add emulation for copy
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Mon, 7 Feb 2022, Nitesh Shetty wrote:

> +				goto retry;
> +			return PTR_ERR(bio);
> +		}
> +
> +		bio->bi_iter.bi_sector = sector >> SECTOR_SHIFT;
> +		bio->bi_opf = op;
> +		bio_set_dev(bio, bdev);
> @@ -346,6 +463,8 @@ int blkdev_issue_copy(struct block_device *src_bdev, int nr,
>  
>  	if (blk_check_copy_offload(src_q, dest_q))
>  		ret = blk_copy_offload(src_bdev, nr, rlist, dest_bdev, gfp_mask);
> +	else
> +		ret = blk_copy_emulate(src_bdev, nr, rlist, dest_bdev, gfp_mask);
>  
>  	return ret;
>  }

The emulation is not reliable because a device mapper device may be 
reconfigured and it may lose the copy capability between the calls to 
blk_check_copy_offload and blk_copy_offload.

You should call blk_copy_emulate if blk_copy_offload returns an error.

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

