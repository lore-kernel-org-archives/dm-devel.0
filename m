From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Device mapper failed to open temporary keystore device
Date: Fri, 17 Apr 2015 18:38:49 -0400
Message-ID: <20150417223848.GD4028@redhat.com>
References: <CA+LKeY6Vm=hWj+gaKxm5JqLqehu8557OX2101a8roKas6WcsFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+LKeY6Vm=hWj+gaKxm5JqLqehu8557OX2101a8roKas6WcsFg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Murilo Opsfelder =?iso-8859-1?Q?Ara=FAjo?= <mopsfelder@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>
List-Id: dm-devel.ids

On Fri, Apr 17 2015 at  4:11pm -0400,
Murilo Opsfelder Ara=FAjo <mopsfelder@gmail.com> wrote:

> Hello, everyone.
>=20
> Right after I enter my passphrase to unlock my cryptsetup partition,
> it displays the following error and asks for cryptsetup password agai=
n
> (it got stuck on this loop).
>=20
> This issue was introduced in next-20150413.  next-20150410 is working=
 just fine.
>=20
> Any hint on how to debug this?
>=20
> Unlocking the disk /dev/disk/by-uuid/<uuid> (sda5_crypt)
> Enter passphrase: *****
> [  244.239821] device-mapper: table: 252:0: crypt: Error allocating c=
rypto tfm
> device-mapper: reload ioctl on  failed: No such file or directory
> Failed to open temporary keystore device.
> device-mapper: remove ioctl on temporary-cryptsetup-239 failed: No
> such device or address
> device-mapper: reload ioctl on temporary-cryptsetup-239 failed: No
> such device or address
> device-mapper: remove ioctl on temporary-cryptsetup-239 failed: No
> such device or address
> device-mapper: remove ioctl on temporary-cryptsetup-239 failed: No
> such device or address
> device-mapper: remove ioctl on temporary-cryptsetup-239 failed: No
> such device or address
> device-mapper: remove ioctl on temporary-cryptsetup-239 failed: No
> such device or address

git diff next-20150410^..next-20150413 drivers/md/dm-crypt.c points to
this commit as the nly dm-crpt.c change:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git=
/commit/?h=3Dfor-next&id=3D5977907937afa2b5584a874d44ba6c0f56aeaa9c

Which appears unrelated given your "crypt: Error allocating crypto tfm"
error.

But any chance you can try reverting that commit from next-20150413 and
re-test just to be absolutely sure?

There are also some crypto changes that could very easily be the cause
of your problem (cc'ing Herbert), e.g.:

$ git diff next-20150410^..next-20150413 -- crypto | diffstat
 algapi.c         |   13 ++++-
 algif_hash.c     |    4 -
 algif_skcipher.c |    4 -
 sha1_generic.c   |  102 ++++++++----------------------------------
 sha256_generic.c |  133 ++++++++--------------------------------------=
---------
 sha512_generic.c |  123 ++++++++--------------------------------------=
----
 6 files changed, 76 insertions(+), 303 deletions(-)
