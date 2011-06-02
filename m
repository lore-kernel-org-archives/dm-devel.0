From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/2] dm-kcopyd: introduce per-module throttle
 structure
Date: Thu, 2 Jun 2011 15:55:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1106021536240.31532@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1105311802330.9322@hs20-bc2-1.build.redhat.com>
	<20110601095106.GA3718@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110601095106.GA3718@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Wed, 1 Jun 2011, Joe Thornber wrote:

> On Tue, May 31, 2011 at 06:03:39PM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > Here I'm sending new kcopyd throttling patches that allow the throttle to 
> > be set per module (i.e. one throttle for mirror and the other for 
> > snapshots).
> 
> I'm sorry Mikulas, but these patches still really worry me.
> 
> i) Your throttling is time based, rather than throughput.

It is impossible to determine what throughput the underlying device has.

> ii) No account is taken of the source and destination devices.  If I
> have an idle mirror, I would like the resyncing of a new leg to go at
> 100% speed.  Other mirrors in the system may be under load so should
> resync in a more sympathetic manner.  Should we be using the
> congestion functions to see if the source or destination are too busy?

You don't know how much I/O is there on the underlying device.

If you want this kind of control, ask the people who develop the I/O 
scheduler.

> iii) calling msleep in kernel code really makes me shudder, especially
> when you call it with a fixed, small duration and then loop.  Can't
> you work out how long you should sleep for?

I tried to sleep shorter time more often, but it didn't work. If you sleep 
10 times for 10ms, it doesn't limit disk throughput much as if you sleep 
once for 100ms. I don't know why, but smaller sleeps don't work (a 
possible reason could be readahead/writeback cache in the disk, but if I 
disabled it setting WCE=0, RCD=1, smaller sleeps still didn't limit).

> Why not defer the worker
> thread until this time? (i.e. use queue_delayed_work()).

Because msleep is simpler.

> iv) you haven't explained how the sys admin works out the correct
> throttle value.

There is no "correct" value. The "correct" value depends on how important 
is copying itself v.s. other i/o.

> If we write this down then maybe we can think about automating it.

In theory (if disk scheduler were perfect), we wouldn't need any 
throttling. The disk scheduler should recognize that the kcopyd process is 
sending way more requests than any other process and should lower the 
i/o priority of kcopyd process.

In practice, the disk scheduler doesn't do it well, so kcopyd hurts the 
users. If you want an automated fix, fix the disk scheduler. But don't put 
disk scheduler logic into device mapper --- it dosn't belong there.

Mikulas

> - Joe
