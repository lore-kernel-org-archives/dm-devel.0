Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 410A7C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 02:04:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BE68B61549
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 02:04:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BE68B61549
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-U9GLzF-PNpSOK2F1Glkscw-1; Wed, 17 Nov 2021 21:04:28 -0500
X-MC-Unique: U9GLzF-PNpSOK2F1Glkscw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 131E215729;
	Thu, 18 Nov 2021 02:04:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 645765BB06;
	Thu, 18 Nov 2021 02:04:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 931DB180BAD2;
	Thu, 18 Nov 2021 02:04:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AI24Ibb015486 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 21:04:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 75CC52026D60; Thu, 18 Nov 2021 02:04:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 714592026D48
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 02:04:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 546B9811E76
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 02:04:15 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com
	[45.249.212.189]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-215-C998eemkNhaF0FmQdikPHw-1; Wed, 17 Nov 2021 21:04:13 -0500
X-MC-Unique: C998eemkNhaF0FmQdikPHw-1
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HvjjY3gcVz8vMR;
	Thu, 18 Nov 2021 10:02:25 +0800 (CST)
Received: from kwepemm600010.china.huawei.com (7.193.23.86) by
	dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Thu, 18 Nov 2021 10:04:09 +0800
Received: from [10.174.179.176] (10.174.179.176) by
	kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.15; Thu, 18 Nov 2021 10:04:09 +0800
To: Benjamin Marzinski <bmarzins@redhat.com>
References: <78637f61-851d-cf9d-d308-9c22396d2071@huawei.com>
	<7a7efb76-ae21-0630-aab5-52d6b06d93ef@huawei.com>
	<20211117180517.GX19591@octiron.msp.redhat.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <7ea1655a-dac5-68f8-9fd8-f44b5b19d233@huawei.com>
Date: Thu, 18 Nov 2021 10:04:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211117180517.GX19591@octiron.msp.redhat.com>
X-Originating-IP: [10.174.179.176]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
	kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	dm-devel mailing list <dm-devel@redhat.com>,
	Martin Wilck <mwilck@suse.com>, "liuzhiqiang
	\(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH 1/5] Fix potential null pointer dereference
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



>> @@ -388,8 +388,10 @@ sysfs_get_tgt_nodename(struct path *pp, char *node)
>>  		if (value && !strcmp(value, "usb")) {
>>  			pp->sg_id.proto_id = SCSI_PROTOCOL_USB;
>>  			tgtname = udev_device_get_sysname(tgtdev);
>> -			strlcpy(node, tgtname, NODE_NAME_SIZE);
>> -			return 0;
>> +			if (!tgtname) {
> 
> I assume that you mean "if (tgtname)"
> 

Thanks for your correction. I'm will correct it.

>> +				strlcpy(node, tgtname, NODE_NAME_SIZE);
>> +				return 0;
>> +			}
>>  		}
>>  		tgtdev = udev_device_get_parent(tgtdev);
>>  	}
>> diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
>> index d40c0869..f778410a 100644
>> --- a/libmultipath/foreign/nvme.c
>> +++ b/libmultipath/foreign/nvme.c
>> @@ -184,7 +184,9 @@ static int snprint_nvme_map(const struct gen_multipath *gmp,
>>  							      "firmware_rev"));
>>  	case 'r':
>>  		val = udev_device_get_sysattr_value(nvm->udev, "ro");
>> -		if (val[0] == 1)
>> +		if (!val)
>> +			return -1;
> 
> sprint_ro() returns "undef" for a similar case. Perhaps we should do
> that here as well.
> 

I'll do it here and send v2 patch. Thanks again.


Regards,
Lixiaokeng

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

