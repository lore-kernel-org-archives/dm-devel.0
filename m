Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8C7EECAAD5
	for <dm-devel@archiver.kernel.org>; Mon,  5 Sep 2022 12:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662382171;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Dp238muCkqWx/wr1FsTFEVRjUxrf/LjwKPJYrpUywS4=;
	b=JEMt6oPQXxS7zMile546vZ5OQd2g40xMTbjwGqp2sawKFLbK7P7GuweUfU2vTM1XuVCadU
	mMTlC1FBlxxI5u2TjYx+s2vS37na0vuFaFUFDxFzFzgWF049z2KwSSpmEX5s+Pg7hJ0uWz
	6BTxDemwedQN7nSqAp01Po0NR4hz3mI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-YN4NmkGzOXmuM-FJ0lg9iQ-1; Mon, 05 Sep 2022 08:49:28 -0400
X-MC-Unique: YN4NmkGzOXmuM-FJ0lg9iQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2403F3825780;
	Mon,  5 Sep 2022 12:49:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C28D240D296C;
	Mon,  5 Sep 2022 12:49:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A10D31946A48;
	Mon,  5 Sep 2022 12:49:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BCC7C1946A47
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Sep 2022 12:49:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 59CD7403167; Mon,  5 Sep 2022 12:49:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 557D0492C3B
 for <dm-devel@redhat.com>; Mon,  5 Sep 2022 12:49:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39B48101A56C
 for <dm-devel@redhat.com>; Mon,  5 Sep 2022 12:49:21 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-labcnzUuOtayR6E62gCIWA-1; Mon, 05 Sep 2022 08:49:19 -0400
X-MC-Unique: labcnzUuOtayR6E62gCIWA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220905124903euoutp02016c195def6f6a4df97070bec16d8cc2~R98B9jouk0100101001euoutp02R
 for <dm-devel@redhat.com>; Mon,  5 Sep 2022 12:49:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220905124903euoutp02016c195def6f6a4df97070bec16d8cc2~R98B9jouk0100101001euoutp02R
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220905124903eucas1p28ce03c18a615c26f6e946b15a149b325~R98BqlOKd0854408544eucas1p2x;
 Mon,  5 Sep 2022 12:49:03 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 7E.D4.29727.F30F5136; Mon,  5
 Sep 2022 13:49:03 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220905124902eucas1p2ac0553ea1fe86340b5dbae2b66c22214~R98BE7RpE2754227542eucas1p2E;
 Mon,  5 Sep 2022 12:49:02 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220905124902eusmtrp2cc0a2e78a6eab472d306af045c0da798~R98BDlBjY0389703897eusmtrp2D;
 Mon,  5 Sep 2022 12:49:02 +0000 (GMT)
X-AuditID: cbfec7f2-205ff7000001741f-a7-6315f03f882d
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id C0.47.07473.E30F5136; Mon,  5
 Sep 2022 13:49:02 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220905124902eusmtip1f3535df1f02cd6b0b6a8939f6c046456~R98A2TTJK2174421744eusmtip1l;
 Mon,  5 Sep 2022 12:49:02 +0000 (GMT)
Received: from [106.110.32.100] (106.110.32.100) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Mon, 5 Sep 2022 13:49:01 +0100
Message-ID: <1ed819b5-924d-6a87-1978-1457061e2647@samsung.com>
Date: Mon, 5 Sep 2022 14:48:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Mike Snitzer <snitzer@redhat.com>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <YxJttvB2Z5I58SQ5@redhat.com>
X-Originating-IP: [106.110.32.100]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsWy7djP87r2H0STDc7N47RYf+oYs8Xqu/1s
 FtM+/GS2+H32PLNFa/s3Jou972azWqxcfZTJ4sn6WcwWf7vuAcVuaVtc3jWHzWL+sqfsFhPa
 vjJbrLn5lMXixC1pi7aNXxkdBDwuX/H22DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx87W+6we
 7/ddZfP4vEnOo/1AN1MAVxSXTUpqTmZZapG+XQJXRsPp3awFHzQrVr61a2BsUuxi5OCQEDCR
 aP5h0MXIxSEksIJRonvHYyYI5wujxKH5m9kgnM+MEs1fnjB2MXKCdcyf/IYZxBYSWM4ocXxW
 MlzRxKd32CGcXYwSM5r/soNU8QrYSdy80cUGYrMIqEj8eLaKCSIuKHFy5hMWEFtUIFJize6z
 YPXCAtkSS/uOg9nMAuISt57MZwK5VURAVeLWNBeI8CFmiQs3skHCbAJaEo2d7CAmJ5A5dVoJ
 RIWmROv231BD5CW2v53DDHG+ksSEeffZIOxaibXHzoBdLCFwj1OiZf0UqISLRPPdK0wQtrDE
 q+Nb2CFsGYn/O+dDxaslnt74zQzR3MIo0b9zPRskSK0l+s7kQNQ4SuxfcJ4ZIswnceOtIMQ9
 fBKTtk1nnsCoOgspHGYh+XcWkhdmIXlhASPLKkbx1NLi3PTUYsO81HK94sTc4tK8dL3k/NxN
 jMAEePrf8U87GOe++qh3iJGJg/EQowQHs5IIb8oOkWQh3pTEyqrUovz4otKc1OJDjNIcLEri
 vMmZGxKFBNITS1KzU1MLUotgskwcnFINTDnmlQdmq37f+tlHfFHuheOBC8xdrkdcCDp0iGHy
 wdcBkktXWcz+cfpoQmzyqXb1PW/F8xnv81nr5/5vfCDrz9lnuXf1V/kN3qFzNJ98+/zowOsX
 4aqblaJ2ugb/7y19NF9FYyr/MqcPM6wyXDd8yF0flHiz4vnvI06/Z+yK2vKjp0TT/Iic+eJn
 WzpLzt4KazgaJhW4QrFB7tDckOOql37c/TTFzsF4r+bRdVXfnli4O1i5KJXacry/HNVsreMY
 einn44NzJUsbArplgx9/MlgQzKHzMjjIjam60G7Hv2Nf0vYVZMmkv1HZ8MJyj8h9R0/flWfX
 lt3g+X/ZYNM/Gbs7vNEeeZWzFLd2p21e+0yJpTgj0VCLuag4EQAQLIGZ7wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t/xu7p2H0STDXoPKVqsP3WM2WL13X42
 i2kffjJb/D57ntmitf0bk8Xed7NZLVauPspk8WT9LGaLv133gGK3tC0u75rDZjF/2VN2iwlt
 X5kt1tx8ymJx4pa0RdvGr4wOAh6Xr3h77Jx1l93j8tlSj02rOtk8Ni+p99h9s4HNY2frfVaP
 9/uusnl83iTn0X6gmymAK0rPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/O
 JiU1J7MstUjfLkEvo+H0btaCD5oVK9/aNTA2KXYxcnJICJhIzJ/8hrmLkYtDSGApo8TCz4uY
 IBIyEp+ufGSHsIUl/lzrYoMo+sgosXHbbRYIZxejxIkDT8A6eAXsJG7eAKni5GARUJH48WwV
 VFxQ4uTMJywgtqhApMTDZU1gcWGBbImlfcfBNjALiEvcejIfKM7BISKgKnFrmgvIfGaBQ8wS
 q3o3M0Esu8coce70YhaQIjYBLYnGTnYQkxPInDqtBGKMpkTr9t9QI+Ultr+dwwzxgJLEhHn3
 2SDsWolX93czTmAUnYXkullIrpiFZNQsJKMWMLKsYhRJLS3OTc8tNtQrTswtLs1L10vOz93E
 CEwe24793LyDcd6rj3qHGJk4GA8xSnAwK4nwpuwQSRbiTUmsrEotyo8vKs1JLT7EaAoMoonM
 UqLJ+cD0lVcSb2hmYGpoYmZpYGppZqwkzutZ0JEoJJCeWJKanZpakFoE08fEwSnVwKQfuWav
 5fxPYpZ3ardkF3LIlzRwsrU2CxUcm2l3d16G5L9J+ucE4mbsFmVxdyv9y5hw6Mg7Ed/6+29Y
 nF5kKM4Rc9z988cTCalj3abzrx/pC+WZe3ced+KnAy9WGBax8L8OerM7Yanx7RWpIlZ28vpL
 E4wm/Vv8RUpUXORgCw9zRmD+jHqzf/8/mHJO4/v3ITxEK1q1c+6xA5uM5m9tmX5mtl3cyr9+
 7bZ3Kq47RgrazVoX0LbA/9+GLY3Rn4uFo8zd1pewFSXa/+owfqzM86uDK2VG7KOF+V1l0yRE
 Sus3L10s+Vbje/m8DbnL/r5sOl5XGMh/b3by5boz779WMP7c/mOrZWvMug2bnfcp+CmxFGck
 GmoxFxUnAgBNDRd8pwMAAA==
X-CMS-MailID: 20220905124902eucas1p2ac0553ea1fe86340b5dbae2b66c22214
X-Msg-Generator: CA
X-RootMTR: 20220823121915eucas1p10296d6a2ab00de5e73791a7d6b8e39de
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220823121915eucas1p10296d6a2ab00de5e73791a7d6b8e39de
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121915eucas1p10296d6a2ab00de5e73791a7d6b8e39de@eucas1p1.samsung.com>
 <20220823121859.163903-14-p.raghav@samsung.com>
 <YxJttvB2Z5I58SQ5@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Mike,

>> Note that the target does not support partial mapping of the underlying
>> device.
>>
>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
>> Suggested-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> Suggested-by: Damien Le Moal <damien.lemoal@wdc.com>
>> Suggested-by: Hannes Reinecke <hare@suse.de>
> 
> 
> This target needs more review from those who Suggested-by it.
> 
> And the header and docs needs to address:
> 
> 1) why is a partial mapping of the underlying device disallowed?
While it is technically possible, I don't see any use-case to do so for
this target. I can mention it in the documentation as well.

> 2) why is it assumed all IO is read-only? (talk to me and others like
>    we don't know the inherent limitations of this class of zoned hw)
>
TL;DR: no, we don't assume all IO to be read-only. All operations all
allowed until the zone capacity, and only reads are permitted in the
emulated gap area.

A bit of context about Zoned HW(especially ZNS SSD):

Zone: A contiguous range of logical block addresses managed as a single unit.
Zoned Block Device: A block device that consists of multiple zones.
Zone size: Size of a zone
Zone capacity: Usable logical blocks in a zone

According to ZNS spec, the LBAs from zone capacity to zone size behave like
deallocated blocks when read and are not allowed to be written. Until now,
zone capacity can be any value, but zone size needed to be a power-of-2 to
work in Linux (More information about this is also in my cover letter).

This patch series aims to allow non-po2 zone size devices with zone
capacity == zone size to work in Linux.

A non-po2 zone size device might not work correctly in filesystems that
support zoned devices such as btrfs and f2fs as they assume po2 zone sizes.
Therefore, this target is created to enable these filesystems to work with
non-po2 zone sizes until native support is added.

This target's zone capacity will be the same as the underlying device, but
the target's zone size will be the nearest po2 value of its zone capacity.
Furthermore, the area between the zone capacity and zone size of the target
(emulated gap area) will resemble the spec behavior: behave like the
deallocated blocks when read (we fill zeroes in the bio) and are not
allowed to write.

Does that clarify your question?
> On a code level:
> 1) are you certain you're properly failing all writes?
>    - are writes allowed to the "zone capacity area" but _not_
>      allowed to the "emulated zone area"? (if yes, _please document_). 
I have already documented in Documentation:

A simple remap is performed for all the BIOs that do not cross the
emulation gap area, i.e., the area between the zone capacity and size.

If a BIO lies in the emulation gap area, the following operations are
performed:

  Read:
    - If the BIO lies entirely in the emulation gap area, then zero out the
BIO and complete it.

    - If the BIO spans the emulation gap area, split the BIO across the
zone capacity boundary and remap only the BIO within the zone capacity
boundary. The other part of the split BIO will be zeroed out.

  Other operations:
    - Return an error

Maybe it is not clear enough?? Let me know.

> 2) yes, you absolutely need to implement the .status target_type hook
>    (for both STATUS and TABLE).
I already queued this change locally. I will send it as a part of the next rev.

> 3) really not loving the nested return (of DM_MAPIO_SUBMITTED or
>    DM_MAPIO_REMAPPED) from methods called from dm_po2z_map().  Would
>    prefer to not have to do a depth-first search to see where and when
>    dm_po2z_map() returns a DM_MAPIO_XXX unless there is a solid
>    justification for it.  To me it just obfuscates the DM interface a
>    bit too much. 
> 
Got it. Do you prefer having the return statements in the dm_po2z_map
itself instead of returning a helper function, which in return returns the
status code?

What about something like this:

static inline void dm_po2z_read_zeroes(struct bio *bio)
{
	zero_fill_bio(bio);
	bio_endio(bio);
}

static int dm_po2z_map(struct dm_target *ti, struct bio *bio)
{
	struct dm_po2z_target *dmh = ti->private;
	int split_io_pos;

	bio_set_dev(bio, dmh->dev->bdev);

	if (op_is_zone_mgmt(bio_op(bio)))
		goto remap_sector;

	if (!bio_sectors(bio))
		return DM_MAPIO_REMAPPED;

	if (!dm_po2z_bio_in_emulated_zone_area(dmh, bio, &split_io_pos))
		goto remap_sector;

	/*
	 * Read operation on the emulated zone area (between zone capacity
	 * and zone size) will fill the bio with zeroes.Any other operation
	 * in the emulated area should return an error.
	 */
	if (bio_op(bio) == REQ_OP_READ) {
		/*
		 * If the bio is across emulated zone boundary, split
		 * the bio at
		 * the boundary.
		 */
		if (split_io_pos > 0) {
			dm_accept_partial_bio(bio, split_io_pos);
			goto remap_sector;
		}

		dm_po2z_read_zeroes(bio);
		return DM_MAPIO_SUBMITTED;
	}
	return DM_MAPIO_KILL;

remap_sector:
	bio->bi_iter.bi_sector =
		target_to_device_sect(dmh, bio->bi_iter.bi_sector);

	return DM_MAPIO_REMAPPED;
}

> Otherwise, pretty clean code and nothing weird going on.
> 
> I look forward to seeing your next (final?) revision of this patchset.
> 
> Thanks,
> Mike
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

