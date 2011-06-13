From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH 1/2] dm-kcopyd: introduce per-module throttle
 structure
Date: Mon, 13 Jun 2011 10:17:16 +0100
Message-ID: <20110613091716.GC4580@ubuntu>
References: <Pine.LNX.4.64.1105311802330.9322@hs20-bc2-1.build.redhat.com>
	<20110601095106.GA3718@ubuntu>
	<Pine.LNX.4.64.1106021536240.31532@hs20-bc2-1.build.redhat.com>
	<20110603110111.GA4969@ubuntu>
	<Pine.LNX.4.64.1106071321300.8279@hs20-bc2-1.build.redhat.com>
	<20110609094746.GA3152@ubuntu>
	<Pine.LNX.4.64.1106091136510.7642@hs20-bc2-1.build.redhat.com>
	<20110610084424.GA3672@ubuntu>
	<Pine.LNX.4.64.1106100858280.32120@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1106100858280.32120@hs20-bc2-1.build.redhat.com>
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

On Sat, Jun 11, 2011 at 04:27:02PM -0400, Mikulas Patocka wrote:
> It is much easier to explain to the users "if you set X value in 
> /sys/module/dm_mirror/parameters/raid1_resync_throttle, then the copying 
> will be done in X% of time, leaving the disk idle 100-X% of time", then to 
> invent some magic mechanisms that change multiple things based on X and 
> other conditions.

Yes, that is very easy to explain to the users.  This sort of
description is what I was after when I kept asking you to tell me how
to set it.

It's not clear to me that setting the throttle to 80% will copy at 80%
of the speed, or leave the disk idle for 20% of the time.  Perhaps you
have some benchmarks to back this up?  (with different memory pressure
situations please).

Restricting the cpu available to issue io is not a great way to
throttle io.  There will be plenty of situations where 20% of the cpu
is enough to swamp the devices.

- Joe
