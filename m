From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 14/19] fs: Permit FIBMAP for users with CAP_SYS_RAWIO in s_user_ns
Date: Fri, 4 Dec 2015 17:00:58 -0700
Message-ID: <DB9A6172-D1AF-4704-9D0D-936365A44AD0@dilger.ca>
References: <1449070821-73820-1-git-send-email-seth.forshee@canonical.com> <1449070821-73820-15-git-send-email-seth.forshee@canonical.com> <20151204191143.GE3624@mail.hallyn.com> <20151204200528.GC18359@thunk.org> <20151204200736.GJ3624@mail.hallyn.com> <20151204204532.GG147214@ubuntu-hedt> <20151204231152.GE18359@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_EE500999-1F4A-473D-9466-533245EFCD34"; protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20151204231152.GE18359@thunk.org>
Sender: linux-bcache-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: Theodore Ts'o <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
List-Id: dm-devel.ids


--Apple-Mail=_EE500999-1F4A-473D-9466-533245EFCD34
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Dec 4, 2015, at 4:11 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
> On Fri, Dec 04, 2015 at 02:45:32PM -0600, Seth Forshee wrote:
>> On Fri, Dec 04, 2015 at 02:07:36PM -0600, Serge E. Hallyn wrote:
>>> Heh, I was looking over =
http://www.gossamer-threads.com/lists/linux/kernel/103611
>>> a little while ago :)  The same question was asked 16 years ago.  =
Apparently
>>> the answer then was that it was easier than fixing the code.
>>=20
>> So it seems then that either it still isn't safe and so unprivileged
>> users shouldn't be allowed to do it at all, or else it's safe and we
>> should drop the requirement completely. I can't say which is right,
>> unfortunately.
>=20
> It may not have been safe 16 years agoo, but giving invalid arguments
> to FIBMAP is safe for ext4 and ext2.  This is the sort of thing that
> tools like trinity should and does test for, so I think it should be
> fine to remove the root check for FIBMAP.

You can use FIEMAP on regular files and directories without special =
permission:

$ filefrag -v /etc
Filesystem type is: ef53
File size of /etc is 12288 (3 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: =
flags:
   0:        0..       0:    8396832..   8396832:      1:
   1:        1..       2:    8397051..   8397052:      2:    8396833: =
last,eof
/etc: 2 extents found


FIEMAP also has the benefit that you don't need to call it millions of =
times
for large files, like is needed for FIBMAP.

Cheers, Andreas






--Apple-Mail=_EE500999-1F4A-473D-9466-533245EFCD34
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVmIpOnKl2rkXzB/gAQiv8xAAps7t3Ska0yZZLMZZpbom7CuzBl76wRN6
d44HirTWGiHhS+29eoruiXIrBnxz8pcnBM7E4ilM/EiTJehIMH9v/aoLuCxZQ4cv
IlZzZBgcf5Sl3CJ7xXA7eMhJLgglNz+dS+3biT2ovXnktVU7vXvBXBpXuJp+lGGg
mYrdjjrBDoYsUge/wbqeOY7+UrBdam2zxfwCn3Mb7nHXZ0a5haYAsQHasOuzcS2G
4a3Vhz9rOgbA+MismKFVbSCwAphGtp9r1ixhPxCLNKw+0Pt7zBXzL/ldznw065RV
oI0ahJk5z9qiGvo53S5+NAcf8PSfpjcBSV+dwrqOGfcLBFcxdJD9SDu2iVMmLYWY
QF4h3CwN4ld1ka041UNXwFuSRmor6ToiA5yoRbwo5q9+YQVbNl4f7iR+lfXNVJco
O5zYqt1tuverbhsJU6yb7gmQjNQROiHQuCyi9CWe8n1kMHbqLW4X1uEsUnvybVOW
WpbPyKu+gNS9QQ4tEvWPoWZ6/g2LUIN7HoGZyxDNrAJgvNsiESFym/HsQSk/Dq63
0VFOjUk3DVtdeSAlmp0fa/HbCFng2yHsNxmrSv3kt0WhVt6DZSC+8AOrH9MsBIqe
hAeeISULRfEuWnT/Fxo3uDlERwogEYMN6OHflfaeInWZAo+ezeymUoldpoaqBopD
AvY4m5kZRjM=
=lPI3
-----END PGP SIGNATURE-----

--Apple-Mail=_EE500999-1F4A-473D-9466-533245EFCD34--
