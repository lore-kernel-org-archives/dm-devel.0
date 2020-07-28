From: Jens Axboe <axboe@kernel.dk>
Subject: Re: bdi cleanups v3
Date: Tue, 28 Jul 2020 09:41:28 -0600
Message-ID: <0b2b59d4-da4c-33df-82b4-0d4935b91e6e@kernel.dk>
References: <20200724073313.138789-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200724073313.138789-1-hch@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org
List-Id: dm-devel.ids

On 7/24/20 1:32 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series contains a bunch of different BDI cleanups.  The biggest item
> is to isolate block drivers from the BDI in preparation of changing the
> lifetime of the block device BDI in a follow up series.

Applied, thanks.

-- 
Jens Axboe
