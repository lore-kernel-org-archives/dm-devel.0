From: Christoph Hellwig <hch@lst.de>
Subject: Re: dm: fix blk-mq request-based DM queue initialization
Date: Thu, 30 Apr 2015 09:22:00 +0200
Message-ID: <20150430072200.GB15819@lst.de>
References: <20150425092358.GA15550@infradead.org>
	<1430269153-647-1-git-send-email-snitzer@redhat.com>
	<20150429130037.GA3017@lst.de> <20150430014152.GA26430@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150430014152.GA26430@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Wed, Apr 29, 2015 at 09:41:52PM -0400, Mike Snitzer wrote:
> > I'm not quite up to speed with this area of code, but shouldn't
> > we always tear the queue fully down before trying to reinitialize it?
> 
> No, the same request_queue should be used for the lifetime of a DM
> device.
> 
> I'm not interested in reinitializing the queue.  A DM table reload has
> no need to destroy and recreate the request_queue associated with 
> the DM device.  It would be bad to do so too because we actually use the
> queue across table reloads in the case of dm-multipath with no paths
> (see: map_request's handling of DM_MAPIO_REQUEUE which triggers
> dm_requeue_request).

Well - we're obviously trying to reinitialize it here and only error
out very low level with your patch.  What I mean is that we shouldn't
even try to reinitialize it at a much higher level, so we don't need
this blk-mq specific hack down here.
