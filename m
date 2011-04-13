From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Date: Wed, 13 Apr 2011 13:41:06 +0200
Message-ID: <1302694866.2035.22.camel@laptop>
References: <20110411223623.4278fad1@notabene.brown>
	 <4DA2F8AD.1060605@fusionio.com> <20110412011255.GA29236@infradead.org>
	 <4DA40F0E.1070903@fusionio.com> <20110412122248.GC31057@dastard>
	 <4DA4456F.3070301@fusionio.com> <20110412124134.GD31057@dastard>
	 <4DA44C86.3090305@fusionio.com> <20110412133117.GE31057@dastard>
	 <4DA45790.2010109@fusionio.com> <20110412143452.GH31057@dastard>
	 <20110413070827.11b2a71d@notabene.brown>
	 <BANLkTikBEJa7bJJoLFU7NoiEgOjVHVG08A@mail.gmail.com>
	 <1302693122.2035.20.camel@laptop>  <4DA587AF.2040308@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DA587AF.2040308@fusionio.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, NeilBrown <neilb@suse.de>, Dave Chinner <david@fromorbit.com>, "hch@infradead.org" <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Wed, 2011-04-13 at 13:23 +0200, Jens Axboe wrote:
> We definitely only want to do it on going to sleep, not preempt events.
> So if you are fine with this change, then lets please do that.

Here's the Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>, that goes
with it ;-)

> Linus, I've got a few other things queued up in the area, I'll add this
> and send them off soon. Or feel free to add this one yourself, since you
> already did it. 

Right, please send it onwards or have Linus commit it himself and I'll
cook up a patch clarifying the rq->lock'ing mess around there.
