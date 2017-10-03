From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt: Reject sector_size feature if device
 length is not aligned to it
Date: Tue, 3 Oct 2017 17:18:15 -0400
Message-ID: <20171003211815.GA26406@redhat.com>
References: <20170913134556.23145-1-gmazyland@gmail.com>
	<b6c539ce-c841-a21c-1a2c-4ee93d826680@gmail.com>
	<alpine.LRH.2.02.1710021034380.2597@file01.intranet.prod.int.rdu2.redhat.com>
	<20171003120508.GA9979@agk-dp.fab.redhat.com>
	<20171003180804.GA25465@redhat.com>
	<20171003190934.GB9979@agk-dp.fab.redhat.com>
	<alpine.LRH.2.02.1710031606140.8739@file01.intranet.prod.int.rdu2.redhat.com>
	<ddef2346-99af-c20d-903f-f77af35925b6@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <ddef2346-99af-c20d-903f-f77af35925b6@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 03 2017 at  4:33pm -0400,
Milan Broz <gmazyland@gmail.com> wrote:

> On 10/03/2017 10:08 PM, Mikulas Patocka wrote:
> > 
> > It would be interesting to know, why Milan wants the table load to fail.
> 
> I mentioned this on IRC:
> the only situation I care about in load is that size (dm-table length) is unaligned to optional sector_size.
> create fails in this case, load should imho fail as well. 
> ...
> if we say that dmsetup table output is always directly usable (as a mapping table),
> then why should there be an exception for dmsetup table --inactive? (now it can print apparently invalid mapping)

The .ctr should validate the inactive table and that'll cause load to
fail.

Or dm-crypt could publish block_limits that reflect this optional
sector_size and we'll get create (resume) failure.. which I assume is
what you want to avoid.

> Anyway, I am ok if it fails in resume - but do not keep the device suspended after the fail!

Sounds like we need a patch to resume after failed inactive table load.
Might cause lvm2 to try to resume when there is no need.  But the user
would've already had to suspend and then resume to try to load the
inactive table.  If we resume with the original (working) table it may
surprise the user... will certainly cause lvm2 to fail its table
comparison tests if the resume to old working table is done without
erroring out.

So we'd need to still return error but resume with old table if it
exists... and who is asking for this again?  Just us devs who think
leaving the device suspended is bad form?

The user caused the problem by requesting a malformed table get
used... I'm not sure how I feel about covering for such imprecise users.

> > It could be possible to check the validity of the alignment in the 
> > cryptsetup tool and not attempt to load invalid tables at all. Is there 
> > any reason, why we need to detect the misalignment in the kernel?
> 
> Cryptsetup already rejects such a mapping before even calling dm-ioctl.
> 
> But anyone can use dmsetup tool to do that. I just think that incompatible
> sector vs. device size should be rejected in target constructor.
> (IOW my former patch for dm-crypt that rejects only this exact situation without
> doing more device-related tests like your generalized patch in table_load.)

I'll revisit your patch since it reflects what I first said above (about
the .ctr erroring out as needed).

Not sure why Mikulas is saying all the other targets need this too
(e.g. verity, integrity, etc).

Mike
