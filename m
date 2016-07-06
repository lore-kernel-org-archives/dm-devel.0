From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: dm-flakey NOT to return -EIO on READ?
Date: Wed, 6 Jul 2016 15:33:25 +0900
Message-ID: <217a0cf8-4853-6316-3016-77460073061d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

I am using dm-flakey to emulate a broken device that should return -EIO on both read and write.
I use the parameter up_interval=0 and down_interval=1.

But when I am dd-ing the flakey device, while write fails, read succeeds.
This isn't the behavior I expect.

Then I looked into the code.

326 static int flakey_end_io(struct dm_target *ti, struct bio *bio, int error)
327 {
328         struct flakey_c *fc = ti->private;
329         struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
330 
331         /*
332          * Corrupt successful READs while in down state.
333          * If flags were specified, only corrupt those that match.
334          */
335         if (fc->corrupt_bio_byte && !error && pb->bio_submitted &&
336             (bio_data_dir(bio) == READ) && (fc->corrupt_bio_rw == READ) &&
337             all_corrupt_bio_flags_match(bio, fc))
338                 corrupt_bio_data(bio, fc);
339 
340         return error;
341 }

When the bio direction is READ and currupt_bio_bytes isn't specified
the READ bio is handled normally right?

I think READ requests should return -EIO if

1. corrupt_bio_bytes isn't specified
2. but the requested is handled during down interval.

as well as WRITE requests:

305                 /*
306                  * Corrupt matching writes.
307                  */
308                 if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw == WRITE)) {
309                         if (all_corrupt_bio_flags_match(bio, fc))
310                                 corrupt_bio_data(bio, fc);
311                         goto map_bio;
312                 }
313 
314                 /*
315                  * By default, error all I/O.
316                  */
317                 return -EIO;
318         }

This code is similar to what we see in the end_io.

If my understanding is correct, I would like to modify dm-flakey to return -EIO in the end_io.

I would like to request for comments.

Thanks,

- Akira
