From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: mirrored device with thousand of mappingtableentries
Date: Sun, 06 Mar 2011 21:39:32 +0100
Message-ID: <4D73F104.2050807@redhat.com>
References: <E04C10E329E0CD40816C9C17AE53BBD3018639C2@kit001.kaminario.local>	<20110228114801.GZ3626@agk-dp.fab.redhat.com>	<E04C10E329E0CD40816C9C17AE53BBD3018639CE@kit001.kaminario.local>	<20110228121149.GA3626@agk-dp.fab.redhat.com>	<E04C10E329E0CD40816C9C17AE53BBD3018639D7@kit001.kaminario.local>	<20110228131028.GB3626@agk-dp.fab.redhat.com>	<E04C10E329E0CD40816C9C17AE53BBD301863A00@kit001.kaminario.local>	<4D6BA566.1050305@redhat.com>
	<yq1oc5wp5i3.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <yq1oc5wp5i3.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 28.2.2011 16:01, Martin K. Petersen napsal(a):
>>>>>> "Zdenek" == Zdenek Kabelac <zkabelac@redhat.com> writes:
> 
> Zdenek> If you really need that many devices - be also sure you have
> Zdenek> disabled this kernel config option:
> 
> Zdenek> CONFIG_BLK_DEV_INTEGRITY
> 
> Zdenek> For some reason it consumes massive amount of memory.  Other
> Zdenek> than that - you should count with 64KB per device usually.
> 
> Care to qualify that?
> 
> Unless your HBA indicates that it supports data integrity the only
> penalty should be that each bio grows a pointer.
> 

Ok - I've taken some new measurements on my (possible not the best way
configure linux kernel 2.6.38-rc7)

As I'm using some kernel memory debugging it might not apply in the same way
for non-debug kernel.

My finding seems to show  that   BIP-256 slabtop segment grow by ~73KB per
each device (while dm-io is ab out ~26KB)

That makes consumption ~730MB when 10000 devices are in the game.
Of course there are some other big slowdowns - so it's not the biggest
problem, however - if I get it right when I don't have hw with bio integrity
support - this memory is essencially wasted? as it will have not use.

Of course people who will plan to use such massive number of devices probably
should use hw where such memory loose isn't big problem - but it's quite
noticeable on my testing laptop with just 4G :)

Another minor issue could be seen in delaying device creation time.
(i.e. ~7000 device activation with BIP is delayed by ~30%).

Zdenek
