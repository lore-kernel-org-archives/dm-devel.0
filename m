From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2 2/2] md/raid0: Do not bypass blocking queue entered
 for raid0 bios
Date: Tue, 21 May 2019 05:56:34 -0700
Message-ID: <20190521125634.GB16799@infradead.org>
References: <20190520220911.25192-1-gpiccoli@canonical.com>
 <20190520220911.25192-2-gpiccoli@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190520220911.25192-2-gpiccoli@canonical.com>
Sender: stable-owner@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, gavin.guo@canonical.com, jay.vosburgh@canonical.com, kernel@gpiccoli.net, Ming Lei <ming.lei@redhat.com>, Song Liu <liu.song.a23@gmail.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, stable@vger.kernel.org
List-Id: dm-devel.ids

On Mon, May 20, 2019 at 07:09:11PM -0300, Guilherme G. Piccoli wrote:
> No changes from V1, only rebased to v5.2-rc1.
> Also, notice that if [1] gets merged before this patch, the
> BIO_QUEUE_ENTERED flag will change to BIO_SPLITTED, so the (easy) conflict
> will need to be worked.
> 
> [1] https://lore.kernel.org/linux-block/20190515030310.20393-4-ming.lei@redhat.com/

Actually - that series should also fix you problem and avoid the need
for both patches in this series.  Can you please test it?
