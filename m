Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA6A382365
	for <dm-devel@lists.linux.dev>; Sat,  9 May 2026 09:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778318349; cv=none; b=OAqbji9/TqGK96LI1f/tjPL9dGTxYsJw5sBIEHCHvU9fyTTv/wtZ2+jBEcrXM3xMqHe/UNTqSfF4e2RrpMstSE27o7+guPwLbakNCuARJjFRPmRtVXtvfncABloRH87karayTLiT6bpqLWYY3eQIMG9+YBACAnDkU2ObF0ucQPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778318349; c=relaxed/simple;
	bh=GAmfihzwBx8UlSMVGuHe/To1/SPfWGuDi3zQirtTis0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WDPM+f1gDpbzuUMJq/UkBh1JgElfstKxdXYEJbiatHDjo26jI5GqAFpsgHLa+GTYE7G+Dfr+uFZddjYU3GML7oUj3q35ctyBkDBD/TFwnCrhZwcxW8Gvp46fbi6akGGaPNoTZUQSwT9/WHuXwLl/KMIBxbH4YmQy88YejBapc+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CrMy9uzi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CrMy9uzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2431AC2BCB2
	for <dm-devel@lists.linux.dev>; Sat,  9 May 2026 09:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778318349;
	bh=GAmfihzwBx8UlSMVGuHe/To1/SPfWGuDi3zQirtTis0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CrMy9uzidZ/luDhoiN3Ec85H8qAcXyVpzmwdUv8KK4NBSB46fHpeCEHBbmFP6yF3f
	 abaPIu9ZPlrS6OVytP+vUh++Uepcvt/XPT+0Zj2ZXJ7UE3AWFlijMZpYN6GarAyxNu
	 g6pyF0WVJihjh03jG4apz5jkSGIsaiZu3NCD8bWQinXIZqkuDhscjUymqTktmaCBPd
	 iY8R9Lpx/YN570D/ahiPmP5W09Pf8cMLxk52XlMpviv/2s2XqFv02tkDZKivFgealv
	 1qKF+bw6l4bdnx4FvAQWoftygultEwuk9ndaiw6b92AC8Dg0xlJ//tdhivHWqWAxeF
	 442sABnN9YvAg==
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-50d876329bbso25891321cf.2
        for <dm-devel@lists.linux.dev>; Sat, 09 May 2026 02:19:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/DI6lI7zqSE82Ha/ME+cL+M4OYTuo0ujpSejR53tSKGtgaOcZh6vs9kxM3NS49pM+qa+zgYJaYrQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzOkt4uLzJ2HpdpKPI57rNBknIak3SYUwb/o8zjMXQhrIg64wJs
	ilWV1Lch61ycGYcs9Qb9mucw7XTv/pNN56mi5pBZRMRh/ieBOILZxHgsz9SbrdlsZlv9/2qoGJx
	DUA4f7Af0V3nQtavFvs4z+ObGc/I02g==
X-Received: by 2002:ac8:6f09:0:b0:50f:135d:9508 with SMTP id
 d75a77b69052e-514621dd852mr221575831cf.55.1778318348481; Sat, 09 May 2026
 02:19:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260428232010.2785514-1-bmarzins@redhat.com>
In-Reply-To: <20260428232010.2785514-1-bmarzins@redhat.com>
From: Xiao Ni <xiao@kernel.org>
Date: Sat, 9 May 2026 17:18:57 +0800
X-Gmail-Original-Message-ID: <CAF-RUYVNd42=g7qSZPJKEndqk4EjjHWcdpByFN1qGkGSGQF53Q@mail.gmail.com>
X-Gm-Features: AVHnY4JlceJXW-oWxLURieRKh-TK859p6YpIIiSYVXUrDSdTmw5CyeoScb-wW1k
Message-ID: <CAF-RUYVNd42=g7qSZPJKEndqk4EjjHWcdpByFN1qGkGSGQF53Q@mail.gmail.com>
Subject: Re: [PATCH v2] dm-raid: only requeue bios when dm is suspending.
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>, 
	Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	Yang Xiuwei <yangxiuwei@kylinos.cn>, Li Nan <linan122@huawei.com>, 
	Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 29, 2026 at 7:20=E2=80=AFAM Benjamin Marzinski <bmarzins@redhat=
.com> wrote:
>
> returning DM_MAPIO_REQUEUE from the target map() function only requeues
> the bio during noflush suspends. During regular operations or during
> flushing suspends, it fails the bio. Failing the bio during flushing
> suspends is the correct behavior here. We cannot handle the bio, and we
> cannot suspends while it is outstanding. But during normal operations,
> we should not push the bio back to dm. Instead, wait for the reshape
> to be resumed.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>
> Changes from v1:
> - Track the dm device's suspending state in mddev->flags instead of
>   adding a new integer to mddev.
>
>  drivers/md/dm-raid.c | 6 ++++++
>  drivers/md/md.h      | 2 ++
>  drivers/md/raid5.c   | 7 +++++--
>  3 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index c5dc083c7244..8f5a5e1342a9 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3831,6 +3831,7 @@ static void raid_presuspend(struct dm_target *ti)
>          * resume, raid_postsuspend() is too late.
>          */
>         set_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
> +       set_bit(MD_DM_SUSPENDING, &mddev->flags);
>
>         if (!reshape_interrupted(mddev))
>                 return;
> @@ -3847,13 +3848,16 @@ static void raid_presuspend(struct dm_target *ti)
>  static void raid_presuspend_undo(struct dm_target *ti)
>  {
>         struct raid_set *rs =3D ti->private;
> +       struct mddev *mddev =3D &rs->md;
>
> +       clear_bit(MD_DM_SUSPENDING, &mddev->flags);
>         clear_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
>  }
>
>  static void raid_postsuspend(struct dm_target *ti)
>  {
>         struct raid_set *rs =3D ti->private;
> +       struct mddev *mddev =3D &rs->md;
>
>         if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) =
{
>                 /*
> @@ -3864,6 +3868,8 @@ static void raid_postsuspend(struct dm_target *ti)
>                 mddev_suspend(&rs->md, false);
>                 rs->md.ro =3D MD_RDONLY;
>         }
> +       clear_bit(MD_DM_SUSPENDING, &mddev->flags);
> +
>  }
>
>  static void attempt_restore_of_faulty_devices(struct raid_set *rs)
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 52c378086046..9e5100609d12 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -346,6 +346,7 @@ struct md_cluster_operations;
>   * @MD_HAS_SUPERBLOCK: There is persistence sb in member disks.
>   * @MD_FAILLAST_DEV: Allow last rdev to be removed.
>   * @MD_SERIALIZE_POLICY: Enforce write IO is not reordered, just used by=
 raid1.
> + * @MD_DM_SUSPENDING: This DM raid device is suspending.
>   *
>   * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is add=
ed
>   */
> @@ -365,6 +366,7 @@ enum mddev_flags {
>         MD_HAS_SUPERBLOCK,
>         MD_FAILLAST_DEV,
>         MD_SERIALIZE_POLICY,
> +       MD_DM_SUSPENDING,
>  };
>
>  enum mddev_sb_flags {
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 0d76e82f4506..65ae7d8930fc 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6042,8 +6042,11 @@ static enum stripe_result make_stripe_request(stru=
ct mddev *mddev,
>         raid5_release_stripe(sh);
>  out:
>         if (ret =3D=3D STRIPE_SCHEDULE_AND_RETRY && reshape_interrupted(m=
ddev)) {
> -               bi->bi_status =3D BLK_STS_RESOURCE;
> -               ret =3D STRIPE_WAIT_RESHAPE;
> +               if (!mddev_is_dm(mddev) ||
> +                   test_bit(MD_DM_SUSPENDING, &mddev->flags)) {
> +                       bi->bi_status =3D BLK_STS_RESOURCE;
> +                       ret =3D STRIPE_WAIT_RESHAPE;
> +               }
>                 pr_err_ratelimited("dm-raid456: io across reshape positio=
n while reshape can't make progress");
>         }
>         return ret;
> --
> 2.53.0
>
This patch looks good to me.
Reviewed-by: Xiao Ni <xiao@kernel.org>
