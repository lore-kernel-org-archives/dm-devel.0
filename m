From: NeilBrown <neilb@suse.com>
Subject: Re: [dm-devel] DM Regression in 4.16-rc1 - read() returns data when    it shouldn't
Date: Thu, 15 Feb 2018 11:07:11 +1100
Message-ID: <87y3jvp13k.fsf@notabene.neil.brown.name>
References: <70cda2a3-f246-d45b-f600-1f9d15ba22ff@gmail.com> <871shnqp9l.fsf@notabene.neil.brown.name> <20180214230526.GA25114@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180214230526.GA25114@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 14 2018, Mike Snitzer wrote:

> On Wed, Feb 14 2018 at  3:39pm -0500,
> NeilBrown <neilb@suse.com> wrote:
>
>> On Wed, Feb 14 2018, Milan Broz wrote:
>>=20
>> > Hi,
>> >
>> > the commit (found by bisect)
>> >
>> >   commit 18a25da84354c6bb655320de6072c00eda6eb602
>> >   Author: NeilBrown <neilb@suse.com>
>> >   Date:   Wed Sep 6 09:43:28 2017 +1000
>> >
>> >     dm: ensure bio submission follows a depth-first tree walk
>> >
>> > cause serious regression while reading from DM device.
>> >
>> > The reproducer is below, basically it tries to simulate failure we see=
 in cryptsetup
>> > regression test: we have DM device with error and zero target and try =
to read
>> > "passphrase" from it (it is test for 64 bit offset error path):
>> >
>> > Test device:
>> > # dmsetup table test
>> > 0 10000000 error=20
>> > 10000000 1000000 zero=20
>> >
>> > We try to run this operation:
>> >   lseek64(fd, 5119999988, SEEK_CUR); // this should seek to error targ=
et sector
>> >   read(fd, buf, 13); // this should fail, if we seek to error part of =
the device
>> >
>> > While on 4.15 the read properly fails:
>> >   Seek returned 5119999988.
>> >   Read returned -1.
>> >
>> > for 4.16 it actually succeeds returning some random data
>> > (perhaps kernel memory, so this bug is even more dangerous):
>> >   Seek returned 5119999988.
>> >   Read returned 13.
>> >
>> > Full reproducer below:
>> >
>> > #define _GNU_SOURCE
>> > #define _LARGEFILE64_SOURCE
>> > #include <stdio.h>
>> > #include <stddef.h>
>> > #include <stdint.h>
>> > #include <stdlib.h>
>> > #include <unistd.h>
>> > #include <fcntl.h>
>> > #include <inttypes.h>
>> >
>> > int main (int argc, char *argv[])
>> > {
>> >         char buf[13];
>> >         int fd;
>> >         //uint64_t offset64 =3D 5119999999;
>> >         uint64_t offset64 =3D   5119999988;
>> >         off64_t r;
>> >         ssize_t bytes;
>> >
>> >         system("echo -e \'0 10000000 error\'\\\\n\'10000000 1000000 ze=
ro\' | dmsetup create test");
>> >
>> >         fd =3D open("/dev/mapper/test", O_RDONLY);
>> >         if (fd =3D=3D -1) {
>> >                 printf("open fail\n");
>> >                 return 1;
>> >         }
>> >
>> >         r =3D lseek64(fd, offset64, SEEK_CUR);
>> >         printf("Seek returned %" PRIu64 ".\n", r);
>> >         if (r < 0) {
>> >                 printf("seek fail\n");
>> >                 close(fd);
>> >                 return 2;
>> >         }
>> >
>> >         bytes =3D read(fd, buf, 13);
>> >         printf("Read returned %d.\n", (int)bytes);
>> >
>> >         close(fd);
>> >         return 0;
>> > }
>> >
>> >
>> > Please let me know if you need more info to reproduce it.
>>=20
>> Thanks for the detailed report.  I haven't tried to reproduce, but the
>> code looks very weird.
>> The patch I posted "Date: Wed, 06 Sep 2017 09:43:28 +1000" had:
>>       +				struct bio *b =3D bio_clone_bioset(bio, GFP_NOIO,
>>       +								 md->queue->bio_split);
>>       +				bio_advance(b, (bio_sectors(b) - ci.sector_count) << 9);
>>       +				bio_chain(b, bio);
>>       +				generic_make_request(b);
>>       +				break;
>>=20
>> The code in Linux has:
>>=20
>> 				struct bio *b =3D bio_clone_bioset(bio, GFP_NOIO,
>> 								 md->queue->bio_split);
>> 				ci.io->orig_bio =3D b;
>> 				bio_advance(bio, (bio_sectors(bio) - ci.sector_count) << 9);
>> 				bio_chain(b, bio);
>> 				ret =3D generic_make_request(bio);
>> 				break;
>>=20
>> So the wrong bio is sent to generic_make_request().
>> Mike: do you remember how that change happened?  I think there were
>> discussions following the patch, but I cannot find anything about making
>> that change.
>
> Mikulas had this feedback:
> https://www.redhat.com/archives/dm-devel/2017-November/msg00159.html
>
> You replied with:
> https://www.redhat.com/archives/dm-devel/2017-November/msg00165.html
>
> Where you said "Yes, you are right something like that would be better."
>
> And you then provided a follow-up patch:
> https://www.redhat.com/archives/dm-devel/2017-November/msg00175.html
>
> That we discussed and I said I'd just fold it into the original, and you
> agreed and thanked me for checking with you ;)
> https://www.redhat.com/archives/dm-devel/2017-November/msg00208.html
>
> Anyway, I'm just about to switch to Daddy Daycare mode (need to get my
> daughter up from her nap, feed her dinner, etc) so: I'll circle back to
> this tomorrow morning.
>

Thanks for the reminder - it's coming back to me now.

And looking again at the code, it doesn't seem so bad.  I was worried
about reassigning ci.io->orig_bio after calling
__split_and_process_non_flush(), but the important thing is to set it
before the last dec_pending() call, and the code gets that right.

I think I've found the problem though:

			/* done with normal IO or empty flush */
			bio->bi_status =3D io_error;

When we have chained bios, there are multiple sources for error which
need to be merged into bi_status:  all bios that were chained to this
one, and this bio itself.

__bio_chain_endio uses:

	if (!parent->bi_status)
		parent->bi_status =3D bio->bi_status;

so the new status won't over-ride the old status (unless there are
races....), but dm doesn't do that - I guess it didn't have to worry
about chains before.

So this:

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d6de00f367ef..68136806d365 100644
=2D-- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -903,7 +903,8 @@ static void dec_pending(struct dm_io *io, blk_status_t =
error)
 			queue_io(md, bio);
 		} else {
 			/* done with normal IO or empty flush */
=2D			bio->bi_status =3D io_error;
+			if (io_error)
+				bio->bi_status =3D io_error;
 			bio_endio(bio);
 		}
 	}

should fix it.  And __bio_chain_endio should probably be

diff --git a/block/bio.c b/block/bio.c
index e1708db48258..ad77140edc6f 100644
=2D-- a/block/bio.c
+++ b/block/bio.c
@@ -312,7 +312,7 @@ static struct bio *__bio_chain_endio(struct bio *bio)
 {
 	struct bio *parent =3D bio->bi_private;
=20
=2D	if (!parent->bi_status)
+	if (bio->bi_status)
 		parent->bi_status =3D bio->bi_status;
 	bio_put(bio);
 	return parent;

to remove the chance that a race will hide a real error.

Milan: could you please check that the patch fixes the dm-crypt bug?
I've confirmed that it fixes your test case.
When you confirm, I'll send a proper patch.

I guess I should audit all code that assigns to ->bi_status and make
sure nothing ever assigns 0 to it.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlqEzy8ACgkQOeye3VZi
gbkvVA//aTNSfCFfEA5r1k/XCWP6bk+f2wjLXJ/iRDU0oHqmfXEqRfCqExwL/1bD
FBcpVQAcobO1qXW82qln9DimTzioR+EvZH3ALgnOi7I/5r2hwlkc8eXhOsdpmQvV
2lru+Edl5RuNIpB4LzCGZF3D5xuXlI9xqqQ/Rc5iq691tqbxncGypy2Xh8cfDs3+
XODDBqqGEkJOk9kqkzGcBJfpin+gRMbl1TWsglREdkdF4eEugoEqUlghDhHTELJw
rX3bizKaJQB5NHBTlv1nUPbHYJHMvuSxMhdUmwgd+RN4SqZwb2h49vvcgZTZvZ1R
omNEvAYSuc+6hiqOMWbPb1cPFv92UfQHWDy6dAuFSFgkb9IgFPSjrs5SAw/aqC3t
r/JJ8uRBbCCHTJeDqgDBwJdXLqWoPsGJ+aseekE5UUwTlD4irQSSHM+yqJwO+cEg
H63JZfyGysqGdptzmw0L0X3lSkmQza4PLCXMNVk8X2Ck3lL0gyKIzHg8U+XIH6YV
YCItNHo6jtpupCYsDbjC/n3ZdqaIDGQ4U4aVm4HMfbsz6shHDNTwSWUfBZbt9N2C
lWz7mZxhmgCB5nEZYycnallRx7KiuHP0ATe9nzC5syx84+JJbylJ8jNKGcG614g+
uEaREbniMrdT5uWvmMuN5Sva26VncTYT/hH+tt2y54rKiL9qP3s=
=sqy1
-----END PGP SIGNATURE-----
--=-=-=--
