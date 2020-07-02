From: Song Liu <song@kernel.org>
Subject: Re: [PATCH 12/20] block: remove the request_queue argument from blk_queue_split
Date: Wed, 1 Jul 2020 23:14:30 -0700
Message-ID: <CAPhsuW5=055Eo-b3fjC_b-nJz-fg1FGwy_aqrNNtHm-U8vut-A@mail.gmail.com>
References: <20200701085947.3354405-1-hch@lst.de> <20200701085947.3354405-13-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20200701085947.3354405-13-hch@lst.de>
Sender: linux-bcache-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, open list <linux-kernel@vger.kernel.org>, linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org, linux-bcache@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Jul 1, 2020 at 2:02 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The queue can be trivially derived from the bio, so pass one less
> argument.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
[...]
>  drivers/md/md.c               |  2 +-

For md.c:
Acked-by: Song Liu <song@kernel.org>
