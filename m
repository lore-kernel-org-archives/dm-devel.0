Return-Path: <SRS0=xkgx=EQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A9AC388F7
	for <dm-devel@archiver.kernel.org>; Tue, 10 Nov 2020 07:55:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2065920829
	for <dm-devel@archiver.kernel.org>; Tue, 10 Nov 2020 07:55:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2065920829
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-xwsfGSPlP16fg_l6S4W0rg-1; Tue, 10 Nov 2020 02:55:14 -0500
X-MC-Unique: xwsfGSPlP16fg_l6S4W0rg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A9CA100747C;
	Tue, 10 Nov 2020 07:55:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E03B45D9D2;
	Tue, 10 Nov 2020 07:55:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 643F9180B65D;
	Tue, 10 Nov 2020 07:55:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A98rqKC022028 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 9 Nov 2020 03:53:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4AA2A2156A4F; Mon,  9 Nov 2020 08:53:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C06E2156A39
	for <dm-devel@redhat.com>; Mon,  9 Nov 2020 08:53:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18AF28007DF
	for <dm-devel@redhat.com>; Mon,  9 Nov 2020 08:53:50 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-277-0aO_5dfMOYqSkynuiQc4yA-1;
	Mon, 09 Nov 2020 03:53:45 -0500
X-MC-Unique: 0aO_5dfMOYqSkynuiQc4yA-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id AB71E6736F; Mon,  9 Nov 2020 09:53:40 +0100 (CET)
Date: Mon, 9 Nov 2020 09:53:40 +0100
From: Christoph Hellwig <hch@lst.de>
To: Hannes Reinecke <hare@suse.de>
Message-ID: <20201109085340.GB27483@lst.de>
References: <20201106190337.1973127-1-hch@lst.de>
	<20201106190337.1973127-4-hch@lst.de>
	<1d06cdfa-a904-30be-f3ec-08ae2fa85cbd@suse.de>
MIME-Version: 1.0
In-Reply-To: <1d06cdfa-a904-30be-f3ec-08ae2fa85cbd@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
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
X-Mailman-Approved-At: Tue, 10 Nov 2020 02:55:04 -0500
Cc: Justin Sanders <justin@coraid.com>, Mike Snitzer <snitzer@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	xen-devel@lists.xenproject.org, Ilya Dryomov <idryomov@gmail.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
	linux-block@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>, drbd-dev@tron.linbit.com,
	ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-raid@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Minchan Kim <minchan@kernel.org>, linux-fsdevel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH 03/24] nvme: let
 set_capacity_revalidate_and_notify update the bdev size
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Mon, Nov 09, 2020 at 08:53:58AM +0100, Hannes Reinecke wrote:
>> index 376096bfc54a83..4e86c9aafd88a7 100644
>> --- a/drivers/nvme/host/core.c
>> +++ b/drivers/nvme/host/core.c
>> @@ -2053,7 +2053,7 @@ static void nvme_update_disk_info(struct gendisk *disk,
>>   			capacity = 0;
>>   	}
>>   -	set_capacity_revalidate_and_notify(disk, capacity, false);
>> +	set_capacity_revalidate_and_notify(disk, capacity, true);
>>     	nvme_config_discard(disk, ns);
>>   	nvme_config_write_zeroes(disk, ns);
>> @@ -2136,7 +2136,6 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_id_ns *id)
>>   		blk_stack_limits(&ns->head->disk->queue->limits,
>>   				 &ns->queue->limits, 0);
>>   		blk_queue_update_readahead(ns->head->disk->queue);
>> -		nvme_update_bdev_size(ns->head->disk);
>>   		blk_mq_unfreeze_queue(ns->head->disk->queue);
>>   	}
>>   #endif
>
> Hold on.
> This, at the very least, should be a separate patch.
> With this you are changing the behaviour of nvme multipath.
>
> Originally nvme multipath would update/change the size of the multipath 
> device according to the underlying path devices.
> With this patch the size of the multipath device will _not_ change if there 
> is a change on the underlying devices.

Yes, it will.  Take a close look at nvme_update_disk_info and how it is
called.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

