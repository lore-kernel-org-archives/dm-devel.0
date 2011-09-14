From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Subject: Re: logfs: kernel NULL dereference
Date: Wed, 14 Sep 2011 21:01:13 +0200
Message-ID: <20110914190113.GO23706@smp.if.uj.edu.pl>
References: <20110903125637.GG6092@smp.if.uj.edu.pl>
	<20110907141527.GM32018@logfs.org>
	<20110907210312.GA17634@smp.if.uj.edu.pl>
	<20110907220856.GR32018@logfs.org>
	<20110908161726.GA9104@smp.if.uj.edu.pl>
	<20110914182425.GD24351@logfs.org>
	<20110914183429.GE24351@logfs.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3002807288210566813=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110914183429.GE24351@logfs.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: dm-devel@redhat.com, Prasad Joshi <prasadjoshi124@gmail.com>, Aniket Sane <aniketsane@gmail.com>
List-Id: dm-devel.ids

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--===============3002807288210566813==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=_smp.if.uj.edu.pl-25268-1316026880-0001-2"
Content-Disposition: inline

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_smp.if.uj.edu.pl-25268-1316026880-0001-2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09-14 20:34, J=F6rn Engel wrote:
> Forwarded to dm-devel.  Problem is a NULL pointer dereference in
> kcryptd_io_read, which is triggered when mounting logfs.  If someone
> with device mapper knowledge could have a look, that would be useful.
>=20
> On Wed, 14 September 2011 20:24:25 +0200, J=F6rn Engel wrote:
> >=20
> > Ok, I can reliably reproduce the problem with the following, based on
> > your description:
> >=20
> > truncate -s 0 foo
> > truncate -s 1G foo
> > losetup -v -f foo
> > cryptsetup luksFormat /dev/loop0
> > cryptsetup luksOpen /dev/loop0 foo
> > pvcreate /dev/mapper/foo
> > vgcreate our_volume /dev/mapper/foo
> > lvcreate -L 128M -n logfstest our_volume
> > yes yes | mklogfs /dev/mapper/our_volume-logfstest
> > mount /dev/mapper/our_volume-logfstest /mnt/
> >=20


I think this can be minimized to

echo secret > keyfile
truncate -s 0 foo
truncate -s 1G foo
losetup -v -f foo
cryptsetup luksFormat /dev/loop0 ./keyfile
cryptsetup --key-file ./keyfile luksOpen /dev/loop0 bar
yes yes | mklogfs /dev/mapper/bar
mount /dev/mapper/bar /mnt/

> > It is a bit annoying that cryptsetup cannot easily be scripted.
Look above.


Rest of crypto behaviour is rather strange.

--=20
Witold Baryluk
JID: witold.baryluk // jabster.pl

--=_smp.if.uj.edu.pl-25268-1316026880-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk5w+fgACgkQ7ZLFFOttZ4JttACfUJtKStJKQ4FAXnOJloZgbj0Y
C1oAoNenfS0rtK+BohNoL+BGQ5rh5n0Q
=K+fc
-----END PGP SIGNATURE-----

--=_smp.if.uj.edu.pl-25268-1316026880-0001-2--


--===============3002807288210566813==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3002807288210566813==--
