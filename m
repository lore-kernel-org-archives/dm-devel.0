From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: DM Regression in 4.16-rc1 - read() returns data when it shouldn't
Date: Wed, 14 Feb 2018 18:05:26 -0500
Message-ID: <20180214230526.GA25114@redhat.com>
References: <70cda2a3-f246-d45b-f600-1f9d15ba22ff@gmail.com>
 <871shnqp9l.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <871shnqp9l.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Milan Broz <gmazyland@gmail.com>, device-mapper development <dm-devel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Wed, Feb 14 2018 at  3:39pm -0500,
NeilBrown <neilb@suse.com> wrote:

> On Wed, Feb 14 2018, Milan Broz wrote:
> 
> > Hi,
> >
> > the commit (found by bisect)
> >
> >   commit 18a25da84354c6bb655320de6072c00eda6eb602
> >   Author: NeilBrown <neilb@suse.com>
> >   Date:   Wed Sep 6 09:43:28 2017 +1000
> >
> >     dm: ensure bio submission follows a depth-first tree walk
> >
> > cause serious regression while reading from DM device.
> >
> > The reproducer is below, basically it tries to simulate failure we see in cryptsetup
> > regression test: we have DM device with error and zero target and try to read
> > "passphrase" from it (it is test for 64 bit offset error path):
> >
> > Test device:
> > # dmsetup table test
> > 0 10000000 error 
> > 10000000 1000000 zero 
> >
> > We try to run this operation:
> >   lseek64(fd, 5119999988, SEEK_CUR); // this should seek to error target sector
> >   read(fd, buf, 13); // this should fail, if we seek to error part of the device
> >
> > While on 4.15 the read properly fails:
> >   Seek returned 5119999988.
> >   Read returned -1.
> >
> > for 4.16 it actually succeeds returning some random data
> > (perhaps kernel memory, so this bug is even more dangerous):
> >   Seek returned 5119999988.
> >   Read returned 13.
> >
> > Full reproducer below:
> >
> > #define _GNU_SOURCE
> > #define _LARGEFILE64_SOURCE
> > #include <stdio.h>
> > #include <stddef.h>
> > #include <stdint.h>
> > #include <stdlib.h>
> > #include <unistd.h>
> > #include <fcntl.h>
> > #include <inttypes.h>
> >
> > int main (int argc, char *argv[])
> > {
> >         char buf[13];
> >         int fd;
> >         //uint64_t offset64 = 5119999999;
> >         uint64_t offset64 =   5119999988;
> >         off64_t r;
> >         ssize_t bytes;
> >
> >         system("echo -e \'0 10000000 error\'\\\\n\'10000000 1000000 zero\' | dmsetup create test");
> >
> >         fd = open("/dev/mapper/test", O_RDONLY);
> >         if (fd == -1) {
> >                 printf("open fail\n");
> >                 return 1;
> >         }
> >
> >         r = lseek64(fd, offset64, SEEK_CUR);
> >         printf("Seek returned %" PRIu64 ".\n", r);
> >         if (r < 0) {
> >                 printf("seek fail\n");
> >                 close(fd);
> >                 return 2;
> >         }
> >
> >         bytes = read(fd, buf, 13);
> >         printf("Read returned %d.\n", (int)bytes);
> >
> >         close(fd);
> >         return 0;
> > }
> >
> >
> > Please let me know if you need more info to reproduce it.
> 
> Thanks for the detailed report.  I haven't tried to reproduce, but the
> code looks very weird.
> The patch I posted "Date: Wed, 06 Sep 2017 09:43:28 +1000" had:
>       +				struct bio *b = bio_clone_bioset(bio, GFP_NOIO,
>       +								 md->queue->bio_split);
>       +				bio_advance(b, (bio_sectors(b) - ci.sector_count) << 9);
>       +				bio_chain(b, bio);
>       +				generic_make_request(b);
>       +				break;
> 
> The code in Linux has:
> 
> 				struct bio *b = bio_clone_bioset(bio, GFP_NOIO,
> 								 md->queue->bio_split);
> 				ci.io->orig_bio = b;
> 				bio_advance(bio, (bio_sectors(bio) - ci.sector_count) << 9);
> 				bio_chain(b, bio);
> 				ret = generic_make_request(bio);
> 				break;
> 
> So the wrong bio is sent to generic_make_request().
> Mike: do you remember how that change happened?  I think there were
> discussions following the patch, but I cannot find anything about making
> that change.

Mikulas had this feedback:
https://www.redhat.com/archives/dm-devel/2017-November/msg00159.html

You replied with:
https://www.redhat.com/archives/dm-devel/2017-November/msg00165.html

Where you said "Yes, you are right something like that would be better."

And you then provided a follow-up patch:
https://www.redhat.com/archives/dm-devel/2017-November/msg00175.html

That we discussed and I said I'd just fold it into the original, and you
agreed and thanked me for checking with you ;)
https://www.redhat.com/archives/dm-devel/2017-November/msg00208.html

Anyway, I'm just about to switch to Daddy Daycare mode (need to get my
daughter up from her nap, feed her dinner, etc) so: I'll circle back to
this tomorrow morning.

Thanks,
Mike
