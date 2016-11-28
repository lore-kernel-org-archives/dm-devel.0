From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Improve processing efficiency for addition and
 deletion of multipath devices
Date: Mon, 28 Nov 2016 11:06:00 +0100
Message-ID: <597eba5c-3efa-8b05-3b7b-87792e3d896d@redhat.com>
References: <OF6C4379F8.661B1ACE-ON48258079.000B15EB-48258079.000CBE4F@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF6C4379F8.661B1ACE-ON48258079.000B15EB-48258079.000CBE4F@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tang.junhui@zte.com.cn, Christophe Varoqui <christophe.varoqui@opensvc.com>, bmarzins@redhat.com, Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 28.11.2016 v 03:19 tang.junhui@zte.com.cn napsal(a):
> Hello Christophe, Ben, Hannes, Martin, Bart,
> I am a member of host-side software development team of ZXUSP storage project
> in ZTE Corporation. Facing the market demand, our team decides to write code to
> promote multipath efficiency next month. The whole idea is in the mail below.We
> hope to participate in and make progress with the open source community, so any
> suggestion and comment would be welcome.
>


Hi

First - we are aware of these issue.

The solution proposed in this mail would surely help - but there is likely a 
bigger issue to be solved first.

The core trouble is to avoid  'blkid' disk identification to be executed.
Recent version of multipath is already marking plain 'RELOAD' operation
of table (which should not be changing disk content) with extra DM bit,
so udev rules ATM skips 'pvscan' - we also would like to extend the 
functionality to skip rules more and reimport existing 'symlinks' from
udev database (so they would not get deleted).

I believe the processing of udev rules is 'relatively' quick as long
as it does not need to read/write ANYTHING from real disks.

So while aggregation of 'uevents' in multipath would 'shorten' queue 
processing of events - it would still not speedup scan alone.

We need to drastically shorten unnecessary disk re-scanning.

Also note - if you have a lot of disks -  it might be worth to checkout
whether udev picks  'right amount of udev workers'.
There is heuristic logic to avoid system overload - but might be worth to 
check if in you system with your amount of CPU/RAM/DISKS  the computed number 
is the best for scaling - i.e. if you double the amount of workers - do you
get any better performance ?

Regards

Zdenek
