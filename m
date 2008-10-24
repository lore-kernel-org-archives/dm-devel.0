From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] DM data integrity support
Date: Fri, 24 Oct 2008 00:36:50 -0400
Message-ID: <yq1hc72d2xp.fsf@sermon.lab.mkp.net>
References: <yq1k5c7mg7v.fsf@sermon.lab.mkp.net>
	<20081021125951.GD2810@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081021125951.GD2810@agk.fab.redhat.com> (Alasdair G. Kergon's
	message of "Tue\, 21 Oct 2008 13\:59\:51 +0100")
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
Cc: device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

>>>>> "agk" == Alasdair G Kergon <agk@redhat.com> writes:

agk> That message adds nothing to the preceding one that
agk> blk_integrity_compare() would have issued - the one bit of data
agk> it could add, namely the name of the mapped device, isn't there,
agk> so I've added it.  

m'kay


agk> I've also reduced it to KERN_WARN, and I'm a bit concerned about
agk> those messages issued by blk_integrity_compare() too i.e. any
agk> message like that will generate support requests asking what it
agk> means and how to fix the problem and eliminate the messages, but
agk> won't they sometimes be unavoidable and expected?

Well, they are there because they are important in the same sense as
"Your RAID is running in degraded mode".  If you've spent $$$$ on
integrity-capable hardware, one should think you'd want to use it
correctly.

Once this technology starts trickling down to commodity hardware we
may want to revisit.  And hopefully by then we'll have better userland
tools to manage this stuff.


[Cloning]

agk> I've separated that into its own patch - it's nothing to do with
agk> blk_integrity, and if it has unforseen side-effects we need
agk> people to be able to bisect to it.

That's fine.


agk> Perhaps change the register/unregister interface to make it
agk> symmetric: we always register and unregister when creating the
agk> device, then set the integrity to the appropriate value - which
agk> might include NULL - when the new table is put into place.

It seemed wasteful to register profiles since 99%+ of all storage
devices out there that don't have a need for them.  That's why I
deferred the allocation.  But I guess mere mortals compile without
BLK_DEV_INTEGRITY anyway so it may not matter that much...

Jens, what do you think?


agk> Currently how does device-mapper clear the integrity profile of a
agk> mapped_device which used to have one but which no longer does
agk> after a table swap?  In other words I'm suggesting 'not
agk> supported' could be a valid integrity profile, rather than
agk> requiring an 'unregister' (which seems to be missing from the
agk> appropriate code path in this patch anyway).

I botched the unregister stuff when I redid the patch after the
previous round of feedback.  Will fix...

-- 
Martin K. Petersen	Oracle Linux Engineering
