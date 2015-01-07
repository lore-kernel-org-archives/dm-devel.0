From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: blk-mq request allocation stalls [was: Re: [PATCH v3
 0/8] dm: add request-based blk-mq support]
Date: Wed, 7 Jan 2015 15:09:28 -0500
Message-ID: <20150107200928.GA18284@redhat.com>
References: <54ABAB80.70006@acm.org> <20150106160553.GB10224@redhat.com>
	<54AC0A39.90801@kernel.dk> <54AD0B63.3010505@acm.org>
	<54AD517E.40002@kernel.dk> <20150107161504.GA16911@redhat.com>
	<20150107162203.GB16911@redhat.com> <54AD5DAC.7020303@kernel.dk>
	<20150107171857.GA21062@redhat.com> <54AD6E62.6040104@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <54AD6E62.6040104@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On Wed, Jan 07 2015 at 12:35pm -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 01/07/2015 10:18 AM, Mike Snitzer wrote:
> >
> >Looking closer, why not have blk_run_queue() (and blk_run_queue_async)
> >call blk_mq_start_stopped_hw_queues() if q->mq_ops?  As is
> >scsi_run_queue() open-codes it.
> >
> >Actually, that is likely the ultimate problem: blk_run_queue* aren't
> >trained for q->mq_ops.  As such DM would need to open code a call to
> >blk_mq_start_stopped_hw_queues.

Turns out that concern was bogus (as was the patch I shared),
request-based DM's request_queue isn't using blk-mq even if the
underlying devices are.

I'm not sure what is causing Bart's slow down; I cannot reproduce any
hang using a 100MB scsi_debug (ramdisk) device on the host that is
exported over virtio-blk into a guest that then layers a multipath
device on the blk-mq virtio-blk device.
 
> It's not completely parallel how SCSI uses it. blk_run_queue(), for
> legacy request_fn, does not start stopped queues. For the mq path,
> scsi-mq decided to do that. So if we embed
> blk_mq_start_stopped_hw_queues() in blk_run_queue*(), then we'd have
> different behavior between mq and non-mq. We could have
> blk_start_queue() do the right thing, but that would require
> different contexts between mq and non-mq, as non-mq requires that to
> be called with the queue lock held and ints disabled.

New wrappers could be introduced and drivers converted to use them but
best to just leave well enough alone.
