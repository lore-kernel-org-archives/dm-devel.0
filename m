Received: from va-2-53.ptr.blmpb.com (va-2-53.ptr.blmpb.com [209.127.231.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C9C43712C
	for <dm-devel@lists.linux.dev>; Sun, 20 Sep 2026 12:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789906382; cv=none; b=TTxPLe+5SaXsNhBISZRL/Bsa/ABELJ3XgNk+c22E+Yko0Gnw06S8wssVksnHL471v8LT8B7U62o+GdEQsIItgdpyUMjzzWVbN4iAZ7BmnMlUccJlwxplYFHTAXIqyTzNBd/fL4Lavs2oQDsQeVfuHQhcL/QoI7QTUvYA53paxk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789906382; c=relaxed/simple;
	bh=pKT+0Fbsx0pOeaciHlR4WxrGwXqJdKpan0Oeq5CTFcc=;
	h=Message-Id:In-Reply-To:Cc:Content-Type:From:Date:Mime-Version:To:
	 Subject:References; b=TcIqUwQGdOvALPc7klJzmaaskKzu3vppcN7tDLfCw0ASajMCT5pVb0kmyB/tULA9zllGCbmRZtGEI8vDdbg2k3oJMUpwrNPDSE4/zEpdctU/vOqU/JwU9GZYuE9W7f57JTx4TxLKJbFHkyB/bD5vCceo/u8c3s8kJYzZWashXGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Y0Nwm6ss; arc=none smtp.client-ip=209.127.231.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Y0Nwm6ss"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789906354;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=kmpN+3+EemAMVuc/I4vBTUm5qj3+yAi4nNgOed5JQOQ=;
 b=Y0Nwm6sse9Z9R63/2mm7v4hLPvLr27DJblGDnHMJL+qEifvbDB4TZGIJOR3Wwfow5pK3n8
 wRJoixtABbXFrKyn8pdKswHXXhd1pCzVb+1m9v4h9GZZxTMOYdWJDEGL+a3pzUu4JA0qDw
 PAMQZsCjPP9JDApGCMcQ7i9H1WNbR6K1keVVOYUi7yyleCJZlpI4oxlc1cE/BQnFqx3Eo0
 duNuz1NsTtSgF9CITJzoLidEs7PbijzRTxy7PQ/s4ItU0c4dbipAKZiJwA+pQ/QeT2a606
 HmJ1+j7kBFBkAE+oue6GKvObZ21HtIyizAqvnXapgoiMzaTfPLCPFY08y+l2+Q==
Message-Id: <d7c8403b-14fd-4c26-9b8e-b327f69e92fb@fygo.io>
In-Reply-To: <20260918141737.3023011-1-peng.fan@oss.nxp.com>
Reply-To: yukuai@fygo.io
Cc: <linux-kernel@vger.kernel.org>, "Peng Fan" <peng.fan@nxp.com>, 
	<dm-devel@lists.linux.dev>, <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
From: "yu kuai" <yukuai@fygo.io>
Date: Sun, 20 Sep 2026 20:12:29 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26aafcdb1+3d7499+lists.linux.dev+yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.142]) by smtp.larksuite.com with ESMTPS; Sun, 20 Sep 2026 12:12:33 +0000
X-Original-From: yu kuai <yukuai@fygo.io>
To: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>, 
	"Alasdair Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, "Song Liu" <song@kernel.org>, 
	"Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md: use assign_bit() where applicable
Content-Transfer-Encoding: quoted-printable
References: <20260918141737.3023011-1-peng.fan@oss.nxp.com>

Hi,

=E5=9C=A8 2026/9/18 22:17, Peng Fan (OSS) =E5=86=99=E9=81=93:
> From: Peng Fan <peng.fan@nxp.com>
>
> Convert open-coded if/else with set_bit/clear_bit and their
> non-atomic __set_bit/__clear_bit variants to the assign_bit/__assign_bit
> API.
>
> Done with Coccinelle semantic patch:
>      // set_bit -> clear_bit =3D> assign_bit
>
>      @@
>      expression cond, bit, addr;
>      @@
>
>      -if (cond)
>      -        set_bit(bit, addr);
>      -else
>      -        clear_bit(bit, addr);
>      +assign_bit(bit, addr, cond);
>
>      // clear_bit -> set_bit =3D> assign_bit
>
>      @@
>      expression cond, bit, addr;
>      @@
>
>      -if (cond)
>      -        clear_bit(bit, addr);
>      -else
>      -        set_bit(bit, addr);
>      +assign_bit(bit, addr, !cond);
>
>      // __set_bit -> __clear_bit =3D> __assign_bit
>
>      @@
>      expression cond, bit, addr;
>      @@
>
>      -if (cond)
>      -        __set_bit(bit, addr);
>      -else
>      -        __clear_bit(bit, addr);
>      +__assign_bit(bit, addr, cond);
>
>      // __clear_bit -> __set_bit =3D> __assign_bit
>
>      @@
>      expression cond, bit, addr;
>      @@
>
>      -if (cond)
>      -        __clear_bit(bit, addr);
>      -else
>      -        __set_bit(bit, addr);
>      +__assign_bit(bit, addr, !cond);
>
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> ---
>   drivers/md/dm-mpath.c                  |  5 +----
>   drivers/md/dm-zone.c                   |  6 ++----
>   drivers/md/md.c                        | 22 ++++++----------------
>   drivers/md/persistent-data/dm-bitset.c |  5 +----
>   drivers/md/raid5-cache.c               |  6 ++----
>   drivers/md/raid5.c                     |  6 ++----
>   6 files changed, 14 insertions(+), 36 deletions(-)

please split this patch, one for mdraid and one for device mapper, they are
different subsystem.

>
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 7cb7bb6233b6..ae9318f5f21b 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1604,10 +1604,7 @@ static void pg_init_done(void *data, int errors)
>   		goto out;
>  =20
>   	if (test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags)) {
> -		if (delay_retry)
> -			set_bit(MPATHF_PG_INIT_DELAY_RETRY, &m->flags);
> -		else
> -			clear_bit(MPATHF_PG_INIT_DELAY_RETRY, &m->flags);
> +		assign_bit(MPATHF_PG_INIT_DELAY_RETRY, &m->flags, delay_retry);
>  =20
>   		if (__pg_init_all_paths(m))
>   			goto out;
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index f29acf64429a..35916c6e490e 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -447,10 +447,8 @@ void dm_finalize_zone_settings(struct dm_table *t, s=
truct queue_limits *lim)
>   	struct mapped_device *md =3D t->md;
>  =20
>   	if (lim->features & BLK_FEAT_ZONED) {
> -		if (dm_table_supports_zone_append(t))
> -			clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> -		else
> -			set_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> +		assign_bit(DMF_EMULATE_ZONE_APPEND, &md->flags,
> +			   !dm_table_supports_zone_append(t));
>   	} else {
>   		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
>   		md->disk->nr_zones =3D 0;
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3..6b2a397f8a9c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3586,10 +3586,7 @@ static ssize_t recovery_start_store(struct md_rdev=
 *rdev, const char *buf, size_
>   		return -EBUSY;
>  =20
>   	rdev->recovery_offset =3D recovery_start;
> -	if (recovery_start =3D=3D MaxSector)
> -		set_bit(In_sync, &rdev->flags);
> -	else
> -		clear_bit(In_sync, &rdev->flags);
> +	assign_bit(In_sync, &rdev->flags, recovery_start =3D=3D MaxSector);
>   	return len;
>   }
>  =20
> @@ -5915,10 +5912,7 @@ fail_last_dev_store(struct mddev *mddev, const cha=
r *buf, size_t len)
>   	if (ret)
>   		return ret;
>  =20
> -	if (value)
> -		set_bit(MD_FAILLAST_DEV, &mddev->flags);
> -	else
> -		clear_bit(MD_FAILLAST_DEV, &mddev->flags);
> +	assign_bit(MD_FAILLAST_DEV, &mddev->flags, value);
>  =20
>   	return len;
>   }
> @@ -7574,14 +7568,10 @@ int md_add_new_disk(struct mddev *mddev, struct m=
du_disk_info_s *info)
>   		}
>  =20
>   		clear_bit(In_sync, &rdev->flags); /* just to be sure */
> -		if (info->state & (1<<MD_DISK_WRITEMOSTLY))
> -			set_bit(WriteMostly, &rdev->flags);
> -		else
> -			clear_bit(WriteMostly, &rdev->flags);
> -		if (info->state & (1<<MD_DISK_FAILFAST))
> -			set_bit(FailFast, &rdev->flags);
> -		else
> -			clear_bit(FailFast, &rdev->flags);
> +		assign_bit(WriteMostly, &rdev->flags,
> +			   info->state & (1 << MD_DISK_WRITEMOSTLY));
> +		assign_bit(FailFast, &rdev->flags,
> +			   info->state & (1 << MD_DISK_FAILFAST));
>  =20
>   		if (info->state & (1<<MD_DISK_JOURNAL)) {
>   			struct md_rdev *rdev2;
> diff --git a/drivers/md/persistent-data/dm-bitset.c b/drivers/md/persiste=
nt-data/dm-bitset.c
> index 00c0a3f186b7..6680f05c25ec 100644
> --- a/drivers/md/persistent-data/dm-bitset.c
> +++ b/drivers/md/persistent-data/dm-bitset.c
> @@ -59,10 +59,7 @@ static int pack_bits(uint32_t index, void *value, void=
 *context)
>   		if (r)
>   			return r;
>  =20
> -		if (bv)
> -			set_bit(bit, (unsigned long *) &word);
> -		else
> -			clear_bit(bit, (unsigned long *) &word);
> +		assign_bit(bit, (unsigned long *)&word, bv);
>   	}
>  =20
>   	*((__le64 *) value) =3D cpu_to_le64(word);
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 7b7546bfa21f..b442a4de61fb 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -432,10 +432,8 @@ static inline void r5c_update_log_state(struct r5l_l=
og *log)
>   			wake_reclaim =3D true;
>   		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
>   	}
> -	if (free_space < 3 * reclaim_space)
> -		set_bit(R5C_LOG_TIGHT, &conf->cache_state);
> -	else
> -		clear_bit(R5C_LOG_TIGHT, &conf->cache_state);
> +	assign_bit(R5C_LOG_TIGHT, &conf->cache_state,
> +		   free_space < 3 * reclaim_space);
>  =20
>   	if (wake_reclaim)
>   		r5l_wake_reclaim(log, 0);
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b91545ce090d..713596ee933c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4748,10 +4748,8 @@ static void analyse_stripe(struct stripe_head *sh,=
 struct stripe_head_state *s)
>   				       RAID5_STRIPE_SECTORS(conf)))
>   			set_bit(R5_ReadRepl, &dev->flags);
>   		else {
> -			if (rdev && !test_bit(Faulty, &rdev->flags))
> -				set_bit(R5_NeedReplace, &dev->flags);
> -			else
> -				clear_bit(R5_NeedReplace, &dev->flags);
> +			assign_bit(R5_NeedReplace, &dev->flags,
> +				   rdev && !test_bit(Faulty, &rdev->flags));
>   			rdev =3D conf->disks[i].rdev;
>   			clear_bit(R5_ReadRepl, &dev->flags);
>   		}

--=20
Thanks,
Kuai
