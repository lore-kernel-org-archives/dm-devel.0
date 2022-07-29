Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FDFAC19F2A
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jul 2022 08:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659081667;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=M/lZS2DEtIF2ldAOH+1DAN8RXsNB0iH+7Bq3T+Qv7Ug=;
	b=Al0yNm14Tk1VtkcoRHQRQHEreW+voUgwv4tquHAoxC3mqN8x++GzkiR/adB2+8SviPKMCF
	ob1Bznk7VKCEnkVvZMmSjbZz8iDPOJNU0Fq6oS/1UcYDag5A7UETx6/2yy+ykc38f019Kw
	ZXu3y6DYnmvPLbBFHfz0+Drt85QPRIU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-416-CzIDKFcMPDqyWAgbWoBHIQ-1; Fri, 29 Jul 2022 04:01:05 -0400
X-MC-Unique: CzIDKFcMPDqyWAgbWoBHIQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9157800124;
	Fri, 29 Jul 2022 08:01:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 93C6A492C3B;
	Fri, 29 Jul 2022 08:01:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 53BCD1932120;
	Fri, 29 Jul 2022 08:01:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DB5CF193211B
 for <dm-devel@listman.corp.redhat.com>; Fri, 29 Jul 2022 08:01:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BDFC72166B2B; Fri, 29 Jul 2022 08:01:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B617C2166B26
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 08:01:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 681A03C0F384
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 08:01:01 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-gUBsMRpROm2VGd59La3t-Q-1; Fri, 29 Jul 2022 04:00:59 -0400
X-MC-Unique: gUBsMRpROm2VGd59La3t-Q-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220729080058euoutp027661803016c5ebdb400f329c9749b44c~GPfpsfHk_2068420684euoutp02J
 for <dm-devel@redhat.com>; Fri, 29 Jul 2022 08:00:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220729080058euoutp027661803016c5ebdb400f329c9749b44c~GPfpsfHk_2068420684euoutp02J
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220729080057eucas1p2bf1e6dbfb1801a86419b17785cb129d3~GPfpOczkL1743317433eucas1p27;
 Fri, 29 Jul 2022 08:00:57 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 7C.D6.10067.9B393E26; Fri, 29
 Jul 2022 09:00:57 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220729080057eucas1p2d3ab499ae1905a2a1df51a4a81a01723~GPfo06HdV1787517875eucas1p2y;
 Fri, 29 Jul 2022 08:00:57 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220729080057eusmtrp2c7bf9e55abbeacd657be9b783f9d7b88~GPfoz63Zy1448014480eusmtrp24;
 Fri, 29 Jul 2022 08:00:57 +0000 (GMT)
X-AuditID: cbfec7f4-dc1ff70000002753-a0-62e393b96c7d
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id CF.03.09038.9B393E26; Fri, 29
 Jul 2022 09:00:57 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220729080057eusmtip1b1ab989d52f0805ddccea4b804ada970~GPfoqr6xS2228922289eusmtip1g;
 Fri, 29 Jul 2022 08:00:57 +0000 (GMT)
Received: from [192.168.8.130] (106.210.248.8) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Fri, 29 Jul 2022 09:00:54 +0100
Message-ID: <3f817b2f-ee25-c643-8d7a-aa0b543b4ca6@samsung.com>
Date: Fri, 29 Jul 2022 10:00:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: <dsterba@suse.cz>, <damien.lemoal@opensource.wdc.com>, <hch@lst.de>,
 <axboe@kernel.dk>, <snitzer@kernel.org>, <Johannes.Thumshirn@wdc.com>,
 <matias.bjorling@wdc.com>, <gost.dev@samsung.com>,
 <linux-kernel@vger.kernel.org>, <hare@suse.de>,
 <linux-block@vger.kernel.org>, <pankydev8@gmail.com>, <bvanassche@acm.org>,
 <jaegeuk@kernel.org>, <dm-devel@redhat.com>,
 <linux-nvme@lists.infradead.org>, Luis Chamberlain <mcgrof@kernel.org>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <20220728121548.GE13489@twin.jikos.cz>
X-Originating-IP: [106.210.248.8]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsWy7djP87o7Jz9OMmj/am6x+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLxb+/s1jsWTSJyWLl6qNMFk/Wz2K2+Nt1j8li7y1ti8u75rBZzF/2lN1i
 QttXZosbE54yWqy5+ZTF4sQtaQcBj8tXvD12zrrL7nH5bKnHplWdbB6bl9R77L7ZwOaxs/U+
 q8f7fVfZPM4sOMLusfl0tcfnTXIe7Qe6mQJ4orhsUlJzMstSi/TtErgyOk6kFUzirHh8+wNr
 A+ME9i5GDg4JAROJHz9Yuhi5OIQEVjBKtJ84zQjhfGGUON9whQnC+cwoMbH1A5DDCdax9Psf
 NojEckaJN/fXscFVvTh2HaplJ6NEw4pzjCAtvAJ2Em+aDrKB2CwCqhLfzv5ihYgLSpyc+YQF
 xBYViJRYs/ssO4gtLBAusQyql1lAXOLWk/lgQ0UE9jFLvJ35nxnkcjYBLYnGTrB6TgFjiZ75
 s1gg6jUlWrf/Zoew5SW2v53DDHG2okT/9w1sEHatxNpjZ9hBZkoI3OOUWPJvHtRvLhInvk1m
 gbCFJV4d38IOYctI/N85H6qmWuLpjd/MEM0tjBL9O9ezQYLSWqLvTA5EjaPE/Yl7GSHCfBI3
 3gpC3MMnMWnbdGaIMK9ER5vQBEaVWUghMQvJx7OQfDMLyTcLGFlWMYqnlhbnpqcWG+WllusV
 J+YWl+al6yXn525iBCbG0/+Of9nBuPzVR71DjEwcjIcYJTiYlUR4BQIeJwnxpiRWVqUW5ccX
 leakFh9ilOZgURLnTc7ckCgkkJ5YkpqdmlqQWgSTZeLglGpg2r04cnd84ycBC/c/ttmsR9fa
 3Q5eeOgt93GOd10sXb3H/jzKjbwuZfWb6+Bcl21Cz1bXpq8oDovv8BDJYDBUdVysHbBpejGX
 RHrl0hD7gN2NNb79FuZBL27t1LVYt+DlzZ+6i418zx9L/rU4WTB9w9HMHzHaHhKc6+KdVlx4
 sfANY6+q4fQd0W/j6i3qfX+/yM/1awucdX76bvcUl/VXcp6trbcUD3Pz6NG7mcbQeO38kqal
 eQuvnvm7WZLL86xfd/TB80dqlxjfOjhleYb/xpcmO1KfXtfrfmy95J0Jz5vvFnql19dP9VFY
 /9gzVtK+9eiqnofJqV+cdkxz2Lj4aWqi+Sq7q7wCGh/WqqhUK7EUZyQaajEXFScCAHOQKr37
 AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t/xu7o7Jz9OMlhzSs5i9d1+NotpH34y
 W/w+e57ZYu+72awWi39/Z7HYs2gSk8XK1UeZLJ6sn8Vs8bfrHpPF3lvaFpd3zWGzmL/sKbvF
 hLavzBY3JjxltFhz8ymLxYlb0g4CHpeveHvsnHWX3ePy2VKPTas62Tw2L6n32H2zgc1jZ+t9
 Vo/3+66yeZxZcITdY/Ppao/Pm+Q82g90MwXwROnZFOWXlqQqZOQXl9gqRRtaGOkZWlroGZlY
 6hkam8daGZkq6dvZpKTmZJalFunbJehldJxIK5jEWfH49gfWBsYJ7F2MnBwSAiYSS7//Yeti
 5OIQEljKKNF8cSEjREJG4tOVj1BFwhJ/rnVBFX1klLi3dBkjhLOTUeLooousIFW8AnYSb5oO
 soHYLAKqEt/O/oKKC0qcnPmEBcQWFYiUeLisiQnEFhYIl5j8/COYzSwgLnHryXwmkKEiAvuY
 Jd7O/M8MseEFo8ShF/uBujk42AS0JBo7wU7iFDCW6Jk/iwWiWVOidftvdghbXmL72znMEGcr
 SvR/38AGYddKvLq/m3ECo8gsJDfNQrJ7FpJRs5CMWsDIsopRJLW0ODc9t9hIrzgxt7g0L10v
 OT93EyMwdWw79nPLDsaVrz7qHWJk4mA8xCjBwawkwisQ8DhJiDclsbIqtSg/vqg0J7X4EKMp
 MGAmMkuJJucDk1deSbyhmYGpoYmZpYGppZmxkjivZ0FHopBAemJJanZqakFqEUwfEwenVAOT
 6DTGf5ftH7+OsephStV+cKTS4nEQn9TzjrIoNU4dz7f+dkavC9ZlRCR1qRSZFYn7PGx651h+
 KDe2bYdnffqS6Ii7H8V3OYR+7E/76dUjWrizwcd99uzZIe9Kg1pWsYXnCF/y0z6dmMxvv7ah
 4SLrwwUcp4XnWMw+dDNjkV34wXy/L2+yz7uZbNqu8KCR9V7gmp4HImYSTfuef7zwtHDi3Iez
 JrdvVHKc+krg646mpayv/fSSHwYJJ8b32v7X26UroOF0OHeaUorlNVXRO2zz+By6M6zlzt6p
 NipMfvPPTC/kPPcy4ynLlY3iE6ucNoXp8HhyzJ8bvrJiw6Qnk6pWLN62qDFxaXViwkRxFiWW
 4oxEQy3mouJEAGk4zn+mAwAA
X-CMS-MailID: 20220729080057eucas1p2d3ab499ae1905a2a1df51a4a81a01723
X-Msg-Generator: CA
X-RootMTR: 20220727162253eucas1p1a5912e0494f6918504cc8ff15ad5d31f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220727162253eucas1p1a5912e0494f6918504cc8ff15ad5d31f
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162253eucas1p1a5912e0494f6918504cc8ff15ad5d31f@eucas1p1.samsung.com>
 <20220727162245.209794-8-p.raghav@samsung.com>
 <20220728121548.GE13489@twin.jikos.cz>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v8 07/11] dm-zoned: ensure only power of 2
 zone sizes are allowed
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

On 2022-07-28 14:15, David Sterba wrote:
> On Wed, Jul 27, 2022 at 06:22:41PM +0200, Pankaj Raghav wrote:
>> --- a/drivers/md/dm-zoned-target.c
>> +++ b/drivers/md/dm-zoned-target.c
>> @@ -792,6 +792,10 @@ static int dmz_fixup_devices(struct dm_target *ti)
>>  				return -EINVAL;
>>  			}
>>  			zone_nr_sectors = bdev_zone_sectors(bdev);
>> +			if (!is_power_of_2(zone_nr_sectors)) {
>> +				ti->error = "Zone size is not power of 2";
> 
> This could print what's the value of zone_nr_sectors
Ok. I will rephrase based on Damien's comment and add the
zone_nr_sectors to be included. Thanks.
> 
>> +				return -EINVAL;
>> +			}
>>  			zoned_dev->zone_nr_sectors = zone_nr_sectors;
>>  			zoned_dev->nr_zones = bdev_nr_zones(bdev);
>>  		}
>> @@ -804,6 +808,10 @@ static int dmz_fixup_devices(struct dm_target *ti)
>>  			return -EINVAL;
>>  		}
>>  		zoned_dev->zone_nr_sectors = bdev_zone_sectors(bdev);
>> +		if (!is_power_of_2(zoned_dev->zone_nr_sectors)) {
>> +			ti->error = "Zone size is not power of 2";
> 
> Same
> 
>> +			return -EINVAL;
>> +		}
>>  		zoned_dev->nr_zones = bdev_nr_zones(bdev);
>>  	}
>>  
>> -- 
>> 2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

