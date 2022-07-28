Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38177C04A68
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 01:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658973160;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mP97hmqWCL1Q0WGhG1OMaQexXSRw71CJYztwKb2RxRE=;
	b=QLuFy/jUYadUnq4cKLPYJhUfxcRMr6BwNQ5R0Cly+lsIVnq7GKyzUHrCONYaSPQ1Mlb9aV
	Jmj2cE/UiGIt2fwicMgBU9ticnsolOEjOWaXB+IT46Q30TRb21cMMtCihy25+eftluMYsC
	a495KEIE3Naa8DEefliyxsjp3WxRNgs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-nnV4mCgeN66ZhIlNotX68Q-1; Wed, 27 Jul 2022 21:52:38 -0400
X-MC-Unique: nnV4mCgeN66ZhIlNotX68Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79BE7802D2C;
	Thu, 28 Jul 2022 01:52:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 09AF718ECC;
	Thu, 28 Jul 2022 01:52:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AD6801945DAB;
	Thu, 28 Jul 2022 01:52:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7BB561945DAF
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 01:52:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 66C8EC15D4F; Thu, 28 Jul 2022 01:52:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 62C42C04482
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 01:52:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49CC785A584
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 01:52:31 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-w9QOkYLyOX-ToI2pzZkAVg-1; Wed, 27 Jul 2022 21:52:29 -0400
X-MC-Unique: w9QOkYLyOX-ToI2pzZkAVg-1
X-IronPort-AV: E=Sophos;i="5.93,196,1654531200"; d="scan'208";a="207100874"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 28 Jul 2022 09:52:26 +0800
IronPort-SDR: QY/1AdbW2plxWn4my/t7S8p9PwjZlrh1riMgoj+io3ezWVUp05ZXTJHIlQ+1YgP5m9Hwj7sK2c
 NynKpakJnoiaLMnZ9nK/VP7C9OvpsG4eaxBKe/1Cp9aHP0eQlpquByiW1T87FtharWqEtKUJVV
 CKcXK600k0bbXhs8dG8aXtfhyDkCjxSWkhmt9SmnhVvmHtlEoAHIM6H32pZrupjUa/bUmFtu2j
 Il+4CO7wD5jWFmIyodznV5VRZkpUskUa2FqIcAVHRGhUNxX39aHbDVPYZZE4XTxTNVQOfYFOUE
 Tb1SjU9ACyA2WAdnLcFSn456
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 18:08:35 -0700
IronPort-SDR: YtgRPftlbl7Tm/U+QfcLOZGVNPbgLLQFKDft19BOQmKHJbESAREbLoixtzv/eUeiBxCSd/shIf
 sh4jfi/2jq4Mx9mWx0Tmdrllzeg/YZVAdVqhIBHFdz+xCNXvFxNB3HUu6RvAO4XQOkNF3upOkW
 PFih4JU03whtQrNpFO3P/3iTJ4fv2uSHF/ToLBl0DEBB+I2wAxUP+M7XNWCaaMzPz6gjDhDVTk
 FkgWUoeeqtRcmB1sYaJFgFJnn2TDKoUfc2K92+Se1iSobLq1MTaldGcHVUWyE29NPzebvVkaed
 zL4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 18:52:28 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LtYYl2HN4z1Rwqy
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 18:52:27 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id AcJo-0l4LHDs for <dm-devel@redhat.com>;
 Wed, 27 Jul 2022 18:52:26 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LtYYh12zFz1RtVk;
 Wed, 27 Jul 2022 18:52:23 -0700 (PDT)
Message-ID: <f2f29f97-5994-37f9-c922-31158c1c1b9a@opensource.wdc.com>
Date: Thu, 28 Jul 2022 10:52:22 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Bart Van Assche <bvanassche@acm.org>, Pankaj Raghav
 <p.raghav@samsung.com>, hch@lst.de, axboe@kernel.dk, snitzer@kernel.org,
 Johannes.Thumshirn@wdc.com
References: <CGME20220727162246eucas1p1a758799f13d36ba99d30bf92cc5e2754@eucas1p1.samsung.com>
 <20220727162245.209794-1-p.raghav@samsung.com>
 <51255650-ddc2-4f3d-52e5-14007b9ff538@acm.org>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <51255650-ddc2-4f3d-52e5-14007b9ff538@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v8 00/11] support non power of 2 zoned device
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
Cc: pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/28/22 08:19, Bart Van Assche wrote:
> On 7/27/22 09:22, Pankaj Raghav wrote:
>> This series adds support to npo2 zoned devices in the block and nvme
>> layer and a new **dm target** is added: dm-po2z-target. This new
>> target will be initially used for filesystems such as btrfs and
>> f2fs that does not have native npo2 zone support.
> 
> Should any SCSI changes be included in this patch series? From sd_zbc.c:
> 
> 	if (!is_power_of_2(zone_blocks)) {
> 		sd_printk(KERN_ERR, sdkp,
> 			  "Zone size %llu is not a power of two.\n",
> 			  zone_blocks);
> 		return -EINVAL;
> 	}

There are no non-power of 2 SMR drives on the market and no plans to have
any as far as I know. Users want power of 2 zone size. So I think it is
better to leave sd_zbc & scsi_debug as is for now.

> 
> Thanks,
> 
> Bart.


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

