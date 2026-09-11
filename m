Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D02417BE0
	for <dm-devel@lists.linux.dev>; Fri, 11 Sep 2026 10:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789124121; cv=none; b=Oo8ii1jJGvs8TgDunwn1trexLvYKfgXQE38kSLAn3NMzvaNhNl1noRgWMNhVX++qsKhRsOHo4zA6bQJxWLA9V9z0XbmIYR8uVvotqutzszKmLxoTFNXN3iYqQrXuHu5Hc8Hl00FhxJ0cKZkzQjptxM16xVfAgICnvcL3YkqdDJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789124121; c=relaxed/simple;
	bh=ve2s5k2AkcEmEu6uGupBJMjWdCPQzeGp6SYoEHL7tQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=puqF+p+zKcSZBk7RYDIBLUcT7x6oaYQkuQg1GVA3lQeqvm9q/QGnbnm6/q7JPpKwzskmLYxpirwy9bGU6QWIJKd4QFJJWLU6IIyhdnPzNZGBS4cAcduJdAE2fnVLL6efl/jtvddjJLHIVruBGgu8LbSmYJqWBoBqFtVmih7lx/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HTvpUoue; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HTvpUoue"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B81io71082809;
	Fri, 11 Sep 2026 10:54:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Dl1WGo
	ynbtS7pJelxoHt7PUoSpyjimiBnE9ma6L8RAQ=; b=HTvpUoueqN2vo+EYb26yB4
	+eJX+nI4VCUxVcVdS94GCvUEloSUX4D/+vgMNVHRlU9k1ldSlfXxca8OMLdHsBAz
	RKWW/Jr9hzGqeR/RJlVFY+sQ7XqiYNR0i6ROghU16OXb72IAj46M4mMTdwo40bfj
	nnws/xhcba0fg7nqbY6rjT3myMecCYryO8I7qUJAjos5f1gHk2HYk0agfdapt1Tb
	DR8yO1KeNLEBH5xRQBPFgDjze6xf7G/12d6PC3tmp6vwC/usaSDRe2VArO9bt7V7
	Gl+pmitp+LgkPqq3U3v87Dv49zSQPU7QiLutLNRogG8/2wJaHCk4YwOSp2238egQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8sauyb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 10:54:54 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68BAo31a1499341;
	Fri, 11 Sep 2026 10:54:54 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvwk5u9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 10:54:54 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68BAsrCg49086866
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 10:54:53 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B7C758056;
	Fri, 11 Sep 2026 10:54:53 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 522315803F;
	Fri, 11 Sep 2026 10:54:45 +0000 (GMT)
Received: from [9.61.102.225] (unknown [9.61.102.225])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 10:54:45 +0000 (GMT)
Message-ID: <ec866125-6e45-4977-bb01-b13697fd3a8c@linux.ibm.com>
Date: Fri, 11 Sep 2026 16:24:44 +0530
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/8] md: pass a queue_limits through ->run()
To: Jack Wang <jinpu.wang@ionos.com>, Song Liu <song@kernel.org>,
        Yu Kuai <yukuai@fygo.io>, linux-raid@vger.kernel.org,
        abd.masalkhi@gmail.com
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <tom.leiming@gmail.com>, Xiao Ni <xiao@kernel.org>,
        Li Nan <magiclinan@didiglobal.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>
References: <20260910081114.1605746-1-jinpu.wang@ionos.com>
 <20260910081114.1605746-7-jinpu.wang@ionos.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260910081114.1605746-7-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: mJoiRqb9F6DXhRIgws3wyshHKa-XeLSu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDE0NyBTYWx0ZWRfX4r2UUkKaDR7s
 /SjSUmnFJfz2+np+3mXaQu0tJ4M6RZ0m79KvqtNq+5MtCyj8POwnz0nh1sfzaydMnxI+0RZ/bs7
 NLjsxZht9sTLxPw/TVZ8PXoXayNjAGmVBgJncvy1hl4tMDNLH5Q3LxpPxUeRH7i7ywIVg7muDAy
 oa2+l9NUqQJU2/jOmWh6psLvbrdvasj32F49uAraPv9zHk/GhN61s+T9ih91/+LaXLNzlV9xl87
 3U/6t2Wp5O5D9S6P685TSq2ncXF/jLDNSxZppV5jS9bSyDGst40TxK9BsA4TQ7pJ9agIwu6GlVh
 yLn5K/nnCsKiAant6dGxMHjPIczNoYSkIqovE42y+mJxZEXOoo6gXTP9A7Vt7HJYMImCpmEGNZH
 KGDJ4fQtwWKVNZcbgXDWgAbDXwyDJV/uqLyYnjNGElbc29JPEaesHuFBNLwKUxScX8W2KmGv2Zs
 Owf995Ef6HeghJIQg8g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDE0NyBTYWx0ZWRfX+BIy3pNXosbk
 HVBpn4uP59O/2q2bpnsnQ1bz6mkrraLxf3K7SPAbvDzjoes9/sXSPIycnbetoUwoxgw4T4da4gr
 iU13hGG0yxB6qyRiaPDs3MDYSRsNFtg=
X-Authority-Analysis: v=2.4 cv=MpXHeGae c=1 sm=1 tr=0 ts=6aa3ddff cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=pFKa84mh1ibiSWCD5WAA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: GH09hlCRcLiK-W5DuwAjUlEKGBVt2biZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110147

> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 35e103f0c2c3..59141e4299a8 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -379,7 +379,8 @@ static void raid0_free(struct mddev *mddev, void *priv)
>   	kfree(conf);
>   }
>   
> -static int raid0_set_limits(struct mddev *mddev)
> +static int raid0_set_limits(struct mddev *mddev,
> +			    struct queue_limits *caller_lim)
>   {
>   	struct queue_limits lim;
>   	int err;
> @@ -398,10 +399,19 @@ static int raid0_set_limits(struct mddev *mddev)
>   	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>   	if (err)
>   		return err;
> +	/*
> +	 * The caller owns an update and commits it itself; taking
> +	 * q->limits_lock here would take it a second time.
> +	 */
> +	if (caller_lim) {
> +		*caller_lim = lim;
> +		return 0;
> +	}
> +
>   	return queue_limits_set(mddev->gendisk->queue, &lim);
>   }
>   
[...]

> -static int raid1_set_limits(struct mddev *mddev)
> +static int raid1_set_limits(struct mddev *mddev,
> +			    struct queue_limits *caller_lim)
>   {
>   	struct queue_limits lim;
>   	int err;
> @@ -3185,10 +3186,19 @@ static int raid1_set_limits(struct mddev *mddev)
>   	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>   	if (err)
>   		return err;
> +	/*
> +	 * The caller owns an update and commits it itself; taking
> +	 * q->limits_lock here would take it a second time.
> +	 */
> +	if (caller_lim) {
> +		*caller_lim = lim;
> +		return 0;
> +	}
> +
>   	return queue_limits_set(mddev->gendisk->queue, &lim);
>   }
>   

[...]

>   
> -static int raid10_set_queue_limits(struct mddev *mddev)
> +static int raid10_set_queue_limits(struct mddev *mddev,
> +				   struct queue_limits *caller_lim)
>   {
>   	struct r10conf *conf = mddev->private;
>   	struct queue_limits lim;
> @@ -3948,10 +3949,19 @@ static int raid10_set_queue_limits(struct mddev *mddev)
>   	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>   	if (err)
>   		return err;
> +	/*
> +	 * The caller owns an update and commits it itself; taking
> +	 * q->limits_lock here would take it a second time.
> +	 */
> +	if (caller_lim) {
> +		*caller_lim = lim;
> +		return 0;
> +	}
> +
>   	return queue_limits_set(mddev->gendisk->queue, &lim);
>   }
>   

[...]

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 22759c631c4d..28bd81de86c1 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7944,7 +7944,8 @@ static int raid5_create_ctx_pool(struct r5conf *conf)
>   	return conf->ctx_pool ? 0 : -ENOMEM;
>   }
>   
> -static int raid5_set_limits(struct mddev *mddev)
> +static int raid5_set_limits(struct mddev *mddev,
> +			    struct queue_limits *caller_lim)
>   {
>   	struct r5conf *conf = mddev->private;
>   	struct queue_limits lim;
> @@ -7996,10 +7997,19 @@ static int raid5_set_limits(struct mddev *mddev)
>   	/* No restrictions on the number of segments in the request */
>   	lim.max_segments = USHRT_MAX;
>   
> +	/*
> +	 * The caller owns an update and commits it itself; taking
> +	 * q->limits_lock here would take it a second time.
> +	 */
> +	if (caller_lim) {
> +		*caller_lim = lim;
> +		return 0;
> +	}
> +
>   	return queue_limits_set(mddev->gendisk->queue, &lim);
>   }
>   
[...]
I'd propose the same changes as I suggested in patch 1/8, for
raid5_set_limits(), raid10_set_queue_limits(), raid1_set_limits()
and raid0_set_limits().

In particular, I think these functions should always operate on
a caller-provided struct queue_limits and only prepare/update the
limits, without deciding whether to commit them. The caller should
own the limits update and commit it as appropriate for its locking
context.

Thanks,
--Nilay

