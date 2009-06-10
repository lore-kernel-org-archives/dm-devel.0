From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH v2] dm: add topology support
Date: Wed, 10 Jun 2009 15:36:24 +0100
Message-ID: <20090610143624.GP647@agk-dp.fab.redhat.com>
References: <1244524492-2292-1-git-send-email-snitzer@redhat.com>
	<yq1ski860ok.fsf@sermon.lab.mkp.net>
	<20090610140028.GD25088@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090610140028.GD25088@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

On Wed, Jun 10, 2009 at 10:00:29AM -0400, Mike Snitzer wrote:
> My v2 of the DM topology support patch does away with those and just
> uses blk_stack_limits().  In the process we go back to _not_ using the
> blk_queue_*() setters (note the additional checks that those setters
> have).
 
That was a secondary point, that could be cleared up by reviewing the
checks to ensure they all automatically hold so never need checking
at that point.

The main problem was that applying the combined limits for the table
previously - and correctly - paid no regard to the existing queue limits
on the dm device.  The new code seems to combine the limits between the
live and inactive tables, which is nonsense as in dm terms they are
totally independent.

Alasdair
