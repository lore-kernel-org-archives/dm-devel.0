Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D19DDC43334
	for <dm-devel@archiver.kernel.org>; Fri, 17 Jun 2022 05:46:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-or1LXQTWNvKByDSJ-vw7rA-1; Fri, 17 Jun 2022 01:46:18 -0400
X-MC-Unique: or1LXQTWNvKByDSJ-vw7rA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F15753C0D85D;
	Fri, 17 Jun 2022 05:46:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 30743492CA6;
	Fri, 17 Jun 2022 05:46:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E5ECD194705F;
	Fri, 17 Jun 2022 05:46:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 36492194705D
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Jun 2022 05:46:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 12677111F5; Fri, 17 Jun 2022 05:46:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0DFD810725
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 05:46:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC5673C0D862
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 05:46:10 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-bUlnV1gcMe6qTubX6A2L9Q-1; Fri, 17 Jun 2022 01:46:08 -0400
X-MC-Unique: bUlnV1gcMe6qTubX6A2L9Q-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220617054607euoutp029534742a8224e25251c512fd241530e4~5Uj7VOK2L1245412454euoutp02I
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 05:46:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220617054607euoutp029534742a8224e25251c512fd241530e4~5Uj7VOK2L1245412454euoutp02I
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220617054607eucas1p12bf3b149c16d5992795ed6722d414b2f~5Uj65en871628816288eucas1p1F;
 Fri, 17 Jun 2022 05:46:07 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 01.89.09664.F151CA26; Fri, 17
 Jun 2022 06:46:07 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220617054606eucas1p23fd49b57f6c12cbb82cf3f700f29ac53~5Uj6djwtL0948609486eucas1p2U;
 Fri, 17 Jun 2022 05:46:06 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220617054606eusmtrp1cd5853c6742faf923e59de41ea4d2950~5Uj6b1vD82642226422eusmtrp1x;
 Fri, 17 Jun 2022 05:46:06 +0000 (GMT)
X-AuditID: cbfec7f2-d81ff700000025c0-92-62ac151f2e12
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 04.19.09095.E151CA26; Fri, 17
 Jun 2022 06:46:06 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220617054606eusmtip17a9761ccee9559d7967ca923bccd96ba~5Uj6N0ubu0452004520eusmtip1i;
 Fri, 17 Jun 2022 05:46:06 +0000 (GMT)
Received: from [192.168.1.12] (106.210.248.244) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Fri, 17 Jun 2022 06:46:00 +0100
Message-ID: <4746a000-2220-211e-1bd6-79c15c18a85c@samsung.com>
Date: Fri, 17 Jun 2022 07:45:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>, <hch@lst.de>,
 <snitzer@redhat.com>, <axboe@kernel.dk>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <0c4f30f2-c206-0201-31e3-fbb9edbdf666@opensource.wdc.com>
X-Originating-IP: [106.210.248.244]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKKsWRmVeSWpSXmKPExsWy7djP87ryomuSDC5uF7RYfbefzWLah5/M
 Fr/Pnme2aG3/xmSx991sVosLPxqZLPYsmsRksXL1USaLJ+tnMVv0HPjAYvG36x5QrOUhs8Xe
 W9oWl3fNYbOYv+wpu8Wam09ZLNo2fmV0EPS4fMXb49+JNWweO2fdZfe4fLbUY9OqTjaPhQ1T
 mT02L6n32H2zASjXep/V4/2+q2we67dcZfHYfLra4/MmOY/2A91MAXxRXDYpqTmZZalF+nYJ
 XBlnHhUU3JapmNTTyNLA2CLRxcjJISFgInHzezMjiC0ksIJRYsIJli5GLiD7C6PE/efzGSGc
 z4wS81ftZIfpuPz7E1TVckaJ3ecvssFVnXq6FGrWLkaJN7/UQGxeATuJ/fvWMoHYLAKqEu9f
 dzJBxAUlTs58wgJiiwpESKxsfQNkc3AICzhKNJ1IAgkzC4hL3HoynwkkLCKQJzHvXxLIKmaB
 FmaJrv0PmUHibAJaEo2dYLdxCrhJvFm0mBWiVVOidftvdghbXmL72zlg5RICyhL/djJDvFIr
 sfbYGXaQkRICTVwSq5b/h0q4SDR9PA5lC0u8Or4F6ncZidOTe1gg7GqJpzd+M0M0tzBK9O9c
 zwaxwFqi70wORI2jxKqWJ4wQYT6JG28FIc7hk5i0bTrzBEbVWUjhMAvJw7OQfDALyQcLGFlW
 MYqnlhbnpqcWG+allusVJ+YWl+al6yXn525iBKbM0/+Of9rBOPfVR71DjEwcjIcYJTiYlUR4
 zYJXJgnxpiRWVqUW5ccXleakFh9ilOZgURLnTc7ckCgkkJ5YkpqdmlqQWgSTZeLglGpgMrhz
 VvZErskmz3sx9tdik59zaZ+ZVcPIpBqztYVppnvvlQnyJ+z15G78OB+jbZw6P36pkZKZ785s
 lq4HwvV77xeKLHfRvxg/e+0lZ/ugTIlgibVaDBrRT/Q992xYXGG95FSNnMYWHYsk26C7zA6e
 dawXNHd1PPCaG6t8MWbWpk3Rb3eudT0Yu8+ss4hzgVzJ8VmLCyInOooL9ntlPV165Gs+9y/V
 51IPLmcen9R0Zlv9l+htBt82+Dx8XrCbPeT1AouNO/+sndx4ufVMabScv+rcXu6f9m8MNV69
 zsv9MT3ndeLOzg0M2h29via9HCwZHaaaGpa7w/b7Zl9hfLT/28Xl4lEWVgXy/HfP/GVRYinO
 SDTUYi4qTgQAAuD4TAgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t/xu7pyomuSDD6t1bNYfbefzWLah5/M
 Fr/Pnme2aG3/xmSx991sVosLPxqZLPYsmsRksXL1USaLJ+tnMVv0HPjAYvG36x5QrOUhs8Xe
 W9oWl3fNYbOYv+wpu8Wam09ZLNo2fmV0EPS4fMXb49+JNWweO2fdZfe4fLbUY9OqTjaPhQ1T
 mT02L6n32H2zASjXep/V4/2+q2we67dcZfHYfLra4/MmOY/2A91MAXxRejZF+aUlqQoZ+cUl
 tkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF+nYJehlnHhUU3JapmNTTyNLA2CLR
 xcjJISFgInH59yeWLkYuDiGBpYwSDcf/MEMkZCQ+XfnIDmELS/y51sUGUfSRUeJ72xRGkISQ
 wC5GidPN/CA2r4CdxP59a5lAbBYBVYn3rzuZIOKCEidnPmEBsUUFIiQ+LZvA2sXIwSEs4CjR
 dCIJJMwsIC5x68l8JpCwiECexLx/SSCrmAVamCW69j9khtj7lkniw+dTYL1sAloSjZ1gt3EK
 uEm8WbSYFWKOpkTr9t/sELa8xPa3c5hByiUElCX+7YR6q1bi1f3djBMYRWchOW4WkitmIZk0
 C8mkBYwsqxhFUkuLc9Nziw31ihNzi0vz0vWS83M3MQJTzbZjPzfvYJz36qPeIUYmDsZDjBIc
 zEoivGbBK5OEeFMSK6tSi/Lji0pzUosPMZoCQ2gis5Rocj4w2eWVxBuaGZgamphZGphamhkr
 ifN6FnQkCgmkJ5akZqemFqQWwfQxcXBKNTCFWgbMPMLydHVe6a33+jOXyS07Oru5r1251X9R
 cO5lHZHjhuIh4vHVCyZvORHV96U+uLd8rfut01/vXWX+63Zw+0PvtXwVH/98WrPPm9838Xzs
 FAEd3Tr+Er6pv6as+3y8JMug/UIRh9xd+fQ1G/Ps7t0U9voyy45ziWhwZYNtVcFKi8yYZlGd
 PSuV47ZfudOt1/bZyGm6wRmDfTu7Xl3tXXk6d6GIw/JGO//t706Fc8dFOYbwvJtSxv6j7uCn
 msDPgosXO9Q+eXg4SYDbI6Z8eqVem4hCq97FUlXhN8Ipoq3Grub37zI3z7lx6Hvt6Z9zpd4m
 +mqUVPVMqhV785dlmlZUbn6eqEMSCwubrhJLcUaioRZzUXEiALC8MQi+AwAA
X-CMS-MailID: 20220617054606eucas1p23fd49b57f6c12cbb82cf3f700f29ac53
X-Msg-Generator: CA
X-RootMTR: 20220615102011eucas1p220368db4a186181b1927dea50a79e5d4
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220615102011eucas1p220368db4a186181b1927dea50a79e5d4
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615102011eucas1p220368db4a186181b1927dea50a79e5d4@eucas1p2.samsung.com>
 <20220615101920.329421-14-p.raghav@samsung.com>
 <63b0cfb6-eb24-f058-e502-2637039c5a98@opensource.wdc.com>
 <0b819562-8b16-37b6-9220-28bf1960bccb@samsung.com>
 <0c4f30f2-c206-0201-31e3-fbb9edbdf666@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v7 13/13] dm: add non power of 2 zoned target
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
Cc: Damien Le Moal <damien.lemoal@wdc.com>, bvanassche@acm.org,
 pankydev8@gmail.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, jonathan.derrick@linux.dev,
 Johannes.Thumshirn@wdc.com, dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022-06-17 01:49, Damien Le Moal wrote:
>>> Why do you need to change dm_set_zones_restrictions() at all ?
>>>
>> When the device mapper is created, the q->limits gets inherited from the
>> underlying device. The chunk sectors of the target and the device will
>> be the same but we want the chunk sector of the target to be different
>> (rounded to po2) compared to the underlying device's chunk sector. This
>> needs to be done only for the dm-po2z target and not for other targets
>> that uses npo2 zoned devices (like dm-linear). So to perform this
>> operation in a target independent way in dm-zone.c, I chose to always
>> revalidate npo2 zoned device and update the chunk sector and nr_zones in
>> dm_zone_revalidate_cb based on the zone information from the target.
>> This allows to set the limits correctly for dm-po2z target.
> 
> But DM revalidate will be called for the target AFTER it is setup (after
> its gendisk is added). So how can DM revalidate see the incorrect zone
> size ? If that is the case, then the target constructor is broken or
> missing something. DM revalidate zone is generic and only allocates the
> zone bitmaps for the target device. There should be not need at all to
> touch that function.
> 
I think this is a cleaner approach using features flag and io_hints
instead of messing with the revalidate zone function:

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 135c0cc190fb..c97a71e0473f 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1618,6 +1618,9 @@ static int device_not_matches_zone_sectors(struct
dm_target *ti, struct dm_dev *
 	if (!blk_queue_is_zoned(q))
 		return 0;

+	if(dm_target_supports_emulated_zone_size(ti->type))
+		return 0;
+
 	return blk_queue_zone_sectors(q) != *zone_sectors;
 }

diff --git a/drivers/md/dm-zoned-npo2-target.c
b/drivers/md/dm-zoned-npo2-target.c
index dad135964e09..b203be808f09 100644
--- a/drivers/md/dm-zoned-npo2-target.c
+++ b/drivers/md/dm-zoned-npo2-target.c
@@ -187,6 +187,12 @@ static int dmz_npo2_end_io(struct dm_target *ti,
struct bio *bio,
 	return DM_ENDIO_DONE;
 }

+static void dmz_npo2_io_hints(struct dm_target *ti, struct queue_limits
*limits)
+{
+	struct dmz_npo2_target *dmh = ti->private;
+	limits->chunk_sectors = dmh->zsze_po2;
+}
+
 static int dmz_npo2_map(struct dm_target *ti, struct bio *bio)
 {
 	struct dmz_npo2_target *dmh = ti->private;
@@ -233,12 +239,13 @@ static int dmz_npo2_iterate_devices(struct
dm_target *ti,
 static struct target_type dmz_npo2_target = {
 	.name = "zoned-npo2",
 	.version = { 1, 0, 0 },
-	.features = DM_TARGET_ZONED_HM,
+	.features = DM_TARGET_ZONED_HM | DM_TARGET_EMULATED_ZONE_SIZE,
 	.map = dmz_npo2_map,
 	.end_io = dmz_npo2_end_io,
 	.report_zones = dmz_npo2_report_zones,
 	.iterate_devices = dmz_npo2_iterate_devices,
 	.module = THIS_MODULE,
+	.io_hints = dmz_npo2_io_hints,
 	.ctr = dmz_npo2_ctr,
 };

diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index c2a3758c4aaa..9f3a4d98a22a 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -283,6 +283,15 @@ struct target_type {
 #define dm_target_supports_mixed_zoned_model(type) (false)
 #endif

+#ifdef CONFIG_BLK_DEV_ZONED
+#define DM_TARGET_EMULATED_ZONE_SIZE	0x00000400
+#define dm_target_supports_emulated_zone_size(type) \
+	((type)->features & DM_TARGET_EMULATED_ZONE_SIZE)
+#else
+#define DM_TARGET_EMULATED_ZONE_SIZE	0x00000000
+#define dm_target_supports_emulated_zone_size(type) (false)
+#endif
+
 struct dm_target {
 	struct dm_table *table;
 	struct target_type *type;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

