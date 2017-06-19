From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/10] pktcdvd: remove the call to
	blk_queue_bounce
Date: Mon, 19 Jun 2017 17:18:41 +0200
Message-ID: <20170619151841.GA12068@lst.de>
References: <20170619072628.12894-1-hch@lst.de>
	<20170619072628.12894-2-hch@lst.de>
	<CACVXFVMxgKk1kzL=rgAzdw8X5qgWn8Z_Hv-gUHSKfp1rXRArxA@mail.gmail.com>
	<20170619150022.GA10165@lst.de>
	<CACVXFVOZMwTdeeUdHzLzNpnPurAHz9VaQNH+yW=XSgRjPN2=Mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CACVXFVOZMwTdeeUdHzLzNpnPurAHz9VaQNH+yW=XSgRjPN2=Mw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Mon, Jun 19, 2017 at 11:13:46PM +0800, Ming Lei wrote:
> On Mon, Jun 19, 2017 at 11:00 PM, Christoph Hellwig <hch@lst.de> wrote:
> > On Mon, Jun 19, 2017 at 10:34:36PM +0800, Ming Lei wrote:
> >> blk_queue_make_request() sets bounce for any highmem page for long time,
> >> and in theory this patch might cause regression on 32bit arch, when
> >> the controller can't handle higmem page really(especially in case of PAE), so
> >> we may need to be careful about this change, especially on some old hardware.
> >
> > Which controller?
> 
> I don't know.
> 
> IMO, we can't just remove it because it is a bio based driver, the
> bounce is not related with
> a bio or req based driver, and it depends if the controller can handle
> highmem page.

pktcdvd is a stacking driver and forwards all data through either
generic_make_request or blk_rq_map_kern + blk_execute_rq,
both of which call blk_queue_bounce internally.
