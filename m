From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/2] dm-kcopyd: introduce per-module throttle
 structure
Date: Thu, 9 Jun 2011 12:08:08 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1106091136510.7642@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1105311802330.9322@hs20-bc2-1.build.redhat.com>
	<20110601095106.GA3718@ubuntu>
	<Pine.LNX.4.64.1106021536240.31532@hs20-bc2-1.build.redhat.com>
	<20110603110111.GA4969@ubuntu>
	<Pine.LNX.4.64.1106071321300.8279@hs20-bc2-1.build.redhat.com>
	<20110609094746.GA3152@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110609094746.GA3152@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Thu, 9 Jun 2011, Joe Thornber wrote:

> Mikulas,
> 
> On Tue, Jun 07, 2011 at 01:50:16PM -0400, Mikulas Patocka wrote:
> > I did some tests. I did some random and sequential I/O on the same disk 
> > while mirror was resynchronizing. The result is this:
> > 
> > random read:
> > mirror throttle / IOs per second
> > 100%	94
> > 75%	113
> > 50%	127
> > 25%	145
> > idle	160
> > 
> > sequential read:
> > mirror throttle / throughput MB/s
> > 100%	104
> > 75%	118
> > 50%	122
> > 25%	127
> > idle	134
> 
> This is nice to see, thanks for providing it.  I'm still uneasy about
> this throttling being time based though.
> 
> What we're trying to do is avoid kcopyd issuing so much io that it
> interferes with userland io.

But you don't know if there is some userland IO or not to the same disk.

> Now you've already posted some nice patches that remove the fixed
> sized buffers in kcopyd clients, instead grabbing extra memory if it's
> available, otherwise making do with a tiny preallocated buffer to
> ensure progress.  So as I see it, the amount of io that kcopyd submits
> is dependent on the amount of memory available.
> 
> i) If there is lots of memory available can your throttling patch
> still manage to issue too much io in the time that kcopyd is active?

It issues as much IO as it can in the active period.

> ii) If there is little memory available few ios will be issued.  But
> your throttling will still occur, slowing things down even more.

Yes. Memory pressure and throttiling are independent things.

> I think it makes much more sense to throttle based on amount of io
> issued by kcopyd.  Either tracking throughput,

You don't know what is the throughput of the device. So throttling to 
something like "50% throughput" can't be done.

Measuring device throughput is unreliable. For example, if there is 
concurrent IO to the same device, your observed throughput is lower than 
the actual device throughput. But you never know that there is a 
concurrent IO, so you can't find that the measuring is skewed.

Also, throughput depends on the disk region you are accessing --- the same 
disk has higher throughput in the beginning than in the end.

Also, one dm-raid leg can span multiple disks, and they can have different 
throughput.

You can't reliably determine the device throughput, so you can't reliably 
throttle based throughput.

> or even just putting a
> limit on the amount of io that can be in flight at any one time.

Which is much less reliable throttling than time slots.
the resync spee is:
8 sub jobs --- 76MB/s
2 sub jobs --- 74MB/s
1 sub job --- 65MB/s

> - Joe

Mikulas
