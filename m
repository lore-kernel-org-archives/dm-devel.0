From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2 2/2] md/raid0: Do not bypass blocking queue entered
 for raid0 bios
Date: Tue, 21 May 2019 10:22:58 -0700
Message-ID: <20190521172258.GA32702@infradead.org>
References: <20190520220911.25192-1-gpiccoli@canonical.com>
 <20190520220911.25192-2-gpiccoli@canonical.com>
 <20190521125634.GB16799@infradead.org>
 <CAHD1Q_z23AO+NRid1xYTeke_5GAe6hPianEZKBf5P30FrfZGFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHD1Q_z23AO+NRid1xYTeke_5GAe6hPianEZKBf5P30FrfZGFg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Guilherme Piccoli <gpiccoli@canonical.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com, axboe@kernel.dk, Gavin Guo <gavin.guo@canonical.com>, Jay Vosburgh <jay.vosburgh@canonical.com>, "Guilherme G. Piccoli" <kernel@gpiccoli.net>, Ming Lei <ming.lei@redhat.com>, Song Liu <liu.song.a23@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, stable@vger.kernel.org
List-Id: dm-devel.ids

On Tue, May 21, 2019 at 11:10:05AM -0300, Guilherme Piccoli wrote:
> Hi Christoph, thanks for looking into this.
> You're right, this series fixes both issues. The problem I see though
> is that it relies
> on legacy IO path removal - for v5.0 and beyond, all fine. But
> backporting that to
> v4.17-v4.20 stable series will be quite painful.
> 
> My fixes are mostly "oneliners". If we could get both approaches upstream,
> that'd be perfect!

But they basically just fix code that otherwise gets removed.  And the way
this patches uses the ENTERED flag from the md code looks slightly
sketchy to me.  Maybe we want them as stable only patches.
