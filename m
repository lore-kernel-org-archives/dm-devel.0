Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A091C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  5 May 2022 07:28:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195--uqdnt3CNoKUj85f599lBg-1; Thu, 05 May 2022 03:28:55 -0400
X-MC-Unique: -uqdnt3CNoKUj85f599lBg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E67DD1014A7C;
	Thu,  5 May 2022 07:28:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 79F6414A4F93;
	Thu,  5 May 2022 07:28:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 20A801947046;
	Thu,  5 May 2022 07:28:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DD7421947043
 for <dm-devel@listman.corp.redhat.com>; Thu,  5 May 2022 07:28:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CF00314693B9; Thu,  5 May 2022 07:28:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CA96E14693B8
 for <dm-devel@redhat.com>; Thu,  5 May 2022 07:28:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B28DE38149A1
 for <dm-devel@redhat.com>; Thu,  5 May 2022 07:28:51 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-kMpYt7UsMHGazw4PYp94nw-1; Thu, 05 May 2022 03:28:50 -0400
X-MC-Unique: kMpYt7UsMHGazw4PYp94nw-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220505072848euoutp02457086f4d3b1bb217a4c239d52c3d82f~sJOTqGYvL2921629216euoutp02j
 for <dm-devel@redhat.com>; Thu,  5 May 2022 07:28:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220505072848euoutp02457086f4d3b1bb217a4c239d52c3d82f~sJOTqGYvL2921629216euoutp02j
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220505072848eucas1p1d66f136b7b1226351171cd4dd1152d26~sJOTKK_DF2541325413eucas1p1z;
 Thu,  5 May 2022 07:28:48 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id B4.15.09887.0BC73726; Thu,  5
 May 2022 08:28:48 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220505072847eucas1p27c50364580d96918bc2a59b6877671ba~sJOSvbf6V0726607266eucas1p2b;
 Thu,  5 May 2022 07:28:47 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220505072847eusmtrp2acdb61270717097424f910760caaa9a7~sJOStu9m32757327573eusmtrp2B;
 Thu,  5 May 2022 07:28:47 +0000 (GMT)
X-AuditID: cbfec7f4-471ff7000000269f-26-62737cb08449
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 73.0D.09404.FAC73726; Thu,  5
 May 2022 08:28:47 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220505072847eusmtip133d8624e020309d5e17197a6d3fce6cd~sJOSiJ1WZ1867518675eusmtip1m;
 Thu,  5 May 2022 07:28:47 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.170) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Thu, 5 May 2022 08:28:44 +0100
Message-ID: <fe8746d5-f7c4-efd6-b4a6-e198f6d95813@samsung.com>
Date: Thu, 5 May 2022 09:28:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
To: David Sterba <dsterba@suse.cz>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20220504211440.GU18596@suse.cz>
X-Originating-IP: [106.210.248.170]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0xTZxjed87pOaedkGOB8K2wbMOxcZk4yJJ9G5sDN+dJRtQfbGMmRiuc
 AI5yaenmmKZ0KFEY4+IFd0Rg3rCIFoEUqVwEpAgWXYA6JFrmKAkWqd1AkRRxtIct/Hve55L3
 fb58NC41kjI6NT2bU6bL04JICWEwzd9aW79Xtevd0iop0vebcHThfjGJjjnncXTz6ACGyoqP
 U8g1cBtHbY4TIvT7My2GTrvmCKS70IMhm57H0c/XnAR6XmDFkG7/AxwtPIhEZV13AJqw8Bhq
 Gw1Hg+PnKTR4ahNqbesj0JCxgkRV5yYoVJL/BEcjJRMAlfY2itClqccEujEaEBPIDg1/wS7e
 qCPZ0jwHxd62XibYoQE121B7iGR/yz2Ks41nNOzV6hmMvXo3l2SL8hwk23JgTMQ+breQrL7J
 QrDm6usUW9J4WbRVuk3yURKXlvodp1y3fqckZfKci8rsp/YYzA0gFxSRBUBMQ+Y9eG2hYQlL
 aClzHsCJwfuEMMwCaC3rWR5mAGxfyPs/8nSmiRKEGgCnrAaRW/C4bK0bBcEIoHM435PwYtbD
 uzWdhBsTzJuwcGx+mV8N+361eXg/JgEe480e3of5BF40zmJujDP+cNRW5cG+TBCsNFkw9wKc
 cUmgo7VyaTNNk0wY1B6i3B4xsxYeqejHhWwoPNDsogT8GmyersCFBmvg4ZFhTMD74EWT2dMG
 MpMS+MeJ08umz2DBi/Jlkw+09zZRAg6EL1qqlvkf4cSICxfC+wEsbtGT7oMgEw1/MacJnlj4
 Z5FNJNDecGR6tXCPNywzlOMlIJhf8RT8isr8igr8igrVgKgF/pxapUjmVFHp3PcRKrlCpU5P
 jkjMUDSApe99c7F39gqosf8d0QUwGnQBSONBvl6fns3cJfVKkv+QwykzdijVaZyqCwTQRJC/
 V2JqvVzKJMuzuW85LpNT/qditFiWi9VHWTd3NNfVGQoSAyLj7PH6O1mZEnF3yOB2/i8yUTG3
 o+M6r9k+3rNzxhA78E9e2qq5KeZhsdT+isw3sCZasTfE76zlJ8OXhYrBRwlbgrOfD8s0b4un
 D6ptYdMv51AObfSa/vKOW88SNogiOsMveXUfH+OzNmzN73WqU/OzdLEZB2UaLVF4ZHHVWzJr
 /MhL2Y/inPu2iaiN9R+caQgNd9KvmqIaO0VGy0Of8Th7RHDV6+HajP43Pv7Q4H3PmFPGvXMl
 ZtzvpObrb3ZbYp4CmqytXPc+3x5rD6xVn+oOTfqqNUVXVPx54ea6Jw6nbjIxku4R7/YOc9wb
 Cqm37tnUF58SRKhS5JFhuFIl/xeMBbOtTQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsVy+t/xu7rra4qTDDa0GVusP3WM2WL13X42
 i2kffjJbnJ56lsliUv8MdovfZ88zW+x9N5vV4sKPRiaLxb+/s1isXH2UyeLJ+lnMFj0HPrBY
 /O26x2SxsuUhs8Wfh4YWkw5dY7R4enUWk8XeW9oWlx6vYLe4tMjdYs/ekywWl3fNYbOYv+wp
 u8WEtq/MFjcmPGW0mHh8M6vFutfvWSxO3JJ2kPG4fMXb49+JNWweE5vfsXucv7eRxePy2VKP
 Tas62TwWNkxl9ti8pN5j94LPTB67bzawefQ2v2Pz2Nl6n9Xj/b6rbB7rt1xl8Tiz4Ai7x4TN
 G1kDhKL0bIryS0tSFTLyi0tslaINLYz0DC0t9IxMLPUMjc1jrYxMlfTtbFJSczLLUov07RL0
 Ml4s+81ecIq9YtuZTYwNjL1sXYycHBICJhLfPm9h72Lk4hASWMoocXXLJqiEjMSnKx/ZIWxh
 iT/Xutggij4ySsz61cIM4exilPj05DdYFa+AncTN5QdZQGwWARWJ7vs/2SDighInZz4Bi4sK
 REg82H2WFcQWFrCXWLvrCxOIzSwgLnHryXwwW0RASWLesatgtpDATiaJR99iQJYxC/zkkpj5
 uRFoMwcHm4CWRGMn2F5OAV2JKXNOMUPM0ZRo3Q5xD7OAvMT2t3OYIT5Qlph84woThF0r8er+
 bsYJjKKzkJw3C8kZs5CMmoVk1AJGllWMIqmlxbnpucVGesWJucWleel6yfm5mxiBKW/bsZ9b
 djCufPVR7xAjEwfjIUYJDmYlEV7npQVJQrwpiZVVqUX58UWlOanFhxhNgWE0kVlKNDkfmHTz
 SuINzQxMDU3MLA1MLc2MlcR5PQs6EoUE0hNLUrNTUwtSi2D6mDg4pRqYPJye+xrfntSvZ258
 sj6QJ9fgXaL0leeRGjbXc2Z27Emf8VX0/e7QfR3TnWf9nXBUmW1d3O05uo/j9ub9Xv+do/+c
 6k+Xz5Ncz6auZj7aEKfMKPCOLZH/r4iFUtiBjKMlDRwBTp+tOK/Eq/yU/GDnG3Juaej7f7c9
 32dmfnFOOtLQFn3ZwdynzppHc+uk5ZVL7ktFvw/KOpx5UzHl3601M7+fPD7P8ac8e2Kl6nvL
 qZ5LLqyY9XS+sreS5fy62uavc7R6Y8t6O8xzT3hWGIR517PbPPu33uTrLOvmbsGnEdf39hW2
 Hr8b+t6/Yu9yK/NfD2vdi45rWb9xTXYKSbueFt7nJ526oeeI8lJrUSclluKMREMt5qLiRABk
 5eXBAgQAAA==
X-CMS-MailID: 20220505072847eucas1p27c50364580d96918bc2a59b6877671ba
X-Msg-Generator: CA
X-RootMTR: 20220427160256eucas1p2db2b58792ffc93026d870c260767da14
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220427160256eucas1p2db2b58792ffc93026d870c260767da14
References: <CGME20220427160256eucas1p2db2b58792ffc93026d870c260767da14@eucas1p2.samsung.com>
 <20220427160255.300418-1-p.raghav@samsung.com>
 <PH0PR04MB74167FC8BA634A3DA09586489BC19@PH0PR04MB7416.namprd04.prod.outlook.com>
 <a702c7f7-9719-9f3e-63de-1e96f2912432@samsung.com>
 <20220504211440.GU18596@suse.cz>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 00/16] support non power of 2 zoned devices
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
Cc: "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>,
 Naohiro Aota <Naohiro.Aota@wdc.com>, "sagi@grimberg.me" <sagi@grimberg.me>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
 "jonathan.derrick@linux.dev" <jonathan.derrick@linux.dev>,
 "kch@nvidia.com" <kch@nvidia.com>, "chao@kernel.org" <chao@kernel.org>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "josef@toxicpanda.com" <josef@toxicpanda.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dsterba@suse.com" <dsterba@suse.com>, "kbusch@kernel.org" <kbusch@kernel.org>,
 "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
 =?UTF-8?Q?Matias_Bj=c3=b8rling?= <Matias.Bjorling@wdc.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-f2fs-devel@lists.sourceforge.net"
 <linux-f2fs-devel@lists.sourceforge.net>,
 "mcgrof@kernel.org" <mcgrof@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022-05-04 23:14, David Sterba wrote:
>> This commit: `btrfs: zoned: relax the alignment constraint for zoned
>> devices` makes sure the zone size is BTRFS_STRIPE_LEN aligned (64K). So
>> even the npo2 zoned device should be aligned to `fs_info->sectorsize`,
>> which is typically 4k.
>>
>> This was one of the comment that came from David Sterba:
>> https://lore.kernel.org/all/20220315142740.GU12643@twin.jikos.cz/
>> where he suggested to have some sane alignment for the zone sizes.
> 
> My idea of 'sane' value would be 1M, that we have 4K for sectors is
> because of the 1:1 mapping to pages, but RAM sizes are on a different
> scale than storage devices. The 4K is absolute minimum but if the page
> size is taken as a basic constraint, ARM has 64K and there are some 256K
> arches.

That is a good point. I think it is safe to have 1MB as the minimum
alignment so that it covers all architecture's page sizes. Thanks. I
will queue this up.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

