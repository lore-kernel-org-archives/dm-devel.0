From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm: Fix alignment stacking on partitioned
	devices
Date: Wed, 23 Dec 2009 14:21:40 -0500
Message-ID: <20091223192139.GA29535@redhat.com>
References: <1261591640-24380-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1261591640-24380-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On Wed, Dec 23 2009 at  1:07pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> From: Martin K. Petersen <martin.petersen@oracle.com> 
> 
> The DM device limits function passes the start offset within the block
> device to the block layer stacking function.  The stacking function
> expects the provided start offset to be relative to start of the disk
> (request_queue).  Until now DM was passing a start offset that was
> relative to beginning of the partition (block_device), resulting in
> incorrect alignment stacking.
> 
> Add the partition offset to the values passed to blk_stack_limits().
> 
> Also clarify, in the DMWARN message, that the device which caused
> blk_stack_limits() to return failure isn't necessarily misaligned
> itself.  It caused the top-level (DM) device to have inconsistent
> alignment when taken in combination with all previously stacked
> device(s).

Alasdair,

This should be pushed as a fix for 2.6.33.  It should probably go to
stable (2.6.31.y and 2.6.32.y) too.

Mike
