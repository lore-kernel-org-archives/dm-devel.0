From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: oblem with lvm and multipath on fedora 13
Date: Sun, 29 Aug 2010 13:27:17 -0700
Message-ID: <20100829202717.GA24466@us.ibm.com>
References: <20100827182634.GB31618@us.ibm.com>
	<C89D80D7.10732%brian.p.stamper@nasa.gov>
	<20100828174751.GA31397@us.ibm.com>
	<12DC34690DFFAC4FACD7A7255FC5E14A131BCDE0DB@NDJSSCC07.ndc.nasa.gov>
	<20100829183943.GA22562@us.ibm.com>
	<12DC34690DFFAC4FACD7A7255FC5E14A131BCDE0DE@NDJSSCC07.ndc.nasa.gov>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <12DC34690DFFAC4FACD7A7255FC5E14A131BCDE0DE@NDJSSCC07.ndc.nasa.gov>
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

Stamper, Brian P. (ARC-D)[Logyx LLC] [brian.p.stamper@nasa.gov] wrote:
> Yes, it's chkconfig'ed on, and I bumped forward its start order to
> start up prior to lvm2-monitor, thinking lvm2-monitor (which does
> vgscan) might be part of the problem.

Don't change any default orders. That is not a proper fix even if it
works and you may break other things.

> >> [root@testfs foo]# find . -print | grep -i multi
> >> ./lib/modules/2.6.33.8-149.fc13.x86_64/kernel/drivers/md/dm-multipath.ko
> >The dm-multipath.ko kernel module is present. It needs multipath command
> >calling from an initrd script (/init ???)
> 
> I'm not positive that I'm sure what you're asking.  Do you mean the
> init.d script I reference above, or is there some other configuration
> change to call mulitpath from initrd?
> 

What I was trying to say is that dm-multipath.ko is included in the
initrd image, but there are other things that need to be included in the
initrd image to make the multipath configuration work in the initrd. For
example, you need multipath.conf in the initrd image as well as some
script in the initrd image calling 'multipath' binary.

> I feel much better knowing that I can get back to a proper
> configuration manually, but any ideas about why this is happening on
> bootup? 

My best guess is that LVM gets configured in initrd and multipath is not
there until the active root FS. Your best bet would be to include
multipath in the initrd (I have no working instructions on how to build
initrd with multipath on recent RedHat distros).

You may be able to get around the problem by restricting LVM in the
initrd image by doing this:

1. Modify the filter in /etc/lvm.conf file to include only the root/swap
   devices
2. Make a new initrd image. Use this to boot now onwards
   Since your filter only includes root/swap paths, LVM won't find or
   configure logical volumes other than root and swap at initrd time!
3. Change the filter to what it should be (the distro default should be
   fine)
4. Now reboot.


> FYI, I played around with filtering in lvm.conf in my first
> night of troubleshooting and tried filtering out all /dev/sd.* drives
> other than /dev/sda, but it seems like dracut was ignoring the lvm
> filters, despite the lvm.conf.  With the filter in place a pvscan
> would find no duplicates (and no sd.* devices) but on reboot dracut
> would find them all and report the dupes.

Did you make a new initrd after changing the lvm.conf file? Your initrd
will have a copy of lvm.conf file (it would be some old file unless you
made a new initrd image) and that would be used at boot up as you have
configured LVM in initrd.
 
> Thanks for your help so far Malahal.

You are welcome.
