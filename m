Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C56A8C28D13
	for <dm-devel@archiver.kernel.org>; Thu, 25 Aug 2022 08:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661415881;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=9hmUpXsigT54uPtf+8WOpOgtzPqEZgQZsJlCbxOoJc4=;
	b=JtFFbbnH7gCJ5NGb3a0US58fizRg2ZT9SuCUZd3PWs5GKs5R3QjjNtVaMV3Mm9BK0J2kB+
	1c6+PmQ1px9jPkfAWK7mgp/svhq9IO3tZJnXtxuTGj5RsFETTc2KklA5e5NkmQjkYQFp4P
	/Jmy0Gi5d7T986ryvzEuZmBCUh1DaC4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-crjuvgqwMpuwWzan5W2hPA-1; Thu, 25 Aug 2022 04:24:38 -0400
X-MC-Unique: crjuvgqwMpuwWzan5W2hPA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33E85811130;
	Thu, 25 Aug 2022 08:24:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 10F212166B26;
	Thu, 25 Aug 2022 08:24:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E33FA1946A5A;
	Thu, 25 Aug 2022 08:24:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 822E61946A43
 for <dm-devel@listman.corp.redhat.com>; Thu, 25 Aug 2022 04:35:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2BD491121319; Thu, 25 Aug 2022 04:35:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2753B1121315
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 04:35:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0958C38041CF
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 04:35:11 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-379-MAyue72TPOmvxS_bGL8D8w-1; Thu, 25 Aug 2022 00:35:09 -0400
X-MC-Unique: MAyue72TPOmvxS_bGL8D8w-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20220825042758epoutp025b89c261272bdcc948f0b9e93922b2e1~OfAYzXLFT1091610916epoutp02L
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 04:27:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20220825042758epoutp025b89c261272bdcc948f0b9e93922b2e1~OfAYzXLFT1091610916epoutp02L
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20220825042757epcas5p37271c9b4890ba1ae41c96fc192d5a2a5~OfAYFXIPb2043620436epcas5p31;
 Thu, 25 Aug 2022 04:27:57 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4MCqhD1C4Cz4x9Q4; Thu, 25 Aug
 2022 04:27:56 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 F7.C0.25709.C4AF6036; Thu, 25 Aug 2022 13:27:56 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20220825042755epcas5p1b74cb6accae9ec3f25cc8d15d313fcbc~OfAWHl5GF0167101671epcas5p1C;
 Thu, 25 Aug 2022 04:27:55 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220825042755epsmtrp222750ad10fa10264323e48d4d19a62bd~OfAWGkW9b1831518315epsmtrp2L;
 Thu, 25 Aug 2022 04:27:55 +0000 (GMT)
X-AuditID: b6c32a49-a71ff7000000646d-d3-6306fa4caa0c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 44.EA.14392.B4AF6036; Thu, 25 Aug 2022 13:27:55 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220825042753epsmtip22acbe0211b824db0a2630278fd0ae467~OfAUcmvsI0868208682epsmtip29;
 Thu, 25 Aug 2022 04:27:53 +0000 (GMT)
Date: Thu, 25 Aug 2022 09:48:13 +0530
From: Kanchan Joshi <joshi.k@samsung.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <20220825041813.GA32607@test-zns>
MIME-Version: 1.0
In-Reply-To: <589cb29e-d2aa-085f-db83-fa718f4fbef2@opensource.wdc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHJsWRmVeSWpSXmKPExsWy7bCmhq7PL7Zkg4mX2CymH1a0mPbhJ7PF
 77PnmS32vpvNarFn0SQmi723tC0uPV7BbrFn70kWi8u75rBZTGj7ymxxY8JTRgduj8tXvD02
 repk89jZep/V4/2+q2wefVtWMXpsPl3t8XmTnEf7gW6mAI6obJuM1MSU1CKF1Lzk/JTMvHRb
 Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoCuVFMoSc0qBQgGJxcVK+nY2RfmlJakK
 GfnFJbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZv9rvsBccF6iY/OY0UwPjbL4u
 Rk4OCQETiVun37F0MXJxCAnsZpTYtH0eK0hCSOATo0T3Fy2IxDdGiQ2r57LAdLQ+28AGkdjL
 KLG27TwThPOMUeLMr0WMIFUsAqoSB641AdkcHGwCmhIXJpeChEUETCXe9rSCrWMW+MMssfT2
 MWaQhLBArMT6jjVMIDavgK7E1F9f2CBsQYmTM5+AbeYUcJOY9XU3WFxUQFniwLbjYIslBNZy
 SBxuvckEcZ6LxOpFX5khbGGJV8e3sEPYUhKf3+1lg7CTJS7NPAdVXyLxeM9BKNteovVUP1gv
 s0CGxKUV3VA2n0Tv7ydMIM9ICPBKdLQJQZQrStyb9JQVwhaXeDhjCZTtIfGyqZcdHnR3Vs1h
 ncAoNwvJP7OQrICwrSQ6PzSxzgJawSwgLbH8HweEqSmxfpf+AkbWVYySqQXFuempxaYFhnmp
 5fBITs7P3cQITrhanjsY7z74oHeIkYmD8RCjBAezkgiv1TGWZCHelMTKqtSi/Pii0pzU4kOM
 psD4mcgsJZqcD0z5eSXxhiaWBiZmZmYmlsZmhkrivFO0GZOFBNITS1KzU1MLUotg+pg4OKUa
 mCJqHvjydb5d96hSzHhFxmW9vWdjnTYsyY9YKOMSEbJ2wu0FvN6b3m+v+rROqcJJobQvKWb7
 73Ux3h+ZQrcc31x2fPWrxdzGrOfunE7z3bX7kkHG1/MaET72YueWPbD8s/bm/spG6bVzNYum
 zjjoIx/FW6Hy4rHLWuHLTnodXi+17076dFehI1027sVRv5SyH2/LXPX4PgeVvjJcvU2NSSNY
 2UjvQ+2SS01a8ecqXF+EvVzoY2865z77ryP8my7MabKKs2USkLO+N39T+oMpB9Tbth003XrI
 5NCiSUtcUha95d1zQM/ZJaXqfZ7YQp4t+0UXqb6b7L3I79PH84mM871u32s66vqM/XVG7vwP
 +0OVWIozEg21mIuKEwFJCHwWQQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsWy7bCSvK73L7Zkg1vrVS2mH1a0mPbhJ7PF
 77PnmS32vpvNarFn0SQmi723tC0uPV7BbrFn70kWi8u75rBZTGj7ymxxY8JTRgduj8tXvD02
 repk89jZep/V4/2+q2wefVtWMXpsPl3t8XmTnEf7gW6mAI4oLpuU1JzMstQifbsEroybf76z
 F/zkrbjwML+B8Tl3FyMnh4SAiUTrsw1sXYxcHEICuxkl1jfcZINIiEs0X/vBDmELS6z89xzM
 FhJ4wijRs84UxGYRUJU4cK2JsYuRg4NNQFPiwuRSkLCIgKnE255WFpCZzAINLBJvTl9nBUkI
 C8RKrO9YwwRi8wroSkz99QVq8TdGibb9GxghEoISJ2c+YQGxmQXMJOZtfsgMsoBZQFpi+T8O
 kDCngJvErK+7we4UFVCWOLDtONMERsFZSLpnIemehdC9gJF5FaNkakFxbnpusWGBYV5quV5x
 Ym5xaV66XnJ+7iZGcPxoae5g3L7qg94hRiYOxkOMEhzMSiK8VsdYkoV4UxIrq1KL8uOLSnNS
 iw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpgmiAaerlQqOTmN07t33MV3aJO1P+z
 sWuZdsv4cpr2um3ZV/pY1t5s5fkgpBGxgYn1eLNqTOwX9ua/AZciLWe9eWzizfF++qacsm+f
 Z1dnWzXFnO/z/q7Hy3Orsc8iJZJns8D0NhmGhm4jle1+2zs5ujLcuO5d/TNJIHXG+2ntAU6H
 PIurt18M2t0tPmPiqRMHwl3aZsRn671vO5d6YjK/2ZtTTN+rHeo4zpYEfZXZr/966aYyM/FZ
 WY7WZ9Vczh2UdTfc/ftQxuJVwf1G6vcWeslzKGcc2px3dn+WWc/317tKnOt1k/c+Cf+sy838
 ePuFv+5Z6xf4la91M66ZHr30KEc4x91HJxsXVK69sqRNiaU4I9FQi7moOBEAaSYJoQ4DAAA=
X-CMS-MailID: 20220825042755epcas5p1b74cb6accae9ec3f25cc8d15d313fcbc
X-Msg-Generator: CA
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220522220139uscas1p1e3426b4457e0753c701e9917fe3ec6d2
References: <CGME20220522220139uscas1p1e3426b4457e0753c701e9917fe3ec6d2@uscas1p1.samsung.com>
 <20220522220128.GA347919@bgt-140510-bm01>
 <89b2bb4b-1848-22cc-9814-6cb6726afc18@acm.org>
 <589cb29e-d2aa-085f-db83-fa718f4fbef2@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Thu, 25 Aug 2022 08:24:35 +0000
Subject: Re: [dm-devel] [ANNOUNCE] CFP: Zoned Storage Microconference -
 Linux Plumbers Conference 2022
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
Cc: Bart Van Assche <bvanassche@acm.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Matias Bjorling <Matias.Bjorling@wdc.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "mcgrof@kernel.org" <mcgrof@kernel.org>,
 Adam Manzanares <a.manzanares@samsung.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
 boundary="----_GKj2UxOoZMooFpgW.UaNJF5RnPKrhbpXXK.PgNceyCDa.V5=_a7674_"

------_GKj2UxOoZMooFpgW.UaNJF5RnPKrhbpXXK.PgNceyCDa.V5=_a7674_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Wed, Aug 24, 2022 at 05:15:28PM -0700, Damien Le Moal wrote:
>On 2022/08/24 16:43, Bart Van Assche wrote:
>> On 5/22/22 15:01, Adam Manzanares wrote:
>>> Zoned Storage Devices (SMR HDDs and ZNS SSDs) have demonstrated that they can
>>> improve storage capacity, throughput, and latency over conventional storage
>>> devices for many workloads. Zoned storage technology is deployed at scale in
>>> some of the largest data centers in the world. There's already a
>>> well-established set of storage vendors with increasing device availability and
>>> a mature software foundation for interacting with zoned storage devices is
>>> available. Zoned storage software support is evolving and their is room for
>>> increased file-system support and additional userspace applications.
>>>
>>> The Zoned Storage microconference focuses on evolving the Linux zoned
>>> storage ecosystem by improving kernel support, file systems, and applications.
>>> In addition, the forum allows us to open the discussion to incorporate and grow
>>> the zoned storage community making sure to meet everyone's needs and
>>> expectations. Finally, it is an excellent opportunity for anyone interested in
>>> zoned storage devices to meet and discuss how we can move the ecosystem forward
>>> together.
>>
>> Hi Adam,
>>
>> On https://protect2.fireeye.com/v1/url?k=755e6c2c-14d5791a-755fe763-000babff9b5d-6defb9d76a932655&q=1&e=e97b90a0-a315-4359-9fee-2976775b532e&u=https%3A%2F%2Flpc.events%2Fevent%2F16%2Fcontributions%2F1147%2F I see four speakers
>> but no agenda? Will an agenda be added before the microconference starts?
>
>And the speaker list is not up-to-date either. I am a speaker too :)

This page shows the agenda: https://lpc.events/event/16/sessions/149/#20220914

------_GKj2UxOoZMooFpgW.UaNJF5RnPKrhbpXXK.PgNceyCDa.V5=_a7674_
Content-Type: text/plain; charset="utf-8"


------_GKj2UxOoZMooFpgW.UaNJF5RnPKrhbpXXK.PgNceyCDa.V5=_a7674_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------_GKj2UxOoZMooFpgW.UaNJF5RnPKrhbpXXK.PgNceyCDa.V5=_a7674_--

