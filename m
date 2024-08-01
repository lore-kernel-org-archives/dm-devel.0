Received: from forward501a.mail.yandex.net (forward501a.mail.yandex.net [178.154.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEA91EB4AE
	for <dm-devel@lists.linux.dev>; Thu,  1 Aug 2024 14:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722523592; cv=none; b=BsdPWAh+OP3n3nh6x3XP+G42eWaSrcKscNEXmHZiH9+2cMFu4a3oQcLIk/SSLSxmcM0TbTWc93DpWsW/+B0Z9QYx3KzTbBveQ5THF/ypCgsYm4gedmr2PQzVtcbtynqD27z4RT6ZdxB+bfoI+FDiJlCqjwfpx/H77FU+brVOSbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722523592; c=relaxed/simple;
	bh=ruElIYvVXuXWlHz/2qpyprt+UXztEzONYjZnkuwty04=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=awGY0GLmhsiv++wCofNkfsG2USMYwGYo66ufdDyv3m3/Qu08KTTu6PRUX/fMm/q0rwxGB1EYrlsk5nTIh3lCbEekkchTW+Jh2YgokkZeYQZGbBhPRHQPOPyXp8GexJ/49vzByBuMKS1VifdEEaKHfLcPvNmQIpTzkFygjYeG9Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=wQnLtger; arc=none smtp.client-ip=178.154.239.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="wQnLtger"
Received: from mail-nwsmtp-smtp-production-main-64.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-64.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:169b:0:640:faad:0])
	by forward501a.mail.yandex.net (Yandex) with ESMTPS id DAB1161CD0;
	Thu,  1 Aug 2024 17:46:20 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-64.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id JkYaPQ0PmuQ0-CX18t2uF;
	Thu, 01 Aug 2024 17:46:20 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1722523580; bh=N8CW5XzoORMtlNIZsYqpZaVQshBSKhGqzo22PeVF58I=;
	h=References:Date:In-Reply-To:Cc:To:From:Subject:Message-ID;
	b=wQnLtger8UgV8kknPfrR832Ume74Nxb1xF+nFRVKdBVDpd8rF7KR4hWtqrJIcYwD+
	 cgvNkNUWaHh1RIa/0WE5V6ehQAicu7OuyYF8gKxQqf3MaSzFUzl0VpGT7Q8LeX8/0G
	 LjMMjmIWv5kzGcRPPdcFJznMdrxUSgit+5Ms+Y38=
Authentication-Results: mail-nwsmtp-smtp-production-main-64.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <ead8c4fcded5a1341a9ce0ca6aa471a52f6d0051.camel@yandex.ru>
Subject: Re: Lockup of (raid5 or raid6) + vdo after taking out a disk under
 load
From: Konstantin Kharlamov <Hi-Angel@yandex.ru>
To: Bryan Gurney <bgurney@redhat.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>, 
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yangerkun@huawei.com" <yangerkun@huawei.com>, "yukuai (C)"
 <yukuai3@huawei.com>,  dm-devel@lists.linux.dev, Matthew Sakai
 <msakai@redhat.com>
Date: Thu, 01 Aug 2024 17:46:18 +0300
In-Reply-To: <CAHhmqcTomcMEooe-mtZ5n1Gm_OfJ+bVssk54oXz84=Au75+Tag@mail.gmail.com>
References: <a6d068a26a90057fb3cdaa59f9d57a2af41a6b22.camel@yandex.ru>
	 <1f879e67-4d64-4df0-5817-360d84ff8b89@huaweicloud.com>
	 <29d69e586e628ef2e5f2fd7b9fe4e7062ff36ccf.camel@yandex.ru>
	 <517243f0-77c5-9d67-a399-78c449f6afc6@huaweicloud.com>
	 <810a319b846c7e16d85a7f52667d04252a9d0703.camel@yandex.ru>
	 <9c60881e-d28f-d8d5-099c-b9678bd69db9@huaweicloud.com>
	 <57241c91337e8fc3257b6d4a35c273af59875eff.camel@yandex.ru>
	 <37df66ec9cf1a0570a86ec0b9f17ae18ed11b832.camel@yandex.ru>
	 <CAHhmqcTomcMEooe-mtZ5n1Gm_OfJ+bVssk54oXz84=Au75+Tag@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-07-31 at 16:41 -0400, Bryan Gurney wrote:
> Hi Konstantin,
>
> This sounds a lot like something that I encountered with md, back in
> 2019, on the old vdo-devel mailing list:
>
> https://listman.redhat.com/archives/vdo-devel/2019-August/000171.html
>
> Basically, I had a RAID-5 md array that was in the process of
> recovery:
>
> $ cat /proc/mdstat
> Personalities : [raid0] [raid6] [raid5] [raid4]
> md0 : active raid5 sde[4] sdd[2] sdc[1] sdb[0]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2929890816 blocks super 1.2 level 5, 512k =
chunk, algorithm 2
> [4/3] [UUU_]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [=3D>...................]=C2=A0 recovery =
=3D=C2=A0 9.1% (89227836/976630272)
> finish=3D85.1min speed=3D173727K/sec
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap: 0/8 pages [0KB], 65536KB chunk
>
> Note that the speed of the recovery is 173,727 KB/sec, which is less
> than the sync_speed_max value:
>
> $ grep . /sys/block/md0/md/sync_speed*
> /sys/block/md0/md/sync_speed:171052
> /sys/block/md0/md/sync_speed_max:200000 (system)
> /sys/block/md0/md/sync_speed_min:1000 (system)
>
> ...And when I decreased "sync_speed_max" to "65536", I stopped seeing
> hung task timeouts.
>
> There's a similar setting in dm-raid: the "--maxrecoveryrate" option
> of lvchange.=C2=A0 So, to set the maximum recovery rate to 64 MiB per
> second per device, this would be the command, for an example VG/LV of
> "p_r5/testdmraid5"
>
> # lvchange --maxrecoveryrate 64M p_r5/testdmraid5
>
> (Older hard disk drives may not have a sequential read / write speed
> of more than 100 MiB/sec; this meant that md's default of 200 MiB/sec
> was "too fast", and would result in the recovery I/O starving the VDO
> volume from being able to service I/O.)
>
> The current value of max_recovery_rate for dm-raid can be displayed
> with "lvs -a -o +raid_max_recovery_rate".
>
> By reducing the maximum recovery rate for the dm-raid RAID-5 logical
> volume, does this result in the hung task timeouts for the
> "dm-vdo0-bioQ*" to not appear, and for the fio job to continue
> writing?

Thank you, so, I'm trying this out, and it doesn't seem to be working that =
well
(unless perhaps something changed in the userspace LVM since the 2.03.11 I =
am
using?).

So, after having executed the original steps-to-reproduce I have these two =
volumes:

    $ lvs
      LV                    VG   Attr       LSize   Pool                  O=
rigin Data%  Meta%  Move Log Cpy%Sync Convert
      deco_vol              p_r5 vwi-XXv-X- 100.00g vdo_internal_deco_vol
      vdo_internal_deco_vol p_r5 dwi-XX--X-  20.00g

Executing the suggested lvchange command does nothing on them:

    $ lvchange --maxrecoveryrate 64M p_r5/deco_vol
      Command on LV p_r5/deco_vol uses options that require LV types raid .
      Command not permitted on LV p_r5/deco_vol.
    $ lvchange --maxrecoveryrate 64M p_r5/vdo_internal_deco_vol
      Command on LV p_r5/vdo_internal_deco_vol uses options that require LV=
 types raid .
      Command not permitted on LV p_r5/vdo_internal_deco_vol.

Also, executing a `lvs -a -o +raid_max_recovery_rate` shows emptiness in pl=
ace of
that field. However, this command shows various internal volumes:

    $ lvs -a -o +raid_max_recovery_rate
      LV                                     VG   Attr       LSize   Pool  =
                Origin Data%  Meta%  Move Log Cpy%Sync Convert MaxSync
      deco_vol                               p_r5 vwi-XXv-X- 100.00g vdo_in=
ternal_deco_vol
      vdo_internal_deco_vol                  p_r5 dwi-XX--X-  20.00g
      [vdo_internal_deco_vol_vdata]          p_r5 rwi-aor---  20.00g       =
                                              100.00
      [vdo_internal_deco_vol_vdata_rimage_0] p_r5 iwi-aor---  10.00g
      [vdo_internal_deco_vol_vdata_rimage_1] p_r5 iwi-aor---  10.00g
      [vdo_internal_deco_vol_vdata_rimage_2] p_r5 iwi-aor---  10.00g
      [vdo_internal_deco_vol_vdata_rmeta_0]  p_r5 ewi-aor---   4.00m
      [vdo_internal_deco_vol_vdata_rmeta_1]  p_r5 ewi-aor---   4.00m
      [vdo_internal_deco_vol_vdata_rmeta_2]  p_r5 ewi-aor---   4.00m

So I tried executing the command on them:

    $ lvchange --maxrecoveryrate 64M p_r5/{vdo_internal_deco_vol_vdata,vdo_=
internal_deco_vol_vdata_rimage_0,vdo_internal_deco_vol_vdata_rimage_1,vdo_i=
nternal_deco_vol_vdata_rimage_2,vdo_internal_deco_vol_vdata_rmeta_0,vdo_int=
ernal_deco_vol_vdata_rmeta_1,vdo_internal_deco_vol_vdata_rmeta_2}
      Command on LV p_r5/vdo_internal_deco_vol_vdata_rimage_0 uses options =
that require LV types raid .
      Command not permitted on LV p_r5/vdo_internal_deco_vol_vdata_rimage_0=
.
      Command on LV p_r5/vdo_internal_deco_vol_vdata_rmeta_0 uses options t=
hat require LV types raid .
      Command not permitted on LV p_r5/vdo_internal_deco_vol_vdata_rmeta_0.
      Command on LV p_r5/vdo_internal_deco_vol_vdata_rimage_1 uses options =
that require LV types raid .
      Command not permitted on LV p_r5/vdo_internal_deco_vol_vdata_rimage_1=
.
      Command on LV p_r5/vdo_internal_deco_vol_vdata_rmeta_1 uses options t=
hat require LV types raid .
      Command not permitted on LV p_r5/vdo_internal_deco_vol_vdata_rmeta_1.
      Command on LV p_r5/vdo_internal_deco_vol_vdata_rimage_2 uses options =
that require LV types raid .
      Command not permitted on LV p_r5/vdo_internal_deco_vol_vdata_rimage_2=
.
      Command on LV p_r5/vdo_internal_deco_vol_vdata_rmeta_2 uses options t=
hat require LV types raid .
      Command not permitted on LV p_r5/vdo_internal_deco_vol_vdata_rmeta_2.
      Logical volume p_r5/vdo_internal_deco_vol_vdata changed.

This resulted in exactly one volume having changed its speed: the `[vdo_int=
ernal_deco_vol_vdata]`.

With that done, I tried removing a disk while there's load, and it results =
in same
old lockup reports:

-----------------------

So to sum up: the lvchange command only managed to change speed on a single=
 internal
volume, but that didn't make the lockup go away.
