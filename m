From: "Stamper, Brian P. (ARC-D)[Logyx LLC]" <brian.p.stamper@nasa.gov>
Subject: Re: oblem with lvm and multipath on fedora 13
Date: Sun, 29 Aug 2010 16:10:26 -0500
Message-ID: <12DC34690DFFAC4FACD7A7255FC5E14A131BCDE0E0@NDJSSCC07.ndc.nasa.gov>
References: <20100827182634.GB31618@us.ibm.com>
	<C89D80D7.10732%brian.p.stamper@nasa.gov>
	<20100828174751.GA31397@us.ibm.com>
	<12DC34690DFFAC4FACD7A7255FC5E14A131BCDE0DB@NDJSSCC07.ndc.nasa.gov>
	<20100829183943.GA22562@us.ibm.com>
	<12DC34690DFFAC4FACD7A7255FC5E14A131BCDE0DE@NDJSSCC07.ndc.nasa.gov>,
	<20100829202717.GA24466@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100829202717.GA24466@us.ibm.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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


________________________________________
From: dm-devel-bounces@redhat.com [dm-devel-bounces@redhat.com] On Behalf Of Malahal Naineni [malahal@us.ibm.com]

>What I was trying to say is that dm-multipath.ko is included in the
>initrd image, but there are other things that need to be included in the
>initrd image to make the multipath configuration work in the initrd. For
>example, you need multipath.conf in the initrd image as well as some
>script in the initrd image calling 'multipath' binary.

Alright, I'll look into this.

>My best guess is that LVM gets configured in initrd and multipath is not
>there until the active root FS. Your best bet would be to include
>multipath in the initrd (I have no working instructions on how to build
>initrd with multipath on recent RedHat distros).

There's info out there about getting systems to boot on multipath volumes, so I'll try to track this down.

>Did you make a new initrd after changing the lvm.conf file? Your initrd
>will have a copy of lvm.conf file

No, this didn't occur to me.  I'll do some testing with this as well.

>> Thanks for your help so far Malahal.
>
>You are welcome.

Here's what's throwing me at this point.  These aren't my only multipath volumes.  They're not even my only multipath volumes with lvm on them.  All my multipath volumes are from the same source, our 3par SAN.  What I can't figure is if multipath is missing from initrd, and that's an issue, why does it only affect these 2 VGs.  Why not the others?  The testNFS vg works fine.  It's a vg created across 2 luns with a single lv.  The filestoreVG works fine as well, it's a single lun in a vg.  There are only a few differences.  Whoever set up the testNFS and filestoreVG  lvs created the vg on the base volumes (/dev/mapper/testnfs0[1..2]) and not on partitions.  The volumes themselves on the SAN are different, the two I'm having an issue with are snapshot volumes and the others are base volumes.
   I can't imagine that has any effect.  I'll keep researching your recommendations above, but I'm finding it difficult to understand why there would be such a low-level problem with multipa!
 th when most of my multipath devices work fine.

Thanks again,
-Brian
