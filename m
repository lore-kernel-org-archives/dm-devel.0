From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH v2] dm: add topology support
Date: Thu, 11 Jun 2009 00:08:04 +0100
Message-ID: <20090610230804.GR647@agk-dp.fab.redhat.com>
References: <1244524492-2292-1-git-send-email-snitzer@redhat.com>
	<yq1ski860ok.fsf@sermon.lab.mkp.net>
	<20090610140028.GD25088@redhat.com>
	<yq1ocsw55t6.fsf@sermon.lab.mkp.net>
	<20090610211235.GF25088@redhat.com>
	<yq1k53j68wj.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1k53j68wj.fsf@sermon.lab.mkp.net>
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
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

On Wed, Jun 10, 2009 at 06:06:36PM -0400, Martin K. Petersen wrote:
> The default limits should all be set by the block layer when setting up
> the request queue.  So my reason for inquiring was to figure out whether
> check_for_valid_limits() actually makes any difference?
 
I renamed that badly-named function earlier to:
  init_valid_queue_limits()

It should also really be shared with block/.

What's going on is that LVM prepares the new tables it wants to
build up a device stack in advance, then if everything has worked,
makes them all go live.

The validation has to happen during the first phase - backing out
the change to the device stack upon a failure is easier then as
we have not yet reached the commit point of the transaction.
The operation making the new stack live if at all possible must not
fail, because that comes within the commit logic and would make recovery
much trickier.

In dm terms, this means we have two tables - called 'live' and
'inactive'.  The first phase sets up inactive tables on all the stacked
devices involved in the transaction and that is when all the memory
needed is allocated and the validation occurs.  The second phase then
makes the inactive table live and discards the previously-live table.
The two tables are independent: the old queue limits on the dm device
are discarded and replaced by the newly-calculated ones.

Currently those limits are calculated in phase one, but we should see
about delaying this limit combination code (which should alway succeed)
until phase two (which gives userspace code more freedom in its use of
the interface).

Alasdair
