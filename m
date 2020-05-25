From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: block I/O accounting improvements
Date: Mon, 25 May 2020 15:34:21 +0300
Message-ID: <81f4057b-124a-d0e7-94af-15a198d48d50@yandex-team.ru>
References: <20200525113014.345997-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200525113014.345997-1-hch@lst.de>
Content-Language: en-CA
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 25/05/2020 14.29, Christoph Hellwig wrote:
> Hi Jens,
> 
> they series contains various improvement for block I/O accounting.  The
> first bunch of patches switch the bio based drivers to better accounting
> helpers compared to the current mess.  The end contains a fix and various
> performanc improvements.  Most of this comes from a series Konstantin
> sent a few weeks ago, rebased on changes that landed in your tree since
> and my change to always use the percpu version of the disk stats.
> 

Thanks for picking this up.

One note about possible further improvement in reply to first patch.

Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
