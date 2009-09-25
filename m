From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2 of 2] DM Snapshot: dont insert before
	existing chunk
Date: Thu, 24 Sep 2009 23:43:36 -0400
Message-ID: <20090925034336.GA12204@redhat.com>
References: <200909231525.n8NFP87C029957@hydrogen.msp.redhat.com>
	<20090924124841.GI3866@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090924124841.GI3866@agk-dp.fab.redhat.com>
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 24 2009 at  8:48am -0400,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Wed, Sep 23, 2009 at 10:25:08AM -0500, Jon Brassow wrote:
> > Don't insert into hash before an existing chunk.
> > Most inserts are after an existing extent anyway so this code is used
> > very rarely.
>  
> Again, I'm not particularly keen on taking this one.  Some systems are very
> short of memory and everything we can save matters and we have no statistics
> about how "rare" this actually is.
> 
> Is it really that difficult to split into two when removing?

Jon, Mikulas and I examined/discussed this in detail today.  We had a
nice break-through: snapshot-merge no longer needs to avoid inserting
before an existing chunk.  As such snapshot-merge no longer imposes less
efficient packing of the exception cache.

We needed a small change to the snapshot-merge clear_exception() code so
that it increments e->old_chunk and e->new_chunk when it makes its call
to dm_consecutive_chunk_count_dec(), e.g.:

        if (dm_consecutive_chunk_count(e)) {
                if ((de->old_chunk == e->old_chunk) &&
                    (de->new_chunk == dm_chunk_number(e->new_chunk))) {
                        e->old_chunk++;
                        e->new_chunk++;
                }
                dm_consecutive_chunk_count_dec(e);
        }

This is the inverse of what is done in dm_insert_exception():

        /* Insert before an existing chunk? */
        if (new_e->old_chunk == (e->old_chunk - 1) &&
            new_e->new_chunk == (dm_chunk_number(e->new_chunk) - 1)) {
                dm_consecutive_chunk_count_inc(e);
                e->old_chunk--;
                e->new_chunk--;
                dm_free_exception(eh, new_e);
                return;
        }

Updated DM snapshot-merge patches are available here:
http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel_unified/2.6.31/
