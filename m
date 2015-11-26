From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm: don't save and restore bi_private
Date: Thu, 26 Nov 2015 08:59:42 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1511260855470.22070@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1511251602270.17072@file01.intranet.prod.int.rdu2.redhat.com>
	<20151125213251.GA20052@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20151125213251.GA20052@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Wed, 25 Nov 2015, Mike Snitzer wrote:

> On Wed, Nov 25 2015 at  4:03pm -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Device mapper used the field bi_private to point to dm_target_io. However,
> > since kernel 3.15, the bi_private field is unused, and so the targets do
> > not need to save and restore this field.
> > 
> > This patch removes code that saves and restores bi_private from dm-cache,
> > dm-snapshot and dm-verity.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > ---
> >  drivers/md/dm-cache-target.c |    3 ---
> >  drivers/md/dm-snap.c         |    6 +-----
> >  drivers/md/dm-verity.c       |    3 ---
> >  3 files changed, 1 insertion(+), 11 deletions(-)
> > 
> > Index: linux-4.4-rc2/drivers/md/dm-cache-target.c
> > ===================================================================
> > --- linux-4.4-rc2.orig/drivers/md/dm-cache-target.c	2015-11-24 15:33:56.000000000 +0100
> > +++ linux-4.4-rc2/drivers/md/dm-cache-target.c	2015-11-24 15:34:35.000000000 +0100
> > @@ -118,14 +118,12 @@ static void iot_io_end(struct io_tracker
> >   */
> >  struct dm_hook_info {
> >  	bio_end_io_t *bi_end_io;
> > -	void *bi_private;
> >  };
> >  
> >  static void dm_hook_bio(struct dm_hook_info *h, struct bio *bio,
> >  			bio_end_io_t *bi_end_io, void *bi_private)
> >  {
> >  	h->bi_end_io = bio->bi_end_io;
> > -	h->bi_private = bio->bi_private;
> >  
> >  	bio->bi_end_io = bi_end_io;
> >  	bio->bi_private = bi_private;
> 
> As you can see dm_hook_bio() goes on to modify bi_private.
> dm-cache uses it to get the migration object associated with a bio for
> the overwrite_endio() case.
> 
> So NAK on the dm-cache change.

dm-cache can modify bi_private (I think I didn't break anything with 
that). I only removed the code that saves and restores bi_private. The dm 
layer doesn't use bi_private, so we don't have to save and restore it.

> How closely have you reviewed your change for snapshot and verity?

I tested dm-snapshot (with LVM testsuite) and dm-verity (by manually 
creating and verifying a block device).

Mikulas
