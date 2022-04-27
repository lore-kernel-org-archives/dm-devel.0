Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8245C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 21:57:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-8l8U7UE2OBS4vk-zlhByfg-1; Wed, 27 Apr 2022 17:57:55 -0400
X-MC-Unique: 8l8U7UE2OBS4vk-zlhByfg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CF221C0514C;
	Wed, 27 Apr 2022 21:57:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 594322024CB6;
	Wed, 27 Apr 2022 21:57:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 169361947046;
	Wed, 27 Apr 2022 21:57:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A7BE71947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 21:57:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 770CD111C482; Wed, 27 Apr 2022 21:57:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 725F51121319
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 21:57:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DC121C0514C
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 21:57:41 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-qiy5RxUAOn-Rr6s8qJgX3A-1; Wed, 27 Apr 2022 17:57:39 -0400
X-MC-Unique: qiy5RxUAOn-Rr6s8qJgX3A-1
X-IronPort-AV: E=Sophos;i="5.90,294,1643644800"; d="scan'208";a="303207114"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2022 05:57:38 +0800
IronPort-SDR: 2PMKT/2/VBh+ZsVXGqY97yog9R+1kMrLKrUU+4lk/kwHtmJO7VOL2TW/VJdct2LUCOIO7fV2qD
 eOO9iEBiM+d++9FLXJZkAhX5YDljBr8qYKWsp6gzFGVGWJ5HPhwwf1WyrOKTGFDurLjKn/BzlG
 3MYgNqir6fQ1uQKymgbyONCM7/xJ/4NTw76loaqezNIAkIiUkFsL/KJ5KFdt75Jpiko5Pjj+EP
 evIArkrA2/pU7qdD8CrroFiKxA0i9UiTeKbVvw4D91qhLm2yI8eB//PvaeQwHkuKWbK3Ks0ols
 xIuOOVBGigLxtYQxjlqLp56j
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Apr 2022 14:27:47 -0700
IronPort-SDR: 1JAFTVQOOto3KPsR3e+IBNBsQg/zgN2kTkgAIqc6S7zMjUIVOc43A+LNqzp4cGRs485NQDSElb
 DTlSL89BIiv+9gYTx3RXanTZJWGP/IawmJe/oCkDK9+U8zlDYVncydHxyiL6SKf1VQNv9gaVxo
 vsDQ+6qjsfvmYI+XaZs8ws+ZXobd5T6xOy33DgIp4WZBdE/zGUAoh+rc0wKCYy6IKmqiZDtHNw
 Ay+LNh8y1slcgWgcPNESrjQR5yfDfvsoNUTAtcDTXaiCrw13k1S+xh7CNw0Z7mXsbzwg1iDg9Q
 gOA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Apr 2022 14:57:38 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KpXfp2QKyz1SVny
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 14:57:38 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id IJqhvwFbtRu6 for <dm-devel@redhat.com>;
 Wed, 27 Apr 2022 14:57:37 -0700 (PDT)
Received: from [10.225.163.27] (unknown [10.225.163.27])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KpXfm4bP3z1Rvlc;
 Wed, 27 Apr 2022 14:57:36 -0700 (PDT)
Message-ID: <ae18fae1-c914-7bea-7c7b-861962b10c2c@opensource.wdc.com>
Date: Thu, 28 Apr 2022 06:57:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Nitesh Shetty <nj.shetty@samsung.com>
References: <20220426101241.30100-1-nj.shetty@samsung.com>
 <CGME20220426101910epcas5p4fd64f83c6da9bbd891107d158a2743b5@epcas5p4.samsung.com>
 <20220426101241.30100-2-nj.shetty@samsung.com>
 <0d52ad34-ab75-9672-321f-34053421c0c4@opensource.wdc.com>
 <20220427153053.GD9558@test-zns>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220427153053.GD9558@test-zns>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v4 01/10] block: Introduce queue limits for
 copy-offload support
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
Cc: inux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 nitheshshetty@gmail.com, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/28/22 00:30, Nitesh Shetty wrote:
>>> +/**
>>> + * blk_queue_max_copy_sectors - set max sectors for a single copy payload
>>> + * @q:  the request queue for the device
>>> + * @max_copy_sectors: maximum number of sectors to copy
>>> + **/
>>> +void blk_queue_max_copy_sectors(struct request_queue *q,
>>
>> This should be blk_queue_max_copy_hw_sectors().
>>
> 
> acked. Reasoning being, this function is used only by driver once for setting hw
> limits ?

function name points at what limit field it sets.

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

