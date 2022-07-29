Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2910AC00144
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jul 2022 09:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659085773;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qYAzAP3euenmu35qN0934a5J69/7Sf+2Ys3J3S0g2K0=;
	b=YLjdF1Ede/kSeYXLFD7tnAZD72x5UzGWmlUxjNieT/AI1QF1TlwGp1AkET90/Q7orqDjW3
	CSXVGDdM51MW/MiZmGizx5V7T/z3TpP+aUg5QdpkXm4Vb/Wj8Tomqw/3Ex85qPn4i/z3U8
	I+iIkTJ0ZUAUjGEbQRHY+/J3KAIldiE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-iytj1U86NE2t2WuzYb_iCQ-1; Fri, 29 Jul 2022 05:09:30 -0400
X-MC-Unique: iytj1U86NE2t2WuzYb_iCQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5126F85A584;
	Fri, 29 Jul 2022 09:09:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E095140C1288;
	Fri, 29 Jul 2022 09:09:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A76441932120;
	Fri, 29 Jul 2022 09:09:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 92313193211F
 for <dm-devel@listman.corp.redhat.com>; Fri, 29 Jul 2022 09:09:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7A88F40CFD0A; Fri, 29 Jul 2022 09:09:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 769EC40CF8E8
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 09:09:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F3788032F1
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 09:09:27 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-r-eV_JyNMHuhmIwOZbeTtA-1; Fri, 29 Jul 2022 05:09:20 -0400
X-MC-Unique: r-eV_JyNMHuhmIwOZbeTtA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220729090918euoutp01a34ad14fe9b6ee1907b9fdf07a12da42~GQbUbnrfT1104111041euoutp01D
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 09:09:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220729090918euoutp01a34ad14fe9b6ee1907b9fdf07a12da42~GQbUbnrfT1104111041euoutp01D
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220729090918eucas1p2789e2f8c650aa31e0ecec8f1d2aff3d6~GQbUD7Cv72990229902eucas1p2D;
 Fri, 29 Jul 2022 09:09:18 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id A5.C1.09580.EB3A3E26; Fri, 29
 Jul 2022 10:09:18 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220729090918eucas1p1782d5db2070d20502d6534c7a7e37a22~GQbTtKK9o1900119001eucas1p1P;
 Fri, 29 Jul 2022 09:09:18 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220729090918eusmtrp2cb36704469666cfa1381c86a8c45a6b0~GQbTsOxOd2132221322eusmtrp2O;
 Fri, 29 Jul 2022 09:09:18 +0000 (GMT)
X-AuditID: cbfec7f5-9adff7000000256c-0c-62e3a3be7352
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id A2.5E.09038.DB3A3E26; Fri, 29
 Jul 2022 10:09:17 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220729090917eusmtip125a6d45cf8e112df70fc03b445c79919~GQbTh_gX13212032120eusmtip1G;
 Fri, 29 Jul 2022 09:09:17 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.8) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Fri, 29 Jul 2022 10:09:15 +0100
Message-ID: <f577e147-c692-97b1-3262-2684649b5eae@samsung.com>
Date: Fri, 29 Jul 2022 11:09:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Bart Van Assche <bvanassche@acm.org>,
 <damien.lemoal@opensource.wdc.com>, <hch@lst.de>, <axboe@kernel.dk>,
 <snitzer@kernel.org>, <Johannes.Thumshirn@wdc.com>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <514f85ce-84fc-1186-7169-a29d7118e8cc@acm.org>
X-Originating-IP: [106.210.248.8]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsWy7djP87r7Fj9OMlj7Sdxi9d1+NotpH34y
 W/w+e57ZYu+72awWexZNYrJYufook8WT9bOYLf523WOy2HtL2+LyrjlsFvOXPWW3mND2ldni
 xoSnjBZrbj5lsThxS9qB3+PyFW+PnbPusntcPlvqsWlVJ5vH5iX1HrtvNrB57Gy9z+rxft9V
 oNDpao/Pm+Q82g90MwVwR3HZpKTmZJalFunbJXBl3Jq/k61gAVvFw3trWRsY21m7GDk5JARM
 JG7POwBkc3EICaxglPi+/DuU84VR4mjXTCjnM6PEm3f9jDAt2z9sZoNILGeUOLz2GRNc1eOZ
 S9hBqoQEdjJKPPxoBmLzCthJXGq9zwJiswioSsz/tJsZIi4ocXLmE7C4qECkxJrdZ8F6hQXi
 JX4cX8QGYjMLiEvcejIfbIGIwFJGiX+3L4KtZhaYwSRx/PIqIIeDg01AS6KxE6yZU8Ba4sPW
 HnaIZk2J1u2/oWx5ie1v5zBDvKAo0f99AxuEXSux9tgZdpCZEgL3OCWmztnFDpFwkejceRvq
 Z2GJV8e3QMVlJP7vBLkIxK6WeHrjNzNEcwujRP/O9WAHSQBd0XcmB6LGUWLB6+eMEGE+iRtv
 BSHu4ZOYtG068wRG1VlIYTELyc+zkLwwC8kLCxhZVjGKp5YW56anFhvnpZbrFSfmFpfmpesl
 5+duYgSmwtP/jn/dwbji1Ue9Q4xMHIyHGCU4mJVEeAUCHicJ8aYkVlalFuXHF5XmpBYfYpTm
 YFES503O3JAoJJCeWJKanZpakFoEk2Xi4JRqYHKLv6Y5b35ef7vnhYPf/XtDKtZKp91VWiG8
 YuYMs50n/zipScx5d8XjgrHyDb44mZevvhVn3F6dUy/mpXmrWT3iTjKjm13ykpbaa3dbXpoc
 YX68///WPOeEz+ZrS6Ri3/xwF+OQt5291zKqTuhE14Rvl/6YlX5V79ywhYnnuTsb77GgoEM3
 C7Xe1li5Zhgn+CQerzqdXFS617/yceoGEfvuKzvN3y3UNl0T1Vxw81DEwX8Flswr5qfd9fp7
 te7HrRT7t/svZ8pWXLHY0rLAXzPb4nb8kgYmp3OVcxjXfrv0UNZtz+kOo7aXk27wRm2PdOBL
 f1gcK5pcPydjZdq+pbtv+Pwz72wsyjxhIa3mrMRSnJFoqMVcVJwIANbigGD0AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t/xu7p7Fz9OMvhxx9pi9d1+NotpH34y
 W/w+e57ZYu+72awWexZNYrJYufook8WT9bOYLf523WOy2HtL2+LyrjlsFvOXPWW3mND2ldni
 xoSnjBZrbj5lsThxS9qB3+PyFW+PnbPusntcPlvqsWlVJ5vH5iX1HrtvNrB57Gy9z+rxft9V
 oNDpao/Pm+Q82g90MwVwR+nZFOWXlqQqZOQXl9gqRRtaGOkZWlroGZlY6hkam8daGZkq6dvZ
 pKTmZJalFunbJehl3Jq/k61gAVvFw3trWRsY21m7GDk5JARMJLZ/2MzWxcjFISSwlFHi1so7
 jBAJGYlPVz6yQ9jCEn+udUEVfWSUWLWulRnC2cko8fDJLSaQKl4BO4lLrfdZQGwWAVWJ+Z92
 M0PEBSVOznwCFhcViJR4uKwJrF5YIF7ix/FFbCA2s4C4xK0n85lAhoqAnDFn5hNGEIdZYAaT
 xPHLq6B2X2OSePpkDdDlHBxsAloSjZ1g93EKWEt82NrDDjFJU6J1+28oW15i+9s5zBA/KEr0
 f9/ABmHXSry6v5txAqPoLCQHzkJyyCwko2YhGbWAkWUVo0hqaXFuem6xkV5xYm5xaV66XnJ+
 7iZGYArZduznlh2MK1991DvEyMTBeIhRgoNZSYRXIOBxkhBvSmJlVWpRfnxRaU5q8SFGU2Ao
 TWSWEk3OByaxvJJ4QzMDU0MTM0sDU0szYyVxXs+CjkQhgfTEktTs1NSC1CKYPiYOTqkGJqb/
 Zt1HuU4vLZG9u8NX7GFqi4HoEw3DJblmc5JSz+YtZS9v1dg46Xba7u/3uHa0zS10EUg4f/9k
 RLAA+62wO2xVczqaJblPJ9+o3bW3Z6c2n7SQ5abefPcnhmstpht+eMe7vn/fxD/THov4R9Wn
 LCzrOuf6YqlM0F5/PoV4xrmsdwKmbV6+yPvJ7D2LVJw5+l6zrzjtLi2tenwDq0SatfZeVw3x
 n5Grjs7TeNTyT/e9TUvf/xeBxw7sqJCLv+E+W4z5YX51lOGCHxI5u04HbXc5uDW/Un9J/OSb
 E/m7fJ4/eppR0ZXt+/PqAuZJb400yuXazopMys7pV7PdF7fTkidF7lq+/7m5leGvVGZGKLEU
 ZyQaajEXFScCALp70FGqAwAA
X-CMS-MailID: 20220729090918eucas1p1782d5db2070d20502d6534c7a7e37a22
X-Msg-Generator: CA
X-RootMTR: 20220727162248eucas1p2ff8c3c2b021bedcae3960024b4e269e9
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220727162248eucas1p2ff8c3c2b021bedcae3960024b4e269e9
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162248eucas1p2ff8c3c2b021bedcae3960024b4e269e9@eucas1p2.samsung.com>
 <20220727162245.209794-3-p.raghav@samsung.com>
 <7984b969-9025-6b31-2645-da08daeefafb@acm.org>
 <eed7d9ee-fd7f-e57c-598e-909dbb0d2380@samsung.com>
 <514f85ce-84fc-1186-7169-a29d7118e8cc@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v8 02/11] block: allow blk-zoned devices to
 have non-power-of-2 zone size
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
Cc: pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022-07-28 15:29, Bart Van Assche wrote:

>> But I am fine with going back to bdev_is_zone_start if you and Damien
>> feel strongly otherwise.
> The "zone start LBA" terminology occurs in ZBC-1, ZBC-2 and ZNS but
> "zone aligned" not. I prefer "zone start" because it is clear,
> unambiguous and because it has the same meaning as in the corresponding
> standards documents. I propose to proceed as follows for checking
> whether a number of LBAs is a multiple of the zone length:
> * Either use bdev_is_zone_start() directly.
> * Or introduce a synonym for bdev_is_zone_start() with an appropriate
> name, e.g. bdev_is_zone_len_multiple().
> 
Thanks for the clarification Bart. I will go with bdev_is_zone_start()
as it is also a commonly used terminology.
> Thanks,
> 
> Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

