From: Neil Brown <neilb@suse.de>
Subject: Re: PATCH - pvmove doesn't terminate sometimes on 64-bit
	bigendian machines
Date: Mon, 10 Oct 2005 13:22:25 +1000
Message-ID: <17225.56945.115400.390314@cse.unsw.edu.au>
References: <17191.43003.616513.15285@cse.unsw.edu.au>
	<20050928174827.GS18976@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: message from Alasdair G Kergon on Wednesday September 28
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wednesday September 28, agk@redhat.com wrote:
> On Wed, Sep 14, 2005 at 02:32:59PM +1000, Neil Brown wrote:
> >  It is worth noting that the code uses the same bitsets for in-memory
> >  and on-disk logs.  As these bitsets are host-endian and host-sized,
> >  this means that they cannot safely be moved between computers with
> >  different architectures.  I don't know if the dm doco makes this
> >  clear...
>  
> Are you able to try out the (untested) patch from Patrick below?
> Since the current implementation is broken for 64-bit BE we might
> as well fix both problems at the same time.
> 

I've ask the person who reported the problem to test this patch.  I'll
let you know what eventuates.

... it's a pity about the 'ext2' appearing in there instead of a more
sensible 'set_le_bit', isn't it :-(

Thanks,

NeilBrown


> Alasdair
> 
> 
> From: Patrick Caulfield <pcaulfie@redhat.com>
> 
> The solution seems to be to use to set_le_bit test_le_bit functions that ext2
> uses. That makes the BE machines keep the bitmap internally in LE order - it
> does mean you can't use any other type of operations on the bitmap words but
> that looks to be OK in this instance. The efficiency tradeoff is very minimal as
> you would expect for something that ext2 uses.
> 
> The nice thing about this way is that there is no on-disk format change for
> 32bit LE boxes at least, and even nicer is that it removes code and data
> structures because log->disk_bits disappears.
> 
> 
> Index: linux-2.6.14-rc2/drivers/md/dm-log.c
> ===================================================================
> --- linux-2.6.14-rc2.orig/drivers/md/dm-log.c	2005-09-28 18:32:53.000000000 +0100
> +++ linux-2.6.14-rc2/drivers/md/dm-log.c	2005-09-28 18:33:30.000000000 +0100
> @@ -157,7 +157,6 @@
>  	struct log_header *disk_header;
>  
>  	struct io_region bits_location;
> -	uint32_t *disk_bits;
>  };
>  
>  /*
> @@ -166,20 +165,20 @@
>   */
>  static  inline int log_test_bit(uint32_t *bs, unsigned bit)
>  {
> -	return test_bit(bit, (unsigned long *) bs) ? 1 : 0;
> +	return ext2_test_bit(bit, (unsigned long *) bs) ? 1 : 0;
>  }
