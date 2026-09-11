Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E432FFDEA
	for <dm-devel@lists.linux.dev>; Fri, 11 Sep 2026 10:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789123628; cv=none; b=JnBHReRCgaFmaZYx5gjN1ejjc5XjNXTGZ/i85oqf2BNTdM33N0/w/f1iRjxSbOKKxxYn4ZXAmsJAhRpajDHfFGcsnOKoj+Jdk2ImXfUsZSvlQt/LA53Gt95TF9T6sS6ivopoZrJ3iyxsnmZS1hJ7wQ5CymZUwfs/llrk9ostOJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789123628; c=relaxed/simple;
	bh=pt/ZgIWTRmdNQBXL6Lc7HqboKtlPDy6cc7GoitbE7X8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WrdwBYkLq7JTZrkDJd1yh+tB1Ad8f5sjDY2f/SlMI/IHYrUqF6cANW/J9cXhyT82DNV0+37+ZQYvX/hnNlaLQhz168k7mfISb5ReCe80Y6roxqeK7Tq9movJW33Gv5Hhh0rllXJuq6dC2zjgPx8CpZQ0+cML8qRBpw5KJwvMvLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YVHpo0nU; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YVHpo0nU"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B81aXL1253338;
	Fri, 11 Sep 2026 10:46:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=oTl7G5
	o4R8WS9QEA7dvnJUZtTtkXhppj8sFdtQ4GUbA=; b=YVHpo0nUPwVPMyd25368SO
	hhPfU1eojoggzLnQq9jI33ZkrfJikJH4gOtwIVYeNf7bWWbTnJpbPKo/a5xI5KFZ
	lFPI6A0wopS1FvDleK4c4depeSF1sKhEwA56G4kuKFFL5FDiPp4A2XurIAdaTUok
	YiVfs5xQXHXbw7gQ+QcCbfua2hAC01ZBXzf2TS0riJJlmoQyMJfQofqIKs24I/1X
	wyiD1gbYv7+hZ0/6RA9QRQ5AxZL9FXQCYMBHoLpd3Sj6Z65CuhOylpEahSgkIx6Y
	UdwGKX0SyoZz5McqoI5vPLXw6D24kjPqgdW8KkTxIzuDOv2QBHBvMeHeVzLHRycg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8t2u06-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 10:46:43 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B7o5hg1327402;
	Fri, 11 Sep 2026 10:46:43 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gkvnrnud2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 10:46:43 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68BAkgGA5374572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 10:46:42 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 03E1058063;
	Fri, 11 Sep 2026 10:46:42 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7BB3F5803F;
	Fri, 11 Sep 2026 10:46:35 +0000 (GMT)
Received: from [9.61.102.225] (unknown [9.61.102.225])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 10:46:35 +0000 (GMT)
Message-ID: <29dafcd7-2364-4196-be57-4b1dc29a128f@linux.ibm.com>
Date: Fri, 11 Sep 2026 16:16:33 +0530
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] md: pass a queue_limits down to ->hot_add_disk()
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
 <20260910081114.1605746-2-jinpu.wang@ionos.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260910081114.1605746-2-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDE0NyBTYWx0ZWRfX2hoNHVPdnYUI
 H8kbFqSd8Om0wBXMABwXzGk+bSKbF4LXs/ZmMP8AFNnTGQlvH87+LEsJ0Jm9FQruZHcHsnsHDSS
 Bp18UOD7SqPttJGfNpNd3r6QZo7QJoE=
X-Proofpoint-ORIG-GUID: 6ac4UBwO4YL3LLDS47vTHivZSvG_mXP-
X-Proofpoint-GUID: tTU994RvFNd4qquOMOwX786x_0zmjG-q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDE0NyBTYWx0ZWRfXz9j4EmtEafIZ
 vn+UeYoi2aNqgULXHPz+gV5HEV6LX/YWX817vks+xwFh+MBq0rqBzO86Yh8qiS5Sze6syHA5lZi
 dQeNWVYG2IljOUu/6PJTm2UdN/ptFxMITz1KnIY0NOI9agrWM819pFJby5ssej5Lk+1tO3PCkKE
 ZzWeumOpaVLy0O7d9qRmCE5tmT/9NvHKOjid3dCU6ikVyjb4+iZVLIXHQa/JuYl7/wZW93FNcMX
 cWrFXmbQWaOEajQyZPiwODDMh0mVkH33s+tJow5lx7+FSX/fN/98/hFXzXLqxdMEKUWezd2teUj
 qaaV06Y0PzRyHhvYEwX6gJFciGCxsNKiwL1g4MDQL6bQB1lCskF2EtsR9PZVjC+9RIneK+B7fpU
 c6APpIOowRaK5Js2Fd6SbRdrGWXrkD8NFAJm+B7sokyLeelI2eO9unmZHja1kFwGxc3o89R84V1
 FDIf74pbqSLiVmcqLmg==
X-Authority-Analysis: v=2.4 cv=PIGaavqC c=1 sm=1 tr=0 ts=6aa3dc14 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=UgJECxHJAAAA:8
 a=azlZDkOc1migqPPA1yoA:9 a=QEXdDO2ut3YA:10 a=-El7cUbtino8hM1DCn8D:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 bulkscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110147

On 9/10/26 1:41 PM, Jack Wang wrote:
> From: Jack Wang <jinpu.wang@cloud.ionos.com>
> 
> Adding a leg stacks its queue limits, which mddev_stack_new_rdev() does
> by taking q->limits_lock itself.  Callers holding reconfig_mutex or a
> suspended array cannot allow that, and must own the update instead.
> 
> Give ->hot_add_disk(), remove_and_add_spares() and
> md_choose_sync_action() a struct queue_limits argument with three
> states: an update to stack into, NULL to let the personality take the
> lock as before, or MDDEV_STACK_SKIP to add the leg without touching the
> limits, for callers that can do neither.  mddev_stack_rdev_into() stacks
> into a caller-owned update without the lock.
> 
> Every caller still passes NULL and nothing passes the sentinel yet, so
> there is no functional change; the users follow.
> 
> Assisted-by: LLM
> Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>   drivers/md/dm-raid.c   |  2 +-
>   drivers/md/md-linear.c | 28 ++++++++++++++----
>   drivers/md/md.c        | 66 ++++++++++++++++++++++++++++++++----------
>   drivers/md/md.h        | 11 ++++++-
>   drivers/md/raid1.c     | 10 +++++--
>   drivers/md/raid10.c    | 19 +++++++++---
>   drivers/md/raid5.c     |  5 ++--
>   7 files changed, 110 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 8f5a5e1342a9..21a1922bee4f 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3923,7 +3923,7 @@ static void attempt_restore_of_faulty_devices(struct raid_set *rs)
>   			clear_bit(Faulty, &r->flags);
>   			clear_bit(WriteErrorSeen, &r->flags);
>   
> -			if (mddev->pers->hot_add_disk(mddev, r)) {
> +			if (mddev->pers->hot_add_disk(mddev, r, NULL)) {
>   				/* Failed to revive this device, try next */
>   				r->raid_disk = r->saved_raid_disk = -1;
>   				r->flags = flags;
> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> index 73b367b61b87..da82c313d459 100644
> --- a/drivers/md/md-linear.c
> +++ b/drivers/md/md-linear.c
> @@ -65,11 +65,16 @@ static sector_t linear_size(struct mddev *mddev, sector_t sectors, int raid_disk
>   	return array_sectors;
>   }
>   
> -static int linear_set_limits(struct mddev *mddev)
> +static int linear_set_limits(struct mddev *mddev,
> +			     struct queue_limits *caller_lim)
>   {
>   	struct queue_limits lim;
>   	int err;
>   
> +	/* the caller can neither stack nor take q->limits_lock */
> +	if (caller_lim == MDDEV_STACK_SKIP)
> +		return 0;
> +
>   	md_init_stacking_limits(&lim);
>   	lim.features |= BLK_FEAT_NOWAIT;
>   	lim.max_hw_sectors = mddev->chunk_sectors;
> @@ -82,10 +87,20 @@ static int linear_set_limits(struct mddev *mddev)
>   	if (err)
>   		return err;
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
This looks overly complicated with three different cases where
linear_set_limits() either ignores the limits update, updates the limits
provided by the caller without committing them, or updates and commits the
limits itself.

Why can't we instead have the callers always pass a struct queue_limits
pointer, and make linear_set_limits() only update the limits provided by
its caller without committing them?

The caller can then decide what to do with the resulting limits: either
ignore them or commit them as appropriate. This also avoids introducing
MDDEV_STACK_SKIP as a special sentinel value.

In this model, linear_set_limits() would only be responsible for preparing
the limits. This also keeps the locking and limits-commit logic in one common
place. The caller is then responsible for acquiring the appropriate locks and
committing the limits in the correct order for its particular context.

So the core logic is: personality should describe what the limits need to
become and the MD core/caller should decide when those limits become visible.

[...]

>   
> +/*
> + * Stack a new rdev into limits the caller already holds limits_lock for and
> + * will commit itself.  Used from paths that must take limits_lock before
> + * quiescing the array, see md_start_sync().
> + */
> +int mddev_stack_rdev_into(struct mddev *mddev, struct md_rdev *rdev,
> +			  struct queue_limits *lim)
> +{
> +	struct queue_limits tmp = *lim;
> +
> +	if (mddev_is_dm(mddev))
> +		return 0;
> +
> +	if (queue_logical_block_size(rdev->bdev->bd_disk->queue) >
> +	    queue_logical_block_size(mddev->gendisk->queue)) {
> +		pr_err("%s: incompatible logical_block_size, can not add\n",
> +		       mdname(mddev));
> +		return -EINVAL;
> +	}
> +
> +	queue_limits_stack_bdev(&tmp, rdev->bdev, rdev->data_offset,
> +				mddev->gendisk->disk_name);
> +
> +	if (!queue_limits_stack_integrity_bdev(&tmp, rdev->bdev)) {
> +		pr_err("%s: incompatible integrity profile for %pg\n",
> +		       mdname(mddev), rdev->bdev);
> +		return -ENXIO;
> +	}
> +
> +	*lim = tmp;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(mddev_stack_rdev_into);
> +
This API is correctly moving in that direction which I proposed above.
But rather than adding new API, I'd update mddev_stack_new_rdev() (or
rename it to mddev_stack_rdev_into()) which would stack the rdev into
the caller-provided struct queue_limits without taking q->limits_lock
or committing the limits.

[...]
> +/*
> + * Sentinel for the queue_limits argument of ->hot_add_disk().  The caller has
> + * no update to stack into and must not take q->limits_lock itself, so the leg
> + * is added with the array's current limits.
> + */
> +#define MDDEV_STACK_SKIP	((struct queue_limits *)ERR_PTR(-EAGAIN))

If we follow the design as I suggested above then we can get away with
above sentinel.

[...]


> -static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
> +static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev,
> +			  struct queue_limits *lim)
>   {
>   	struct r1conf *conf = mddev->private;
>   	int err = -EEXIST;
> @@ -1923,7 +1924,12 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
>   	for (mirror = first; mirror <= last; mirror++) {
>   		p = conf->mirrors + mirror;
>   		if (!p->rdev) {
> -			err = mddev_stack_new_rdev(mddev, rdev);
> +			if (lim == MDDEV_STACK_SKIP)
> +				err = 0;
> +			else if (lim)
> +				err = mddev_stack_rdev_into(mddev, rdev, lim);
> +			else
> +				err = mddev_stack_new_rdev(mddev, rdev);
>   			if (err)
>   				return err;
>   
Here as well the same comment as linear_set_limits().

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 1093c798d9dd..222bd7badcff 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2095,7 +2095,8 @@ static int raid10_spare_active(struct mddev *mddev)
>   	return count;
>   }
>   
> -static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
> +static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev,
> +			   struct queue_limits *lim)
>   {
>   	struct r10conf *conf = mddev->private;
>   	int err = -EEXIST;
> @@ -2130,7 +2131,12 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
>   			continue;
>   		}
>   
> -		err = mddev_stack_new_rdev(mddev, rdev);
> +		if (lim == MDDEV_STACK_SKIP)
> +			err = 0;
> +		else if (lim)
> +			err = mddev_stack_rdev_into(mddev, rdev, lim);
> +		else
> +			err = mddev_stack_new_rdev(mddev, rdev);
>   		if (err)
>   			return err;
>   		p->head_position = 0;
> @@ -2147,7 +2153,12 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
>   		clear_bit(In_sync, &rdev->flags);
>   		set_bit(Replacement, &rdev->flags);
>   		rdev->raid_disk = repl_slot;
> -		err = mddev_stack_new_rdev(mddev, rdev);
> +		if (lim == MDDEV_STACK_SKIP)
> +			err = 0;
> +		else if (lim)
> +			err = mddev_stack_rdev_into(mddev, rdev, lim);
> +		else
> +			err = mddev_stack_new_rdev(mddev, rdev);
>   		if (err)
>   			return err;
>   		conf->fullsync = 1;

Again same comment as linear_set_limits().

Thanks,
--Nilay

