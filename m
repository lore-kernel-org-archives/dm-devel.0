From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm log: fix create_log_context() to use proper
	logical_block_size
Date: Wed, 17 Jun 2009 12:29:33 -0400
Message-ID: <20090617162933.GD638@redhat.com>
References: <1245255712-5320-1-git-send-email-snitzer@redhat.com>
	<yq14oueq11o.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq14oueq11o.fsf@sermon.lab.mkp.net>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Jun 17 2009 at 12:26pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> create_log_context() must use the logical_block_size from the log
> Mike> disk rather than the target's logical_block_size.
> 
> Mike>  		buf_size = dm_round_up((LOG_OFFSET << SECTOR_SHIFT) +
> Mike>  				       bitset_size,
> Mike> - ti->limits.logical_block_size);
> Mike> + q->limits.logical_block_size);
>  
> Please use the accessor functions when possible.
> 
> bdev_logical_block_size(lc->header_location.bdev) to the rescue....

Ah right, thanks for the reminder!

v2 of the patch to follow...

Mike
