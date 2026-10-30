Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793386081;
	b=pwRqc+QbdW8eTabvViNS0KgNeZ2yemn6G5mu7RkpkJCXVqkiH7VUBLtJjToUQp6B/Er5
	 gkpMSvdyloKhizFh9+OmUUOUaYp8nf/JXNd5gnDLkPn/0UfG08N6Lufs0iajU0LCfeKon
	 TzJILNISrHcTX1RU+za87hg1TV+T7HrwiOyofMODRgN1dJBSYkhbNSoiy/L405B2yJFSD
	 dXk9KDDTHtS8NBE/nUXIjbwlxBEk8qkWuWtttxWx60/gEjzQx0PWQjaFOhNXx6s8UsC/h
	 fYCancAnGhBIVYSehJZuKeFtqo965rkHx6h0Kagdjnxoxl8wOIhgESx6TH0WHfGr6tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793386081;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type:
	 Content-Transfer-Encoding;
	bh=ys5StJHbRjlo+Q3/UfxHPtT29K5285J7qEPolXBBHPg=;
	b=lXYu0BT/QH4ewcCnTDn9oOchQyXUBWv/xAfDJGabcI8/rqQ69QWWQQEH4oKBZijmkF7r
	 tWy3ERGAF3p45M49M9PAWKQVNeM9PfSk5dIudEc4KwAzo3pRJFAC0//W99FEJZL287/Yh
	 Z+vqAgFx7TofubbSb8YJNXoJFhap8JNh+WJXghk5EfOZkF+1K7zGWPCQfuGRSftjQExa7
	 lP3n3O2gv4PNDUM0jomLIbDhrswdvuTDGl5ZYdYNeXIXubo+IycL2/zV5OUx+lq33d8GY
	 81C1vg+WVsjkowR6jP8sPCZUp9BS33gggg0hIs4jNbrTjr3cAuhYWJaUQnFi27LXQ5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QkUVMLMG;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A22A606A31D
	for <dm-devel@lists.linux.dev>; Fri, 30 Oct 2026 18:48:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A22A606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QkUVMLMG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793386079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ys5StJHbRjlo+Q3/UfxHPtT29K5285J7qEPolXBBHPg=;
	b=QkUVMLMGFjZL3qIZizo+o0p211z4C6c07t4+wA7y9gePGUVt3hL2OwL7uFdvKa1Kd7XveZ
	kaWRkWUWz6MhMiD3Ju0eWhMXyqgzF3Dd9E2Nj+5M/8TUNx9SUH7rIXqGFfKyTxgMjklmu2
	6u7mJM8520HfM/nY0rymbfSfgIGCWaQ=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-UY_lCkRtPWeNFMr81JVw1A-1; Fri, 30 Oct 2026 14:47:58 -0400
X-MC-Unique: UY_lCkRtPWeNFMr81JVw1A-1
X-Mimecast-MFC-AGG-ID: UY_lCkRtPWeNFMr81JVw1A_1793386076
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-3ab442d8d13so4903291fa.1
        for <dm-devel@lists.linux.dev>; Fri, 30 Oct 2026 11:47:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793386076; x=1793990876;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ys5StJHbRjlo+Q3/UfxHPtT29K5285J7qEPolXBBHPg=;
        b=pWsnG2x3KjWlA7BslHXARBYdNAJeAD54ZZVFF2AyuPUQyQUGEqTPSYnpW5QzA75wgr
         gPBfWK+kM2GOEfe3mx+J8UN7BVKWnngcvxVDgO46Mabv8Njt7rwWN9XR+bUX1+e/LMfu
         Jh+RQMKbtPf1o50FRQ7h1CYipX9UB6INqDwQrDUY4oE0KsfaT4B/0ngydAuw63RRFPol
         d1tn13pDAABY2tdd3lE2Zq6cOwPCo35E+GPfYE5fZps9ILXqFvqxDfQJ3hHdQ8sxserR
         TPob3FlNnyBquuiQ3LH0vPTVxYKQLgOUWHybFSETsMU8IWWI0iYVH9GPwUQ1u8YaKSf6
         QE3A==
X-Forwarded-Encrypted: i=1; AKwUvBxPiNrbn34gz5DvgirDXyiHIeGkz0LWcy7p0hNlxM8EdcqH0gszIeQKpBhp5IXg4Nx4Sig7JNQ9Dw==@lists.linux.dev
X-Gm-Message-State: AFq9FYIiysetesF4dh1BUjEEgU3f8TmwQW/gva5yjjfZKyxBpkI4GgRp
	PWOLszKiwBttwxHMMVobvbjm50NlH/fRT2o9ZKgo5YoQrIkxQeIQefWm/W4d8AZo9tOKnJVANsI
	PcNj8V5L5vdUIkdJ5+vQPFj1wugm4HegwR58SIEf89Vw2in2Yk/XsMnulnHM5fOEpp9Glo2qC9O
	REifx1EFqxxbb+RxsXDVu2xguAWEyCa2kfWQ==
X-Gm-Gg: AYBFou1oICZdSI4Yy1BLFvjtCqkhDIzwsO4M2z09wItJTe4E7FlARyEyjnjOfGoYNvb
	KmMPmjUMEI9MApgcRaj1MXWby4kUrWMxv8xroGdn7yLO0v4xAuwApGTyVFspg+lDNimEVm7cQEg
	u9ClvOsAuz/4AyAOJtcEPi5F8x+Cb64i6nZtXP2vFlaCKKnst/Kjtr7PDzEQ==
X-Received: by 2002:a2e:be26:0:b0:3ac:429f:6d93 with SMTP id 38308e7fff4ca-3acb7b981d1mr7655491fa.29.1793386076329;
        Fri, 30 Oct 2026 11:47:56 -0700 (PDT)
X-Received: by 2002:a2e:be26:0:b0:3ac:429f:6d93 with SMTP id
 38308e7fff4ca-3acb7b981d1mr7655371fa.29.1793386075916; Fri, 30 Oct 2026
 11:47:55 -0700 (PDT)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261026110402.103622-1-shreeramrahul94@gmail.com> <auGBLzpQBLvds2vl@redhat.com>
In-Reply-To: <auGBLzpQBLvds2vl@redhat.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Sat, 31 Oct 2026 02:47:44 +0800
X-Gm-Features: AclHuK_1KqIJvnT0dQOX_UUGdRcV1FJXwQB4bAFNbSQTpJYwGPiCkY6oYBd1XCo
Message-ID: <CALjSBEs6qTsyFPCrDnL0GZ=WUojdEeOq9wVhEXJrgDr0N0kDyQ@mail.gmail.com>
Subject: Re: [PATCH] dm thin: prevent use-after-free when metadata and data
 devices alias
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Rahul Rao <shreeramrahul94@gmail.com>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Joe Thornber <thornber@redhat.com>, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, 
	syzbot+83827f9a59abe148bff4@syzkaller.appspotmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WAaItGnamXcV2UPMZghRNc67Tbvv0pH2twqI9tas1co_1793386076
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 1:10=E2=80=AFPM Benjamin Marzinski <bmarzins@redhat=
.com> wrote:
>
> On Mon, Oct 26, 2026 at 04:34:02PM +0530, Rahul Rao wrote:
> > pool_ctr() takes separate specification strings for the metadata and da=
ta
> > devices. However, different strings (or format representations such as
> > /dev/ram0 and 1:0) can resolve to the same underlying block device.
> >
> > When the read_only feature is requested, the metadata device is opened
> > read-only before the data device is opened read-write. If the devices
> > alias, the second dm_get_device() call upgrades the existing device's
> > mode. upgrade_mode() replaces the dm_dev and drops the old table device=
,
> > leaving pool_ctr() with a stale metadata_dev pointer. The subsequent
> > metadata_dev->bdev access triggers a KASAN use-after-free report.
> >
> > Acquire the read-write data device first so that acquiring the metadata
> > device cannot trigger this mode upgrade. Then reject matching block
> > devices, including those specified through different names, and release
> > the devices in reverse acquisition order on error.
>
> What this patch fixes looks good to me, but there is still an issue
> here. There is a similar problem in thin_ctr() if the pool and origin
> device name strings are different but they alias. Unfortunately, this
> style of fix doesn't work as well there. It is only a valid fix for a
> thin-pool target because that is a DM_TARGET_SINGLETON. That means there
> can't be another target that's part of the same table. This isn't the
> case with the thin target. There can be other targets in the table, and
> you can't force correct dm_get_device() ordering between them. Like
> Mikulas said about a similar issue with dm-snapshot, this is probably
> something that is better fixed in dm_get_device() than in its callers.
>
> -Ben

Agreed. Fixing in dm_get_device() looks like the right direction. A
possible approach is to avoid upgrade_mode() and allow a
dm_dev_internal to hold multiple references to table_devices of
different modes. This way we can fix dm-thin by simply comparing the
block_device pointers in pool_ctr() and thin_ctr() after
dm_get_device() returns, and reject the table if they alias.

dm-snapshot already has the block_device comparison, so once
dm_get_device() is fixed it is covered too.

I have a rough WIP that seems to confirm the idea, though the approach
still needs refinement.

>
> >
> > Reported-by: syzbot+83827f9a59abe148bff4@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3D83827f9a59abe148bff4
> > Fixes: 991d9fa02da0 ("dm: add thin provisioning target")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Rahul Rao <shreeramrahul94@gmail.com>
> > ---
> >  drivers/md/dm-thin.c | 22 ++++++++++++++--------
> >  1 file changed, 14 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> > index 59392de7a477..52e47874048d 100644
> > --- a/drivers/md/dm-thin.c
> > +++ b/drivers/md/dm-thin.c
> > @@ -3326,18 +3326,24 @@ static int pool_ctr(struct dm_target *ti, unsig=
ned int argc, char **argv)
> >
> >       metadata_mode =3D BLK_OPEN_READ |
> >               ((pf.mode =3D=3D PM_READ_ONLY) ? 0 : BLK_OPEN_WRITE);
> > -     r =3D dm_get_device(ti, argv[0], metadata_mode, &metadata_dev);
> > +     r =3D dm_get_device(ti, argv[1], BLK_OPEN_READ | BLK_OPEN_WRITE, =
&data_dev);
> >       if (r) {
> > -             ti->error =3D "Error opening metadata block device";
> > +             ti->error =3D "Error getting data device";
> >               goto out_unlock;
> >       }
> > -     warn_if_metadata_device_too_big(metadata_dev->bdev);
> >
> > -     r =3D dm_get_device(ti, argv[1], BLK_OPEN_READ | BLK_OPEN_WRITE, =
&data_dev);
> > +     r =3D dm_get_device(ti, argv[0], metadata_mode, &metadata_dev);
> >       if (r) {
> > -             ti->error =3D "Error getting data device";
> > -             goto out_metadata;
> > +             ti->error =3D "Error opening metadata block device";
> > +             goto out_data;
> > +     }
> > +
> > +     if (metadata_dev->bdev =3D=3D data_dev->bdev) {
> > +             ti->error =3D "Metadata and data devices must be differen=
t";
> > +             r =3D -EINVAL;
> > +             goto out;
> >       }
> > +     warn_if_metadata_device_too_big(metadata_dev->bdev);
> >
> >       if (kstrtoul(argv[2], 10, &block_size) || !block_size ||
> >           block_size < DATA_DEV_BLOCK_SIZE_MIN_SECTORS ||
> > @@ -3426,9 +3432,9 @@ static int pool_ctr(struct dm_target *ti, unsigne=
d int argc, char **argv)
> >  out_free_pt:
> >       kfree(pt);
> >  out:
> > -     dm_put_device(ti, data_dev);
> > -out_metadata:
> >       dm_put_device(ti, metadata_dev);
> > +out_data:
> > +     dm_put_device(ti, data_dev);
> >  out_unlock:
> >       mutex_unlock(&dm_thin_pool_table.mutex);
> >
> > --
> > 2.43.0
>
>

