Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B4D6C54EE9
	for <dm-devel@archiver.kernel.org>; Thu, 22 Sep 2022 11:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663847598;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=urlemyTqdcDV1Zdi4b+cY4kD2D5JtWUFd9GYdTRkp9w=;
	b=iGVxuQAEGtv+YMAJAi7qfUjDGswSA0alPW9AhAIE+JCGtzBuctD0CGxGGdy3G5NPexUWCT
	8M9VsyqKBomLbd9EXpIixuciIBVDBdBK/O6litePZKhFyZv7QjV9Z59fF1e1ptVs2yJHQv
	qy2ZFFdMIiN/DOQssFK2mq2fQBYWYPE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-StfLniyfP2y7raxdr8J39A-1; Thu, 22 Sep 2022 07:53:15 -0400
X-MC-Unique: StfLniyfP2y7raxdr8J39A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7016C1C07555;
	Thu, 22 Sep 2022 11:53:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 53148140EBF4;
	Thu, 22 Sep 2022 11:53:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 134B019465B5;
	Thu, 22 Sep 2022 11:53:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A5FBE19465A4
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Sep 2022 11:53:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 90BF8140EBF5; Thu, 22 Sep 2022 11:53:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 892D8140EBF4
 for <dm-devel@redhat.com>; Thu, 22 Sep 2022 11:53:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E755811E87
 for <dm-devel@redhat.com>; Thu, 22 Sep 2022 11:53:09 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-tpUxAWucOC-crtmaS-VUiA-1; Thu, 22 Sep 2022 07:53:07 -0400
X-MC-Unique: tpUxAWucOC-crtmaS-VUiA-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220922115306euoutp0163d8f01a924cbe2353836840df5994a3~XLJCNtyx71214712147euoutp01n
 for <dm-devel@redhat.com>; Thu, 22 Sep 2022 11:53:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220922115306euoutp0163d8f01a924cbe2353836840df5994a3~XLJCNtyx71214712147euoutp01n
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220922115306eucas1p12b7db3f20df086bdff2ff3400cd52ca1~XLJB7_SLs2018120181eucas1p1Y;
 Thu, 22 Sep 2022 11:53:06 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id DF.89.07817.2AC4C236; Thu, 22
 Sep 2022 12:53:06 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220922115305eucas1p1b862ce6603248112d2b0836f37f922f2~XLJBZmEFt3156431564eucas1p1O;
 Thu, 22 Sep 2022 11:53:05 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220922115305eusmtrp15dccd4d9687bb0f6a554d7a41d80da06~XLJBYjnIZ2733027330eusmtrp1l;
 Thu, 22 Sep 2022 11:53:05 +0000 (GMT)
X-AuditID: cbfec7f4-8abff70000011e89-3b-632c4ca25f3a
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 6F.97.07473.1AC4C236; Thu, 22
 Sep 2022 12:53:05 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20220922115305eusmtip2f92eefce3c8f8d5f30b16cc3aebb9e87~XLJBOExt23183331833eusmtip2e;
 Thu, 22 Sep 2022 11:53:05 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.168) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Thu, 22 Sep 2022 12:53:03 +0100
Message-ID: <b393c127-b773-8296-a559-83606077aa1c@samsung.com>
Date: Thu, 22 Sep 2022 13:53:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>, Mike Snitzer
 <snitzer@redhat.com>, <axboe@kernel.dk>, <hch@lst.de>, Keith Busch
 <kbusch@kernel.org>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <7dd9dbc0-b08b-fa47-5452-d448d86ca56b@opensource.wdc.com>
X-Originating-IP: [106.210.248.168]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsWy7djP87qLfHSSDfY2CVusP3WM2WL13X42
 i2kffjJb/D57ntli77vZrBYrVx9lsniyfhazxd+ue0wWkw5dY7TYe0vb4vKuOWwW85c9ZbeY
 0PaV2WLNzacsFiduSVu0bfzK6CDgcfmKt8fOWXfZPS6fLfXYtKqTzWPzknqP3Tcb2Dx2tt5n
 9Xi/7yqbx+dNch7tB7qZAriiuGxSUnMyy1KL9O0SuDJuf/nHUtDCV/Fk2wuWBsap3F2MnBwS
 AiYSf1Z/Z+li5OIQEljBKNHZcYoRwvnCKHHz1Cc2COczo8SSJZ1sMC0XmrcyQySWM0pM/NTB
 Dle1c8ZvJghnN6PEgwO/WUBaeAXsJP7vmc0KYrMIqEo8mnGTGSIuKHFy5hOwGlGBSIk1u8+C
 TRIWmM8oca39IFiCWUBc4taT+WBTRQTmMUrMuneQFSJxgEli3iu/LkYODjYBLYnGTnaQMKeA
 m8S8Z/vYIEo0JVq3/2aHsOUltr+dwwzxg7LE8tMzoexaibXHzoAtlhB4xilx6+caqISLxLmT
 75kgbGGJV8e3sEPYMhKnJ/ewQNjVEk9v/GaGaG5hlOjfuZ4N5CAJAWuJvjM5EDWOEg/fLmGG
 CPNJ3HgrCHEPn8SkbdOZJzCqzkIKi1lIXp6F5IVZSF5YwMiyilE8tbQ4Nz212CgvtVyvODG3
 uDQvXS85P3cTIzAdnv53/MsOxuWvPuodYmTiYDzEKMHBrCTCO/uOZrIQb0piZVVqUX58UWlO
 avEhRmkOFiVxXrYZWslCAumJJanZqakFqUUwWSYOTqkGpt2TX++Q91p1WeVcXLx4krnXYlOx
 5SJe0zbWN2krM4ebNekwmq8RzFtzWOTOom/uPUc/yirLfE2/avolekKf9roW7cc2EQtbJ/NG
 MKtOEtr0Y3vI/+TlYXUT/3r/smQTaXvMtYerf83xadWPlEo2J2Z1ZSpanLbZ8kumdIcCC2Nj
 jYWD6vvol2lSk67OuHXsfeyN8K/GEx9fmeliw2Iau2jiHaO7N56Gzt+1+eeDc/+iVQ97rHYI
 qXKtSp3wbIW1/dZN9+sW/RKzrrJdOemgTOD5Cu9VfYFT3My9fol8WNQrIHpD02HXIrkwxbup
 i0M+cO7N5So19Tnu2HhgwUKve01/JMN0Djo1up1k+ak+VYmlOCPRUIu5qDgRAPO4N0/2AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t/xe7oLfXSSDXbv0rVYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1Wrj7KZPFk/Sxmi79d95gsJh26xmix95a2xeVdc9gs5i97ym4x
 oe0rs8Wam09ZLE7ckrZo2/iV0UHA4/IVb4+ds+6ye1w+W+qxaVUnm8fmJfUeu282sHnsbL3P
 6vF+31U2j8+b5DzaD3QzBXBF6dkU5ZeWpCpk5BeX2CpFG1oY6RlaWugZmVjqGRqbx1oZmSrp
 29mkpOZklqUW6dsl6GXc/vKPpaCFr+LJthcsDYxTubsYOTkkBEwkLjRvZe5i5OIQEljKKLGw
 6yELREJG4tOVj+wQtrDEn2tdbBBFHxklHny+zwLh7GaUWHPxHytIFa+AncT/PbPBbBYBVYlH
 M24yQ8QFJU7OfAI2VVQgUuLhsiYmkGZhgbmMEoe+LAJLMAuIS9x6Mh8sISIwj1Fi1r2DrCAO
 s8A+JokrX89CXfiCUeLJ20+MXYwcHGwCWhKNnWAHcgq4Scx7to8NYpKmROv23+wQtrzE9rdz
 mCGeUJZYfnomlF0r8er+bsYJjKKzkFw4C8khs5CMmoVk1AJGllWMIqmlxbnpucWGesWJucWl
 eel6yfm5mxiBaWTbsZ+bdzDOe/VR7xAjEwfjIUYJDmYlEd7ZdzSThXhTEiurUovy44tKc1KL
 DzGaAoNpIrOUaHI+MJHllcQbmhmYGpqYWRqYWpoZK4nzehZ0JAoJpCeWpGanphakFsH0MXFw
 SjUwGe5TfJyhXjxpTY3dJHXF2NJIw/Ds8uNrnXhF/PjmLDTNyK0rNXl5lS3k5sopU193fDAo
 dJ7VJyCc66K6YjaD/Pktd56ESaq9nZmt+fDZEslH6V+iO2QnfzGf7jpB5cZ7U9GMW5Unfk7d
 vZpxt8Eu1XUrD/331Mmr83Bl6JMouDt30aHymbfFs0r/Pos4r6xyxU0/ZVP+ojPMZ51PcmsU
 Xt7ddzh1VsPFrIdReusPP1qkqPFE9uHMNQJmh+xlWwPc53Nczpm5urtfIzJr4WH3Y5GhBxfU
 spd0rct/3jDHi1kgtZ1t9hY/Rb8b73MFpXb9aipNWeYh53thU5bqVDPDFYpqJgee7Z7iJqj6
 5IasEktxRqKhFnNRcSIAtXBZ3qwDAAA=
X-CMS-MailID: 20220922115305eucas1p1b862ce6603248112d2b0836f37f922f2
X-Msg-Generator: CA
X-RootMTR: 20220920091120eucas1p2c82c18f552d6298d24547cba2f70b7fc
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220920091120eucas1p2c82c18f552d6298d24547cba2f70b7fc
References: <CGME20220920091120eucas1p2c82c18f552d6298d24547cba2f70b7fc@eucas1p2.samsung.com>
 <20220920091119.115879-1-p.raghav@samsung.com> <YytJhEywBhqcr7MX@redhat.com>
 <7dd9dbc0-b08b-fa47-5452-d448d86ca56b@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] Please further explain Linux's "zoned storage"
 roadmap [was: Re: [PATCH v14 00/13] support zoned block devices with
 non-power-of-2 zone sizes]
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
Cc: bvanassche@acm.org, pankydev8@gmail.com, gost.dev@samsung.com,
 snitzer@kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, matias.bjorling@wdc.com, Johannes.Thumshirn@wdc.com,
 jaegeuk@kernel.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Thanks a lot Damien for the summary. Your feedback has made this series
much better.

> Pankaj patch series is all about supporting ZNS devices that have a zone
> size that is not a power of 2 number of LBAs as some vendors want to
> produce such drives. There is no such move happening in the SMR world as
> all users are happy with the current zone sizes which match the kernel
> support (which currently requires power-of-2 number of LBAs for the zone
> size).
> 
> I do not think we have yet reached a consensus on if we really want to
> accept any zone size for zoned storage. I personally am not a big fan of
> removing the existing constraint as that makes the code somewhat heavier
> (multiplication & divisions instead of bit shifts) without introducing any
> benefit to the user that I can see (or agree with). And there is also a
> risk of forcing onto the users to redesign/change their code to support
> different devices in the same system. That is never nice to fragment
> support like this for the same device class. This is why several people,
> including me, requested something like dm-po2zoned, to avoid breaking user
> applications if non-power-of-2 zone size drives support is merged. Better
> than nothing for sure, but not ideal either. That is only my opinion.
> There are different opinions out there.

I appreciate that you have explained the different perspectives. We have
covered this written and orally, and it seems to me that we have a good
coverage of the arguments in the list.

At this point, I would like to ask the opinion of Jens, Christoph and
Keith. Do you think we are missing anything in the series? Can this be
queued up for 6.1 (after I send the next version with a minor fix suggested
by Mike)?

--
Regards,
Pankaj

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

