From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: linux-next: Tree for Nov 15 (drivers/md/dm-integrity)
Date: Fri, 15 Nov 2019 18:10:51 -0500
Message-ID: <20191115231050.GA29649@redhat.com>
References: <20191115190525.77efdf6c@canb.auug.org.au>
 <f368f431-b741-d04f-440b-3d8c3c035537@infradead.org>
 <20191116094620.497663ab@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191116094620.497663ab@canb.auug.org.au>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alasdair G Kergon <agk@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Linux Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Joe Thornber <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Fri, Nov 15 2019 at  5:46pm -0500,
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
>=20
> On Fri, 15 Nov 2019 08:17:48 -0800 Randy Dunlap <rdunlap@infradead.org> w=
rote:
> >
> > on i386:
> >=20
> > ld: drivers/md/dm-integrity.o: in function `calculate_device_limits':
> > dm-integrity.c:(.text.unlikely+0x1e9): undefined reference to `__udivdi=
3'
>=20
> Caused by commit
>=20
>   a236c37603bd ("dm integrity: fix excessive alignment of metadata runs")
>=20
> From the device-mapper tree.

Yes, I've pushed a fixed commit, please see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/=
commit/?h=3Dfor-next&id=3Dd537858ac8aaf4311b51240893add2fc62003b97
