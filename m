From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] [RFC] persistent readable names
Date: Wed, 5 Oct 2005 15:38:24 -0700
Message-ID: <20051005223824.GA27219@us.ibm.com>
References: <4343DFDC.2020701@redhat.com> <20051005150923.GC6195@free.fr>
	<20051005180721.GA22387@us.ibm.com>
	<1128547659.6140.40.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1128547659.6140.40.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Christophe -

On Wed, Oct 05, 2005 at 11:27:38PM +0200, Christophe Varoqui wrote:
> 
> > I haven't recently looked at dm or dm multipath naming, but dm and dm
> > multipath should not have a different naming scheme outside of udev.
> > 
> Do you mean we should stop naming the maps after aliases ?

> If so, there are quite a few glitches ahead : the multipath configurator
> and daemon will have a hard time playing with those meaningful aliases.
> 
> They are used for :
> 1) printing meaningful map names (multipath -l, multipathd -k"show
> maps")
> 2) limiting the scope (multipath -l mymap, multipathd -k"del map mymap")
> 3) naming /dev/mapper/ nodes
> 
> 
> I'm all in favor of keeping the naming policies in a central place
> (udev). But can we safely lose (1) and (2) ?

Sorry, I am not up to date on current dm or dm multipath so I can't
answer those. 

But readable persistent naming should be done in udev and be the same
for all devices.

> Can/will this "outlaw" behaviour persist ?

Yes, as long as no one patches/fixes it :)

> > udev now has persistent naming, and probably could or should have a dm_id
> > (dm_id could run scsi_id on a single path, unless dm is passing down scsi
> > ioctl's). The udev persistent naming scheme is not intuitive (i.e.  not
> > easy for people to create and use).
> > 
> Are you sure you mean persistent like "stable enumeration accross
> reboots, and even accross a cluster", or simply persistent like
> "predictable" ?

udev does not generate enumerations for its solution.

It does have both persistent as in predictable naming (by-path), based
on some *kernel* enumerations (i.e. sysfs paths), like scsi host number,
and I think some pci slot numbers and probably more. Plus it has names
that are ummmmm persistent (by-id).

> Personnaly, I fail to see how to achieve persistance through udev (1st
> definition, the one PatrickC cares about). Do I miss something ?

Yes ... it can name (or create sym links) based on the execution of
device (or in sysfs terms bus) specific programs. There now exist a
scsi_id, ata_id and more under udev/extras.

> That said, I agree it makes sense : a persistent (and reliable)
> enumeration naming through a udev '%e'-like substitution would be a nice
> and simple thing to use.

No, udev enumeration is not persistent, and Kay never (AFAIR) could come
up with a fast and simple way to guarantee that the enumeration was
atomic.

> > Intuitive names could be built upon the persistent names as part of udev,
> > like an alias, or if you could "match" a NAME, and have a new udev rule
> > like:
> > 
> > 	NAME=="disk/by-id/foo" SYMLINK+="disk/by-simple/my-database"
> > 
> I fail to see how this can be done without 1 rule per multipath. 

Right, I assumed this was required no matter what the solution, I don't
see how you can have readable and persistent /dev names covering all
possible disks without some one-to-one mapping.

> Administrative scalability was the purpose of PatrickC's patch, ie no
> admin-supplied aliases.

Guess I need to actually read and understand the patch :-/

Here is some /dev, lsscsi and scsi_id output on a SLES9 system (rpm
udev-021-36.55). by-path is basically pci and scsi bus_id's; by-id is
basically scsi_id plus partition output. 

[Uh oh, the by-path output looks broken! It should be scsi-1:0:0:0 pointing to sdc not scsi-0:0:0:0, but this shows the /dev structure.]

I hope this clears things up:

elm3a47:~ # ls -l /dev/disk/by-path | grep sdc
lrwxrwxrwx  1 root root   9 Oct  5 08:18 pci-0000:01:01.1-scsi-0:0:0:0 -> ../../sdc
lrwxrwxrwx  1 root root  10 Oct  5 08:18 pci-0000:01:01.1-scsi-0:0:0:0p1 -> ../../sdc1
lrwxrwxrwx  1 root root  10 Oct  5 08:18 pci-0000:01:01.1-scsi-0:0:0:0p2 -> ../../sdc2
lrwxrwxrwx  1 root root  10 Oct  5 08:18 pci-0000:01:01.1-scsi-0:0:0:0p3 -> ../../sdc3

elm3a47:~ # ls -l /dev/disk/by-id | grep sdc
lrwxrwxrwx  1 root root   9 Oct  5 08:18 320000004cf311121 -> ../../sdc
lrwxrwxrwx  1 root root  10 Oct  5 08:18 320000004cf311121p1 -> ../../sdc1
lrwxrwxrwx  1 root root  10 Oct  5 08:18 320000004cf311121p2 -> ../../sdc2
lrwxrwxrwx  1 root root  10 Oct  5 08:18 320000004cf311121p3 -> ../../sdc3

elm3a47:~ # lsscsi | grep sdc
[1:0:0:0]    disk    IBM-ESXS ST318453FC    F  B953  /dev/sdc

elm3a47:~ # ls -l /sys/block/sdc/device
lrwxrwxrwx  1 root root 0 Oct  5 08:18 /sys/block/sdc/device -> ../../devices/pci0000:00/0000:00:1f.0/0000:01:01.1/host1/1:0:0:0

elm3a47:~ # scsi_id -g -s /block/sdc
320000004cf311121

-- Patrick Mansfield
