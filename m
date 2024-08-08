Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1035146019
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 08:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723107250; cv=none; b=StHh1e6I8U2g445PX1dGlwKCQLWFM7gm3+1iI3nc0WGvgUvENsgtCNfTyfJ6VetKpw0/ScCoExPNLXwkd1yourj3vpCaihXDhGMPNeAsoL+kftDkZ2n7rEMugVrRZbxiRiGu6HWg4+s4orqddjIfGh76EGxDxIdmLdEzjbiOHg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723107250; c=relaxed/simple;
	bh=mhkrNrscBtzK5StKoeTvqN1QxGewDI5VEdH6Iek/EIo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=fX+ROS7zwIu1B5mhZXDetGSGc7wJp/0NXkvG0br0a0agPV2OAlybF8DSgi3rVbIfn2j46WCG4f/BprJPL/RPTg3L1BoYgDQuZgm6woiQj0cllU9f2W+O5p11t5hdvI91JrqoVWKCjnJTIcGAl14TOtyo2SZUDZz46P0NQad/F9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=d+rBcQRk; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="d+rBcQRk"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1723107244;
	bh=fDkm5+aEhfSYgDbMGqSYZbaw3erkzaOJH9Vc//wCxkA=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=d+rBcQRkrehDhJII1stCzV48EuR0J8QA22U6wZ+h+1ihDeoEPRtfF3CKaX2tbJGNH
	 jffOzK5WdMGVVf5jW+HTknqeps4EfLQPilqnf6N3PJVsCIo0B0idOF4vGUTlnEHQ92
	 HEkCfXbr6lQWYy9GvovIDFOaFFtuq1MPwA64jtOM=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <4363F3A3-46C2-419E-B43A-4CDA8C293CEB@flyingcircus.io>
Date: Thu, 8 Aug 2024 10:53:42 +0200
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C832C22B-E720-4457-83C6-CA259AD667B2@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <316050c6-fac2-b022-6350-eaedcc7d953a@huaweicloud.com>
 <58450ED6-EBC3-4770-9C5C-01ABB29468D6@flyingcircus.io>
 <EACD5B78-93F6-443C-BB5A-19C9174A1C5C@flyingcircus.io>
 <22C5E55F-9C50-4DB7-B656-08BEC238C8A7@flyingcircus.io>
 <26291.57727.410499.243125@quad.stoffel.home>
 <2EE0A3CE-CFF2-460C-97CD-262D686BFA8C@flyingcircus.io>
 <1dfc4792-02b2-5b3c-c3d1-bf1b187a182e@huaweicloud.com>
 <4363F3A3-46C2-419E-B43A-4CDA8C293CEB@flyingcircus.io>
To: Yu Kuai <yukuai1@huaweicloud.com>

Hi,

> On 8. Aug 2024, at 09:06, Christian Theune <ct@flyingcircus.io> wrote:
>>=20
>> 1) With the hangtaks, are the underlying disks idle?(By iostat). And =
can
>> you please collect /sys/block/[disk]/inflight for both raid and
>> underlying disks.

The underlying disks are completely idle, the md reports 100% =
utilization:

Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s =
    wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  =
%drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
dm-0             0.00      0.00     0.00   0.00    0.00     0.00    0.00 =
     0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   =
0.00    0.00     0.00    0.00    0.00    0.00 100.00
dm-1             0.00      0.00     0.00   0.00    0.00     0.00    0.00 =
     0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   =
0.00    0.00     0.00    0.00    0.00    0.00   0.00
dm-2             0.00      0.00     0.00   0.00    0.00     0.00    0.00 =
     0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   =
0.00    0.00     0.00    0.00    0.00    0.00   0.00
dm-3             0.00      0.00     0.00   0.00    0.00     0.00    0.00 =
     0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   =
0.00    0.00     0.00    0.00    0.00    0.00   0.00
dm-4             0.00      0.00     0.00   0.00    0.00     0.00    0.00 =
     0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   =
0.00    0.00     0.00    0.00    0.00    0.00 100.00
md127            0.00      0.00     0.00   0.00    0.00     0.00    0.00 =
     0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   =
0.00    0.00     0.00    0.00    0.00    0.00 100.00
nvme0n1          0.00      0.00     0.00   0.00    0.00     0.00    0.00 =
     0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   =
0.00    0.00     0.00    0.00    0.00    0.00   0.00
nvme10n1         0.00      0.00     0.00   0.00    0.00     0.00    0.00 =
     0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   =
0.00    0.00     0.00    0.00    0.00    0.00   0.00
nvme11n1         0.00      0.00     0.00   0.00    0.00     0.00    0.00 =
     0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   =
0.00    0.00     0.00    0.00    0.00    0.00   0.00
nvme1n1          0.00      0.00     0.00   0.00    0.00     0.00    0.00 =
     0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   =
0.00    0.00     0.00    0.00    0.00    0.00   0.00
nvme2n1          0.00      0.00     0.00   0.00    0.00     0.00    0.00 =
     0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   =
0.00    0.00     0.00    0.00    0.00    0.00   0.00
nvme3n1          0.00      0.00     0.00   0.00    0.00     0.00    0.00 =
     0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   =
0.00    0.00     0.00    0.00    0.00    0.00   0.00
nvme4n1          0.00      0.00     0.00   0.00    0.00     0.00    0.00 =
     0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   =
0.00    0.00     0.00    0.00    0.00    0.00   0.00
nvme5n1          0.00      0.00     0.00   0.00    0.00     0.00    0.00 =
     0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   =
0.00    0.00     0.00    0.00    0.00    0.00   0.00
nvme6n1          0.00      0.00     0.00   0.00    0.00     0.00    0.00 =
     0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   =
0.00    0.00     0.00    0.00    0.00    0.00   0.00
nvme7n1          0.00      0.00     0.00   0.00    0.00     0.00    0.00 =
     0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   =
0.00    0.00     0.00    0.00    0.00    0.00   0.00
nvme8n1          0.00      0.00     0.00   0.00    0.00     0.00    0.00 =
     0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   =
0.00    0.00     0.00    0.00    0.00    0.00   0.00
nvme9n1          0.00      0.00     0.00   0.00    0.00     0.00    0.00 =
     0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   =
0.00    0.00     0.00    0.00    0.00    0.00   0.00
sda              0.00      0.00     0.00   0.00    0.00     0.00    0.00 =
     0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   =
0.00    0.00     0.00    0.00    0.00    0.00   0.00

Inflight seems 0:

$ cat /sys/block/nvme*/inflight
       0        0
       0        0
       0        0
       0        0
       0        0
       0        0
       0        0
       0        0
       0        0
       0        0
       0        0
       0        0

The md has 348 inflight:

/sys/block/md127
       0      348

Does this help for now?

Liebe Gr=C3=BC=C3=9Fe,
Christian Theune

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

