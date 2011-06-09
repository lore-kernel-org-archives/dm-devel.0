From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH 1/2] dm-kcopyd: introduce per-module throttle
 structure
Date: Thu, 9 Jun 2011 10:47:47 +0100
Message-ID: <20110609094746.GA3152@ubuntu>
References: <Pine.LNX.4.64.1105311802330.9322@hs20-bc2-1.build.redhat.com>
	<20110601095106.GA3718@ubuntu>
	<Pine.LNX.4.64.1106021536240.31532@hs20-bc2-1.build.redhat.com>
	<20110603110111.GA4969@ubuntu>
	<Pine.LNX.4.64.1106071321300.8279@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1106071321300.8279@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Mikulas,

On Tue, Jun 07, 2011 at 01:50:16PM -0400, Mikulas Patocka wrote:
> I did some tests. I did some random and sequential I/O on the same disk 
> while mirror was resynchronizing. The result is this:
> 
> random read:
> mirror throttle / IOs per second
> 100%	94
> 75%	113
> 50%	127
> 25%	145
> idle	160
> 
> sequential read:
> mirror throttle / throughput MB/s
> 100%	104
> 75%	118
> 50%	122
> 25%	127
> idle	134

This is nice to see, thanks for providing it.  I'm still uneasy about
this throttling being time based though.

What we're trying to do is avoid kcopyd issuing so much io that it
interferes with userland io.

Now you've already posted some nice patches that remove the fixed
sized buffers in kcopyd clients, instead grabbing extra memory if it's
available, otherwise making do with a tiny preallocated buffer to
ensure progress.  So as I see it, the amount of io that kcopyd submits
is dependent on the amount of memory available.

i) If there is lots of memory available can your throttling patch
still manage to issue too much io in the time that kcopyd is active?

ii) If there is little memory available few ios will be issued.  But
your throttling will still occur, slowing things down even more.

I think it makes much more sense to throttle based on amount of io
issued by kcopyd.  Either tracking throughput, or even just putting a
limit on the amount of io that can be in flight at any one time.

- Joe
