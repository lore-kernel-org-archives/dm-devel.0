From: David =?UTF-8?Q?H=C3=A4rdeman?= <david@hardeman.nu>
Subject: Bug#409875: cannot setup device-mapper mapping ontop of /dev/md* device
Date: Thu, 8 Feb 2007 23:43:33 +0100
Message-ID: <20070208224333.GC9849@hardeman.nu>
References: <20070206214530.GA23506@hardeman.nu> <20070206220221.GL1316@doriath.informatik.uni-erlangen.de> <20070206234626.GA26196@hardeman.nu> <20070206235151.GM1316@doriath.informatik.uni-erlangen.de> <20070207212457.GA12135@hardeman.nu> <20070207213127.GA32661@doriath.informatik.uni-erlangen.de> <32476.145.64.134.242.1170938284.squirrel@www.hardeman.nu> <20070208185253.GK32661@doriath.informatik.uni-erlangen.de> <20070208213609.GA6406@hardeman.nu> <20070208215149.GL32661@doriath.informatik.uni-erlangen.de>
Reply-To: David =?UTF-8?Q?H=C3=A4rdeman?= <david@hardeman.nu>,
	409875@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.409875.B409875.117097458722183@bugs.debian.org>
Content-Disposition: inline
In-Reply-To: <20070208215149.GL32661@doriath.informatik.uni-erlangen.de>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: Johannes Schlumberger <asso@doriath.informatik.uni-erlangen.de>
Cc: 409875@bugs.debian.org, agk@redhat.com, dm-devel@redhat.com, waldi@debian.org, pkg-lvm-maintainers@lists.alioth.debian.org
List-Id: dm-devel.ids

On Thu, Feb 08, 2007 at 10:51:50PM +0100, Johannes Schlumberger wrote:
>I built the packages and installed them.
>The attached file contains the generated stderr stream (which looks a bi=
t
>strange to me). Just to make shure, here is also the output generated fr=
om the
>command without the redirection.

The stderr stream is fine. When you run it without redirection, bash=20
will helpfully mask the null characters that are printed (which is not=20
done when they are redirected to a file).

However, everything looks ok after studying that file, the first two=20
ioctl's are executed (i.e. the device-mapper version is checked and the=20
"root" mapping name is reserved).

Then when it is time to pass the actual parameters for the mapping using=20
the "reload" ioctl, everything goes south. I'm quickly running out of=20
ideas what might cause this or what the best way to debug it would be.

So I'm CC:ing this mail to some different people with the hope that=20
someone other than me can spot the error.

Quoting from previous mails:
> [04:11:35][root@asso:/home/spjsschl]# cryptsetup -c aes -s 256 -d /dev/=
stdin
> create root /dev/md0 < /key
> Command failed: device-mapper: reload ioctl failed: Invalid argument
>=20
> [04:12:57][root@asso:/home/spjsschl]# dmesg | tail -n 3
> device-mapper: table: 253:2: crypt: Device lookup failed
> device-mapper: ioctl: error adding target to table
> device-mapper: ioctl: device doesn't appear to be in the dev hash table=
.
>=20
> [22:28:31][root@asso:/tmp]# echo '0 10000 crypt aes-cbc-essiv:sha256 \
> 0123456789abcdef0123456789abcdef 0 /dev/md0 0' > map
> [22:28:46][root@asso:/tmp]# dmsetup create root map
> device-mapper: reload ioctl failed: Invalid argument Command failed

Executive summary:
dmsetup / cryptsetup both fail to create a mapping on top of a raid=20
device (/dev/md0 in this case).

For much more details, see the bug report, any help appreciated:
http://bugs.debian.org/409875

--=20
David H=E4rdeman
