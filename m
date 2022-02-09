Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1488BC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  9 Feb 2022 09:28:02 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-cl64iOfQPI6OREdqbXSCxQ-1; Wed, 09 Feb 2022 04:27:58 -0500
X-MC-Unique: cl64iOfQPI6OREdqbXSCxQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63DE41091DA0;
	Wed,  9 Feb 2022 09:27:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FA4829990;
	Wed,  9 Feb 2022 09:27:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 247A94BB7C;
	Wed,  9 Feb 2022 09:27:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2199RpfJ024048 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Feb 2022 04:27:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0AAA140ED413; Wed,  9 Feb 2022 09:27:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 06CF4400E13A
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 09:27:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E23C418ABF8A
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 09:27:50 +0000 (UTC)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-5-J91045LwNTCOw-XlUcZG0w-1; Wed, 09 Feb 2022 04:27:48 -0500
X-MC-Unique: J91045LwNTCOw-XlUcZG0w-1
To: Jinpu Wang <jinpu.wang@ionos.com>
References: <20220209082828.2629273-1-hch@lst.de>
	<20220209082828.2629273-4-hch@lst.de>
	<4f1565b2-0f83-0cfa-58bd-86d5dee48e51@linux.dev>
	<CAMGffE=FmVj26PJtu5fwtr3rNbtE+-dcfxOrmT4hEt3sO7Kw2A@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
	include these headers.
From: Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <0b8c9d4d-0fb0-1aee-97b2-f4381e124df2@linux.dev>
Date: Wed, 9 Feb 2022 17:21:39 +0800
MIME-Version: 1.0
In-Reply-To: <CAMGffE=FmVj26PJtu5fwtr3rNbtE+-dcfxOrmT4hEt3sO7Kw2A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, manoj@linux.ibm.com, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com, philipp.reisner@linbit.com,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	target-devel@vger.kernel.org, haris.iqbal@ionos.com,
	ukrishn@linux.ibm.com, lars.ellenberg@linbit.com,
	drbd-dev@lists.linbit.com, Christoph Hellwig <hch@lst.de>,
	mrochs@linux.ibm.com
Subject: Re: [dm-devel] [PATCH 3/7] rnbd: drop WRITE_SAME support
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2/9/22 5:13 PM, Jinpu Wang wrote:
>>> --- a/drivers/block/rnbd/rnbd-srv.c
>>> +++ b/drivers/block/rnbd/rnbd-srv.c
>>> @@ -548,8 +548,7 @@ static void rnbd_srv_fill_msg_open_rsp(struct rnbd_msg_open_rsp *rsp,
>>>                cpu_to_le16(rnbd_dev_get_max_segs(rnbd_dev));
>>>        rsp->max_hw_sectors =
>>>                cpu_to_le32(rnbd_dev_get_max_hw_sects(rnbd_dev));
>>> -     rsp->max_write_same_sectors =
>>> -             cpu_to_le32(bdev_write_same(rnbd_dev->bdev));
>>> +     rsp->max_write_same_sectors = 0;
>> IIUC, I think we can delete max_write_same_sectors from rsp as well given
>> the earlier change in setup_request_queue and rnbd_clt_set_dev_attr.
> No, I don't think it's a good idea, we need to keep the protocol
> compatible, so client for old kernel version
> won't be confused.

Fair enough. Then I guess it is better to add obsolete_ prefix like 
obsolete_rotational.

Thanks,
Guoqing

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

