From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] DM data integrity support
Date: Fri, 24 Oct 2008 11:51:12 +0100
Message-ID: <20081024105112.GQ2810@agk.fab.redhat.com>
References: <yq1k5c7mg7v.fsf@sermon.lab.mkp.net>
	<20081021125951.GD2810@agk.fab.redhat.com>
	<yq1hc72d2xp.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1hc72d2xp.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

On Fri, Oct 24, 2008 at 12:36:50AM -0400, Martin K. Petersen wrote:
> agk> Perhaps change the register/unregister interface to make it
> agk> symmetric: we always register and unregister when creating the
> agk> device, then set the integrity to the appropriate value - which
> agk> might include NULL - when the new table is put into place.
> It seemed wasteful to register profiles since 99%+ of all storage
> devices out there that don't have a need for them.  That's why I
> deferred the allocation.  But I guess mere mortals compile without
> BLK_DEV_INTEGRITY anyway so it may not matter that much...
 
Then the integrity profile allocation/free should be attached to the
table creation/destruction, not the device itself, and you make the
reasonable assumption that the profiles of the devices in the table
won't change between table creation and device resumption.

i.e. Each dm table holds a reference to its own allocated integrity
profile, and when a table switches from inactivate to live, that profile
becomes the one registered against the block device (without memory
allocation that could deadlock at that point - the allocation might
involve flushing to the suspended device, which waits for the resume
which waits for this allocation).  (I'd prefer not to see another
dependency on PF_MEMALLOC enter the tree, when a slightly different
interface could avoid it and still offer lazy allocation.)

Alasdair
-- 
agk@redhat.com
