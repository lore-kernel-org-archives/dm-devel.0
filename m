Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21649C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 09:41:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-nZ3xFKoXPeu27OlTbaFVOw-1; Mon, 11 Apr 2022 05:41:17 -0400
X-MC-Unique: nZ3xFKoXPeu27OlTbaFVOw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A08D833942;
	Mon, 11 Apr 2022 09:41:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 35F02417E38;
	Mon, 11 Apr 2022 09:41:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9B28C19451F2;
	Mon, 11 Apr 2022 09:41:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1087319466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 09:41:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F33A4C28106; Mon, 11 Apr 2022 09:41:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EDF5FC44B07
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 09:41:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D55872A59546
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 09:41:11 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170--KlEn7OROeSb4U-Zm5W9pQ-1; Mon, 11 Apr 2022 05:41:10 -0400
X-MC-Unique: -KlEn7OROeSb4U-Zm5W9pQ-1
X-IronPort-AV: E=Sophos;i="5.90,251,1643644800"; d="scan'208";a="309578035"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2022 17:40:04 +0800
IronPort-SDR: U5QwmQ29744tXZMGsAt2m5AdY9i3kyp7V45Y9QkwLj4mASeH+Od497ctaReM3Wg75LfMEQNd1j
 ZUW+LVaF9N6o0ciJk7b/2m3vZBB67+m0cYos872tNyzHlK5m0p54/dniCKXWx3KeP606JKyqTO
 1ey+gzQ6cyyA8fAJSyCMufu2Xq//Kc9R0TpoWfXzN1OhZyEE7kkWRwzbf+WVaQCLeVZIFxknpS
 uvUnzS60kW87an8N4Q2z/D98oZx/OPS40MfAuxvr+z1zfYd49ViMrhHseM/4ZCnkpHuqNubIU9
 +y/i27AQbSvmlUSwXGuwyBFx
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 11 Apr 2022 02:11:22 -0700
IronPort-SDR: Ywr4Rnjw2ATJ0WHdQe34snjlqLfr2m4gw1heK+wEQZ1revX/LhQ0FanDjm5va9RSu9pCxNnK1L
 pYNknmuHoUjPZH9GmBW3cqG6EAHD3ZjpZro81XBEoOASSn83G+Ws8WfR41OwYms7GYCXWtjRL0
 Qb/NVS02Pwpgx9PZHzsC47hToNxsLRAZkmOz3GyStVKyAUaEoYXMfsx1ZSgkDdm1FnKVgbgswd
 Rwz1cqiYq7y0T3x0p+s++ehwch9VkBBteLMv8fF5qeKU4b9vwVgmpQaK1HfRBqxiEAnmGnEgXh
 NtI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 11 Apr 2022 02:40:04 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KcP380B2vz1SVnx
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 02:40:04 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id i--BhiRQI6Jk for <dm-devel@redhat.com>;
 Mon, 11 Apr 2022 02:40:03 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KcP366R86z1Rvlx;
 Mon, 11 Apr 2022 02:40:02 -0700 (PDT)
Message-ID: <7d3c5f4f-5760-ae96-32b3-1fdd8da8b940@opensource.wdc.com>
Date: Mon, 11 Apr 2022 18:40:01 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Ming Lei <ming.lei@redhat.com>, Mike Snitzer <snitzer@redhat.com>
References: <20220408171254.935171-1-ming.lei@redhat.com>
 <20220408171254.935171-2-ming.lei@redhat.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220408171254.935171-2-ming.lei@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 1/3] dm: don't grab target io reference in
 dm_zone_map_bio
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
Cc: dm-devel@redhat.com, Damien Le Moal <damien.lemoal@wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/9/22 02:12, Ming Lei wrote:
> dm_zone_map_bio() is only called from __map_bio in which the io's
> reference is grabbed already, and the reference won't be released
> until the bio is submitted, so no necessary to do it dm_zone_map_bio
> any more.
> 
> Cc: Damien Le Moal <damien.lemoal@wdc.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Tested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

