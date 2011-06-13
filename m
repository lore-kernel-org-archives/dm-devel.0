From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/2] dm-kcopyd: introduce per-module throttle
 structure
Date: Mon, 13 Jun 2011 17:06:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1106131632230.837@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1105311802330.9322@hs20-bc2-1.build.redhat.com>
	<20110601095106.GA3718@ubuntu>
	<Pine.LNX.4.64.1106021536240.31532@hs20-bc2-1.build.redhat.com>
	<20110603110111.GA4969@ubuntu>
	<Pine.LNX.4.64.1106071321300.8279@hs20-bc2-1.build.redhat.com>
	<20110609094746.GA3152@ubuntu>
	<Pine.LNX.4.64.1106091136510.7642@hs20-bc2-1.build.redhat.com>
	<20110610084424.GA3672@ubuntu>
	<Pine.LNX.4.64.1106100858280.32120@hs20-bc2-1.build.redhat.com>
	<20110613091716.GC4580@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110613091716.GC4580@ubuntu>
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



On Mon, 13 Jun 2011, Joe Thornber wrote:

> On Sat, Jun 11, 2011 at 04:27:02PM -0400, Mikulas Patocka wrote:
> > It is much easier to explain to the users "if you set X value in 
> > /sys/module/dm_mirror/parameters/raid1_resync_throttle, then the copying 
> > will be done in X% of time, leaving the disk idle 100-X% of time", then to 
> > invent some magic mechanisms that change multiple things based on X and 
> > other conditions.
> 
> Yes, that is very easy to explain to the users.  This sort of
> description is what I was after when I kept asking you to tell me how
> to set it.
> 
> It's not clear to me that setting the throttle to 80% will copy at 80%
> of the speed, or leave the disk idle for 20% of the time.  Perhaps you
> have some benchmarks to back this up?  (with different memory pressure
> situations please).

See below. It is not exatly linear, but it is approximately linear well 
enough.

> Restricting the cpu available to issue io is not a great way to
> throttle io.  There will be plenty of situations where 20% of the cpu
> is enough to swamp the devices.
>
> - Joe

You misunderstand the patch. The patch doesn't restrict cpu time. The 
patch measures global time and time when one or more i/os was in flight 
(it doesn't count the number of i/os in flight). Every second, both these 
variables are divided by 2 (to provide some decay). The proportion of 
these two variables is the percentage of actual disk activity. When this 
proportion is greater than the percentage set by the user, we sleep.



Resync speed is this:

throttle | resync speed MB/s
100%	75
90%	66
80%	60
70%	49
60%	44
50%	33
40%	25
30%	17
20%	10
10%	5
0%	0.26

If I simulate memory pressure (i.e. don't allow allocations and process 
just one sub job), the speed is this:

100%	70
90%	62
80%	55
70%	47
60%	37
50%	29
40%	25
30%	16
20%	9
10%	2
0%	0.12

Mikulas
