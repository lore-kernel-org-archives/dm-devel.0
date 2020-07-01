From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 10/20] dm: stop using ->queuedata
Date: Wed, 1 Jul 2020 13:24:48 -0400
Message-ID: <20200701172448.GA27528@redhat.com>
References: <20200701085947.3354405-1-hch@lst.de>
 <20200701085947.3354405-11-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200701085947.3354405-11-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-bcache@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-nvdimm@lists.01.org, linux-s390@vger.kernel.org, dm-devel@redhat.com, linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linuxppc-dev@lists.ozlabs.org, drbd-dev@lists.linbit.com
List-Id: dm-devel.ids

On Wed, Jul 01 2020 at  4:59am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Instead of setting up the queuedata as well just use one private data
> field.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Mike Snitzer <snitzer@redhat.com>
