Received: from forward500a.mail.yandex.net (forward500a.mail.yandex.net [178.154.239.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD152193079
	for <dm-devel@lists.linux.dev>; Wed, 31 Jul 2024 14:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722435680; cv=none; b=dBundWqWh5OZOPZDOP7D1GJf/K7W8VHtNwL4XtU4m3Lcbk87ILHGYRrNTj+9VfDWh5Brq8vwj39+9b8uVY1fitk0utgI/4wZPQtvdIfosCrg4kfGP0ystT3bRfs5VNnvN1lxgKdhigBRUpGwTJDNzJKE4Gsx5SsXJYn6xjELohE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722435680; c=relaxed/simple;
	bh=UpRkHWkRUZpnx10VV5ws2Oa91Vy3M0E4fnIKxdx5l9E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T9WnhIZlAf+CzOg00vW+2PjLeb/23TnVrra/fGMspbR2Vb/W8hEs7PMDrfBNOPfyVfNkwskuVheMcl81G2zR9nhw+Ozb3r3ulcxr2B7Vc3DaxSC9FoEWKGc3rQuHEhVs7XS4T8ldSWl2WHCvpfvHCgOKQXeVPNjkUfNfFYl/Xl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=BcTB33vj; arc=none smtp.client-ip=178.154.239.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="BcTB33vj"
Received: from mail-nwsmtp-smtp-production-main-81.myt.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-81.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:3b1b:0:640:d43f:0])
	by forward500a.mail.yandex.net (Yandex) with ESMTPS id C9E9860C8A;
	Wed, 31 Jul 2024 17:14:35 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-81.myt.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id YEX6G9cX2uQ0-IGox0398;
	Wed, 31 Jul 2024 17:14:34 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1722435274; bh=eriLGYJahVXf7n6Ke6GN0wrykegYXIjB71hUidxOuY0=;
	h=References:Date:In-Reply-To:Cc:To:From:Subject:Message-ID;
	b=BcTB33vjVyPA6JDv0qBXnsP7XyHKxVT+07GZaquNT9j9kXJBG9aE4i74517ulkEwp
	 zHzBAyxpm8n+bP36r7LeCnKbqB3s1cz7zba2fW3H5qypne+gWS53cVkgQR4dsD4M2e
	 VquFkS+DdFw6Bf9bNmSOGV6PobgCtZKudUpObZg8=
Authentication-Results: mail-nwsmtp-smtp-production-main-81.myt.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <37df66ec9cf1a0570a86ec0b9f17ae18ed11b832.camel@yandex.ru>
Subject: Re: Lockup of (raid5 or raid6) + vdo after taking out a disk under
 load
From: Konstantin Kharlamov <Hi-Angel@yandex.ru>
To: Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>, 
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yangerkun@huawei.com" <yangerkun@huawei.com>, "yukuai (C)"
 <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev, Matthew Sakai <msakai@redhat.com>
Date: Wed, 31 Jul 2024 17:14:33 +0300
In-Reply-To: <57241c91337e8fc3257b6d4a35c273af59875eff.camel@yandex.ru>
References: <a6d068a26a90057fb3cdaa59f9d57a2af41a6b22.camel@yandex.ru>
	 <1f879e67-4d64-4df0-5817-360d84ff8b89@huaweicloud.com>
	 <29d69e586e628ef2e5f2fd7b9fe4e7062ff36ccf.camel@yandex.ru>
	 <517243f0-77c5-9d67-a399-78c449f6afc6@huaweicloud.com>
	 <810a319b846c7e16d85a7f52667d04252a9d0703.camel@yandex.ru>
	 <9c60881e-d28f-d8d5-099c-b9678bd69db9@huaweicloud.com>
	 <57241c91337e8fc3257b6d4a35c273af59875eff.camel@yandex.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

CC'ing VDO maintainers, because the problem is only reproducible with
VDO, so potentially they might have some ideas.

On Mon, 2024-07-22 at 20:56 +0300, Konstantin Kharlamov wrote:
> Hi, sorry for the delay, I had to give away the nodes and we had a
> week
> of teambuilding and company party, so for the past week I only
> managed
> to hack away stripping debug symbols, get another node and set it up.
>=20
> Experiments below are based off of vanilla 6.9.8 kernel *without*
> your
> patch.
>=20
> On Mon, 2024-07-15 at 09:56 +0800, Yu Kuai wrote:
> > Line number will be helpful.
>=20
> So, after tinkering with building scripts I managed to build modules
> with debug symbols (not the kernel itself but should be good enough),
> but for some reason kernel doesn't show line numbers in stacktraces.
> No
> idea what could be causing it, so I had to decode line numbers
> manually, below is an output where I inserted line numbers for
> raid456
> manually after decoding them with `gdb`.
>=20
> =C2=A0=C2=A0=C2=A0 [=E2=80=A6]
> =C2=A0=C2=A0=C2=A0 [ 1677.293366]=C2=A0 <TASK>
> =C2=A0=C2=A0=C2=A0 [ 1677.293661]=C2=A0 ? asm_sysvec_apic_timer_interrupt=
+0x16/0x20
> =C2=A0=C2=A0=C2=A0 [ 1677.293972]=C2=A0 ? _raw_spin_unlock_irq+0x10/0x30
> =C2=A0=C2=A0=C2=A0 [ 1677.294276]=C2=A0 ? _raw_spin_unlock_irq+0xa/0x30
> =C2=A0=C2=A0=C2=A0 [ 1677.294586]=C2=A0 raid5d at drivers/md/raid5.c:6572
> =C2=A0=C2=A0=C2=A0 [ 1677.294910]=C2=A0 md_thread+0xc1/0x170
> =C2=A0=C2=A0=C2=A0 [ 1677.295228]=C2=A0 ? __pfx_autoremove_wake_function+=
0x10/0x10
> =C2=A0=C2=A0=C2=A0 [ 1677.295545]=C2=A0 ? __pfx_md_thread+0x10/0x10
> =C2=A0=C2=A0=C2=A0 [ 1677.295870]=C2=A0 kthread+0xff/0x130
> =C2=A0=C2=A0=C2=A0 [ 1677.296189]=C2=A0 ? __pfx_kthread+0x10/0x10
> =C2=A0=C2=A0=C2=A0 [ 1677.296498]=C2=A0 ret_from_fork+0x30/0x50
> =C2=A0=C2=A0=C2=A0 [ 1677.296810]=C2=A0 ? __pfx_kthread+0x10/0x10
> =C2=A0=C2=A0=C2=A0 [ 1677.297112]=C2=A0 ret_from_fork_asm+0x1a/0x30
> =C2=A0=C2=A0=C2=A0 [ 1677.297424]=C2=A0 </TASK>
> =C2=A0=C2=A0=C2=A0 [=E2=80=A6]
> =C2=A0=C2=A0=C2=A0 [ 1705.296253]=C2=A0 <TASK>
> =C2=A0=C2=A0=C2=A0 [ 1705.296554]=C2=A0 ? asm_sysvec_apic_timer_interrupt=
+0x16/0x20
> =C2=A0=C2=A0=C2=A0 [ 1705.296864]=C2=A0 ? _raw_spin_unlock_irq+0x10/0x30
> =C2=A0=C2=A0=C2=A0 [ 1705.297172]=C2=A0 ? _raw_spin_unlock_irq+0xa/0x30
> =C2=A0=C2=A0=C2=A0 [ 1677.294586]=C2=A0 raid5d at drivers/md/raid5.c:6597
> =C2=A0=C2=A0=C2=A0 [ 1705.297794]=C2=A0 md_thread+0xc1/0x170
> =C2=A0=C2=A0=C2=A0 [ 1705.298099]=C2=A0 ? __pfx_autoremove_wake_function+=
0x10/0x10
> =C2=A0=C2=A0=C2=A0 [ 1705.298409]=C2=A0 ? __pfx_md_thread+0x10/0x10
> =C2=A0=C2=A0=C2=A0 [ 1705.298714]=C2=A0 kthread+0xff/0x130
> =C2=A0=C2=A0=C2=A0 [ 1705.299022]=C2=A0 ? __pfx_kthread+0x10/0x10
> =C2=A0=C2=A0=C2=A0 [ 1705.299333]=C2=A0 ret_from_fork+0x30/0x50
> =C2=A0=C2=A0=C2=A0 [ 1705.299641]=C2=A0 ? __pfx_kthread+0x10/0x10
> =C2=A0=C2=A0=C2=A0 [ 1705.299947]=C2=A0 ret_from_fork_asm+0x1a/0x30
> =C2=A0=C2=A0=C2=A0 [ 1705.300257]=C2=A0 </TASK>
> =C2=A0=C2=A0=C2=A0 [=E2=80=A6]
> =C2=A0=C2=A0=C2=A0 [ 1733.296255]=C2=A0 <TASK>
> =C2=A0=C2=A0=C2=A0 [ 1733.296556]=C2=A0 ? asm_sysvec_apic_timer_interrupt=
+0x16/0x20
> =C2=A0=C2=A0=C2=A0 [ 1733.296862]=C2=A0 ? _raw_spin_unlock_irq+0x10/0x30
> =C2=A0=C2=A0=C2=A0 [ 1733.297170]=C2=A0 ? _raw_spin_unlock_irq+0xa/0x30
> =C2=A0=C2=A0=C2=A0 [ 1677.294586]=C2=A0 raid5d at drivers/md/raid5.c:6572
> =C2=A0=C2=A0=C2=A0 [ 1733.297792]=C2=A0 md_thread+0xc1/0x170
> =C2=A0=C2=A0=C2=A0 [ 1733.298096]=C2=A0 ? __pfx_autoremove_wake_function+=
0x10/0x10
> =C2=A0=C2=A0=C2=A0 [ 1733.298403]=C2=A0 ? __pfx_md_thread+0x10/0x10
> =C2=A0=C2=A0=C2=A0 [ 1733.298711]=C2=A0 kthread+0xff/0x130
> =C2=A0=C2=A0=C2=A0 [ 1733.299018]=C2=A0 ? __pfx_kthread+0x10/0x10
> =C2=A0=C2=A0=C2=A0 [ 1733.299330]=C2=A0 ret_from_fork+0x30/0x50
> =C2=A0=C2=A0=C2=A0 [ 1733.299637]=C2=A0 ? __pfx_kthread+0x10/0x10
> =C2=A0=C2=A0=C2=A0 [ 1733.299943]=C2=A0 ret_from_fork_asm+0x1a/0x30
> =C2=A0=C2=A0=C2=A0 [ 1733.300251]=C2=A0 </TASK>
>=20
> > Meanwhile, can you check if the underlying
> > disks has IO while raid5 stuck, by /sys/block/[device]/inflight.
>=20
> The two devices that are left after the 3rd one is removed has these
> numbers that don't change with time:
>=20
> =C2=A0=C2=A0=C2=A0 [Mon Jul 22 20:18:06 @ ~]:> for d in dm-19 dm-17; do e=
cho -n $d;
> cat
> =C2=A0=C2=A0=C2=A0 /sys/block/$d/inflight; done
> =C2=A0=C2=A0=C2=A0 dm-19=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 9=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1
> =C2=A0=C2=A0=C2=A0 dm-17=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 11=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 2
> =C2=A0=C2=A0=C2=A0 [Mon Jul 22 20:18:11 @ ~]:> for d in dm-19 dm-17; do e=
cho -n $d;
> cat
> =C2=A0=C2=A0=C2=A0 /sys/block/$d/inflight; done
> =C2=A0=C2=A0=C2=A0 dm-19=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 9=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1
> =C2=A0=C2=A0=C2=A0 dm-17=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 11=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 2
>=20
> They also don't change after I return the disk back (which is to be
> expected I guess, given that the lockup doesn't go away).
>=20
> > >=20
> > > > At first, can the problem reporduce with raid1/raid10? If not,
> > > > this
> > > > is
> > > > probably a raid5 bug.
> > >=20
> > > This is not reproducible with raid1 (i.e. no lockups for raid1),
> > > I
> > > tested that. I didn't test raid10, if you want I can try (but
> > > probably
> > > only after the weekend, because today I was asked to give the
> > > nodes
> > > away, for the weekend at least, to someone else).
> >=20
> > Yes, please try raid10 as well. For now I'll say this is a raid5
> > problem.
>=20
> Tested: raid10 works just fine, i.e. no lockup and fio continues
> having non-zero IOPS.
>=20
> > > > The best will be that if I can reporduce this problem myself.
> > > > The problem is that I don't understand the step 4: turning off
> > > > jbod
> > > > slot's power, is this only possible for a real machine, or can
> > > > I
> > > > do
> > > > this in my VM?
> > >=20
> > > Well, let's say that if it is possible, I don't know a way to do
> > > that.
> > > The `sg_ses` commands that I used
> > >=20
> > > 	sg_ses --dev-slot-num=3D9 --set=3D3:4:1=C2=A0=C2=A0 /dev/sg26 #
> > > turning
> > > off
> > > 	sg_ses --dev-slot-num=3D9 --clear=3D3:4:1 /dev/sg26 #
> > > turning
> > > on
> > >=20
> > > =E2=80=A6sets and clears the value of the 3:4:1 bit, where the bit is
> > > defined
> > > by the JBOD's manufacturer datasheet. The 3:4:1 specifically is
> > > defined
> > > by "AIC" manufacturer. That means the command as is unlikely to
> > > work on
> > > a different hardware.
> >=20
> > I never do this before, I'll try.
> > >=20
> > > Well, while on it, do you have any thoughts why just using a
> > > `echo
> > > 1 >
> > > /sys/block/sdX/device/delete` doesn't reproduce it? Does perhaps
> > > kernel
> > > not emulate device disappearance too well?
> >=20
> > echo 1 > delete just delete the disk from kernel, and scsi/dm-raid
> > will
> > know that this disk is deleted. However, the disk will stay in
> > kernel
> > for the other way, dm-raid does not aware that underlying disks are
> > problematic and IO will still be generated and issued.
> >=20
> > Thanks,
> > Kuai

