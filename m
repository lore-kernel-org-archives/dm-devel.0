From: malahal@us.ibm.com
Subject: Re: DM-RAID1 data corruption
Date: Tue, 23 Jun 2009 11:22:29 -0700
Message-ID: <20090623182229.GD30667@us.ibm.com>
References: <Pine.LNX.4.64.0904141618220.701@hs20-bc2-1.build.redhat.com>
	<20090415031210.GA11881@us.ibm.com> <49E645DA.4010204@redhat.com>
	<20090416024959.GB19876@us.ibm.com> <49E7B029.20906@redhat.com>
	<Pine.LNX.4.64.0904200552590.27291@hs20-bc2-1.build.redhat.com>
	<20090623010930.GA13392@us.ibm.com> <4A41065D.10804@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A41065D.10804@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Takahiro Yasui [tyasui@redhat.com] wrote:
> >> MD-RAID1 solves this problem by having counters in superblocks on both 
> >> legs. If some leg dies, the counter on the other devices is increased. If 
> >> the dead disk comes online again, it is found that it has old counter and 
> >> cannot be trusted.
> >>
> >> Would it be possible to extend a logical volume when converting it to a 
> >> raid1 and use the last area of the volume as a superblock?
> >>
> >> Mikulas
> > 
> > This is an old thread, I am just trying to revitalize it! :-) How about
> > dm-raid1 taking superblock storage as arguments in the command line,
> > just like the log device? The superblock storage is entirely managed by
> > the kernel, LVM just allocates it. Error handling can be instant this
> > way. LVM can auto convert the exiting mirrors to this kind of mirrors if
> > space is available.
> 
> Interesting idea. The superblock storage managed by kernel is really
> important to handle an error quickly inside the kernel.
> 
> According to Mikulas's comment, superblocks are located on each legs
> and contains a counter. Do you have an idea to separate a superblock
> device like the log device? Or do you mean to add a parameter to
> enable superblock like "--superblock"? It might be helpful if you
> could describe some command line examples.

I was thinking something like adding {metadata-size #metadata-areas <dev offset>
...

echo 0 1000 mirror core 1 64 2 /dev/sda 0 /dev/sdb 0 512 2 /dev/sda 2000
/dev/sdb 2000

The above one will create a mirror with sda and sdb and mirror metadata
on the same disks at offset 2000 with 512 size. The kernel target can
use that 512 bytes whatever the way it wants.
