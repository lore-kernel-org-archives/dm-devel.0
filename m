From: Guilherme Piccoli <gpiccoli@canonical.com>
Subject: Re: [PATCH V2 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
Date: Tue, 21 May 2019 14:37:36 -0300
Message-ID: <CAHD1Q_zgBxE-nD6zY4koJGJC9K53+6d6-xGpEpA6W4sudu0Pgg@mail.gmail.com>
References: <20190520220911.25192-1-gpiccoli@canonical.com>
 <20190520220911.25192-2-gpiccoli@canonical.com> <20190521125634.GB16799@infradead.org>
 <CAHD1Q_z23AO+NRid1xYTeke_5GAe6hPianEZKBf5P30FrfZGFg@mail.gmail.com> <20190521172258.GA32702@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190521172258.GA32702@infradead.org>
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com, axboe@kernel.dk, Gavin Guo <gavin.guo@canonical.com>, Jay Vosburgh <jay.vosburgh@canonical.com>, "Guilherme G. Piccoli" <kernel@gpiccoli.net>, Ming Lei <ming.lei@redhat.com>, Song Liu <liu.song.a23@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, stable@vger.kernel.org
List-Id: dm-devel.ids

On Tue, May 21, 2019 at 2:23 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, May 21, 2019 at 11:10:05AM -0300, Guilherme Piccoli wrote:
> > Hi Christoph, thanks for looking into this.
> > You're right, this series fixes both issues. The problem I see though
> > is that it relies
> > on legacy IO path removal - for v5.0 and beyond, all fine. But
> > backporting that to
> > v4.17-v4.20 stable series will be quite painful.
> >
> > My fixes are mostly "oneliners". If we could get both approaches upstream,
> > that'd be perfect!
>
> But they basically just fix code that otherwise gets removed.  And the way
> this patches uses the ENTERED flag from the md code looks slightly
> sketchy to me.  Maybe we want them as stable only patches.

OK, it makes sense to me, if that is a possibility. The fist one is
clearly a small
and non-intrusive fix. The 2nd indeed is more invasive heh

Please let me know how to proceed to have that added at least in stable trees;
this would help a lot the distro side of the world hehe

Cheers,


Guilherme
