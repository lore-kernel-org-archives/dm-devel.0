From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 support ?
Date: Thu, 3 Nov 2005 21:07:52 +1100
Message-ID: <17257.57720.25495.299797@cse.unsw.edu.au>
References: <1129981242.7217.6.camel@jetpack.demon.co.uk>
	<17242.17266.315175.852854@cse.unsw.edu.au>
	<1129996688.7217.9.camel@jetpack.demon.co.uk>
	<17244.8868.117125.78408@cse.unsw.edu.au>
	<1130157973.6046.11.camel@jetpack.demon.co.uk>
	<17257.33116.12284.159992@cse.unsw.edu.au>
	<1131008651.6239.10.camel@jetpack.demon.co.uk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: message from Alan Hourihane on Thursday November 3
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thursday November 3, alanh@fairlite.demon.co.uk wrote:
> > md doesn't work with partitions.  It works with devices which may be
> > partitions or may be the whole device.
> > I often make raid5 arrays out of a set of devices, none of them
> > partitioned. 
> 
> O.k. Can you explain to me how to do that and still boot from the md
> device ?

It depends on exactly what you mean by 'still boot from'...

If you mean, "Have to root filesystem on an md device", there are two
ways. 

1/ use a kernel parameter like:
     md=d0,/dev/hda,/dev/hdc root=/dev/md_d0p1

 This tells the kernel to assemble an md array from /dev/hda and
 /dev/hdc.  It will be /dev/md/d0 which is a partitionable array,
 so you can have normal partitioning. /dev/md/d0p1 /dev/md0/d0p2.
 Most of my servers I configure like this, with a raid1 pair on sda
 and sdb, partitioned into root, swap, and the rest.

 This works quite well for ide drives as the device names are stable.
 It is not so good for SCSI as device names can change if you pull a
 device out.  However using sda and sdb for the root device works ok.

2/ use an initrd or initfs image which contains code to find and
  assemble md/raid arrays. mdadm comes with a striped down
  'mdassemble' which does just this.
  It currently needs a config file in the initfs, but I'm working
  towards being able to have the important configuration information
  reliably in the raid superblock.


If you mean "Load the kernel image from an md device" (which is what
"boot from" really means to me), then it depends on your boot loader.
I have lilo configured to boot from a mirrored pair as above.  Booting
from a raid5 almost certainly requires bios support, but once the
kernel and initfs are loaded, md can take it from there (once it can
understand the metadata format).

Hope that helps,

NeilBrown
