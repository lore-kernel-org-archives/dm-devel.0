Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EBB9C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 17 May 2022 08:00:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-zXt5QksuPGKfa1cyE-8m3A-1; Tue, 17 May 2022 04:00:49 -0400
X-MC-Unique: zXt5QksuPGKfa1cyE-8m3A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 607E4803D47;
	Tue, 17 May 2022 08:00:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 48B2D2026D64;
	Tue, 17 May 2022 08:00:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1BD141947063;
	Tue, 17 May 2022 08:00:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EFF6E194705F
 for <dm-devel@listman.corp.redhat.com>; Tue, 17 May 2022 08:00:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E1399400E400; Tue, 17 May 2022 08:00:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DC5C840C1438
 for <dm-devel@redhat.com>; Tue, 17 May 2022 08:00:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2E14803D45
 for <dm-devel@redhat.com>; Tue, 17 May 2022 08:00:45 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-zcOhrAM6OkWiFDMq3PhdFw-1; Tue, 17 May 2022 04:00:43 -0400
X-MC-Unique: zcOhrAM6OkWiFDMq3PhdFw-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220517080042euoutp028d3ef686d18c0272c0cb8528d3dafc91~v1ZlabHPd1742017420euoutp02F
 for <dm-devel@redhat.com>; Tue, 17 May 2022 08:00:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220517080042euoutp028d3ef686d18c0272c0cb8528d3dafc91~v1ZlabHPd1742017420euoutp02F
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220517080041eucas1p24bc8b50fe287967bcd8dc73669c11d32~v1Zkg2fD-0241602416eucas1p2j;
 Tue, 17 May 2022 08:00:41 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id B6.44.10009.92653826; Tue, 17
 May 2022 09:00:41 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220517080041eucas1p227e0a5d81f7b9b018c2e8f38b74d3aff~v1ZkEScpL1149811498eucas1p2k;
 Tue, 17 May 2022 08:00:41 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220517080041eusmtrp25e844b307bbeb73179ae75e18bd42416~v1ZkDZe662741427414eusmtrp2B;
 Tue, 17 May 2022 08:00:41 +0000 (GMT)
X-AuditID: cbfec7f2-e95ff70000002719-1f-62835629f1a7
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 26.48.09522.92653826; Tue, 17
 May 2022 09:00:41 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220517080041eusmtip14c1a1beb38bfd07fa000460be6ca25fa~v1Zj2h0za1378313783eusmtip1b;
 Tue, 17 May 2022 08:00:41 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.7) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Tue, 17 May 2022 09:00:39 +0100
Message-ID: <8fc4e862-fa89-2d8d-b340-27a6465b59ca@samsung.com>
Date: Tue, 17 May 2022 10:00:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, "axboe@kernel.dk"
 <axboe@kernel.dk>, "damien.lemoal@opensource.wdc.com"
 <damien.lemoal@opensource.wdc.com>, "pankydev8@gmail.com"
 <pankydev8@gmail.com>, "dsterba@suse.com" <dsterba@suse.com>, "hch@lst.de"
 <hch@lst.de>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <PH0PR04MB7416DFEC00A21B533E86110E9BCE9@PH0PR04MB7416.namprd04.prod.outlook.com>
X-Originating-IP: [106.210.248.7]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMKsWRmVeSWpSXmKPExsWy7djPc7qaYc1JBqf3mFisvtvPZvH77Hlm
 i73vZrNaXPjRyGSxcvVRJoueAx9YLP523WOy2HtL2+LS4xXsFnv2nmSxuLxrDpvF/GVP2S3W
 3HzK4sDr8e/EGjaPnbPusntcPlvqsXlJvcfumw1Akdb7rB7v911l81i/5SqLx+dNch7tB7qZ
 AriiuGxSUnMyy1KL9O0SuDJ6dl9gK2jnqli49zdTA+M/9i5GTg4JAROJgzP+MHYxcnEICaxg
 lLjZ84QJwvnCKHF2zTwWCOczo8SGV88YYVrmzPnLCpFYzijx9MQadriqLzsusEE4Oxklrrev
 YwFp4RWwk7gz4SqYzSKgKtE2u4cVIi4ocXLmE7C4qECExLRZZ4CaOTiEBVIkdqwsAgkzC4hL
 3HoynwnEFhGYxiRxdKsVRPwRs8T2I0Eg5WwCWhKNnWD/cArEShyd95YdokRTonX7byhbXmL7
 2znMEA8oStxc+YsNwq6VWHvsDNj9EgLnOCVaGxdDFblI3HzayAphC0u8Or4FGmAyEv93Qtwj
 IVAt8fTGb2aI5hZGif6d68HulxCwlug7kwNR4yhx6dtnZogwn8SNt4IQ9/BJTNo2nXkCo+os
 pICYheTjWUhemIXkhQWMLKsYxVNLi3PTU4sN81LL9YoTc4tL89L1kvNzNzEC093pf8c/7WCc
 ++qj3iFGJg7GQ4wSHMxKIrwGFQ1JQrwpiZVVqUX58UWlOanFhxilOViUxHmTMzckCgmkJ5ak
 ZqemFqQWwWSZODilGpjUrwWtnpxQY3PPcJ1rxL/fRnF1l/6cnsx8vU12nTC75daI3SV/Hp04
 9i7yygrlleyHL/54sOASg1cNy77JT5pPZ/29dfLF3OgP8Tpv/0pbpdV1+ws8PhkQLqPQkvmz
 4v1+jss+0ZbNF+ZEWUy6xlM3M+9rX2Pe9zhzK69ZxSIvan0t3hu+m123aWaJznWhMLu929eI
 P/m8o7bZapPA8rSmfaES69borV+40rtA2v7HW7/d2fwtqeXNnxbNFjVIm1ds1KhieGTH/eCN
 Ptf/Fh1Z9eep/nXO9PoWkdPv7y6oD3plUbkhev6MI0oyjzXK3kglzpjeFcHFw+P1srd4uucR
 6+/V0Y0blXaa7itLM2hUYinOSDTUYi4qTgQAjB1Qu+YDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e/4XV3NsOYkg4bLQhar7/azWfw+e57Z
 Yu+72awWF340MlmsXH2UyaLnwAcWi79d95gs9t7Strj0eAW7xZ69J1ksLu+aw2Yxf9lTdos1
 N5+yOPB6/Duxhs1j56y77B6Xz5Z6bF5S77H7ZgNQpPU+q8f7fVfZPNZvucri8XmTnEf7gW6m
 AK4oPZui/NKSVIWM/OISW6VoQwsjPUNLCz0jE0s9Q2PzWCsjUyV9O5uU1JzMstQifbsEvYye
 3RfYCtq5Khbu/c3UwPiPvYuRk0NCwERizpy/rCC2kMBSRok5P7kh4jISn658hKoRlvhzrYsN
 ouYjo8T7P8pdjFxA9k5GiSkXzzGBJHgF7CTuTLjKAmKzCKhKtM3uYYWIC0qcnPkELC4qECHx
 YPdZsLiwQIrEo0+zwWxmAXGJW0/mg80REZjGJHF0qxXIAmaBB8wSaw5+YIbYNolJYsaLXqAz
 ODjYBLQkGjvBruMUiJU4Ou8tO8QgTYnW7b+hbHmJ7W/nMEN8oChxc+UvNgi7VuLV/d2MExhF
 ZyG5bxaSO2YhGTULyagFjCyrGEVSS4tz03OLDfWKE3OLS/PS9ZLzczcxApPEtmM/N+9gnPfq
 o94hRiYOxkOMEhzMSiK8BhUNSUK8KYmVValF+fFFpTmpxYcYTYGBNJFZSjQ5H5im8kriDc0M
 TA1NzCwNTC3NjJXEeT0LOhKFBNITS1KzU1MLUotg+pg4OKUamMIdPqa7JbyZpmDiyaW8iMOJ
 ccJv7QAGqdnV8QdjNbZlmxw57cxnVvqwLXTj6b8e899V/Q7fH2J19eJPbpV9VR7b7rwNvsaz
 csbqj9f28Cz7EdN8bvmPKcI/zvJ9eh0x5eXC8xNsI3QDV0+IuFm44NqcgIoL61k31r+94Sv+
 yyZzTtz5HN0szWObGtIPb9fKVLi69I60Ro7/uw8x5lkrzu/4eUKQa86PmHlTRa+6/yr/G/o6
 QPPOJV4H5dduZ6fdryvXKwl9Ej13V0dxqcme3ZnTNn8+McObaUXpVt+rq9j4mnbwfHJj2Ry4
 xLS2V7/U6sbd7eZP7UO53l7Q/RMR96JDW/FO+sLN5xaGLft767ipEktxRqKhFnNRcSIAYEKl
 5JsDAAA=
X-CMS-MailID: 20220517080041eucas1p227e0a5d81f7b9b018c2e8f38b74d3aff
X-Msg-Generator: CA
X-RootMTR: 20220516165429eucas1p272c8b4325a488675f08f2d7016aa6230
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220516165429eucas1p272c8b4325a488675f08f2d7016aa6230
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165429eucas1p272c8b4325a488675f08f2d7016aa6230@eucas1p2.samsung.com>
 <20220516165416.171196-9-p.raghav@samsung.com>
 <PH0PR04MB7416DFEC00A21B533E86110E9BCE9@PH0PR04MB7416.namprd04.prod.outlook.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
Cc: "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
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

On 2022-05-17 08:50, Johannes Thumshirn wrote:
> On 16/05/2022 18:55, Pankaj Raghav wrote:
>> Superblocks for zoned devices are fixed as 2 zones at 0, 512GB and 4TB.
>> These are fixed at these locations so that recovery tools can reliably
>> retrieve the superblocks even if one of the mirror gets corrupted.
>>
>> power of 2 zone sizes align at these offsets irrespective of their
>> value but non power of 2 zone sizes will not align.
>>
>> To make sure the first zone at mirror 1 and mirror 2 align, write zero
>> operation is performed to move the write pointer of the first zone to
>> the expected offset. This operation is performed only after a zone reset
>> of the first zone, i.e., when the second zone that contains the sb is FULL.
> 
> Hi Pankaj, stupid question. Npo2 devices still have a zone size being a 
> multiple of 4k don't they?
> 
> If not, we'd need to also have a tail padding of the superblock zones, in order
> to move the WP of these zones to the end, so the sb-log states match up.
Hi Johannes,
NPO2 zoned devices has a minimum alignment requirement of 1MB. See
commit: `btrfs: zoned: relax the alignment constraint for zoned devices`

It will naturally align to 4k. So I don't think we need special handling
there with tail padding.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

