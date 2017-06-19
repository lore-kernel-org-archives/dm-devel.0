From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 01/10] pktcdvd: remove the call to blk_queue_bounce
Date: Mon, 19 Jun 2017 23:13:46 +0800
Message-ID: <CACVXFVOZMwTdeeUdHzLzNpnPurAHz9VaQNH+yW=XSgRjPN2=Mw@mail.gmail.com>
References: <20170619072628.12894-1-hch@lst.de> <20170619072628.12894-2-hch@lst.de>
 <CACVXFVMxgKk1kzL=rgAzdw8X5qgWn8Z_Hv-gUHSKfp1rXRArxA@mail.gmail.com> <20170619150022.GA10165@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170619150022.GA10165@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 19, 2017 at 11:00 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Jun 19, 2017 at 10:34:36PM +0800, Ming Lei wrote:
>> blk_queue_make_request() sets bounce for any highmem page for long time,
>> and in theory this patch might cause regression on 32bit arch, when
>> the controller can't handle higmem page really(especially in case of PAE), so
>> we may need to be careful about this change, especially on some old hardware.
>
> Which controller?

I don't know.

IMO, we can't just remove it because it is a bio based driver, the
bounce is not related with
a bio or req based driver, and it depends if the controller can handle
highmem page.

Actually the bounce for highmem is here from v2.6.12, and looks you
might need to
investigate why it is introduced from start before the removing, :-)



Thanks,
Ming Lei
