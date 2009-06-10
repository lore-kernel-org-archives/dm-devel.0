From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm: add topology support
Date: Wed, 10 Jun 2009 10:00:29 -0400
Message-ID: <20090610140028.GD25088@redhat.com>
References: <1244524492-2292-1-git-send-email-snitzer@redhat.com>
	<yq1ski860ok.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1ski860ok.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

On Wed, Jun 10 2009 at  2:51am -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> Use blk_stack_limits() to stack block limits (including topology)
> Mike> rather than duplicate the equivalent within Device Mapper.
> 
> Great!  So how are the userland bits coming along?

They should be pretty well sorted out with the patches I posted to
lvm-devel early Monday morning (code review still needed):
https://www.redhat.com/archives/lvm-devel/2009-June/msg00037.html

As for the DM changes.  Alasdair reviewed v2 of the patch and found an
issue that I need to get a final answer to.

Your change to dm-table.c:dm_table_set_restrictions() in linux-2.6-block
+for-next's ae03bf639a5027d27270123f5f6e3ee6a412781d introduced calls to
blk_queue_*() setters.

My v2 of the DM topology support patch does away with those and just
uses blk_stack_limits().  In the process we go back to _not_ using the
blk_queue_*() setters (note the additional checks that those setters
have).

So the question: is _not_ using the blk_queue_*() setters perfectly
fine?  Given that DM has always _not_ used them the quick answer is
"seems fine".

But I need to dig a bit more to understand if the additional logic in
the blk_queue_*() setters is something DM shouldn't be circumventing.

But we're almost done with these DM/LVM2 topology bits.. really :)

Mike
