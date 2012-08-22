From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH v6 08/13] block: Add an explicit bio flag for
 bios that own their bvec
Date: Wed, 22 Aug 2012 23:00:38 +0300
Message-ID: <20120822200038.GB27453@bunk.dyndns.info>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
	<1345655050-28199-9-git-send-email-koverstreet@google.com>
	<20120822174351.GA27453@bunk.dyndns.info>
	<20120822192241.GA30084@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120822192241.GA30084@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Adrian Bunk <bunk@kernel.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, mpatocka@redhat.com, bharrosh@panasas.com, tj@kernel.org, vgoyal@redhat.com
List-Id: dm-devel.ids

On Wed, Aug 22, 2012 at 12:22:41PM -0700, Kent Overstreet wrote:
> On Wed, Aug 22, 2012 at 08:43:52PM +0300, Adrian Bunk wrote:
> > On Wed, Aug 22, 2012 at 10:04:05AM -0700, Kent Overstreet wrote:
> > >...
> > > --- a/include/linux/blk_types.h
> > > +++ b/include/linux/blk_types.h
> > > @@ -117,6 +117,7 @@ struct bio {
> > >   * BIO_POOL_IDX()
> > >   */
> > >  #define BIO_RESET_BITS	12
> > > +#define BIO_OWNS_VEC	12	/* bio_free() should free bvec */
> > >...
> > 
> > This doesn't look right.
> 
> Well, the first 12 bits are reset, so bit 12 will get preserved... I
> guess it's unusual to have a duplicated enum value like that but
> BIO_RESET_BITS is just a marker, not a real bit.

Wouldn't a BIO_RESET_MASK be better than BIO_RESET_BITS?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
