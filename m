From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] block: silently error unsupported empty
	barriers too
Date: Thu, 6 Aug 2009 08:22:21 -0400
Message-ID: <20090806122221.GA5175@infradead.org>
References: <1249557257.3721.55.camel@blaa>
	<20090806114550.GL29899@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090806114550.GL29899@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mark McLoughlin <markmc@redhat.com>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Rusty Russell <rusty@rustcorp.com.au>, linux-kernel <linux-ke>
List-Id: dm-devel.ids

On Thu, Aug 06, 2009 at 12:45:50PM +0100, Alasdair G Kergon wrote:
> On Thu, Aug 06, 2009 at 12:14:17PM +0100, Mark McLoughlin wrote:
> > We should error all barriers, even empty barriers, on devices like
> > virtio_blk which don't support them.
>  
> Have you considered whether or not virtio_blk actually needs to
> support empty barriers?

virtio_blk on kvm does not support any barriers at all, similar to many
other drivers out there.  If the queue flags say we don't support
barriers higher layers should not submit any barrier requests.
