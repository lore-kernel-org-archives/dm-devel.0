Received: from mail-il1-f193.google.com (mail-il1-f193.google.com [209.85.166.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE81149C6F
	for <dm-devel@lists.linux.dev>; Thu, 27 Nov 2025 23:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764285868; cv=none; b=XBNQrJRQz4GV6h4LufwiiDXjJZ1F98hK+bpz1fSrtDwxZYOihxdh+Pat07WwyqoL9ukVfXH+p1T4T+4vONByY853JZRgR6NA+55BSFjbI2AfLvgXXLb6G7G0dBgmyWsKTTMI8KF7pzf1zKrwRdxBztWAmDdD1ePzbkRx/aJkVuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764285868; c=relaxed/simple;
	bh=Zh1BUd1pl+O2Ics5ZSR6XMjSUAb+ZxamnBOr44eua3M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UViYnF9f+ElRTPxzJccJzPrF43xbAbW9LMH7QH0RTsCCHUoaJDOUz0pEnVLtNGcMDEPtwa0gvm1MM8oVlgubB/Rd0bJ8bLDKOjzio8oCmjG+QyqrioTv37Tv2qeg9NeC+V2aW2OCv4pT6B/7Sq1hCARPOR0VGj7QK3iGsJqCu8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iNhilMhr; arc=none smtp.client-ip=209.85.166.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iNhilMhr"
Received: by mail-il1-f193.google.com with SMTP id e9e14a558f8ab-43326c45389so580865ab.1
        for <dm-devel@lists.linux.dev>; Thu, 27 Nov 2025 15:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764285864; x=1764890664; darn=lists.linux.dev;
        h=mime-version:references:in-reply-to:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2KPEDOCb5mXuCIR0Wc+ytoxgYgWn7CfbT1FbFeR5YO4=;
        b=iNhilMhr5zsxc26fZVVyvCCEq6t15tGmHwLwiHqJX6VepXg+fUVNISZqXegbLgADw1
         XXd3pJRNMum0BZ6/0517QsjmsLV9HxN2t0nCrV2hUYb0ZgxQ+zydXOWETaf/GOyPGjBE
         q5JiTDO/+Dj7R3R907gYacFrK1ViYIFIovn6px3g3SiFxRgkXwqf9Yz80m7ivLCvRyhA
         tEmQ06w21Zf8/2zO2Q1BEEhqbvMTrGyYeIMrWrSQodLBWVhuuk1M5pJfIL4LbRc+i+RY
         eEnoboGAPaayqiOCU4MWJdXw+3LQoxL6pJQiAGU9xTCFI3GCvsaTfBLm/IxQBGfFAjem
         Ahng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764285864; x=1764890664;
        h=mime-version:references:in-reply-to:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2KPEDOCb5mXuCIR0Wc+ytoxgYgWn7CfbT1FbFeR5YO4=;
        b=E18wP5T+AsOCLXWGXAKE8map9tZLqBvAv2FFVr+uNwaD8FynW/mUmfPtgisdVH0Wx1
         2Zz/+x6FOEaHYvpzsk+hcK8MV0OeTMGH+Qcy8PjL9f8vEjskMleb01IaHo62LnN/RZqO
         cJCaSOPT0j85+cilTTOy06J4hCx9Lq8gFZzqFpHct96C0ncQRDZQuZFFCXFiBhSb1zuv
         bsO2GnCW8Ccm3iJJZY4wrYuyPZRCYcWJnCSrBWhR2HuqvJvUZyEVxyHBBZv87GTRZUbi
         8x9VtunPUBAVU7HrfZV61G/Z/JQJk1W0g3kNlWsxGZl9ZHpEddqMlieCg+k8bjl8F9j2
         /LOg==
X-Forwarded-Encrypted: i=1; AJvYcCWo7MhIBFjGEgEUF7toz5rTKHSJkVz9aEMDAkglCKxbBjYCk+Is04B0F0ZwaocJ321sNbdaqPQt5A==@lists.linux.dev
X-Gm-Message-State: AOJu0YwIclcj6lp09mXVyVtauQlkMGZYB8YLUqpFJg5z4z2Hf5nbyPS7
	Yoq0OpCB6w6xl4uX3i9lBHbgIpbGUXfm2fD6amJEP1NAeyMsMIjJbWKz
X-Gm-Gg: ASbGncuWJhwwMta9o1+18tHYeNNlvJW1DVFVl6wCpO0w0qScx/vMv9h6RE4pUikqDUl
	i+4n8FVOcJahhM6X5YkvyEM3w2GnVv2jD27pzFqewiiVWj6veQ3YH54zbG6vHTpDvxFc6H6Pzmh
	gB2Rxy7w5ezi/dKNySdsvLRyTBeaDWsFQiX5gA9Cy0BhgWAIrDakaxEZQMrl31AlLIBvH6n7dZc
	BBaTUenQHYyT0W4BHcsQDxutzhtL/zq9faNFheNQydWoOs1iVuaiFuVPsh3GN6WCYyu6SQnWhhU
	kZFrpKxmlkB4x6bFQPg4Td2t/YDkHJRqBGbuU00v0i8LCLmjSqnylkOZ6YRqd1fTFzQyXVhG8B6
	p/LIMbN+Ns9kwUtTrQvU0T4MIgCekOdst6jUn0QN2MRnWvbmXglagemzMyvcdWy3EBEy0R3l8aO
	IU1JQ8qRE=
X-Google-Smtp-Source: AGHT+IF1FZ7gp0CgtAprc3JnWiifAK4jaouDoqm3H9RkUcsuikGC8VoAWjBDdMdey7zD3t5eiOJ0Rg==
X-Received: by 2002:a05:6e02:188e:b0:433:2fe2:9d41 with SMTP id e9e14a558f8ab-435bc9beca3mr87373145ab.7.1764285864483;
        Thu, 27 Nov 2025 15:24:24 -0800 (PST)
Received: from kf-m2g5 ([2607:fb90:bf0b:8b65:e4a9:bd5:56d9:5426])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-436b33b704dsm14654055ab.22.2025.11.27.15.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 15:24:23 -0800 (PST)
Date: Thu, 27 Nov 2025 17:24:16 -0600
From: Aaron Rainbolt <arraybolt3@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Milan Broz <gmazyland@gmail.com>, linux-mm@kvack.org,
 cryptsetup@lists.linux.dev, "dm-devel@lists.linux.dev"
 <dm-devel@lists.linux.dev>, linux-kernel@vger.kernel.org,
 adrelanos@whonix.org
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is
 exhausted
Message-ID: <20251127172323.7913c99f@kf-m2g5>
In-Reply-To: <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com>
References: <20251111231835.1232ad8f@kf-m2g5>
	<2b8b83fa-5cf5-4f97-b796-0c738ce3a548@gmail.com>
	<3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/r1E/HN.et+YE1IVFD_tEODW";
 protocol="application/pgp-signature"; micalg=pgp-sha512

--Sig_/r1E/HN.et+YE1IVFD_tEODW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Nov 2025 18:54:04 +0100 (CET)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> On Thu, 27 Nov 2025, Milan Broz wrote:
>=20
> > Hi,
> >=20
> > On 11/12/25 6:18 AM, Aaron Rainbolt wrote: =20
> > > Not sure if this is a memory management issue, a LUKS issue, or
> > > both, so I wrote both mailing lists. =20
> >=20
> > It is not a LUKS issue; cryptsetup/LUKS activates the encrypted
> > device, so it is only the kernel/dm-crypt handling IOs.
> >=20
> > Adding cc to dm-devel as this would be another combination
> > device-mapper and encrypted swap that could cause issues...
> >=20
> > However, could you please specify exactly your storage
> > configuration?
> >=20
> > From the subject, I expected you to have an encrypted swap, but it
> > is not clear if there are other encrypted devices.
> >=20
> > Please paste at least lsblk, lsblk -f output, and also luksDump
> > (or crypttab if it is not LUKS) for LUKS/dm-crypt configuration.
> >=20
> > Thanks,
> > Milan
> >=20
> >  =20
> > >=20
> > > I'm seeing an issue with both the latest mainline kernel
> > > (6.18-rc5) and Debian 13's 6.12 kernel package. When physical
> > > memory fills up, the entire system locks up hard, as if it hit
> > > rather severe thrashing, despite the fact that there appears to
> > > be disk cache that can still be evicted, and there is ample
> > > amounts of swap space remaining (gigabytes of it). This issue did
> > > not occur with the 6.1 kernel in Debian 12. I'm seeing this occur
> > > in very low-memory Debian VMs, with between 512 and 900 MB RAM,
> > > running under VirtualBox and KVM. (I suspect, but have not
> > > verified, that I'm seeing similar behavior under Xen as well.)
> > > These VMs generally use a swappiness of 1, though I have seen a
> > > lockup occur even with a swappiness of 60. The filesystem in use,
> > > in case it matters, is ext4.
> > >=20
> > > To reproduce on a system running Linux 6.18-rc5, with :
> > >=20
> > > * Follow the steps from
> > >    https://gitlab.com/cryptsetup/cryptsetup/-/wikis/FrequentlyAskedQu=
estions,
> > >    section "2.3 How do I set up encrypted swap?", but creating a
> > >    swapfile rather than a swap partition. =20
>=20
> Hi
>=20
> Encrypted swap file is not supposed to work. It uses the loop device
> that routes the requests to a filesystem and the filesystem needs to
> allocate memory to process requests.
>=20
> So, this is what happened to you - the machine runs out of memory, it=20
> needs to swap out some pages, dm-crypt encrypts the pages and
> generates write bios, the write bios are directed to the loop device,
> the loop device directs them to the filesystem, the filesystem
> attempts to allocate more memory =3D> deadlock.
>=20
> I got the deadlock with 6.18-rc4 when I used dm-crypt on a file and I=20
> didn't get the deadlock when I used dm-crypt on a SCSI block device.
> That is expected behavior.

Is it only expected behavior since some time after kernel 6.1, or has
it always been expected behavior and encrypted swapfiles simply worked
by accident with kernel 6.1? Is there any reasonable way to reserve
some memory for in-kernel filesystem code (at least for some
filesystems like ext4 in the event it's not feasible for all of them)
that will ensure it has enough memory to handle I/O operations even if
the system is completely out of memory from userspace's perspective?
I'd be happy to try to contribute a fix if possible.

With kernel 6.1, this was working reliably, and Kicksecure (a
security-focused Debian derivative with a relatively sizable userbase)
was using encrypted swapfiles by default. We never got any reports of
lockups like we're seeing now with kernel 6.12. Whether this was
intended to work or not before, it seemed to work very well, and this
seems like a regression from our standpoint.

--
Aaron

> Note that the in-kernel OOM killer sometimes doesn't kill the
> application and discards read-only program pages (which generates big
> I/O churn and general system slowdown) - if you are hitting this
> problem, I recommend installing userspace OOM killer, such as
> earlyoom.
>=20
> Mikulas
>=20


--Sig_/r1E/HN.et+YE1IVFD_tEODW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEudh48PFXwyPDa0wGpwkWDXPHkQkFAmko3aAACgkQpwkWDXPH
kQntQhAAxJBsISFb0MTNGHlS2xtdPK9zFeL3vVCaWdSpBfMH8BQFUZVbMYrBXEBQ
JMalBPkjor4pOFJiDNIKWrir/Er67jbtlsY/nFvK5g+AOQ0CaiPcLiokv6Jfx1oR
IFy8UNm82uoMamzv61zWwzv7BdEuVctYaGBpabJX876PqxrATeYLamEOE3Rx04h8
7uFSdc3Oz3WK99/G09lAHXibZCD053Lo++JtumG7dN3p0CQ1YGWYYR9ApssYIeZq
bFYjH2SIJf2V+4D8x5NUZAVVXfvv0QoyKk8WAyivo8jKP25wSbmOiUId8npo6JQM
fsTNO5NOba5K6TZPzjfxEsHOT54qlQs/OKu2tzC37u2DVNUWwlZHs4Iqav8NlIZY
ikYQcARj+6kvEJRgjhNaBxt40zEoT1uu5maBRLqHuM8alFmmr1IwJh+QuR5WRoXL
qXFoRZoywlCZuVwrFUh/g3N+yfZXDZ04OIWxPMqkNaPwIyNOn6JXpm/tG1B/95Nn
VU/2ZRadxceBuPrzbHnLnzSLD33wFpl8181IpRBMDTSHwCA5TMtvcJhuV6+aH12x
3O1/CZ7YqyOHEHS2moKcwves7XCBqCeION5+nJoDEIgkmjOKkZx9CEBmc8v7T17v
SXayP7eYNKLbBQfhV1pSJnt8j/n9zS7lfGTzZVN+cnWiNclF1Y4=
=yBJC
-----END PGP SIGNATURE-----

--Sig_/r1E/HN.et+YE1IVFD_tEODW--
