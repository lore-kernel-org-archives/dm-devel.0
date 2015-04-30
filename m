From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: fix blk-mq request-based DM queue initialization
Date: Wed, 29 Apr 2015 21:41:52 -0400
Message-ID: <20150430014152.GA26430@redhat.com>
References: <20150425092358.GA15550@infradead.org>
	<1430269153-647-1-git-send-email-snitzer@redhat.com>
	<20150429130037.GA3017@lst.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150429130037.GA3017@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Apr 29 2015 at  9:00am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> On Tue, Apr 28, 2015 at 08:59:13PM -0400, Mike Snitzer wrote:
> > Commit bfebd1cdb4 ("dm: add full blk-mq support to request-based DM")
> > didn't properly account for the need to short-circuit re-initializing
> > DM's blk-mq request_queue if it was already initialized.
> > 
> > Fix dm_init_request_based_blk_mq_queue() to return early if the
> > mapped_device's tag_set already has its driver_data set to the
> > mapped_device pointer.
> 
> I'm not quite up to speed with this area of code, but shouldn't
> we always tear the queue fully down before trying to reinitialize it?

No, the same request_queue should be used for the lifetime of a DM
device.

I'm not interested in reinitializing the queue.  A DM table reload has
no need to destroy and recreate the request_queue associated with 
the DM device.  It would be bad to do so too because we actually use the
queue across table reloads in the case of dm-multipath with no paths
(see: map_request's handling of DM_MAPIO_REQUEUE which triggers
dm_requeue_request).
