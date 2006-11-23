From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: [PATCH 01/11] dm io: fix bi_max_vecs
Date: Thu, 23 Nov 2006 16:26:38 +0100
Message-ID: <20061123152638.GA3245@redhat.com>
References: <20061122185936.GR6993@agk.surrey.redhat.com>
	<20061123091957.GM4999@kernel.dk>
Reply-To: mauelshagen@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061123091957.GM4999@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@osdl.org>, Heinz Mauelshagen <hjm@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Nov 23, 2006 at 10:19:57AM +0100, Jens Axboe wrote:
> On Wed, Nov 22 2006, Alasdair G Kergon wrote:
> > From: Heinz Mauelshagen <hjm@redhat.com>
> > 
> > The existing code allocates an extra slot in bi_io_vec[] and uses it to
> > store the region number.
> > 
> > This patch hides the extra slot from bio_add_page() so the region number
> > can't get overwritten.
> > 
> > Also remove a hard-coded SECTOR_SHIFT and fix a typo in a comment.
> >
> > Index: linux-2.6.19-rc6/drivers/md/dm-io.c
> > ===================================================================
> > --- linux-2.6.19-rc6.orig/drivers/md/dm-io.c	2006-11-22 17:26:47.000000000 +0000
> > +++ linux-2.6.19-rc6/drivers/md/dm-io.c	2006-11-22 17:26:53.000000000 +0000
> > @@ -92,12 +92,12 @@ void dm_io_put(unsigned int num_pages)
> >   *---------------------------------------------------------------*/
> >  static inline void bio_set_region(struct bio *bio, unsigned region)
> >  {
> > -	bio->bi_io_vec[bio->bi_max_vecs - 1].bv_len = region;
> > +	bio->bi_io_vec[bio->bi_max_vecs].bv_len = region;
> >  }
> >  
> 
> Ehm eww, that is really ugly code imo.

Got an idea to squirrel the region more beautiful ?

Heinz

> 
> -- 
> Jens Axboe

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Storage Development                               56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            PHONE +49  171 7803392
                                                  FAX   +49 2626 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
