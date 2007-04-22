From: Lars =?ISO-8859-15?Q?T=E4uber?= <lars.taeuber@gmx.net>
Subject: Fw: Re: [dm-crypt] LUKS on DVD+RW
Date: Sun, 22 Apr 2007 13:08:30 +0200
Message-ID: <20070422130830.cc88595b.lars.taeuber@gmx.net>
Reply-To: taeuber@informatik.hu-berlin.de,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hallo!

Your email address is written as contact in /usr/src/linux/drivers/md/dm-=
ioctl.c.
I'd like to make a unix group on a workstation that is allowed to make a =
crypted udf filesystem on a dvd-rw or dvd-ram.
I don't like the sudo mechanism, because the users have to understand wha=
t they do.
What is the reason only root to be able to create such a device?

Thanks
Lars


Begin forwarded message:

> Date: Sun, 22 Apr 2007 12:33:48 +0200
> From: Luca Berra <bluca@comedia.it>
> To: dm-crypt@saout.de
> Subject: Re: [dm-crypt] LUKS on DVD+RW
>=20
>=20
> On Fri, Apr 20, 2007 at 06:18:28PM +0200, Lars T=E4uber wrote:
> >mmap2(NULL, 123180, PROT_READ, MAP_PRIVATE, 6, 0) =3D 0xb7bd6000
> >close(6)                                =3D 0
> >ioctl(5, DM_VERSION, 0x80d5c80)         =3D -1 EACCES (Permission deni=
ed)
> >close(5)                                =3D 0
> >
> >Do you think I have a chance to get it working my way without sudo?
>=20
> No, i am sorry,
>=20
> /usr/src/linux/drivers/md/dm-ioctl.c
> static int ctl_ioctl(struct inode *inode, struct file *file,
>                      uint command, ulong u)
> {
> ....
>         /* only root can play with this */
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EACCES;
>=20
> L.
>=20
> --=20
> Luca Berra -- bluca@comedia.it
>         Communication Media & Services S.r.l.
>  /"\
>  \ /     ASCII RIBBON CAMPAIGN
>   X        AGAINST HTML MAIL
>  / \
>=20
> ---------------------------------------------------------------------
> dm-crypt mailing list - http://www.saout.de/misc/dm-crypt/
> To unsubscribe, e-mail: dm-crypt-unsubscribe@saout.de
> For additional commands, e-mail: dm-crypt-help@saout.de
