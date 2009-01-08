From: "Cheng Renquan" <crquan@gmail.com>
Subject: Re: [2.6.29 PATCH 01/02] dm target: use module refcount
	directly
Date: Thu, 8 Jan 2009 21:13:25 +0800
Message-ID: <91b13c310901080513g1e3d33acu15a6a0325d4a6c71@mail.gmail.com>
References: <20090107204143.GR3512@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090107204143.GR3512@agk.fab.redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 8, 2009 at 4:41 AM, Alasdair G Kergon <agk@redhat.com> wrote:
> From: Cheng Renquan <crquan@gmail.com>
>
> The tt_internal's 'use' field is superfluous: the module's refcount can=
 do
> the work properly.  An acceptable side-effect is that this increases th=
e
> reference counts reported by 'lsmod'.
>
> Remove the superfluous test when removing a target module.

Thank you for doing the work, I'm just too busy to have time to take it.

I've applied these two patches on the current linus's 2.6.29 kernel
head, and have done some simple building and running tests, it seems
OK with allyesconfig, allnoconfig(with all DM config enabled), and
serverl randconfigs with DM enabled.

> Signed-off-by: Cheng Renquan <crquan@gmail.com>
> Reviewed-by: Alasdair G Kergon <agk@redhat.com>
> Signed-off-by: Alasdair G Kergon <agk@redhat.com>
> ---
>  drivers/md/dm-target.c |   20 +++-----------------
>  1 files changed, 3 insertions(+), 17 deletions(-)
>
> Index: linux-2.6.28/drivers/md/dm-target.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.28.orig/drivers/md/dm-target.c    2009-01-07 20:29:57.000=
000000 +0000
> +++ linux-2.6.28/drivers/md/dm-target.c 2009-01-07 20:30:57.000000000 +=
0000

--=20
Cheng Renquan (=E7=A8=8B=E4=BB=BB=E5=85=A8), Shenzhen, China
Joan Crawford  - "I, Joan Crawford, I believe in the dollar.
Everything I earn, I spend."
