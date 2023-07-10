Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43EEBEB64DA
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688970568;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=WruSCfct0V9r4DAkrxzn/1n9i2587aBHAg1ehR5ksKI=;
	b=Kdr4ZzpkHLgS28VkYdB7IAIdJclAs/+OjTuMP6A3GJZ2oFeAVB3X67oB4msnaiHTQfaez2
	ERnynGTUFT1DbBaaw+a0melu1cvuf/VWbKyC1UDQAaSKaMmffj9GBK45mRAdxHJPw0w4X6
	ICcnxrrO89E3eaCi6opah5w+XfHstGs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-2R2GYBJMPIiNua2ET-wQ-Q-1; Mon, 10 Jul 2023 02:29:24 -0400
X-MC-Unique: 2R2GYBJMPIiNua2ET-wQ-Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 827933C0ED45;
	Mon, 10 Jul 2023 06:29:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8288DF5CED;
	Mon, 10 Jul 2023 06:29:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D96D419452D1;
	Mon, 10 Jul 2023 06:29:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A27DF1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 10 Jul 2023 06:29:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0993D40C2070; Mon, 10 Jul 2023 06:29:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0129840C206F
 for <dm-devel@redhat.com>; Mon, 10 Jul 2023 06:29:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6DEB38008A4
 for <dm-devel@redhat.com>; Mon, 10 Jul 2023 06:29:02 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-7oFL3zJYPLegBlvfyhds7w-1; Mon, 10 Jul 2023 02:29:00 -0400
X-MC-Unique: 7oFL3zJYPLegBlvfyhds7w-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230710062857epoutp02e94980f838680bc6bf78b479f1889625~wbcFQezxY1907019070epoutp02f
 for <dm-devel@redhat.com>; Mon, 10 Jul 2023 06:28:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230710062857epoutp02e94980f838680bc6bf78b479f1889625~wbcFQezxY1907019070epoutp02f
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20230710062856epcas5p2880af543580e2063d281acd332e97161~wbcEompir0427004270epcas5p2q;
 Mon, 10 Jul 2023 06:28:56 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4QzvGb2Td5z4x9Q7; Mon, 10 Jul
 2023 06:28:55 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 AE.14.44250.725ABA46; Mon, 10 Jul 2023 15:28:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
 20230710061719epcas5p36b7be425517b0b09d73540b18fc17748~wbR7vCBu91195211952epcas5p3V;
 Mon, 10 Jul 2023 06:17:19 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230710061719epsmtrp1bebd27292cfbc5654c3251e1e80611db~wbR7t2fVC1310913109epsmtrp1d;
 Mon, 10 Jul 2023 06:17:19 +0000 (GMT)
X-AuditID: b6c32a4a-ec1fd7000000acda-96-64aba52792cd
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
 86.2E.64355.F62ABA46; Mon, 10 Jul 2023 15:17:19 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20230710061715epsmtip1965f1b463cf314395eb9ac24b4926cc0~wbR3v5VNB2634026340epsmtip1p;
 Mon, 10 Jul 2023 06:17:15 +0000 (GMT)
Date: Mon, 10 Jul 2023 11:44:01 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <20230710061401.43uzki644sw5jagz@green245>
MIME-Version: 1.0
In-Reply-To: <ZIKphgDavKVPREnw@infradead.org>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTdxTH+d3b3hYZ5gISf+ADcjed4MDWlfJDYC6DmOtwhCmbi1nCOnpH
 EWibPsacMVIY76f4GHSggiDPQaBsAwHHygAFtFuYNBJgMAuLNhPkoSIKoy26/fc553tev3Py
 4+LOXRx3bqxUxSikoniK2MD6sdvL2+fNyjoxr2neATX29+IoueAFjurG8glk7p4D6MLsEo5M
 XekADZk2oomf96POh9+x0d2uNgx1lBdiaKCgHEM1dT0Yai97hKF7o/Mc1LP6D4EK9cMATd3R
 YqhzZDcqS6tgoY7Omyw0dK2EQJeuTnFQtrGVQFV9KxjSn03BUKtJA1CDeYaFboxsQYYXfWy0
 /LSEeNeDHvojjNb+eYug27RjHNow3sSiddXe9NAtNd1cm0nQuorTdPvdJIK+kneWTeemPCTo
 R1MjLHrm+h2CzmupBbRu4CQ937w9wulYXJCEEYkZhScjjZaJY6UxwVTYkaiQKD8hj+/DD0D+
 lKdUlMAEU6GHInwOxMavLYvy/FIUr15zRYiUSmrPO0EKmVrFeEpkSlUwxcjF8XKB3FcpSlCq
 pTG+Uka1j8/j7fVbC/wsTjKgKcLkTx2/KikewZLArw5ZgMuFpACOzLlkgQ1cZ7IdwNkryWyb
 MQdgzfVlziujP28WzwL21oyczEHcJrQBeL/XaBWcyWkAMxY/sTCL3AEXdSssSwuC3A0HVrkW
 9ybSC45UpVtzcbKbA58YilkWwYUMhBNGs7WOIymE2fUGzMZO8GaxyRpjT/rAwccTwMKu5FZY
 VLloLQTJOXs4+ff8+nShsOeqFrOxC3zQ18KxsTu8n5+2zomw5lw1YUv+BkCtUQtswn6Y2p+P
 W6bGSQkcngm2ubfB8/0N1po4uRHmLpvW6zvC1osv+XVY33iZsLEbHH6iWWcaNv32nLBtawWD
 5uUfsALgof3f47T/tdNaW+yDmbPJbJt7C6xa4drQCzZe23MZsGuBGyNXJsQwSj/5XimT+Ore
 0bKEZmD9St7vt4LJiVlfPcC4QA8gF6c2Ocp/qRU7O4pFJ75mFLIohTqeUeqB39qtzuDurtGy
 tb8oVUXxBQE8gVAoFAS8LeRTmx3NqaViZzJGpGLiGEbOKF7mYVx79ySsdGYq91N1JL388cKR
 3oPZ7gsZnP4Wu2ctAceCawsCW9+KvMjmrvIwVkiVUWoXdO40Si2Qbf0w6EEF5jTuOlgtonSB
 C4KsRVMa16xVSwKC83cuOZQ3VxY+X5R8UaSXq/yLPndr1LdFnH+syPn+g8EAu9SyjNLbyyEd
 r9HhodsPjrJ+H50rOZk4tC3mRgN2KezZEl4J+KW5FMPfWRZ5RvfRYXZ2UPqpbz3uaVKO4yeK
 04iJo+7e0dm7Mu1NRr15MHDVkFQhv3D7Df3h5hQwm6n5Kyd9TK6pPz5t7KIivfJDDUen/fm8
 0r7xWKV/1S5TuND1lH3ET+FZZYd2vDc1udmBYiklIr43rlCK/gWa8eSm0wQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsWy7bCSnG7+otUpBnP36VmsP3WM2aJpwl9m
 i9V3+9ksXh/+xGgx7cNPZosnB9oZLS4/4bN4sN/eYu+72awWNw/sZLLYs2gSk8XpCYuYLFau
 PspksXvhRyaLx3c+s1sc/f+WzWLSoWuMFk+vzmKy2HtL22Jh2xIWiz17T7JYXN41h81i/rKn
 7Bbd13ewWSw//o/J4tDkZiaLHU8aGS3WvX7PYnHilrTF+b/HWS1+/5jD5iDvcfmKt8es+2fZ
 PHbOusvucf7eRhaPzSu0PC6fLfXYtKqTzWPzknqP3Tcb2DwW901m9ehtfsfm8fHpLRaP9/uu
 snn0bVnF6LH5dLXH501yAYJRXDYpqTmZZalF+nYJXBnXTnUzF6ziruhqbGBvYJzA2cXIySEh
 YCLR03mGuYuRi0NIYDujxP97e9kgEpISy/4eYYawhSVW/nvODmILCTxhlJizyAjEZhFQlfi6
 +R9LFyMHB5uAtsTp/xwgYREBTYlby9vBZjILHGeX2LF5BwtIQljAWuLB9ddgM3kFzCS615xn
 gljcxCxx4HgXK0RCUOLkzCdgDcxARfM2P2QGWcAsIC2x/B/YAk4BXYkz3x4wgtiiAjISM5Z+
 ZZ7AKDgLSfcsJN2zELoXMDKvYhRNLSjOTc9NLjDUK07MLS7NS9dLzs/dxAhOI1pBOxiXrf+r
 d4iRiYPxEKMEB7OSCG/BwVUpQrwpiZVVqUX58UWlOanFhxilOViUxHmVczpThATSE0tSs1NT
 C1KLYLJMHJxSDUzMh+RcBTh2ehzl4HRosmI99OVHYN3f5oS0m1JfDv7ZoOeWq5//6o3VgbIb
 E66/TKi7+lSF52+9gAWfXli8gXBX/Z7Pny9Hxe+WnRKvuT7kU+PNFc3zhN5EuV1LO+z/Wj1r
 J+dNz1XeUgVOdbf0Oo7JzN+0KfvR7fNnOp/nvBQqNV93uMEwOluwUrSR/4PjSffmZU9Yrh02
 POe4e/H0u+pBJ3LOG55k9HylE9T+9DFnm3vEcr0bnk92fHa99c84MjO8e+/M7ftUBR+xSeun
 7Nh62kr/oUiac9gM40n27xrjpb/kbfVYscvqZqbH/phTBcIyf/Re3HDzS3nSkSx2uO7+erP7
 v3daugYtqBOaX6rEUpyRaKjFXFScCACXJ/QPkgMAAA==
X-CMS-MailID: 20230710061719epcas5p36b7be425517b0b09d73540b18fc17748
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230605122310epcas5p4aaebfc26fe5377613a36fe50423cf494
References: <20230605121732.28468-1-nj.shetty@samsung.com>
 <CGME20230605122310epcas5p4aaebfc26fe5377613a36fe50423cf494@epcas5p4.samsung.com>
 <20230605121732.28468-6-nj.shetty@samsung.com>
 <ZH3mjUb+yqI11XD8@infradead.org> <20230606113535.rjbhe6eqlyqk4pqq@green245>
 <ZIAt7vL+/isPJEl5@infradead.org> <20230608120817.jg4xb4jhg77mlksw@green245>
 <ZIKphgDavKVPREnw@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v12 5/9] nvme: add copy offload support
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
Cc: linux-doc@vger.kernel.org, djwong@kernel.org,
 linux-nvme@lists.infradead.org, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, gost.dev@samsung.com,
 nitheshshetty@gmail.com, James Smart <james.smart@broadcom.com>,
 willy@infradead.org, Chaitanya Kulkarni <kch@nvidia.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Mike Snitzer <snitzer@kernel.org>,
 ming.lei@redhat.com, linux-block@vger.kernel.org, dlemoal@kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 bvanassche@acm.org, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>, Kanchan Joshi <joshi.k@samsung.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----RbnLpepSOhDWt1JmDV6HMUWO9Dmn-C3OOrycHY1seGoKI43i=_b1f2d_"

------RbnLpepSOhDWt1JmDV6HMUWO9Dmn-C3OOrycHY1seGoKI43i=_b1f2d_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/06/08 09:24PM, Christoph Hellwig wrote:
>On Thu, Jun 08, 2023 at 05:38:17PM +0530, Nitesh Shetty wrote:
>> Sure, we can do away with subsys and realign more on single namespace copy.
>> We are planning to use token to store source info, such as src sector,
>> len and namespace. Something like below,
>>
>> struct nvme_copy_token {
>> 	struct nvme_ns *ns; // to make sure we are copying within same namespace
>> /* store source info during *IN operation, will be used by *OUT operation */
>> 	sector_t src_sector;
>> 	sector_t sectors;
>> };
>> Do you have any better way to handle this in mind ?
>
>In general every time we tried to come up with a request payload that is
>not just data passed to the device it has been a nightmare.
>
>So my gut feeling would be that bi_sector and bi_iter.bi_size are the
>ranges, with multiple bios being allowed to form the input data, similar
>to how we implement discard merging.
>
>The interesting part is how we'd match up these bios.  One idea would
>be that since copy by definition doesn't need integrity data we just
>add a copy_id that unions it, and use a simple per-gendisk copy I/D
>allocator, but I'm not entirely sure how well that interacts stacking
>drivers.

V13[1] implements that route. Please see if that matches with what you had
in mind?

[1] https://lore.kernel.org/linux-nvme/20230627183629.26571-1-nj.shetty@samsung.com/

Thank you, 
Nitesh Shetty

------RbnLpepSOhDWt1JmDV6HMUWO9Dmn-C3OOrycHY1seGoKI43i=_b1f2d_
Content-Type: text/plain; charset="utf-8"


------RbnLpepSOhDWt1JmDV6HMUWO9Dmn-C3OOrycHY1seGoKI43i=_b1f2d_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------RbnLpepSOhDWt1JmDV6HMUWO9Dmn-C3OOrycHY1seGoKI43i=_b1f2d_--

