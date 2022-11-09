Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AC9AC433FE
	for <dm-devel@archiver.kernel.org>; Wed,  9 Nov 2022 08:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667982418;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Tkw+antgZspoiXHzG9U3LnUPJWGLP2/jBQBJXJiA1jY=;
	b=GKmt77Dv3AePR+Y+LvUFOSfKjcF7bD0Xjrt+y4W5cjTZNxcHTuYnlrq7mZjKoEuNpw3ztm
	BwqvssCcosexKv2oTD00uAkwFLEm+Pks8x7p1wuIFQRW8MD+Di2lHl98ksTZke4YKYgM5u
	wLkDHfAmwYnPzBYLshUwGCxRvK/F+0A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-8HIOuDEgOLubvCPXq9OHzA-1; Wed, 09 Nov 2022 03:26:55 -0500
X-MC-Unique: 8HIOuDEgOLubvCPXq9OHzA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B95AD1C09043;
	Wed,  9 Nov 2022 08:26:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BCF68C1912A;
	Wed,  9 Nov 2022 08:26:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8F4E2194658F;
	Wed,  9 Nov 2022 08:26:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E8DE21946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  9 Nov 2022 08:26:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C96B12166B2E; Wed,  9 Nov 2022 08:26:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C1DC52166B29
 for <dm-devel@redhat.com>; Wed,  9 Nov 2022 08:26:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A860B1C09048
 for <dm-devel@redhat.com>; Wed,  9 Nov 2022 08:26:51 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-283-yYjshkc4MWChqkrLHK6l0w-1; Wed, 09 Nov 2022 03:26:49 -0500
X-MC-Unique: yYjshkc4MWChqkrLHK6l0w-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 5473D68AFE; Wed,  9 Nov 2022 09:26:45 +0100 (CET)
Date: Wed, 9 Nov 2022 09:26:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <20221109082645.GA14093@lst.de>
References: <20221030153120.1045101-1-hch@lst.de>
 <20221030153120.1045101-6-hch@lst.de>
 <9b5b4c2a-6566-2fb4-d3ae-4904f0889ea0@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <9b5b4c2a-6566-2fb4-d3ae-4904f0889ea0@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 5/7] dm: track per-add_disk holder relations
 in DM
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 "yukuai \(C\)" <yukuai3@huawei.com>, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 09, 2022 at 10:08:14AM +0800, Yu Kuai wrote:
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index 2917700b1e15c..7b0d6dc957549 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -751,9 +751,16 @@ static struct table_device *open_table_device(struct mapped_device *md,
>>   		goto out_free_td;
>>   	}
>>   -	r = bd_link_disk_holder(bdev, dm_disk(md));
>> -	if (r)
>> -		goto out_blkdev_put;
>> +	/*
>> +	 * We can be called before the dm disk is added.  In that case we can't
>> +	 * register the holder relation here.  It will be done once add_disk was
>> +	 * called.
>> +	 */
>> +	if (md->disk->slave_dir) {
> If device_add_disk() or del_gendisk() can concurrent with this, It seems
> to me that using 'slave_dir' is not safe.
>
> I'm not quite familiar with dm, can we guarantee that they can't
> concurrent?

I assumed dm would not get itself into territory were creating /
deleting the device could race with adding component devices, but
digging deeper I can't find anything.  This could be done
by holding table_devices_lock around add_disk/del_gendisk, but
I'm not that familar with the dm code.

Mike, can you help out on this?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

