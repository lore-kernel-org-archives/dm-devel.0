From: David Rosenstrauch <darose@darose.net>
Subject: Re: Volume group / volumes not activated at boot
Date: Thu, 24 Oct 2013 10:51:27 -0400
Message-ID: <526933EF.8030301@darose.net>
References: <5267E5C4.3070707@darose.net> <5268E940.2000006@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5268E940.2000006@redhat.com>
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

On 10/24/2013 05:32 AM, Zdenek Kabelac wrote:
> IMHO in normal case distro should ensure that only devices needed for the
> system are activated on the boot.
>
> So if you need all your volumes from a VG active - just add somewhere in
> your
> boot sequence    'vgchange -ay' if you need all LVs active.
>
> There is also recently a support for 'autoactivated' LVs - but this
> needs lvmetad daemon running in your system.
>
> Zdenek

Thanks for the response.

Actually after some additional research last night, I was able to figure 
out what the problem is:

The single PV in vg2 is a full disk device (/dev/sdc), not a partition. 
However, when I first was initializing the drive to add in to LVM, I 
accidentally partitioned the drive first.  Realizing the mistake, I then 
deleted the partitions.  However the result was a drive with an empty 
partition table, instead of a drive with no partition table. So what 
must be happening is that when LVM scans the drive, it sees that it's 
partitioned, but sees no partitions, and then moves on, leaving the VG 
inactive.  When I later manually tell LVM to activate the group 
explicitly it works; it just can't do it automatically.

Wiping out the partition table (i.e., MBR) on the drive seems to fix the 
issue, and LVM can now see the VG at boot.

Thanks,

DR
