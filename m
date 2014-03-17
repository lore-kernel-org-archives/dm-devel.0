From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/6] dm: introduce dm_accept_partial_bio
Date: Mon, 17 Mar 2014 13:08:19 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1403171251510.24934@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1403141837520.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141840500.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<20140317132740.GA7184@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140317132740.GA7184@redhat.com>
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
Cc: dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Mon, 17 Mar 2014, Mike Snitzer wrote:

> > +void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
> > +{
> > +	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
> > +	unsigned bi_size = bio->bi_iter.bi_size >> SECTOR_SHIFT;
> > +	BUG_ON(bi_size > *tio->len_ptr);
> > +	BUG_ON(n_sectors > bi_size);
> > +	*tio->len_ptr -= bi_size - n_sectors;
> > +	bio->bi_iter.bi_size = n_sectors << SECTOR_SHIFT;
> > +}
> > +EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
> > +
> 
> The dm_accept_partial_bio interface should return an error (e.g. if bio
> has REQ_FLUSH set, or the above BUG_ON conditions are met).  The method
> should probably also be designated with __must_check.  And it should
> _not_ BUG_ON.  BUG_ON is a crutch that I do not appreciate seeing in new
> code.  If you'd like to keep them, and get stacktraces, I'd prefer
> seeing them converted to WARN_ON that is followed with an error return.

You need to return error for externally triggered events (like disk 
errors, memory allocation failures, etc.), not for bugs in the code.

Here, if someone passes invalid n_sectors, it is not externally triggered 
event (the code that passed the invalid argument is just buggy) - so 
crashing on BUG_ON is OK.


Another problem is that warnings can be easily missed, BUG won't be 
missed. For example, the lvm testsuite generates large number of messages 
to the syslog. Consequently, when I run the testsuite, I don't read 
syslog. Consequently, if you convert BUG_ON to WARN_ON and the testsuite 
triggers it, I will miss it.


Regarding REQ_FLUSH - it would already crash on NULL pointer dereference 
when accessing *tio->len_ptr.

Mikulas
