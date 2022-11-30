Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DB52C352A1
	for <dm-devel@archiver.kernel.org>; Wed, 30 Nov 2022 09:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669802123;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=y9tJU3wO/VQ2eq61LyXAw5TqlT/sCETHNCPXJ/7E0Fc=;
	b=KHZkdw/TSgb+5Q4intEu8vA2fjgeI7MpNypcsNcNqnSz25+SNjZOXscw/LDmy2LzRjoR76
	/zEbvVYPFFUngAI/5M0oYVezs+Y2idB/CkaqWp3QVSSQem+I7jCjmEFfzq/A9oo7Q+hezr
	SSMiLgn46lv7n6LETBsEeIvPdTCa08s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-GGjkCHaEM2uc-MWUYsk_Vg-1; Wed, 30 Nov 2022 04:55:20 -0500
X-MC-Unique: GGjkCHaEM2uc-MWUYsk_Vg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D3F2382C96E;
	Wed, 30 Nov 2022 09:55:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 977FA40C6EC4;
	Wed, 30 Nov 2022 09:55:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 68CE719465A2;
	Wed, 30 Nov 2022 09:55:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 592F619465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Nov 2022 09:55:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 28C0C40C6EC4; Wed, 30 Nov 2022 09:55:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 20A3D40E9785
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 09:55:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5240382C96D
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 09:55:12 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-9lkXuk4xPd-OmP87prJSmw-1; Wed, 30 Nov 2022 04:55:10 -0500
X-MC-Unique: 9lkXuk4xPd-OmP87prJSmw-1
X-IronPort-AV: E=Sophos;i="5.96,206,1665417600"; d="scan'208";a="217538405"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 30 Nov 2022 17:55:09 +0800
IronPort-SDR: 8wDz9LoqHaqNTUtw2YkQAs0g5S46eqSu01AmapJQWJTPRTV4JailaY3DsVbpITvxIuK+TFe+7f
 0su2sF4NiP9zI3nsuiY/KffB3bS4A4iJbMx7+8GlPJRsIpWCDYA5dx9dHzKPm7w8EZlcULb4xi
 qPhuYHBRioHPwczCxQOT0kCjqXAVxFVw6gOV6yI2DeaY3//pcSsrGMQi9dMUPWgabVyI5nuuad
 kZ9X/zlkspOUru/K6oOSYNh30bA4p8xmL2qZVv47vmSB5uJhgapMZNBEl3gz1QGCuhcwlnDJuU
 XPM=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 30 Nov 2022 01:13:48 -0800
IronPort-SDR: v22YblL8CWi1CbyNdJkjFqCWTQPf/FzPF1JJ5HkIF3YeRkPVtxQQDnPBxAk7Haftc5JFE5y7vF
 P8uxT+LRd2lJqZo41SjAgXEDoOxJF3EED0ENr5pj4aj8zwFL/piUZ1dXHVTYwOCPI0nRAAlSi+
 a/A/F4nEcbLFNOG302Urs8a5RzKYRpVcthddmUzCEkxTgzr/O2GYUwq+PKcqJH63su6cFtU5Mc
 wYDJs5DkheLUFYhGXweKr9IcfrodIhRzjOwVgr0kHkrTgxm4o8JpA+mjd0IsQPbN1IpfMm/4Cc
 EVU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 30 Nov 2022 01:55:10 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NMZM10FPyz1Rwt8
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 01:55:08 -0800 (PST)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id xjWDQrfFhrhQ for <dm-devel@redhat.com>;
 Wed, 30 Nov 2022 01:55:08 -0800 (PST)
Received: from [10.225.163.66] (unknown [10.225.163.66])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NMZLx09szz1RvLy;
 Wed, 30 Nov 2022 01:55:04 -0800 (PST)
Message-ID: <1ef5747a-9469-4365-ffc9-05daa6f69288@opensource.wdc.com>
Date: Wed, 30 Nov 2022 18:55:03 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
To: Nitesh Shetty <nj.shetty@samsung.com>
References: <20221123055827.26996-1-nj.shetty@samsung.com>
 <CGME20221123061044epcas5p2ac082a91fc8197821f29e84278b6203c@epcas5p2.samsung.com>
 <20221123055827.26996-11-nj.shetty@samsung.com>
 <729254f8-2468-e694-715e-72bcbef80ff3@opensource.wdc.com>
 <349a4d66-3a9f-a095-005c-1f180c5f3aac@opensource.wdc.com>
 <20221129122232.GC16802@test-zns>
 <b22652ee-9cca-a5b1-e9f1-862ed8f0354d@opensource.wdc.com>
 <20221130041728.GB17533@test-zns>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221130041728.GB17533@test-zns>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v5 10/10] fs: add support for copy file range
 in zonefs
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
Cc: axboe@kernel.dk, naohiro.aota@wdc.com, kch@nvidia.com, sagi@grimberg.me,
 joshi.k@samsung.com, gost.dev@samsung.com, anuj20.g@samsung.com,
 snitzer@kernel.org, james.smart@broadcom.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, viro@zeniv.linux.org.uk,
 nitheshshetty@gmail.com, kbusch@kernel.org, jth@kernel.org, hch@lst.de,
 agk@redhat.com, p.raghav@samsung.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/30/22 13:17, Nitesh Shetty wrote:
> On Wed, Nov 30, 2022 at 08:45:55AM +0900, Damien Le Moal wrote:
>> On 11/29/22 21:22, Nitesh Shetty wrote:
>>> Acked. I do see a gap in current zonefs cfr implementation. I will drop this
>>
>> cfr ?
>>
> 
> yes, will drop zonefs cfr for next version.

I meant: I do not understand "cfr". I now realize that it probably means
copy-file-range ? Please be clear and do not use abbreviations.

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

