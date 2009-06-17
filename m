From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] dm log: fix create_log_context() to use proper
	logical_block_size
Date: Wed, 17 Jun 2009 12:26:27 -0400
Message-ID: <yq14oueq11o.fsf@sermon.lab.mkp.net>
References: <1245255712-5320-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1245255712-5320-1-git-send-email-snitzer@redhat.com> (Mike
	Snitzer's message of "Wed, 17 Jun 2009 12:21:52 -0400")
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
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> create_log_context() must use the logical_block_size from the log
Mike> disk rather than the target's logical_block_size.

Mike>  		buf_size = dm_round_up((LOG_OFFSET << SECTOR_SHIFT) +
Mike>  				       bitset_size,
Mike> - ti->limits.logical_block_size);
Mike> + q->limits.logical_block_size);
 
Please use the accessor functions when possible.

bdev_logical_block_size(lc->header_location.bdev) to the rescue....

-- 
Martin K. Petersen	Oracle Linux Engineering
