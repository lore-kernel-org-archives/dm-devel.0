From: "Patrick J. LoPresti" <lopresti@gmail.com>
Subject: [PATCH] Fix kernel NULL pointer dereference in dm-mpath.c
Date: Fri, 11 Jun 2010 10:18:14 -0700
Message-ID: <AANLkTim0Fgiwj-3h5XweiO0oiXQOM7twKfCg7csO8Zc1@mail.gmail.com>
References: <AANLkTilQx3qv6HIi83nYIoC9QRvgS4lJiC42UlcanhSs@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AANLkTilQx3qv6HIi83nYIoC9QRvgS4lJiC42UlcanhSs@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

(re-send; I think my first attempt got eaten by the dm-devel list software)

I discovered this when I accidentally put the following in my
/etc/multipath.conf file:

=A0 =A0 =A0path_selector least_pending

...instead of this:

=A0 =A0path_selector "least_pending 0"

To my surprise, this resulted in a NULL pointer dereference in the
kernel. =A0The bug (and fix) is trivial:

--- linux/drivers/md/dm-mpath.c 2010-05-20 03:06:58.000000000 -0700
+++ linux-patl/drivers/md/dm-mpath.c =A0 =A02010-06-10 12:22:49.000000000 -=
0700
@@ -736,12 +736,13 @@
=A0 =A0 =A0 =A0for (i =3D 0; i < pg->nr_pgpaths; i++) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct pgpath *pgpath;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct arg_set path_args;

=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (as->argc < nr_params) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ti->error =3D "not enough pa=
th parameters";
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D -EINVAL;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto bad;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}

=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0path_args.argc =3D nr_params;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0path_args.argv =3D as->argv;

Without this patch, the parse_priority_group() function can return 0,
which the caller (multipath_ctr()) immediately dereferences. =A0Bang!

I have confirmed that this bug still exists in 2.6.32.9 and 2.6.35-rc2.

=A0- Pat

P.S. =A0Are the Coverity folks still running the kernel through their
tool? =A0This seems like the sort of thing it would catch.
