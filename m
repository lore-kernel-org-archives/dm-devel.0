Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4978C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  4 May 2022 06:49:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-wvvgIhxpOE6Lpb4zOXY3fg-1; Wed, 04 May 2022 02:49:10 -0400
X-MC-Unique: wvvgIhxpOE6Lpb4zOXY3fg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 820671C3E983;
	Wed,  4 May 2022 06:49:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A979B53CF;
	Wed,  4 May 2022 06:49:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 625D11947040;
	Wed,  4 May 2022 06:49:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 97C921947041
 for <dm-devel@listman.corp.redhat.com>; Tue,  3 May 2022 09:12:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4427F463E0B; Tue,  3 May 2022 09:12:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F7BB401E77
 for <dm-devel@redhat.com>; Tue,  3 May 2022 09:12:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2652F1014A61
 for <dm-devel@redhat.com>; Tue,  3 May 2022 09:12:12 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-Dd_WhwxAPROg61TkSTDxUw-1; Tue, 03 May 2022 05:12:10 -0400
X-MC-Unique: Dd_WhwxAPROg61TkSTDxUw-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220503091209euoutp01ef2714ea113e8f081849f897a9fa26a3~rjV9v2Um10886808868euoutp01t
 for <dm-devel@redhat.com>; Tue,  3 May 2022 09:12:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220503091209euoutp01ef2714ea113e8f081849f897a9fa26a3~rjV9v2Um10886808868euoutp01t
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220503091208eucas1p1ad5c611652cba012530519c5e24823cc~rjV9RGgOw0201902019eucas1p16;
 Tue,  3 May 2022 09:12:08 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 64.C8.09887.8E1F0726; Tue,  3
 May 2022 10:12:08 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220503091208eucas1p1cea931169fd910bd02f1de6d79a10d3c~rjV82hCoz0339703397eucas1p1h;
 Tue,  3 May 2022 09:12:08 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220503091208eusmtrp2c917ae498f4cf3801576f009a47b084c~rjV8zlopc1059410594eusmtrp2Z;
 Tue,  3 May 2022 09:12:08 +0000 (GMT)
X-AuditID: cbfec7f4-45bff7000000269f-65-6270f1e8de5e
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 23.F9.09522.8E1F0726; Tue,  3
 May 2022 10:12:08 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220503091208eusmtip159597f8d3e9ac33c0b07ef5f593ee926~rjV8kr5Ci1917519175eusmtip1Z;
 Tue,  3 May 2022 09:12:08 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.170) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Tue, 3 May 2022 10:12:05 +0100
Message-ID: <a702c7f7-9719-9f3e-63de-1e96f2912432@samsung.com>
Date: Tue, 3 May 2022 11:12:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, "jaegeuk@kernel.org"
 <jaegeuk@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "snitzer@kernel.org" <snitzer@kernel.org>, "hch@lst.de" <hch@lst.de>,
 "mcgrof@kernel.org" <mcgrof@kernel.org>, Naohiro Aota
 <Naohiro.Aota@wdc.com>, "sagi@grimberg.me" <sagi@grimberg.me>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
 "dsterba@suse.com" <dsterba@suse.com>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <PH0PR04MB74167FC8BA634A3DA09586489BC19@PH0PR04MB7416.namprd04.prod.outlook.com>
X-Originating-IP: [106.210.248.170]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0xTZxje13N6eqjWHaobn8WAgc0NFio6E78EAls08yjhIrtETIwUPFKy
 UrGFTSE4WHHMjktB7baKwowDBOXaCEVgG4Sb0NVwG+CsNW0j3koJlQxxMMrBhX/P8z7v877v
 8+UjMaGeEJHJ8jRGIZfI/Ag+fqtn/s+gqZnUhOC2l2JUd6cHQzX3iwikdc5jaOCikYNKin7i
 oQWjCUPtjktcdPefHA66XtPNQbY6HYbyf3fi6F+1ebmW+xBDrx7uQCWdYwDZR3Uc1D75ARqy
 VvHQ0NV9qK29H0fDraUEKquw85DmuxcYGtfYASrubeKi2qfTOOqb9P7Imx4eiaAX+24QdLHK
 waNN5gacHjam043V5wj6l+yLGN107Rv6dvksh749kU3QBSoHQRvOPuDS0x2jBF2nH8VpTVMD
 l55t9InxPMwPPcbIkr9iFNvD4vnS+h+e4al9glPO+gYsG6jWqYEHCald8LJmAlMDPimkqgC8
 fP4KlyUuAAeqKwmWzAKY21zDeW1prewCbiykKgFsefnZ/01XH1u5rNAK4AtHhBsLqDCY12Fe
 MeDUO9BQbOSxdU/Y/7MNd+O3qENQqxsk3HgjFQ5vtrpWlmGUF5y0lXHcCzZRLRicKLmBuwlG
 dfNg7auqZUKSBBUIc86tDPWgjsCK61qMNQfAs80LPBb7wubnpRibwB+eHx9ZTZMFb/YM8twz
 IWXhwzt3XavCXtjUqiVYvBE+6dXzWLwFLhnKVnsyoX18AWPNuQAWGeoI90GQCoGFgzK252No
 KbBx2fIGOP7ck71nAyy59SOmAe/q1ryFbk1m3ZoIujURygFeDbyYdGVKEqPcKWe+FislKcp0
 eZI48URKI1j+2AOLva4WUPlkRtwJOCToBJDE/DYJ9vyamiAUHJOczmAUJ44q0mWMshN4k7if
 lyAxuV4ipJIkacyXDJPKKF6rHNJDlM3J2PxFkDXbIZ2bD45WffLeVMibuwe21eQRkWEHrL1F
 enPs4z2Bn4emaeOuNS8eMEjDCym7/3Dc0r0zIv/JU9+Xh57M+wNcCO9biBbxG2o884NC1umi
 17syhQJLlGl77BF5573aeGQMWdw/59nuY4tdyg12xriMXuoAUV6p76fCmAdO9f2OMybQZvpw
 r8g5158Q231QxFUP1W/j0wFRskstb+viD78xmJORL+eHVO88FDmTeTzqW/NYYfe+9VmV4oou
 xd/6rJHIhqmtidODT1vi/lI+K39/9gJVYLYe79oda/nNawbzUfuqYrYEp3T5PqqF+UctJ0vH
 T49tlkbsekTu98OVUsmOQEyhlPwHcH1JrkcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsVy+t/xu7ovPhYkGey8x2+x/tQxZovVd/vZ
 LKZ9+MlscXrqWSaLSf0z2C1+nz3PbLH33WxWiws/GpksVq4+ymTxZP0sZoueAx9YLP523QOK
 tTxktvjz0NBi0qFrjBZPr85isth7S9vi0uMV7BaXFrlb7Nl7ksXi8q45bBbzlz1lt5jQ9pXZ
 4saEp4wWE49vZrVY9/o9i8WJW9IO0h6Xr3h7/Duxhs1jYvM7do/z9zayeFw+W+qxaVUnm8fC
 hqnMHpuX1HvsXvCZyWP3zQY2j97md2weO1vvs3q833eVzWP9lqssHhM2b2T1+LxJLkAwSs+m
 KL+0JFUhI7+4xFYp2tDCSM/Q0kLPyMRSz9DYPNbKyFRJ384mJTUnsyy1SN8uQS9jQ/cbloIT
 vBUfNmxkbmBs5u5i5OSQEDCR2LX8MGMXIxeHkMBSRonzD9qYIBIyEp+ufGSHsIUl/lzrYoMo
 +sgocXbLAmYIZxejxMrWpWAdvAJ2Eu377jGC2CwCKhI7J55lh4gLSpyc+YQFxBYViJB4sPss
 K4gtLGAvsXbXF7BeZgFxiVtP5jOBDBUR2MYssXbKebANzAKH2SU+7t3MDrHuIaPE7Pczgco4
 ONgEtCQaO8E2cArESixbOY0ZYpKmROv23+wQtrzE9rdzmCF+UJaYfOMK1G+1Eq/u72acwCg6
 C8mBs5AcMgvJqFlIRi1gZFnFKJJaWpybnltsqFecmFtcmpeul5yfu4kRmOq2Hfu5eQfjvFcf
 9Q4xMnEwHmKU4GBWEuF1XlqQJMSbklhZlVqUH19UmpNafIjRFBhKE5mlRJPzgck2ryTe0MzA
 1NDEzNLA1NLMWEmc17OgI1FIID2xJDU7NbUgtQimj4mDU6qBSWv7S9WNHwXkQ2z7F83ZZLb5
 2irRmZo7P8496uVr/nVSLqdho0HPxgBj67s8H7fdNTCbcTA3+ssq/ryO1rBPdx6I2x8/FmS8
 xljyQvJqx/Pvb0YvbZj+v9ropMHcP+VL+q4aMWhxn+t3cJK/tLrtdo0Av9GO87tKG5k1Pcov
 Nre3s6/gVarldBFnq9admtpzP7cvUPbUS8n/fbwRros02bw598+3XP5e+8Hxto8nVI4snW4e
 rbH8VXtySDTj38m89QoFcjfzXn5cu9n8g6VElsl85tNVzLvrnXQCN264e/+qsf35TNW777yP
 a3scy60TDRVj0o5Yecbxx5tbt+2v37C8+0Bxin2KcX2ctvF6JZbijERDLeai4kQArWmSZP4D
 AAA=
X-CMS-MailID: 20220503091208eucas1p1cea931169fd910bd02f1de6d79a10d3c
X-Msg-Generator: CA
X-RootMTR: 20220427160256eucas1p2db2b58792ffc93026d870c260767da14
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220427160256eucas1p2db2b58792ffc93026d870c260767da14
References: <CGME20220427160256eucas1p2db2b58792ffc93026d870c260767da14@eucas1p2.samsung.com>
 <20220427160255.300418-1-p.raghav@samsung.com>
 <PH0PR04MB74167FC8BA634A3DA09586489BC19@PH0PR04MB7416.namprd04.prod.outlook.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Wed, 04 May 2022 06:49:03 +0000
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
 "kch@nvidia.com" <kch@nvidia.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
 =?UTF-8?Q?Matias_Bj=c3=b8rling?= <Matias.Bjorling@wdc.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "chao@kernel.org" <chao@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-f2fs-devel@lists.sourceforge.net"
 <linux-f2fs-devel@lists.sourceforge.net>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "agk@redhat.com" <agk@redhat.com>,
 "jonathan.derrick@linux.dev" <jonathan.derrick@linux.dev>,
 "kbusch@kernel.org" <kbusch@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "josef@toxicpanda.com" <josef@toxicpanda.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
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

Hi Johannes,
On 2022-05-03 00:07, Johannes Thumshirn wrote:
>> There was an effort previously [1] to add support to non po2 devices via
>> device level emulation but that was rejected with a final conclusion
>> to add support for non po2 zoned device in the complete stack[2].
> 
> Hey Pankaj,
> 
> One thing I'm concerned with this patches is, once we have npo2 zones (or to be precise 
> not fs_info->sectorsize aligned zones) we have to check on every allocation if we still 
> have at least have fs_info->sectorsize bytes left in a zone. If not we need to 
> explicitly finish the zone, otherwise we'll run out of max active zones. 
> 
This commit: `btrfs: zoned: relax the alignment constraint for zoned
devices` makes sure the zone size is BTRFS_STRIPE_LEN aligned (64K). So
even the npo2 zoned device should be aligned to `fs_info->sectorsize`,
which is typically 4k.

This was one of the comment that came from David Sterba:
https://lore.kernel.org/all/20220315142740.GU12643@twin.jikos.cz/
where he suggested to have some sane alignment for the zone sizes.

> This is a problem for zoned btrfs at the moment already but it'll be even worse
> with npo2, because we're never implicitly finishing zones.
> 
> See also 
> https://lore.kernel.org/linux-btrfs/42758829d8696a471a27f7aaeab5468f60b1565d.1651157034.git.naohiro.aota@wdc.com
> 
I did take a look at this few days back and the patch should work fine
also for npo2 zoned device as we allow only zone sizes that are
BTRFS_STRIPE_LEN aligned. So even the max nodesize for METADATA BGs is
only 64k and it should be aligned correctly to implicitly finish the zone.

Let me know your thoughts and if I am missing something.

Regards,
Pankaj

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

