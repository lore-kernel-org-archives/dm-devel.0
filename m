From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Shared snapshots
Date: Wed, 16 Dec 2009 15:39:01 -0500
Message-ID: <20091216203901.GA17098@redhat.com>
References: <Pine.LNX.4.64.0912160255370.10656@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0912160255370.10656@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Dec 16 2009 at  3:05am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
>=20
> I uploaded new shared snapshots here:
> http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/devel/

Just a general observation:
You have an empty line separating your comment blocks above functions.
I think eliminating that empty line would help join the comment block to
the function a bit better (as is common in the rest of the kernel).

Also, a comment block of the form:
/* single line comment above function */

Is generally done as:
/*
 * single line comment above function
 */

Hopefully I'm not triggering unhappy checkpatch.pl-type thoughts with
these recommendations :)

> changes:
>=20
> - Broken to separate patches, one patch per file. The last patch adds a=
ll=20
> the files to Makefile and makes it all compile. It allows you to ack=20
> patches individually. I didn't use stubs to compile intermediate patche=
s,=20
> the problem is that if multiple patches modify the same file, general=20
> modifications to the code become harder. With one-patch-per-file I can=20
> edit it with normal text editor and quilt regenerates the patches.
>=20
> - Document on-disk format in dm-multisnap-mikulas-struct.h
>=20
> - More functions are commented
>=20
> - Removed /*printk ... */ statements. I left some #ifdefed debug routin=
es,=20
> they are non-trivial to write again

I'm still seeing one in dm_bufio_client_create()

> - Fixed a bug on big-endian systems
>=20
> - Exposed interface for snapshots-of-snapshots, tested that they work

Where is that interface documented?

As an aside, I have some ideas for improving
Documentation/device-mapper/dm-multisnapshot.txt
I'll just send a patch and we can go from there.

> Mikulas

BTW, I'm getting the following warning when I build the code:

drivers/md/dm-bufio.c: In function =E2=80=98write_endio=E2=80=99:
drivers/md/dm-bufio.c:725: warning: value computed is not used

A cast fixes it:

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 1ab5304..be7b89b 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -722,7 +722,7 @@ static void write_endio(struct bio *bio, int error)
 	b->write_error =3D error;
 	if (unlikely(error)) {
 		struct dm_bufio_client *c =3D b->c;
-		cmpxchg(&c->async_write_error, 0, error);
+		(void)cmpxchg(&c->async_write_error, 0, error);
 	}
 	BUG_ON(!test_bit(B_WRITING, &b->state));
 	smp_mb__before_clear_bit();
