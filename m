From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 14/24] dm cache: use is_write_io() in more
	places
Date: Fri, 25 Oct 2013 16:11:59 -0400
Message-ID: <20131025201158.GE4804@redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
	<1382639437-27007-15-git-send-email-snitzer@redhat.com>
	<20131025195300.GL17070@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131025195300.GL17070@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

On Fri, Oct 25 2013 at  3:53pm -0400,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Thu, Oct 24, 2013 at 02:30:27PM -0400, Mike Snitzer wrote:
> > From: Heinz Mauelshagen <heinzm@redhat.com>
>  
> > Use is_write_io() consistently where it is makes sense.
>  
> > +++ b/drivers/md/dm-cache-target.c
> 
> > +static bool is_write_io(struct bio *bio)
> > +{
> > +	return bio_data_dir(bio) == WRITE;
> > +}
> 
> I'm not really convinced about this one, though I can see some superficial
> attractiveness.  I think introducing it in a single file (rather than
> kernel-wide) is obfuscating the code rather than making it more readable.
> 
> If a change like this were to happen, wouldn't fs.h be a better place?

is_write_io() was already in dm-cache-target.c, this patch just makes
use of it in more applicable places.

But I'm fine with completely eliminating is_write_io()... whatever
others would prefer.
