Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C1518D633
	for <dm-devel@lists.linux.dev>; Mon, 26 Aug 2024 14:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724683480; cv=none; b=cIHRIjzFm2W42ZA+p9ZlxLwDbHFoe1IcWBAbz+STXYNpFUifOoWifhPR3em97h0A4o2KbZT04TaG8rFXNgjckQz+BQwi2xdsy+T1y6owRhe1Kp39/HjNRFc2u93+xzAnhB3qXW6wy79qD53fW7AZ2lyGIMyrnwP51p/gQ7Q4YBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724683480; c=relaxed/simple;
	bh=Wgq+ci3qT04jdW6TMxeuX9NxGl7Odt92S9/kkmQVeVk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Y92gJBKyp9jgZDrWQ2O3GJfwiRCZhn5wYaWHs3xB967xsnv+cDP5mL0Qi5Lwlm8PVBl3EQ5C6yXNa4XlmSe/71tiMPLbLA7f26vQCGPDqzQ7BnHvvs7vBPT8xwqTeXcxC1kCyZyN7/VPD4Hdelm7lAP3EHhBmfdU11Z5+xncxtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=TrXqm+TB; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="TrXqm+TB"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1724683160;
	bh=ojbIBl/msrDdF2thwISHcilC5x5EFGrcP4usEr80zrM=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=TrXqm+TB92OnCgIpB24vToz3BwemQZNnnGqwJfr0C7Mky1TyALF6syygwsZUNXjID
	 tSEGeInTPJ9VJyip4dwwXt0XlIOFG/78tOhdbNMW9hlKFjyRe4zWKCrLJrp6mxOoEI
	 eWrCGpWrZ5HXwgYnwHRpmnzyG6JJYnfloZO6ni2I=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <D7998E5E-4FC1-40E1-A308-4A0E8A87950A@flyingcircus.io>
Date: Mon, 26 Aug 2024 16:38:59 +0200
Cc: Yu Kuai <yukuai1@huaweicloud.com>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <59F26844-EB24-4613-82F3-578BEF032678@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <316050c6-fac2-b022-6350-eaedcc7d953a@huaweicloud.com>
 <58450ED6-EBC3-4770-9C5C-01ABB29468D6@flyingcircus.io>
 <EACD5B78-93F6-443C-BB5A-19C9174A1C5C@flyingcircus.io>
 <22C5E55F-9C50-4DB7-B656-08BEC238C8A7@flyingcircus.io>
 <26291.57727.410499.243125@quad.stoffel.home>
 <2EE0A3CE-CFF2-460C-97CD-262D686BFA8C@flyingcircus.io>
 <1dfc4792-02b2-5b3c-c3d1-bf1b187a182e@huaweicloud.com>
 <4363F3A3-46C2-419E-B43A-4CDA8C293CEB@flyingcircus.io>
 <C832C22B-E720-4457-83C6-CA259AD667B2@flyingcircus.io>
 <e92ccf15-be2a-a1aa-5ea2-a88def82e681@huaweicloud.com>
 <30D680B2-F494-42F5-8498-6ED586E05766@flyingcircus.io>
 <26294.40330.924457.532299@quad.stoffel.home>
 <C9A9855D-B0A2-4B13-947E-01AF5BA6DF04@flyingcircus.io>
 <26298.22106.810744.702395@quad.stoffel.home>
 <EBC67418-E60C-435A-8F63-114C67F07583@flyingcircus.io>
 <CEC90137-09B3-41AA-A115-1C172F9C6C4B@flyingcircus.io>
 <26302.9357.226392.717562@quad.stoffel.home>
 <D7998E5E-4FC1-40E1-A308-4A0E8A87950A@flyingcircus.io>
To: John Stoffel <john@stoffel.org>

Hi,

I still haven=E2=80=99t been able to create a reproducer based on a =
tmpfs setup. I=E2=80=99ve run the xfstests with increased load and time =
factors, but didn=E2=80=99t trigger a crash.

@yukuai - I=E2=80=99m running out of ideas. Personally my preferred next =
step would be to gather debug output. If that takes some time, then =
I=E2=80=99ll remain patient. :)

Something I do have on the horizon: I=E2=80=99ll receive a mostly =
identical server in the next weeks and can try to reproduce the issue =
there, taking a few disks aside for a separate debugging array.  Maybe =
the number of disks is also relevant, so I=E2=80=99ll also try with the =
full size.

> On 15. Aug 2024, at 21:13, Christian Theune <ct@flyingcircus.io> =
wrote:
>=20
>>> On the plus side, I have a script now that can create the various
>>> loopback settings quickly, so I can try out things as needed. Not
>>> that valuable without a reproducer, yet, though.
>>=20
>> Yay!  Please share it.
>=20
> Will do next week after a bit of cleanup.

Here=E2=80=99s the setup I=E2=80=99ve been using with tmpfs backed =
software raid:

mkdir /srv/test-raid/
mkdir /srv/test-raid/backing

mount -t tmpfs none /srv/test-raid/backing

loops=3D()

for i in {0..3}; do=20
    dd if=3D/dev/zero of=3D/srv/test-raid/backing/img${i}.bin bs=3D1M =
seek=3D1100 count=3D1
    loops+=3D($(losetup -f /srv/test-raid/backing/img${i}.bin --show))
done

mdadm --create /dev/md/test --level=3D6 --raid-devices=3D4 ${loops[@]}

dd if=3D/dev/zero of=3D/srv/test-raid/backing/scratch.bin bs=3D1M =
seek=3D1100 count=3D1
SCRATCH_DEV=3D$(losetup -f /srv/test-raid/backing/scratch.bin --show)
loops+=3D($SCRATCH_DEV)

mkfs.xfs /dev/md/test

mkdir /srv/test-raid/scratch
mkdir /srv/test-raid/test
#mount /dev/md/test /srv/test-raid/test

export TEST_DEV=3D$(realpath /dev/md/test)
export TEST_DIR=3D/srv/test-raid/test
# export SCRATCH_DEV=3D/dev/loop1 # see above
export SCRATCH_MNT=3D/srv/test-raid/scratch

export LOAD_FACTOR=3D10
export TIME_FACTOR=3D10
# export SOAK_DURATION=3D1m

xfstests-check

# cleanup

umount /srv/test-raid/test
mdadm --stop /dev/md/test
for x in "${loops[@]}"; do losetup -d $x; done

umount /srv/test-raid/backing

rm -r /srv/test-raid


Hugs,
Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

