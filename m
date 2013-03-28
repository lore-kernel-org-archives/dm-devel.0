From: Tejun Heo <tj@kernel.org>
Subject: Re: dm-crypt performance
Date: Thu, 28 Mar 2013 12:44:43 -0700
Message-ID: <20130328194443.GG14088@htj.dyndns.org>
References: <Pine.LNX.4.64.1303252051520.9745@file.rdu.redhat.com>
 <20130326122713.GC27610@agk-dp.fab.redhat.com>
 <5151FF82.6090405@gmail.com>
 <20130326202837.GA5599@redhat.com>
 <20130328185327.GF14088@htj.dyndns.org>
 <20130328193343.GA15969@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130328193343.GA15969@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>, dm-crypt@saout.de, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Christian Schmidt <schmidt@digadd.de>, Jens Axboe <axboe@kernel.dk>
List-Id: dm-devel.ids

Hello,

On Thu, Mar 28, 2013 at 03:33:43PM -0400, Vivek Goyal wrote:
> I am curious why out of order bio is a problem. Doesn't the elevator
> already merge bio's with existing requests and if merging does not
> happen then requests are sorted in order. So why ordering is not
> happening properly with dm-crypt. What additional info dm-crypt has
> that it can do better ordering than IO scheduler.

Hmmm... well, for one, it doesn't only change ordering.  It also
changes the timings.  Before iosched would get contiguous stream of
IOs when the queue gets unplugged (BTW, how does dm crypt handling
plugging?  If not handled properly, it could definitely affect a lot
of things.)  With multiple threads doing encryption in the middle, the
iosched could get scattered IOs which could easily span multiple
millisecs.  Even if context tagging was done properly, it could easily
lead to much less efficient IO patterns to hardware.

Keeping IO order combined with proper plug handling would not only
keep the ordering constant but also the relative timing of events,
which is an important factor when scheduling IOs.

> CFQ might seeing more performance hit because we maintain per
> process queues and kernel threads might not be sharing the IO context
> (i am not sure). So if all the crypto threads can share the IO
> context, atleast it will make sure all IO from them goes into a
> single queue.

Right, this is important too although I fail to see how workqueue
vs. custom dispatch would make any difference here.  dm-crypt should
definitely be using bio_associate_current().

Thanks.

-- 
tejun
