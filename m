Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D243FECAAD5
	for <dm-devel@archiver.kernel.org>; Mon,  5 Sep 2022 12:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662382662;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ayyDdb14xAIW2FoS2evJisgAHeRXrvSeRR96ZRGSFZo=;
	b=MtPPA82N9nTYY13UxqTuQmNxaDLlEHNCmHcoMI/l0Of9VeykwgUFpp2kWHcM276VvpPhq2
	UeAQNJzb4QASlcMQGCeYLHURYzhJnM2oM6NarjRs/rRiw9HkRgszjyaKttWeYTiGI0gVUK
	b+x8p6jTwrQzlJ1g5KQr3T9Idrq0vfY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-zuVK2yHPOZajG62hHpD7qQ-1; Mon, 05 Sep 2022 08:57:39 -0400
X-MC-Unique: zuVK2yHPOZajG62hHpD7qQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E6293C216CB;
	Mon,  5 Sep 2022 12:57:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A4135C15BC5;
	Mon,  5 Sep 2022 12:57:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 74DA01946A48;
	Mon,  5 Sep 2022 12:57:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3C7511946A47
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Sep 2022 12:57:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 29F0DC15BC8; Mon,  5 Sep 2022 12:57:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 25D1CC15BC5
 for <dm-devel@redhat.com>; Mon,  5 Sep 2022 12:57:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E35C803301
 for <dm-devel@redhat.com>; Mon,  5 Sep 2022 12:57:37 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-gJIrIBcIP4WfTe03LSwuXA-1; Mon, 05 Sep 2022 08:57:33 -0400
X-MC-Unique: gJIrIBcIP4WfTe03LSwuXA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220905125717euoutp010b4fcd6d8320f432ed6393bd1a66f053~R_DNuPIhv0405104051euoutp01i
 for <dm-devel@redhat.com>; Mon,  5 Sep 2022 12:57:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220905125717euoutp010b4fcd6d8320f432ed6393bd1a66f053~R_DNuPIhv0405104051euoutp01i
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220905125712eucas1p27c789651a573fe2b0f6774b0a5c7889f~R_DI2eCzV1056610566eucas1p2j;
 Mon,  5 Sep 2022 12:57:12 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 1D.2C.19378.722F5136; Mon,  5
 Sep 2022 13:57:11 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220905125711eucas1p12e53a64104034b1a8dca6ada0a79cf94~R_DIcHdgG1238212382eucas1p1v;
 Mon,  5 Sep 2022 12:57:11 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220905125711eusmtrp20c331e84f5a49de8bce1b5aa4250139d~R_DIbOf650766107661eusmtrp2u;
 Mon,  5 Sep 2022 12:57:11 +0000 (GMT)
X-AuditID: cbfec7f5-a35ff70000014bb2-e1-6315f2279068
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 15.CB.10862.722F5136; Mon,  5
 Sep 2022 13:57:11 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220905125711eusmtip19aba6d939273cea0e9076ccec1896a95~R_DILN56f3006530065eusmtip1b;
 Mon,  5 Sep 2022 12:57:11 +0000 (GMT)
Received: from [106.110.32.100] (106.110.32.100) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Mon, 5 Sep 2022 13:57:10 +0100
Message-ID: <67726654-2c13-2c41-c002-30dc99db8497@samsung.com>
Date: Mon, 5 Sep 2022 14:57:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Mike Snitzer <snitzer@redhat.com>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <YxJwd7xcZRdznsYz@redhat.com>
X-Originating-IP: [106.110.32.100]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsWy7djP87rqn0STDbattbRYf+oYs8Xqu/1s
 FtM+/GS2+H32PLNFa/s3Jou972azWqxcfZTJ4sn6WcwWf7vuAcVuaVtc3jWHzWL+sqfsFhPa
 vjJbrLn5lMXixC1pi7aNXxkdBDwuX/H22DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx87W+6we
 7/ddZfP4vEnOo/1AN1MAVxSXTUpqTmZZapG+XQJXxpEnKxkL1vJV3Nhwnb2BcRV3FyMnh4SA
 icSb93vZuxi5OIQEVjBK9FxcxAbhfGGU+DZrLSuE85lR4ta1uUwwLSvXvGGBSCxnlDjweSUz
 XFXvgbNQzi5GiYfrp7GCtPAK2EmcebkYqJ2Dg0VARaL3pCREWFDi5MwnLCC2qECkxJrdZ9lB
 bGGBbImlfcfBbGYBcYlbT+aDtYoIqErcmuYCET7ELHHhRjZImE1AS6KxE6yaE8h833OaCaJE
 U6J1+2+oKfIS29/OYYa4X0liwrz7bBB2rcTaY2fA3pcQeMQpcWV9KyNEwkVi7co/UEXCEq+O
 b2GHsGUk/u+cDw2IaomnN34zQzS3MEr071zPBnKQhIC1RN+ZHIgaR4n9C84zQ4T5JG68FYS4
 h09i0rbpzBMYVWchBcQsJA/PQvLCLCQvLGBkWcUonlpanJueWmycl1quV5yYW1yal66XnJ+7
 iRGYBk//O/51B+OKVx/1DjEycTAeYpTgYFYS4U3ZIZIsxJuSWFmVWpQfX1Sak1p8iFGag0VJ
 nDc5c0OikEB6YklqdmpqQWoRTJaJg1Oqgalsziu3+lPvtAqrbp5f8SKMU+I5U3vIfd8odrXH
 bOKX+HN7t5w58ILZamXZJBXbG97X9AyPbDEwPKZjG7WwzkhA/at00YOGt/ed5gsmWMyQXDhX
 9rnggoBqt4uylZ1Nt+zd5h2YFx/W8aw2vW3WziZBTfHLnc/q+xiVSswr5d6kRkyP1Qr2CvFZ
 um/vzgdMNkUHI64LvtNNt/BQfv1i9WEWmRPsH+aUe3VXmO1WCOdcveTCX9lHG6PvLEu7Zajw
 Wk6w1tZub+rTo9OyOZb+eJ/yNsV5nkHu1faJjg/kmiWMO3heXPr0N/6x7qFy1RfuhicXHD1x
 8fitKfYrt219UX5bl/P0huqy6pyjK+e9rldiKc5INNRiLipOBACZzGsn8gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t/xu7rqn0STDY5MlLJYf+oYs8Xqu/1s
 FtM+/GS2+H32PLNFa/s3Jou972azWqxcfZTJ4sn6WcwWf7vuAcVuaVtc3jWHzWL+sqfsFhPa
 vjJbrLn5lMXixC1pi7aNXxkdBDwuX/H22DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx87W+6we
 7/ddZfP4vEnOo/1AN1MAV5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6d
 TUpqTmZZapG+XYJexpEnKxkL1vJV3Nhwnb2BcRV3FyMnh4SAicTKNW9YQGwhgaWMEpN+Z0PE
 ZSQ+XfnIDmELS/y51sXWxcgFVPORUeLd00usEM4uRok9e+6yglTxCthJnHm5mKmLkYODRUBF
 ovekJERYUOLkzCdgC0QFIiUeLmtiArGFBbIllvYdB1vALCAucevJfLBWEQFViVvTXEDGMwsc
 YpZY1buZCWLXP0aJE+vmM4MUsQloSTR2gvVyApnve04zQczRlGjd/htqprzE9rdzmCEeUJKY
 MO8+G4RdK/Hq/m7GCYyis5CcNwvJGbOQjJqFZNQCRpZVjCKppcW56bnFRnrFibnFpXnpesn5
 uZsYgclj27GfW3Ywrnz1Ue8QIxMH4yFGCQ5mJRHelB0iyUK8KYmVValF+fFFpTmpxYcYTYFB
 NJFZSjQ5H5i+8kriDc0MTA1NzCwNTC3NjJXEeT0LOhKFBNITS1KzU1MLUotg+pg4OKUamIQC
 /od7nHUxdV+YvTZi47Z1XRVHtuy92nU+i5vh5z/269ei7XcsW61yTHyTyI2Li45GzKhQYcoJ
 3fVm8hOXL2YO+3ZEPThscE+mVv5d8b6t2TI/VB5c+XVIuHv66qtHtdvv5bbKyLjoMufXek4x
 XHrjsn3KYrODRUfUfx1VvP5B5OXpKf8qEsTtXsetZ7tU+TJ6gU3Ix+x3m7j+7z3NFdMb8P7G
 joyjje9lv1ez79h47nyhxF2jDbGc/zK6LPovpteZfT/KusxZuWSbiR8Pb5RAsvhaMUZFU34r
 o1TxRT9Pz5hv2qQh2LayVTplps2944v+ufVrTf6c8Oz15VxN+QX7d62InpP7wlty6lP3LfVK
 LMUZiYZazEXFiQDE0KUFpwMAAA==
X-CMS-MailID: 20220905125711eucas1p12e53a64104034b1a8dca6ada0a79cf94
X-Msg-Generator: CA
X-RootMTR: 20220823121915eucas1p10296d6a2ab00de5e73791a7d6b8e39de
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220823121915eucas1p10296d6a2ab00de5e73791a7d6b8e39de
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121915eucas1p10296d6a2ab00de5e73791a7d6b8e39de@eucas1p1.samsung.com>
 <20220823121859.163903-14-p.raghav@samsung.com>
 <YxJttvB2Z5I58SQ5@redhat.com> <YxJwd7xcZRdznsYz@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v12 13/13] dm: add power-of-2 target for
 zoned devices with non power-of-2 zone sizes
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
Cc: axboe@kernel.dk, Damien Le Moal <damien.lemoal@wdc.com>, bvanassche@acm.org,
 pankydev8@gmail.com, Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, matias.bjorling@wdc.com,
 gost.dev@samsung.com, jaegeuk@kernel.org, hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

>>
>> 1) why is a partial mapping of the underlying device disallowed?
>> 2) why is it assumed all IO is read-only? (talk to me and others like
>>    we don't know the inherent limitations of this class of zoned hw)
>>
>> On a code level:
>> 1) are you certain you're properly failing all writes?
>>    - are writes allowed to the "zone capacity area" but _not_
>>      allowed to the "emulated zone area"? (if yes, _please document_). 
>> 2) yes, you absolutely need to implement the .status target_type hook
>>    (for both STATUS and TABLE).
>> 3) really not loving the nested return (of DM_MAPIO_SUBMITTED or
>>    DM_MAPIO_REMAPPED) from methods called from dm_po2z_map().  Would
>>    prefer to not have to do a depth-first search to see where and when
>>    dm_po2z_map() returns a DM_MAPIO_XXX unless there is a solid
>>    justification for it.  To me it just obfuscates the DM interface a
>>    bit too much. 
>>
>> Otherwise, pretty clean code and nothing weird going on.
>>
>> I look forward to seeing your next (final?) revision of this patchset.
> 
> Thinking further.. I'm left confused about just what the heck this
> target is assuming.
> 
> E.g.: feels like its exposing a readonly end of the zone is very
> bi-polar... yet no hint to upper layer it shouldn't write to that
> read-only end (the "emulated zone").. but there has to be some zoned
> magic assumed?  And I'm just naive?
> 

You are absolutely right about "zoned magic". Applications that use a zoned
block device are aware of the zone capacity and zone size. BLKREPORTZONE
ioctl is typically used to get the zone information from a zoned block device.

This target adjusts the zone report so that zone size and zone capacity are
modified correctly (see dm_po2z_report_zones() and
dm_po2z_report_zones_cb() functions).

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

