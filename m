From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Date: Wed, 13 Apr 2011 19:35:29 +0200
Message-ID: <4DA5DEE1.9070803@fusionio.com>
References: <20110411223623.4278fad1@notabene.brown> <4DA2F8AD.1060605@fusionio.com> <20110412011255.GA29236@infradead.org> <4DA40F0E.1070903@fusionio.com> <20110412122248.GC31057@dastard> <4DA4456F.3070301@fusionio.com> <20110412124134.GD31057@dastard> <4DA44C86.3090305@fusionio.com> <20110412133117.GE31057@dastard> <4DA45790.2010109@fusionio.com> <20110412143452.GH31057@dastard> <20110413070827.11b2a71d@notabene.brown> <BANLkTikBEJa7bJJoLFU7NoiEgOjVHVG08A@mail.gmail.com> <1302693122.2035.20.camel@laptop> <4DA587AF.2040308@fusionio.com> <BANLkTimTGGJjXGX96LqP0YL4dcdGONFyhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTimTGGJjXGX96LqP0YL4dcdGONFyhA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, NeilBrown <neilb@suse.de>, Dave Chinner <david@fromorbit.com>, "hch@infradead.org" <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On 2011-04-13 17:13, Linus Torvalds wrote:
> On Wed, Apr 13, 2011 at 4:23 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>> Linus, I've got a few other things queued up in the area, I'll add this
>> and send them off soon. Or feel free to add this one yourself, since you
>> already did it.
> 
> Ok, I committed it with Peter's and your acks.

Great, thanks.

> And if you already put it in your git tree too, git will merge it.

I did not, I had a feeling you'd merge this one.

-- 
Jens Axboe
