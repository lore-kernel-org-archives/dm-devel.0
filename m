From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: drivers: md: include "linux/vmalloc.h" in
 "dm-cache-policy-hints.c"
Date: Wed, 30 Oct 2013 10:38:25 -0400
Message-ID: <20131030143825.GA8125@redhat.com>
References: <5270A465.2040200@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5270A465.2040200@asianux.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chen Gang <gang.chen@asianux.com>
Cc: agk@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 30 2013 at  2:17am -0400,
Chen Gang <gang.chen@asianux.com> wrote:

> Need include related header file, or can not pass compiling, the
> related error (for powerpc with allmodconfig):
>=20
>     CC [M]  drivers/md/dm-cache-policy-hints.o
>   drivers/md/dm-cache-policy-hints.c: In function =E2=80=98alloc_hash=
=E2=80=99:
>   drivers/md/dm-cache-policy-hints.c:94:2: error: implicit declaratio=
n of function =E2=80=98vzalloc=E2=80=99 [-Werror=3Dimplicit-function-de=
claration]
>   drivers/md/dm-cache-policy-hints.c:94:14: warning: assignment makes=
 pointer from integer without a cast [enabled by default]
>   drivers/md/dm-cache-policy-hints.c: In function =E2=80=98free_hash=E2=
=80=99:
>   drivers/md/dm-cache-policy-hints.c:101:2: error: implicit declarati=
on of function =E2=80=98vfree=E2=80=99 [-Werror=3Dimplicit-function-dec=
laration]
>   drivers/md/dm-cache-policy-hints.c: In function =E2=80=98alloc_bits=
et=E2=80=99:
>   drivers/md/dm-cache-policy-hints.c:184:2: warning: return makes poi=
nter from integer without a cast [enabled by default]
>=20
>=20
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

This was already fixed a couple days ago in the linux-dm.git 'for-next'
branch.

But thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
