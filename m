From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/7 v2] blk-mq: add
 blk_mq_init_allocated_queue and export blk_mq_register_disk
Date: Thu, 12 Mar 2015 13:14:39 -0400
Message-ID: <5501C97F.3060004@suse.de>
References: <1426132602-34331-1-git-send-email-snitzer@redhat.com>	<1426132602-34331-3-git-send-email-snitzer@redhat.com>
	<20150312142921.GB3159@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150312142921.GB3159@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 03/12/2015 10:29 AM, Mike Snitzer wrote:
> Add a variant of blk_mq_init_queue that allows a previously allocated
> queue to be initialized.  blk_mq_init_allocated_queue models
> blk_init_allocated_queue -- which was also created for DM's use.
> =

> DM's approach to device creation requires a placeholder request_queue be
> allocated for use with alloc_dev() but the decision about what type of
> request_queue will be ultimately created is deferred until all component
> devices referenced in the DM table are processed to determine the table
> type (request-based, blk-mq request-based, or bio-based).
> =

> Also, because of DM's late finalization of the request_queue type
> the call to blk_mq_register_disk() doesn't happen during alloc_dev().
> Must export blk_mq_register_disk() so that DM can backfill the 'mq' dir
> once the blk-mq queue is fully allocated.
> =

> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Reviewed-by: Ming Lei <ming.lei@canonical.com>

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
