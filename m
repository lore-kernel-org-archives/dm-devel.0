Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F456C4332F
	for <dm-devel@archiver.kernel.org>; Fri, 20 May 2022 09:07:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-j1EPaXcPOneT3jT9VDornw-1; Fri, 20 May 2022 05:07:07 -0400
X-MC-Unique: j1EPaXcPOneT3jT9VDornw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F243801210;
	Fri, 20 May 2022 09:07:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E29D740CF8EB;
	Fri, 20 May 2022 09:07:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AE8F1194705A;
	Fri, 20 May 2022 09:07:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DBF741947058
 for <dm-devel@listman.corp.redhat.com>; Fri, 20 May 2022 09:07:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CD224492CA3; Fri, 20 May 2022 09:07:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C80B6492CA2
 for <dm-devel@redhat.com>; Fri, 20 May 2022 09:07:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3FF44811E76
 for <dm-devel@redhat.com>; Fri, 20 May 2022 09:07:02 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-xB2z13rJOLivOiK9juNSDQ-1; Fri, 20 May 2022 05:07:00 -0400
X-MC-Unique: xB2z13rJOLivOiK9juNSDQ-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220520090659euoutp01d8ecca763a71410b6dd74b4ffa108dd4~wxPTio1Uy1607816078euoutp01W
 for <dm-devel@redhat.com>; Fri, 20 May 2022 09:06:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220520090659euoutp01d8ecca763a71410b6dd74b4ffa108dd4~wxPTio1Uy1607816078euoutp01W
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220520090658eucas1p19241042c1d4d4bf5821401c597a1af02~wxPTNJ9M-0637606376eucas1p1x;
 Fri, 20 May 2022 09:06:58 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 42.2D.10009.23A57826; Fri, 20
 May 2022 10:06:58 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220520090658eucas1p1b33f4cb964566691674c4b015509ceec~wxPS0eI0V3138931389eucas1p1D;
 Fri, 20 May 2022 09:06:58 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220520090658eusmtrp1fc09ac06a8697122e1bebb8cc020ff52~wxPSzj_us2148821488eusmtrp1T;
 Fri, 20 May 2022 09:06:58 +0000 (GMT)
X-AuditID: cbfec7f2-e7fff70000002719-2a-62875a32e7b5
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id CA.BC.09522.23A57826; Fri, 20
 May 2022 10:06:58 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220520090658eusmtip198be26f25d7bc7783e6b666edad5d54a~wxPSqRLcC1273112731eusmtip1c;
 Fri, 20 May 2022 09:06:58 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.20) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Fri, 20 May 2022 10:06:56 +0100
Message-ID: <2252c3b2-0f65-945e-dc39-c0726bce72e8@samsung.com>
Date: Fri, 20 May 2022 11:06:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, "dsterba@suse.cz"
 <dsterba@suse.cz>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <PH0PR04MB7416FF84CE207FEC3ED8912F9BD09@PH0PR04MB7416.namprd04.prod.outlook.com>
X-Originating-IP: [106.210.248.20]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsWy7djP87pGUe1JBi9uGVusvtvPZvH77Hlm
 i73vZrNaXPjRyGSx+Pd3FouVq48yWfQc+MBi8bfrHpPF3lvaFpcer2C32LP3JIvF5V1z2Czm
 L3vKbrHm5lMWBz6PfyfWsHnsnHWX3ePy2VKPzUvqPXbfbACKtN5n9Xi/7yqbx/otV1k8ziw4
 wu7xeZOcR/uBbqYA7igum5TUnMyy1CJ9uwSujL9f7jMVnOKuWLbqIksD40TOLkYODgkBE4kz
 P7O6GLk4hARWMEocOzSLDcL5wiix+PURFgjnM6PEtv/3gDKcYB3fT/2CqlrOKDHjbD8bXNXt
 TV+YIJxdjBKTlz5mB2nhFbCTeLS1A8xmEVCVWLNwJSNEXFDi5MwnLCC2qECExLRZZ9hAjhIW
 SJHYsbIIJMwsIC5x68l8JpCwiECUxK93ASDjmQUOs0psOnuOFSTOJqAl0djJDmJyCsRKfP/h
 C9GpKdG6/Tc7hC0vsf3tHGaIj5Uktv0ygXilVmLtsTPsIBMlBO5xSky88Y0dIuEisX/2IyYI
 W1ji1fEtUHEZidOTe1gg7GqJpzd+M0M0tzBK9O9czwaxwFqi70wORI2jxKVvn6H28knceCsI
 cQ6fxKRt05knMKrOQgqGWUj+nYXkg1lIPljAyLKKUTy1tDg3PbXYMC+1XK84Mbe4NC9dLzk/
 dxMjMPmd/nf80w7Gua8+6h1iZOJgPMQowcGsJMLLmNuSJMSbklhZlVqUH19UmpNafIhRmoNF
 SZw3OXNDopBAemJJanZqakFqEUyWiYNTqoEpQ2Dqnx+JRanq3I1XvVZM2b/zQnodu4NsqUmX
 XmqfK8uDX5JOAs+Vc+YemHcy2eK67v+wuSrft+w3+LvQOc6W81LyAX7tt7WnGvdwsEa8nhp7
 KSCKYyPrcl6bQPsrUf1F/itWen26xrZJKk6Q9522cO+04ohnlis+Xg4xsXofoxSsv0Al+Yht
 U4n5xGZL3mKOpfn7tqQ8b7FMiHm+NveK05xlEzou+27+7vRlj+mPd9+qOBx2briXzNZqe5y5
 VHrXIxWriUKyW9Q9OrzVOgVblvmezw7xNc57w1c2kTevkd9ZfK9gyNwJXJPmxQr6yLB2hR36
 2ZTSV6T2carCujez14vdzwj4nPtzRtYpDSWW4oxEQy3mouJEAI6rGDvtAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e/4XV2jqPYkg7ezpC1W3+1ns/h99jyz
 xd53s1ktLvxoZLJY/Ps7i8XK1UeZLHoOfGCx+Nt1j8li7y1ti0uPV7Bb7Nl7ksXi8q45bBbz
 lz1lt1hz8ymLA5/HvxNr2Dx2zrrL7nH5bKnH5iX1HrtvNgBFWu+zerzfd5XNY/2WqyweZxYc
 Yff4vEnOo/1AN1MAd5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6dTUpq
 TmZZapG+XYJext8v95kKTnFXLFt1kaWBcSJnFyMnh4SAicT3U7/Yuhi5OIQEljJKzDy7hh0i
 ISPx6cpHKFtY4s+1LjYQW0jgI6PEuhfKEA27GCUWnO8GK+IVsJN4tLUDzGYRUJVYs3AlI0Rc
 UOLkzCcsILaoQITEg91nWUFsYYEUiUefZoPZzALiEreezGfqYuTgEBGIkvj1LgAifJhVYtcS
 cYhdH5gkHt+axgJSwyagJdHYyQ5icgrESnz/4QtRrinRuv03O4QtL7H97RxmkBIJASWJbb9M
 ID6plXh1fzfjBEbRWUhum4XkhllIJs1CMmkBI8sqRpHU0uLc9NxiQ73ixNzi0rx0veT83E2M
 wJSx7djPzTsY5736qHeIkYmD8RCjBAezkggvY25LkhBvSmJlVWpRfnxRaU5q8SFGU2AATWSW
 Ek3OByatvJJ4QzMDU0MTM0sDU0szYyVxXs+CjkQhgfTEktTs1NSC1CKYPiYOTqkGpuhgPda3
 v54fzDnk17HzgM7sJXNPscZfP5Eh/EB7efPOEtOQn9XV1zy+fyr/d4Dr7tqTy59YC5oe+n5x
 9vI5OUm3eKYdkbabvm67x4Nv37ddC+lXlgp5s2ftbgPOma8zprFs0o4O3j4l9v0BJk4tywL9
 KcdaPO+8D/khVXjqWffhv1NOhF/+J+TBrR7F/YvvIGf+Vu4HzyQcPq//kmZc03uSIaYjzDVp
 xvu+6gm//fZ4u557nDol7bdqwr79l36u+Pax9c7igDkmMmlqVzTbZhZM/rEs8ejcjTZ/toRL
 vzXiOi/VZqZvmV51drLJUrO3kZsu7M/mzT3r5+Zkt/VtxwJVCR37c4pTXulc82EJ29StxFKc
 kWioxVxUnAgA6L2ujKIDAAA=
X-CMS-MailID: 20220520090658eucas1p1b33f4cb964566691674c4b015509ceec
X-Msg-Generator: CA
X-RootMTR: 20220516165429eucas1p272c8b4325a488675f08f2d7016aa6230
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220516165429eucas1p272c8b4325a488675f08f2d7016aa6230
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165429eucas1p272c8b4325a488675f08f2d7016aa6230@eucas1p2.samsung.com>
 <20220516165416.171196-9-p.raghav@samsung.com>
 <20220517124257.GD18596@twin.jikos.cz>
 <717a2c83-0678-9310-4c75-9ad5da0472f6@samsung.com>
 <PH0PR04MB7416FF84CE207FEC3ED8912F9BD09@PH0PR04MB7416.namprd04.prod.outlook.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v4 08/13] btrfs:zoned: make sb for npo2 zone
 devices align with sb log offsets
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
 "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "dsterba@suse.com" <dsterba@suse.com>, "hch@lst.de" <hch@lst.de>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/19/22 09:57, Johannes Thumshirn wrote:
>> Unfortunately it is not possible to just move the WP in zoned devices.
>> The only alternative that I could use is to do write zeroes which are
>> natively supported by some devices such as ZNS. It would be nice to know
>> if someone had a better solution to this instead of doing write zeroes
>> in zoned devices.
>>
> 
> I have another question. In case we need to pad the sb zone with a write
> zeros and have a power fail between the write-zeros and the regular 
> super-block write, what happens? I know this padding is only done for the
> backup super blocks, never the less it can happen and it can happen when
> the primary super block is also corrupted.
> 
> AFAIU we're then trying to reach out for a backup super block, look at the
> write pointer and it only contains zeros but no super block, as only the 
> write-zeros has reached the device and not the super block write.
> 
> How is this situation handled?
> 
That is a very good point. I did think about this situation while adding
padding to the mirror superblock with write zeroes. If the drive is
**less than 4TB** and with the **primary superblock corrupted**, then it
will be an issue with the situation you have described for npo2 drives.
That situation is not handled here. Ofc this is not an issue when we
have the second mirror at 4TB for bigger drives. Do you have some ideas
in mind for this failure mode?
> Thanks,
> 	Johannes

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

