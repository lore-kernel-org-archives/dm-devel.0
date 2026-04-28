Received: from va-2-30.ptr.blmpb.com (va-2-30.ptr.blmpb.com [209.127.231.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3574E3A7831
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 08:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777365370; cv=none; b=LodG9Pg/hGDbUehG1Vo72PJJYfXTr2wFRtBW4gpdxMeIvybNKah7kStEat0gxSnJzujjIlP4JLEYz01qsCHHoW00W54tf8rQfDUAsf6hAaJQxcx98Y7J0DOrCwVKO/DLVg/5iF3nVjNMDHrsgaTeKXgBoEgeYY65ZcmLxvBwd0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777365370; c=relaxed/simple;
	bh=mEkoZyVRKnDgwYNS3ydtXdpNVtYjMErvomVxhO9m5Zk=;
	h=To:From:Message-Id:Cc:Subject:Date:Mime-Version:References:
	 In-Reply-To:Content-Type; b=KYGUEs6nyq/wm3NT427yC/TP4LMNQLhQT/PZa8cB2roIfom5VyvRYpLgNpiyInWK3L5lbyQCPzhjxf9ng5i2cAwFZJIfe+FFzHj0lbKRunEKmj5VNVTySVfxk485P5+KCPj5rU3fgZmJ6aaJftr1LdVtuOyACD4WqelYHS6TE8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=oqNwNAAf; arc=none smtp.client-ip=209.127.231.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="oqNwNAAf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1777365357;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=WqOpI73oguuXxE77jncWiCP//wCNv+y8pygW9AIz84M=;
 b=oqNwNAAf7DALDEfrPCktzy2byPviQ8BQePJXUfBbBkcE1vSWusieLpU3gggyNnuC/shFez
 jKaOR5Z0Ns2eCxb8sda7ESPvxnIhIggYj1BCC4KE2FEiKqbc5UUYJc5bOtlmk0Ll1LUiei
 JXaBJ6ZgUUPsJ7JHPWqZet2nGwpNdPZuqCSJ7ExALh5RTPQFZvPwoUKU311Rol00CIRWP1
 NlDxrD2UqeZniKMVMO25qJ8psKM4A87nTmIJFfGU3E/ck3q0G6qcCfnsUjBL23ORE/yzR6
 td8KfZ/NqPR3dH1vMmQDymuHAP2Vp2CUG4RtcdYCQvwZ2zlJg8UljNxLTMsQ3Q==
To: "Benjamin Marzinski" <bmarzins@redhat.com>, 
	"Yang Xiuwei" <yangxiuwei@kylinos.cn>
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <e98037c0-de70-4de4-b3ea-e2d67022a7fc@fnnas.com>
Reply-To: yukuai@fnnas.com
Cc: "Yu Kuai" <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>, 
	"Li Nan" <linan666@huaweicloud.com>, "Song Liu" <song@kernel.org>, 
	<linux-raid@vger.kernel.org>, <dm-devel@lists.linux.dev>, 
	"Xiao Ni" <xni@redhat.com>, "Nigel Croxon" <ncroxon@redhat.com>, 
	<yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.183]) by smtp.feishu.cn with ESMTPS; Tue, 28 Apr 2026 16:35:54 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+269f0716b+eeb328+lists.linux.dev+yukuai@fnnas.com>
Subject: Re: [RFC PATCH] dm-raid: only requeue bios when dm is suspending.
Date: Tue, 28 Apr 2026 16:35:52 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <ad6FNUtSCS_zTrHW@redhat.com> <20260414190350.1946406-1-bmarzins@redhat.com>
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260414190350.1946406-1-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/4/15 3:03, Benjamin Marzinski =E5=86=99=E9=81=93:
> returning DM_MAPIO_REQUEUE from the target map() function only requeues
> the bio during noflush suspends. During regular operations or during
> flushing suspends, it fails the bio. Failing the bio during flushing
> suspends is the correct behavior here. We cannot handle the bio, and we
> cannot suspends while it is outstanding. But during normal operations,
> we should not push the bio back to do. Instead, wait for the reshape
> to be resumed.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>
> Yang Xiuwei, if you are still able to see I/O errors during LVM testing,
> does this patch fix them?
>
>   drivers/md/dm-raid.c | 7 +++++++
>   drivers/md/md.h      | 1 +
>   drivers/md/raid5.c   | 6 ++++--
>   3 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 4bacdc499984..cac61d57e7e2 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3831,6 +3831,7 @@ static void raid_presuspend(struct dm_target *ti)
>   	 * resume, raid_postsuspend() is too late.
>   	 */
>   	set_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
> +	WRITE_ONCE(mddev->dm_suspending, 1);
>  =20
>   	if (!reshape_interrupted(mddev))
>   		return;
> @@ -3847,6 +3848,9 @@ static void raid_presuspend(struct dm_target *ti)
>   static void raid_presuspend_undo(struct dm_target *ti)
>   {
>   	struct raid_set *rs =3D ti->private;
> +	struct mddev *mddev =3D &rs->md;
> +
> +	WRITE_ONCE(mddev->dm_suspending, 0);
>  =20
>   	clear_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
>   }
> @@ -3854,6 +3858,7 @@ static void raid_presuspend_undo(struct dm_target *=
ti)
>   static void raid_postsuspend(struct dm_target *ti)
>   {
>   	struct raid_set *rs =3D ti->private;
> +	struct mddev *mddev =3D &rs->md;
>  =20
>   	if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
>   		/*
> @@ -3864,6 +3869,8 @@ static void raid_postsuspend(struct dm_target *ti)
>   		mddev_suspend(&rs->md, false);
>   		rs->md.ro =3D MD_RDONLY;
>   	}
> +	WRITE_ONCE(mddev->dm_suspending, 0);
> +
>   }
>  =20
>   static void attempt_restore_of_faulty_devices(struct raid_set *rs)
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ac84289664cd..e8d7332c5cb9 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -463,6 +463,7 @@ struct mddev {
>   	int				delta_disks, new_level, new_layout;
>   	int				new_chunk_sectors;
>   	int				reshape_backwards;
> +	int				dm_suspending;

This patch looks fine, however, can you also optimize it by a new
flag instead a new int field ?

>  =20
>   	struct md_thread __rcu		*thread;	/* management thread */
>   	struct md_thread __rcu		*sync_thread;	/* doing resync or reconstruct *=
/
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8854e024f311..d528263f92a3 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6042,8 +6042,10 @@ static enum stripe_result make_stripe_request(stru=
ct mddev *mddev,
>   	raid5_release_stripe(sh);
>   out:
>   	if (ret =3D=3D STRIPE_SCHEDULE_AND_RETRY && reshape_interrupted(mddev)=
) {
> -		bi->bi_status =3D BLK_STS_RESOURCE;
> -		ret =3D STRIPE_WAIT_RESHAPE;
> +		if (!mddev_is_dm(mddev) || READ_ONCE(mddev->dm_suspending)) {
> +			bi->bi_status =3D BLK_STS_RESOURCE;
> +			ret =3D STRIPE_WAIT_RESHAPE;
> +		}
>   		pr_err_ratelimited("dm-raid456: io across reshape position while resh=
ape can't make progress");
>   	}
>   	return ret;

--=20
Thansk,
Kuai
