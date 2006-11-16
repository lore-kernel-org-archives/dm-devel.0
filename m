From: Tejun Heo <htejun@gmail.com>
Subject: Re: Problem booting linux 2.6.19-rc5, 2.6.19-rc5-git6,      2.6.19-rc5-mm2
 with md raid 1 over lvm root
Date: Thu, 16 Nov 2006 09:26:03 +0900
Message-ID: <455BB01B.2080309@gmail.com>
References: <41884.81.64.156.37.1163631254.squirrel@rousalka.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <41884.81.64.156.37.1163631254.squirrel@rousalka.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Nicolas Mailhot <nicolas.mailhot@laposte.net>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, neilb@cse.unsw.edu.au, mingo@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Nicolas Mailhot wrote:
> The failing kernels (I tried -rc5, -rc5-git6, -rc5-mm2 only print :
>=20
> %<----
> device-mapper: ioctl: 4.7.0-ioctl (2006-06-24) initialised:
> dm-devel@redhat.com
> md: Autodetecting RAID arrays.
> md: autorun ...
> md: ... autorun DONE.
> %<-----
>=20
> (I didn't bother copying the rest of the failing kernel dmesg, as sat=
a
> initialisation fills the first half of the screen, then dm is initial=
ised,
> then you only get the logical consequences of failing to detect the /
> volume. The sata part seems fine =E2=80=93 it prints the name of the =
hard drives
> we want to use)
>=20
> I'm attaching the dmesg for the working distro kernel (yes I know not=
 100%
> distro kernel, but very close to one), distro config , and the config=
 I
> used in my test. If anyone could help me to figure what's wrong I'd b=
e
> grateful.

Say 'y' not 'm' to SCSI disk support.

--=20
tejun
