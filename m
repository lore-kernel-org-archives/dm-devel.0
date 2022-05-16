Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B244EC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 16 May 2022 14:16:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-oDQOjHSPO_Sc6rUHunriCw-1; Mon, 16 May 2022 10:16:01 -0400
X-MC-Unique: oDQOjHSPO_Sc6rUHunriCw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19D4A101A52C;
	Mon, 16 May 2022 14:15:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B9C0AC15D70;
	Mon, 16 May 2022 14:15:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5D8211947054;
	Mon, 16 May 2022 14:15:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AF611194704E
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 May 2022 14:15:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9F3322166B25; Mon, 16 May 2022 14:15:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 99FAA2166B2D
 for <dm-devel@redhat.com>; Mon, 16 May 2022 14:15:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3836A3804524
 for <dm-devel@redhat.com>; Mon, 16 May 2022 14:15:54 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-5xZH4YHkMxStdyG2TTC3tQ-1; Mon, 16 May 2022 10:15:49 -0400
X-MC-Unique: 5xZH4YHkMxStdyG2TTC3tQ-1
X-IronPort-AV: E=Sophos;i="5.91,230,1647273600"; d="scan'208";a="304659623"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 16 May 2022 22:15:48 +0800
IronPort-SDR: Apowq2ylJe0COdgXVzm0NajJ5j4sC1oMcICSHygQ0OS0c6mMcGyQbyH2jzP5NlGj+OKHXIG0Vj
 e2QlglSBd3IhTKW8QF0liVggNJvaJDECTspX5MtAJW5zHGLRizKh/R7x6Gjqq5Y8dyMmO8Yl3j
 SQz9VJSrsfIIe4T6RmfGyyO8img+rHsMXtdhW+3aTBVmEZvYZEnw2dF+qOknq2crI58TMtYWvZ
 ZiLwJ5u0AX5MyGfqC0jg/MMUGflHDAHGIhFK1vuCbLJ7eVOLIvOrYObNbngsG1rqyPA73qzlN0
 zKY=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 16 May 2022 06:41:24 -0700
IronPort-SDR: UdbXhxPoa/ux+hsiYn//BU/xlkKLWQsmMdPd4vQlXqQnU/vwGjLAC+CANeKAEoxXBOLy9M3JRb
 SG33+PyCCz4yqtuxIjL1Q4AZCYsUP7yohWI2vcrqrszMxJFp+uoJXUYuoQwxPx+fFJ0tyL50bw
 LrzfLMWcyfcAf5G62rIiuni5O7h/hZti6LRl+kCM40y2FxZKcZ5RcO3M3fTKvG6Y64hYeRboBd
 70O5GEFisN+VN+t6qEshhO7P6x3JfJNA5dyZOwRVWEVrq0cUZcid8M/u15nN6kAXhGZOIZ+QQD
 tm0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 16 May 2022 07:15:44 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4L21W21wfXz1SHwl
 for <dm-devel@redhat.com>; Mon, 16 May 2022 07:15:42 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id VAeRlXVlactH for <dm-devel@redhat.com>;
 Mon, 16 May 2022 07:15:41 -0700 (PDT)
Received: from [10.225.1.43] (unknown [10.225.1.43])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4L21Vw31VPz1Rvlc;
 Mon, 16 May 2022 07:15:36 -0700 (PDT)
Message-ID: <31e03f27-6610-c4e4-58b9-6b9db000a753@opensource.wdc.com>
Date: Mon, 16 May 2022 16:15:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
To: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk,
 naohiro.aota@wdc.com, Johannes.Thumshirn@wdc.com, snitzer@kernel.org,
 dsterba@suse.com, jaegeuk@kernel.org, hch@lst.de
References: <CGME20220516133922eucas1p1c891cd1d82539b4e792acb5d1aa74444@eucas1p1.samsung.com>
 <20220516133921.126925-1-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220516133921.126925-1-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v4 00/13] support non power of 2 zoned devices
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
Cc: linux-block@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>,
 bvanassche@acm.org, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 Jens Axboe <axboe@fb.com>, Chris Mason <clm@fb.com>, dm-devel@redhat.com,
 linux-btrfs@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
 jonathan.derrick@linux.dev, linux-fsdevel@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>, Johannes Thumshirn <jth@kernel.org>,
 Keith Busch <kbusch@kernel.org>, matias.bjorling@wdc.com,
 Sagi Grimberg <sagi@grimberg.me>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022/05/16 15:39, Pankaj Raghav wrote:
[...]
> - Patchset description:
> This patchset aims at adding support to non power of 2 zoned devices in
> the block layer, nvme layer, null blk and adds support to btrfs and
> zonefs.
> 
> This round of patches **will not** support DM layer for non
> power of 2 zoned devices. More about this in the future work section.
> 
> Patches 1-2 deals with removing the po2 constraint from the
> block layer.
> 
> Patches 3-4 deals with removing the constraint from nvme zns.
> 
> Patches 5-9 adds support to btrfs for non po2 zoned devices.
> 
> Patch 10 removes the po2 constraint in ZoneFS
> 
> Patch 11-12 removes the po2 contraint in null blk
> 
> Patches 13 adds conditions to not allow non power of 2 devices in
> DM.


Not sure what is going on but I only got the first 4 patches and I do not see
the remaining patches on the lists anywhere.


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

