From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: Multipath not rebuilding correctly on reboot
Date: Fri, 15 Feb 2008 13:25:20 -0600
Message-ID: <20080215192520.GF15608@ether.msp.redhat.com>
References: <20080212222227.GA15608@ether.msp.redhat.com>
	<2F1F44D192D1284BAA298E48C1B2A4F90234F1E6@exchmail03.ncogroup.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="4Ckj6UjgE2iN1+kY"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2F1F44D192D1284BAA298E48C1B2A4F90234F1E6@exchmail03.ncogroup.com>
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


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 14, 2008 at 01:40:53PM -0500, Greene, Rick wrote:
> I tried Benjamin's suggestions, and with a little poking around I
> basically got nowhere.
> 
> I did have to make one other adjustment to the system, I modified
> /etc/lvm/lvm.conf to only try activating the vg00 volume group (local
> disk) and not the vgftp volume group (built on the disk running through
> multipath).
> 
> I'm still left with the same state, it takes that extra "multipath -v 2"
> to get everything fully activated.  I do have that in rc.local at the
> moment, but I'm hoping someone can figure out what is going on so I
> don't have to have that extra step.
> 
> Attached is the log file generated during the boot process, including
> the results of the extra step.  If you look for lines starting with %%,
> you'll see comments showing what has generated each section of the long.
> 
> Any further advice greatly appreciated,

It seems that all your paths appear early enough to be managed by
rc.sysint.  However, looking at the path info output for sde, sdf, sdg,
and sdh, it looks like multipath can't open their device nodes.  I'm
assuming that it's because udev hasn't created them yet.  In upstream
and RHEL5 there is code to wait up to five seconds for the device node
to be created.  In RHEL4, that code is only run by multipathd. I can't
be sure that this is the cause of your problems, but it seems very likely.

Besides putting sleeps into rc.sysinit, there's not much that can be
done without patching the code.  If you are willing to patch the source
yourself, I've attached a patch.  Otherwise, I can build a test rpm,
although maybe not till early next week, send out a link to it.

Hope this helps
-Ben

===== path info sdh (mask 0x1f) =====
bus = 1
dev_t = 8:112
size = 28452960
vendor = HP      
product = OPEN-E          
rev = 2114
h:b:t:l = 2:0:0:3
tgt_node_name = 0x50060e80039c5a14
#
# all paths :
#
00040026_05:83  1:0:0:0 sda 8:0  [ready] HP      /OPEN-E          /2114
00040026_05:84  1:0:0:1 sdb 8:16  [ready] HP      /OPEN-E          /2114
00040026_05:85  1:0:0:2 sdc 8:32  [ready] HP      /OPEN-E          /2114
00040026_05:86  1:0:0:3 sdd 8:48  [ready] HP      /OPEN-E          /2114
  2:0:0:0 sde 8:64  [faulty] HP      /OPEN-E          /2114
  2:0:0:1 sdf 8:80  [faulty] HP      /OPEN-E          /2114
  2:0:0:2 sdg 8:96  [faulty] HP      /OPEN-E          /2114
  2:0:0:3 sdh 8:112  [faulty] HP      /OPEN-E          /2114

> Rick
> 
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Benjamin Marzinski
> Sent: Tuesday, February 12, 2008 5:22 PM
> To: device-mapper development
> Subject: Re: [dm-devel] Multipath not rebuilding correctly on reboot
> 
> On Thu, Jan 31, 2008 at 03:20:04PM -0500, Greene, Rick wrote:
> > Now that I seem to have multipath and my XP 1024 working together,
> I've
> > found a new issue.  Someone recently had a similar thread going, but I
> > saw no ultimate resolution.
> > 
> > My problem is that when I reboot my server, the multipath
> configuration
> > is not coming back the way it was before.  I moved the two external
> > tools I use to find the UID into /etc (they had bin in /usr/bin and
> > /sbin), updated the multipath.conf file (and one of the scripts) to
> > reflect this, but odd things are still happening.
> > 
> > Attached is initial_view.txt, which shows what multipath is coming up
> > with when I do the commands shown (the bulk of the file is multipath
> -v3
> > output, but at the bottom of the file is a multipath -ll output as
> > well).  It (seems to) correctly shows that I have 4 disks, each
> visible
> > via two separate paths.
> > 
> > After I reboot, however, I get different results.  Once it showed 4
> > paths for mpath0, and 2 paths for mpath1, 2, and 3.  Next time it
> > correctly showed mpath0, mpath1, and mpath3, but didn't show mpath2 at
> > all.  On the next attempt I got everything correct, and the very next
> > one only showed mpath0 and mpath1.
> > 
> > The post_reboot.txt file shows the contents of the /var/log/boot.log
> > file and the output of the dmesg command, along with the "multipath
> -ll"
> > view from the most recent reboot.
> > 
> > I then manually did a "multipath -v2" and the missing two paths then
> > came back.  The file manual_run.txt shows those results plus the
> updated
> > "multipath -ll".
> > 
> > Do I need to just make my own /etc/init.d script to do a "multipath
> -v2"
> > at the end of booting to make sure it all gets covered, along with the
> > requisite LVM & mount commands to get the VG that is on these disks
> > working right?
> 
> Hopefully, you can just add the line
> 
> multipath -v 0 
> 
> to /etc/rc.local and fix this.  However, if you want to dig into
> what's going wrong:
> 
> There are two places were multipath gets called to create devices during
> bootup.  One is in /etc/rc.sysinit and one in
> /etc/dev.d/block/multipath.dev.  /etc/rc.sysinit will always be run as
> one of the first things during the boot process, and it just calls
> multipath.static -v 0, which should correctly set up multipath devices
> on all of the available paths.  /etc/dev.d/block/multipath.dev gets
> called by udev, and is a lot more suspect.
> 
> If you feel confortable editting boot scripts, you can do some debugging
> to figure out what's going on.
> 
> in /etc/rc.sysinit (assuming you aren't using md or raid), you can
> change
> the first line with:
> /sbin/multipath.static -v 0
> to:
> /sbin/multipath.static -v 3 >> /tmp/multipath_boot_log 2>&1
> 
> the other lines that call multipath.static are only run if you have
> the files /etc/raidtab or /etc/mdadm.conf, which you probably don't.
> 
> in /etc/dev.d/block/multipath.dev just add the following line right
> after the #!/bin/sh line:
> 
> echo "${ACTION} ${DEVPATH}" >> /tmp/multipath_boot_log
> 
> Then reboot and look at /tmp/multipath_boot_log
> 
> You should see something that looks like the output of running
> # multipath -v 3
> along with a bunch of lines like:
> 
> add /block/md0
> add /block/loop1
> add /block/loop0
> add /block/dm-7
> 
> The multipath run is from rc.sysinit, and the "add" lines are devices
> that udev is trying to create a multipath device on.  On systems where
> everthing comes up fine during boot up, all of the devices that aren't
> dealt with by the multipath call in rc.sysinit should be added by udev.
> 
> I'm assuming that this won't be the case on your box. If udev isn't
> running /etc/dev.d/block/multipath.dev, there's not much you can do
> to fix it, besides filing a bug against udev.  However you may be able
> to
> make it more likely that your scsi devices will all be up by the time
> rc.sysinit is run.  If your device drivers aren't getting loaded by the
> initrd, you can add them to /etc/modprobe.conf, run mkinitrd.  If you do
> this, it's always wise to back up your existing initrd, and make sure
> that grub can boot with it.
> 
> Otherwise, just try adding the line to rc.local
> 
> Hope this helps
> 
> -Ben
>  
> > Thanks in advance,
> > Rick
> > 
> > 
> > 
> 
> Content-Description: initial_view.txt
> > # service multipathd stop
> > # multipath -F
> > # service multipathd start
> > # multipath -v3
> > load path identifiers cache
> > #
> > # all paths in cache :
> > #
> > 00040026_05:83  1:0:0:0 sda 8:0   HP      /OPEN-E          /2114
> > 00040026_05:84  1:0:0:1 sdb 8:16   HP      /OPEN-E          /2114
> > 00040026_05:85  1:0:0:2 sdc 8:32   HP      /OPEN-E          /2114
> > 00040026_05:86  1:0:0:3 sdd 8:48   HP      /OPEN-E          /2114
> > 00040026_05:83  2:0:0:0 sde 8:64   HP      /OPEN-E          /2114
> > 00040026_05:84  2:0:0:1 sdf 8:80   HP      /OPEN-E          /2114
> > 00040026_05:85  2:0:0:2 sdg 8:96   HP      /OPEN-E          /2114
> > 00040026_05:86  2:0:0:3 sdh 8:112   HP      /OPEN-E          /2114
> > cciss!c0d0 blacklisted
> > cciss!c0d1 blacklisted
> > dm-0 blacklisted
> > dm-1 blacklisted
> > dm-2 blacklisted
> > dm-3 blacklisted
> > dm-4 blacklisted
> > dm-5 blacklisted
> > dm-6 blacklisted
> > dm-7 blacklisted
> > fd0 blacklisted
> > hda blacklisted
> > md0 blacklisted
> > ram0 blacklisted
> > ram10 blacklisted
> > ram11 blacklisted
> > ram12 blacklisted
> > ram13 blacklisted
> > ram14 blacklisted
> > ram15 blacklisted
> > ram1 blacklisted
> > ram2 blacklisted
> > ram3 blacklisted
> > ram4 blacklisted
> > ram5 blacklisted
> > ram6 blacklisted
> > ram7 blacklisted
> > ram8 blacklisted
> > ram9 blacklisted
> > ===== path info sda (mask 0x1f) =====
> > bus = 1
> > dev_t = 8:0
> > size = 28452960
> > vendor = HP
> > product = OPEN-E
> > rev = 2114
> > h:b:t:l = 1:0:0:0
> > tgt_node_name = 0x50060e80039c5a04
> > serial = 40026
> > path checker = tur (controler setting)
> > state = 2
> > getprio = /bin/true (internal default)
> > prio = 0
> > uid = 00040026_05:83 (cache)
> > ===== path info sdb (mask 0x1f) =====
> > bus = 1
> > dev_t = 8:16
> > size = 28452960
> > vendor = HP
> > product = OPEN-E
> > rev = 2114
> > h:b:t:l = 1:0:0:1
> > tgt_node_name = 0x50060e80039c5a04
> > serial = 40026
> > path checker = tur (controler setting)
> > state = 2
> > getprio = /bin/true (internal default)
> > prio = 0
> > uid = 00040026_05:84 (cache)
> > ===== path info sdc (mask 0x1f) =====
> > bus = 1
> > dev_t = 8:32
> > size = 28452960
> > vendor = HP
> > product = OPEN-E
> > rev = 2114
> > h:b:t:l = 1:0:0:2
> > tgt_node_name = 0x50060e80039c5a04
> > serial = 40026
> > path checker = tur (controler setting)
> > state = 2
> > getprio = /bin/true (internal default)
> > prio = 0
> > uid = 00040026_05:85 (cache)
> > ===== path info sdd (mask 0x1f) =====
> > bus = 1
> > dev_t = 8:48
> > size = 28452960
> > vendor = HP
> > product = OPEN-E
> > rev = 2114
> > h:b:t:l = 1:0:0:3
> > tgt_node_name = 0x50060e80039c5a04
> > serial = 40026
> > path checker = tur (controler setting)
> > state = 2
> > getprio = /bin/true (internal default)
> > prio = 0
> > uid = 00040026_05:86 (cache)
> > ===== path info sde (mask 0x1f) =====
> > bus = 1
> > dev_t = 8:64
> > size = 28452960
> > vendor = HP
> > product = OPEN-E
> > rev = 2114
> > h:b:t:l = 2:0:0:0
> > tgt_node_name = 0x50060e80039c5a14
> > serial = 40026
> > path checker = tur (controler setting)
> > state = 2
> > getprio = /bin/true (internal default)
> > prio = 0
> > uid = 00040026_05:83 (cache)
> > ===== path info sdf (mask 0x1f) =====
> > bus = 1
> > dev_t = 8:80
> > size = 28452960
> > vendor = HP
> > product = OPEN-E
> > rev = 2114
> > h:b:t:l = 2:0:0:1
> > tgt_node_name = 0x50060e80039c5a14
> > serial = 40026
> > path checker = tur (controler setting)
> > state = 2
> > getprio = /bin/true (internal default)
> > prio = 0
> > uid = 00040026_05:84 (cache)
> > ===== path info sdg (mask 0x1f) =====
> > bus = 1
> > dev_t = 8:96
> > size = 28452960
> > vendor = HP
> > product = OPEN-E
> > rev = 2114
> > h:b:t:l = 2:0:0:2
> > tgt_node_name = 0x50060e80039c5a14
> > serial = 40026
> > path checker = tur (controler setting)
> > state = 2
> > getprio = /bin/true (internal default)
> > prio = 0
> > uid = 00040026_05:85 (cache)
> > ===== path info sdh (mask 0x1f) =====
> > bus = 1
> > dev_t = 8:112
> > size = 28452960
> > vendor = HP
> > product = OPEN-E
> > rev = 2114
> > h:b:t:l = 2:0:0:3
> > tgt_node_name = 0x50060e80039c5a14
> > serial = 40026
> > path checker = tur (controler setting)
> > state = 2
> > getprio = /bin/true (internal default)
> > prio = 0
> > uid = 00040026_05:86 (cache)
> > #
> > # all paths :
> > #
> > 00040026_05:83  1:0:0:0 sda 8:0  [ready] HP      /OPEN-E
> /2114
> > 00040026_05:84  1:0:0:1 sdb 8:16  [ready] HP      /OPEN-E
> /2114
> > 00040026_05:85  1:0:0:2 sdc 8:32  [ready] HP      /OPEN-E
> /2114
> > 00040026_05:86  1:0:0:3 sdd 8:48  [ready] HP      /OPEN-E
> /2114
> > 00040026_05:83  2:0:0:0 sde 8:64  [ready] HP      /OPEN-E
> /2114
> > 00040026_05:84  2:0:0:1 sdf 8:80  [ready] HP      /OPEN-E
> /2114
> > 00040026_05:85  2:0:0:2 sdg 8:96  [ready] HP      /OPEN-E
> /2114
> > 00040026_05:86  2:0:0:3 sdh 8:112  [ready] HP      /OPEN-E
> /2114
> > Initialized new bindings file [/var/lib/multipath/bindings]
> > No matching wwid [00040026_05:83] in bindings file.
> > Created new binding [mpath0] for WWID [00040026_05:83]
> > pgpolicy = multibus (controler setting)
> > selector = round-robin 0 (internal default)
> > features = 0 (internal default)
> > hwhandler = 0 (internal default)
> > rr_weight = 2 (config file default)
> > rr_min_io = 100 (config file default)
> > no_path_retry = -1 (config file default)
> > pg_timeout = NONE (internal default)
> > 0 28452960 multipath 0 0 1 1 round-robin 0 2 1 8:0 100 8:64 100
> > set ACT_CREATE: map does not exists
> > message mpath0 0 switch_group 1
> > 
> > create: mpath0 (00040026_05:83)
> > [size=13 GB][features="0"][hwhandler="0"]
> > \_ round-robin 0
> >  \_ 1:0:0:0 sda 8:0   [ready]
> >  \_ 2:0:0:0 sde 8:64  [ready]
> > 
> > reloading features
> > No matching wwid [00040026_05:84] in bindings file.
> > Created new binding [mpath1] for WWID [00040026_05:84]
> > pgpolicy = multibus (controler setting)
> > selector = round-robin 0 (internal default)
> > features = 0 (internal default)
> > hwhandler = 0 (internal default)
> > rr_weight = 2 (config file default)
> > rr_min_io = 100 (config file default)
> > no_path_retry = -1 (config file default)
> > pg_timeout = NONE (internal default)
> > 0 28452960 multipath 0 0 1 1 round-robin 0 2 1 8:16 100 8:80 100
> > set ACT_CREATE: map does not exists
> > message mpath1 0 switch_group 1
> > 
> > create: mpath1 (00040026_05:84)
> > [size=13 GB][features="0"][hwhandler="0"]
> > \_ round-robin 0
> >  \_ 1:0:0:1 sdb 8:16  [ready]
> >  \_ 2:0:0:1 sdf 8:80  [ready]
> > 
> > reloading features
> > No matching wwid [00040026_05:85] in bindings file.
> > Created new binding [mpath2] for WWID [00040026_05:85]
> > pgpolicy = multibus (controler setting)
> > selector = round-robin 0 (internal default)
> > features = 0 (internal default)
> > hwhandler = 0 (internal default)
> > rr_weight = 2 (config file default)
> > rr_min_io = 100 (config file default)
> > no_path_retry = -1 (config file default)
> > pg_timeout = NONE (internal default)
> > 0 28452960 multipath 0 0 1 1 round-robin 0 2 1 8:32 100 8:96 100
> > set ACT_CREATE: map does not exists
> > message mpath2 0 switch_group 1
> > 
> > create: mpath2 (00040026_05:85)
> > [size=13 GB][features="0"][hwhandler="0"]
> > \_ round-robin 0
> >  \_ 1:0:0:2 sdc 8:32  [ready]
> >  \_ 2:0:0:2 sdg 8:96  [ready]
> > 
> > reloading features
> > No matching wwid [00040026_05:86] in bindings file.
> > Created new binding [mpath3] for WWID [00040026_05:86]
> > pgpolicy = multibus (controler setting)
> > selector = round-robin 0 (internal default)
> > features = 0 (internal default)
> > hwhandler = 0 (internal default)
> > rr_weight = 2 (config file default)
> > rr_min_io = 100 (config file default)
> > no_path_retry = -1 (config file default)
> > pg_timeout = NONE (internal default)
> > 0 28452960 multipath 0 0 1 1 round-robin 0 2 1 8:48 100 8:112 100
> > set ACT_CREATE: map does not exists
> > message mpath3 0 switch_group 1
> > 
> > create: mpath3 (00040026_05:86)
> > [size=13 GB][features="0"][hwhandler="0"]
> > \_ round-robin 0
> >  \_ 1:0:0:3 sdd 8:48  [ready]
> >  \_ 2:0:0:3 sdh 8:112 [ready]
> > 
> > reloading features
> > 
> > # multipath -ll
> > mpath2 (00040026_05:85)
> > [size=13 GB][features="0"][hwhandler="0"]
> > \_ round-robin 0 [active]
> >  \_ 1:0:0:2 sdc 8:32  [active][ready]
> >  \_ 2:0:0:2 sdg 8:96  [active][ready]
> > 
> > mpath1 (00040026_05:84)
> > [size=13 GB][features="0"][hwhandler="0"]
> > \_ round-robin 0 [active]
> >  \_ 1:0:0:1 sdb 8:16  [active][ready]
> >  \_ 2:0:0:1 sdf 8:80  [active][ready]
> > 
> > mpath0 (00040026_05:83)
> > [size=13 GB][features="0"][hwhandler="0"]
> > \_ round-robin 0 [active]
> >  \_ 1:0:0:0 sda 8:0   [active][ready]
> >  \_ 2:0:0:0 sde 8:64  [active][ready]
> > 
> > mpath3 (00040026_05:86)
> > [size=13 GB][features="0"][hwhandler="0"]
> > \_ round-robin 0 [active]
> >  \_ 1:0:0:3 sdd 8:48  [active][ready]
> >  \_ 2:0:0:3 sdh 8:112 [active][ready]
> 
> Content-Description: post_reboot.txt
> > # dmesg
> > Bootdata ok (command line is ro root=/dev/vg00/root rhgb quiet)
> > Linux version 2.6.9-55.ELsmp (brewbuilder@hs20-bc2-4.build.redhat.com)
> (gcc version 3.4.6 20060404 (Red Hat 3.4.6-3)) #1 SMP Fri Apr 20
> 16:36:54 EDT 2007
> > BIOS-provided physical RAM map:
> >  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
> >  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
> >  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> >  BIOS-e820: 0000000000100000 - 00000000bfff3000 (usable)
> >  BIOS-e820: 00000000bfff3000 - 00000000bfffb000 (ACPI data)
> >  BIOS-e820: 00000000bfffb000 - 00000000c0000000 (reserved)
> >  BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
> >  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
> >  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
> > ACPI: RSDP (v002 HP                                    ) @
> 0x00000000000f4f00
> > ACPI: XSDT (v001 HP     P51      0x00000002 ? 0x0000162e) @
> 0x00000000bfff3300
> > ACPI: FADT (v003 HP     P51      0x00000002 ? 0x0000162e) @
> 0x00000000bfff3380
> > ACPI: SPCR (v001 HP     SPCRRBSU 0x00000001 ? 0x0000162e) @
> 0x00000000bfff3140
> > ACPI: MCFG (v001 HP     ProLiant 0x00000001  0x00000000) @
> 0x00000000bfff31c0
> > ACPI: MADT (v001 HP     00000083 0x00000002  0x00000000) @
> 0x00000000bfff3200
> > ACPI: SSDT (v001 HP        SSDTP 0x00000001 INTL 0x20030228) @
> 0x00000000bfff8000
> > ACPI: DSDT (v001 HP         DSDT 0x00000001 INTL 0x20030228) @
> 0x0000000000000000
> > No NUMA configuration found
> > Faking a node at 0000000000000000-00000000bfff3000
> > Bootmem setup node 0 0000000000000000-00000000bfff3000
> > On node 0 totalpages: 786419
> >   DMA zone: 4096 pages, LIFO batch:1
> >   Normal zone: 782323 pages, LIFO batch:16
> >   HighMem zone: 0 pages, LIFO batch:1
> > DMI 2.3 present.
> > ACPI: PM-Timer IO Port: 0x908
> > ACPI: Local APIC address 0xfee00000
> > ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> > Processor #0 15:4 APIC version 16
> > ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
> > ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
> > ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
> > Processor #6 15:4 APIC version 16
> > ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> > Processor #1 15:4 APIC version 16
> > ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
> > ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
> > ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
> > Processor #7 15:4 APIC version 16
> > ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> > Setting APIC routing to flat
> > ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
> > IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
> > ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[24])
> > IOAPIC[1]: apic_id 9, version 32, address 0xfec80000, GSI 24-47
> > ACPI: IOAPIC (id[0x0a] address[0xfec80400] gsi_base[48])
> > IOAPIC[2]: apic_id 10, version 32, address 0xfec80400, GSI 48-71
> > ACPI: IOAPIC (id[0x0b] address[0xfec84000] gsi_base[72])
> > IOAPIC[3]: apic_id 11, version 32, address 0xfec84000, GSI 72-95
> > ACPI: IOAPIC (id[0x0c] address[0xfec84400] gsi_base[96])
> > IOAPIC[4]: apic_id 12, version 32, address 0xfec84400, GSI 96-119
> > ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
> > ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> > ACPI: IRQ0 used by override.
> > ACPI: IRQ2 used by override.
> > ACPI: IRQ9 used by override.
> > Using ACPI (MADT) for SMP configuration information
> > Allocating PCI resources starting at c4000000 (gap: c0000000:3ec00000)
> > Checking aperture...
> > Built 1 zonelists
> > Kernel command line: ro root=/dev/vg00/root rhgb quiet console=tty0
> > Initializing CPU#0
> > PID hash table entries: 4096 (order: 12, 131072 bytes)
> > time.c: Using 3.579545 MHz PM timer.
> > time.c: Detected 3400.312 MHz processor.
> > Console: colour VGA+ 80x25
> > Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> > Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> > Memory: 3089236k/3145676k available (2112k kernel code, 0k reserved,
> 1305k data, 208k init)
> > Calibrating delay using timer specific routine.. 6807.48 BogoMIPS
> (lpj=3403744)
> > Security Scaffold v1.0.0 initialized
> > SELinux:  Initializing.
> > SELinux:  Starting in permissive mode
> > There is already a security framework initialized, register_security
> failed.
> > selinux_register_security:  Registering secondary module capability
> > Capability LSM initialized as secondary
> > Mount-cache hash table entries: 256 (order: 0, 4096 bytes)
> > CPU: Trace cache: 12K uops, L1 D cache: 16K
> > CPU: L2 cache: 1024K
> > using mwait in idle threads.
> > CPU0: Initial APIC ID: 0, Physical Processor ID: 0
> > Using IO APIC NMI watchdog
> > CPU: Trace cache: 12K uops, L1 D cache: 16K
> > CPU: L2 cache: 1024K
> > CPU0: Initial APIC ID: 0, Physical Processor ID: 0
> > CPU0:                   Intel(R) Xeon(TM) CPU 3.40GHz stepping 01
> > per-CPU timeslice cutoff: 1023.90 usecs.
> > task migration cache decay timeout: 1 msecs.
> > Booting processor 1/6 rip 6000 rsp 10037e05f58
> > Initializing CPU#1
> > Calibrating delay using timer specific routine.. 6799.32 BogoMIPS
> (lpj=3399660)
> > CPU: Trace cache: 12K uops, L1 D cache: 16K
> > CPU: L2 cache: 1024K
> > CPU1: Initial APIC ID: 6, Physical Processor ID: 3
> >                   Intel(R) Xeon(TM) CPU 3.40GHz stepping 01
> > Booting processor 2/1 rip 6000 rsp 10037e3df58
> > Initializing CPU#2
> > Calibrating delay using timer specific routine.. 6799.31 BogoMIPS
> (lpj=3399655)
> > CPU: Trace cache: 12K uops, L1 D cache: 16K
> > CPU: L2 cache: 1024K
> > CPU2: Initial APIC ID: 1, Physical Processor ID: 0
> >                   Intel(R) Xeon(TM) CPU 3.40GHz stepping 01
> > Booting processor 3/7 rip 6000 rsp 100016f3f58
> > Initializing CPU#3
> > Calibrating delay using timer specific routine.. 6799.18 BogoMIPS
> (lpj=3399591)
> > CPU: Trace cache: 12K uops, L1 D cache: 16K
> > CPU: L2 cache: 1024K
> > CPU3: Initial APIC ID: 7, Physical Processor ID: 3
> >                   Intel(R) Xeon(TM) CPU 3.40GHz stepping 01
> > Total of 4 processors activated (27205.30 BogoMIPS).
> > activating NMI Watchdog ... done.
> > testing NMI watchdog ... OK.
> > Using local APIC timer interrupts.
> > Detected 12.501 MHz APIC timer.
> > checking TSC synchronization across 4 CPUs: passed.
> > Brought up 4 CPUs
> > time.c: Using PIT/TSC based timekeeping.
> > checking if image is initramfs... it is
> > NET: Registered protocol family 16
> > PCI: Using configuration type 1
> > PCI: Using MMCONFIG at e0000000
> > mtrr: v2.0 (20020519)
> > mtrr: your CPUs had inconsistent fixed MTRR settings
> > mtrr: probably your BIOS does not setup all CPUs.
> > mtrr: corrected configuration.
> > ACPI: Subsystem revision 20040816
> > ACPI: Interpreter enabled
> > ACPI: Using IOAPIC for interrupt routing
> > ACPI: PCI Root Bridge [PCI0] (00:00)
> > PCI: Probing PCI hardware (bus 00)
> > PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
> > PCI: PXH quirk detected, disabling MSI for SHPC device
> > PCI: PXH quirk detected, disabling MSI for SHPC device
> > PCI: PXH quirk detected, disabling MSI for SHPC device
> > PCI: PXH quirk detected, disabling MSI for SHPC device
> > PCI: Transparent bridge - 0000:00:1e.0
> > ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> > ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
> > ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PTA0._PRT]
> > ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PTA0.PCXA._PRT]
> > ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PTA0.PCXB._PRT]
> > ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PTC0._PRT]
> > ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PTC0.PCXC._PRT]
> > ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PTC0.PCXD._PRT]
> > ACPI: PCI Interrupt Link [LNKA] (IRQs *5 7 10 11)
> > ACPI: PCI Interrupt Link [LNKB] (IRQs *5 7 10 11)
> > ACPI: PCI Interrupt Link [LNKC] (IRQs *5 7 10 11)
> > ACPI: PCI Interrupt Link [LNKD] (IRQs *5 7 10 11)
> > ACPI: PCI Interrupt Link [LNKE] (IRQs 5 7 10 11) *0, disabled.
> > ACPI: PCI Interrupt Link [LNKF] (IRQs *5 7 10 11)
> > ACPI: PCI Interrupt Link [LNKG] (IRQs *5 7 10 11)
> > ACPI: PCI Interrupt Link [LNKH] (IRQs *5 7 10 11)
> > usbcore: registered new driver usbfs
> > usbcore: registered new driver hub
> > PCI: Using ACPI for IRQ routing
> > GSI 16 sharing vector 0xA9 and IRQ 16
> > ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 169
> > ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 16 (level, low) -> IRQ 169
> > ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 169
> > GSI 17 sharing vector 0xB1 and IRQ 17
> > ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 177
> > GSI 18 sharing vector 0xB9 and IRQ 18
> > ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 185
> > ACPI: PCI Interrupt 0000:00:1d.3[A] -> GSI 16 (level, low) -> IRQ 169
> > GSI 19 sharing vector 0xC1 and IRQ 19
> > ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 193
> > ACPI: PCI interrupt 0000:00:1f.1[A]: no GSI
> > GSI 20 sharing vector 0xC9 and IRQ 20
> > ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 25 (level, low) -> IRQ 201
> > GSI 21 sharing vector 0xD1 and IRQ 21
> > ACPI: PCI Interrupt 0000:03:01.1[B] -> GSI 26 (level, low) -> IRQ 209
> > GSI 22 sharing vector 0xD9 and IRQ 22
> > ACPI: PCI Interrupt 0000:04:03.0[A] -> GSI 51 (level, low) -> IRQ 217
> > GSI 23 sharing vector 0xE1 and IRQ 23
> > ACPI: PCI Interrupt 0000:06:02.0[A] -> GSI 78 (level, low) -> IRQ 225
> > GSI 24 sharing vector 0xE9 and IRQ 24
> > ACPI: PCI Interrupt 0000:07:04.0[A] -> GSI 74 (level, low) -> IRQ 233
> > GSI 25 sharing vector 0x32 and IRQ 25
> > ACPI: PCI Interrupt 0000:07:05.0[A] -> GSI 73 (level, low) -> IRQ 50
> > GSI 26 sharing vector 0x3A and IRQ 26
> > ACPI: PCI Interrupt 0000:0a:01.0[A] -> GSI 97 (level, low) -> IRQ 58
> > GSI 27 sharing vector 0x42 and IRQ 27
> > ACPI: PCI Interrupt 0000:0a:01.1[B] -> GSI 98 (level, low) -> IRQ 66
> > GSI 28 sharing vector 0x4A and IRQ 28
> > ACPI: PCI Interrupt 0000:01:04.0[A] -> GSI 21 (level, low) -> IRQ 74
> > GSI 29 sharing vector 0x52 and IRQ 29
> > ACPI: PCI Interrupt 0000:01:04.2[B] -> GSI 22 (level, low) -> IRQ 82
> > PCI-DMA: Disabling IOMMU.
> > IA32 emulation $Id: sys_ia32.c,v 1.32 2002/03/24 13:02:28 ak Exp $
> > audit: initializing netlink socket (disabled)
> > audit(1201791896.599:1): initialized
> > Total HugeTLB memory allocated, 0
> > VFS: Disk quotas dquot_6.5.1
> > Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> > SELinux:  Registering netfilter hooks
> > Initializing Cryptographic API
> > ksign: Installing public key data
> > Loading keyring
> > - Added public key B7CA3C9BE2FAFC39
> > - User ID: Red Hat, Inc. (Kernel Module GPG key)
> > pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> > ACPI: Processor [CPU0] (supports C1)
> > ACPI: Processor [CPU1] (supports C1)
> > ACPI: Processor [CPU2] (supports C1)
> > ACPI: Processor [CPU3] (supports C1)
> > ACPI: Thermal Zone [THM0] (8 C)
> > Real Time Clock Driver v1.12
> > Linux agpgart interface v0.100 (c) Dave Jones
> > serio: i8042 AUX port at 0x60,0x64 irq 12
> > serio: i8042 KBD port at 0x60,0x64 irq 1
> > Serial: 8250/16550 driver $Revision: 1.90 $ 68 ports, IRQ sharing
> enabled
> > ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> > ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> > RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
> > divert: not allocating divert_blk for non-ethernet device lo
> > Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> > ide: Assuming 33MHz system bus speed for PIO modes; override with
> idebus=xx
> > ICH5: IDE controller at PCI slot 0000:00:1f.1
> > PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
> > ACPI: PCI interrupt 0000:00:1f.1[A]: no GSI
> > ICH5: chipset revision 2
> > ICH5: not 100% native mode: will probe irqs later
> >     ide0: BM-DMA at 0x0500-0x0507, BIOS settings: hda:DMA, hdb:pio
> >     ide1: BM-DMA at 0x0508-0x050f, BIOS settings: hdc:pio, hdd:pio
> > Probing IDE interface ide0...
> > hda: DV-28E-N, ATAPI CD/DVD-ROM drive
> > Using cfq io scheduler
> > ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> > Probing IDE interface ide1...
> > Probing IDE interface ide1...
> > Probing IDE interface ide2...
> > Probing IDE interface ide3...
> > Probing IDE interface ide4...
> > Probing IDE interface ide5...
> > hda: ATAPI 24X DVD-ROM drive, 256kB Cache, UDMA(33)
> > Uniform CD-ROM driver Revision: 3.20
> > ide-floppy driver 0.99.newide
> > usbcore: registered new driver hiddev
> > usbcore: registered new driver usbhid
> > drivers/usb/input/hid-core.c: v2.0:USB HID core driver
> > mice: PS/2 mouse device common for all mice
> > input: AT Translated Set 2 keyboard on isa0060/serio0
> > input: PS/2 Generic Mouse on isa0060/serio1
> > md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
> > NET: Registered protocol family 2
> > IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
> > TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
> > TCP bind hash table entries: 262144 (order: 10, 4194304 bytes)
> > TCP: Hash tables configured (established 262144 bind 262144)
> > Initializing IPsec netlink socket
> > NET: Registered protocol family 1
> > NET: Registered protocol family 17
> > cpufreq: CPU0 - ACPI performance management activated.
> > cpufreq: *P0: 3400 MHz, 103000 mW, 100 uS
> > cpufreq:  P1: 2800 MHz, 77469 mW, 100 uS
> > cpufreq: CPU1 - ACPI performance management activated.
> > cpufreq: *P0: 3400 MHz, 103000 mW, 100 uS
> > cpufreq:  P1: 2800 MHz, 77469 mW, 100 uS
> > cpufreq: CPU2 - ACPI performance management activated.
> > cpufreq: *P0: 3400 MHz, 103000 mW, 100 uS
> > cpufreq:  P1: 2800 MHz, 77469 mW, 100 uS
> > cpufreq: CPU3 - ACPI performance management activated.
> > cpufreq: *P0: 3400 MHz, 103000 mW, 100 uS
> > cpufreq:  P1: 2800 MHz, 77469 mW, 100 uS
> > ACPI wakeup devices:
> > 
> > ACPI: (supports S0 S4 S5)
> > Freeing unused kernel memory: 208k freed
> > SCSI subsystem initialized
> > HP CISS Driver (v 2.6.14.RH2)
> > cciss: Device 0x46 has been found at bus 4 dev 3 func 0
> > ACPI: PCI Interrupt 0000:04:03.0[A] -> GSI 51 (level, low) -> IRQ 217
> > cciss: using DAC cycles
> >       blocks= 71122559 block_size= 512
> >       heads= 255, sectors= 32, cylinders= 8716
> > 
> >       blocks= 71122559 block_size= 512
> >       heads= 255, sectors= 32, cylinders= 8716
> > 
> >       blocks= 71122559 block_size= 512
> >       heads= 255, sectors= 32, cylinders= 8716
> > 
> >  cciss/c0d0: p1 p2
> >       blocks= 71122559 block_size= 512
> >       heads= 255, sectors= 32, cylinders= 8716
> > 
> >  cciss/c0d1: unknown partition table
> > device-mapper: 4.5.5-ioctl (2006-12-01) initialised:
> dm-devel@redhat.com
> > hda: packet command error: status=0x51 { DriveReady SeekComplete Error
> }
> > hda: packet command error: error=0x50
> > ide: failed opcode was 100
> > cdrom: open failed.
> > kjournald starting.  Commit interval 5 seconds
> > EXT3-fs: mounted filesystem with ordered data mode.
> > security:  3 users, 4 roles, 355 types, 26 bools
> > security:  55 classes, 22610 rules
> > SELinux:  Completing initialization.
> > SELinux:  Setting up existing superblocks.
> > SELinux: initialized (dev dm-0, type ext3), uses xattr
> > SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> > SELinux: initialized (dev selinuxfs, type selinuxfs), uses
> genfs_contexts
> > SELinux: initialized (dev mqueue, type mqueue), not configured for
> labeling
> > SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses
> genfs_contexts
> > SELinux: initialized (dev devpts, type devpts), uses transition SIDs
> > SELinux: initialized (dev eventpollfs, type eventpollfs), uses
> genfs_contexts
> > SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
> > SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> > SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
> > SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
> > SELinux: initialized (dev proc, type proc), uses genfs_contexts
> > SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
> > SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
> > SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
> > SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
> > libata version 2.00 loaded.
> > Emulex LightPulse Fibre Channel SCSI driver 8.0.16.27
> > Copyright(c) 2003-2006 Emulex.  All rights reserved.
> > ACPI: PCI Interrupt 0000:06:02.0[A] -> GSI 78 (level, low) -> IRQ 225
> > lpfc 0000:06:02.0: 0:1303 Link Up Event x1 received Data: x1 xf7 x8 x0
> > scsi0 : Emulex LP9002L-F2 2Gb PCI Fibre Channel Adapter on PCI bus 06
> device 10 irq 225
> > ACPI: PCI Interrupt 0000:07:04.0[A] -> GSI 74 (level, low) -> IRQ 233
> > lpfc 0000:07:04.0: 1:1303 Link Up Event x1 received Data: x1 xf7 x8 x0
> > scsi1 : Emulex LP9002 2Gb PCI Fibre Channel Adapter on PCI bus 07
> device 20 irq 233
> >   Vendor: HP        Model: OPEN-E            Rev: 2114
> >   Type:   Direct-Access                      ANSI SCSI revision: 02
> > SCSI device sda: 28452960 512-byte hdwr sectors (14568 MB)
> > SCSI device sda: drive cache: write back
> > SCSI device sda: 28452960 512-byte hdwr sectors (14568 MB)
> > SCSI device sda: drive cache: write back
> >  sda: sda1
> > Attached scsi disk sda at scsi1, channel 0, id 0, lun 0
> >   Vendor: HP        Model: OPEN-E            Rev: 2114
> >   Type:   Direct-Access                      ANSI SCSI revision: 02
> > SCSI device sdb: 28452960 512-byte hdwr sectors (14568 MB)
> > SCSI device sdb: drive cache: write back
> > SCSI device sdb: 28452960 512-byte hdwr sectors (14568 MB)
> > SCSI device sdb: drive cache: write back
> >  sdb: unknown partition table
> > Attached scsi disk sdb at scsi1, channel 0, id 0, lun 1
> >   Vendor: HP        Model: OPEN-E            Rev: 2114
> >   Type:   Direct-Access                      ANSI SCSI revision: 02
> > SCSI device sdc: 28452960 512-byte hdwr sectors (14568 MB)
> > SCSI device sdc: drive cache: write back
> > SCSI device sdc: 28452960 512-byte hdwr sectors (14568 MB)
> > SCSI device sdc: drive cache: write back
> >  sdc: unknown partition table
> > Attached scsi disk sdc at scsi1, channel 0, id 0, lun 2
> >   Vendor: HP        Model: OPEN-E            Rev: 2114
> >   Type:   Direct-Access                      ANSI SCSI revision: 02
> > SCSI device sdd: 28452960 512-byte hdwr sectors (14568 MB)
> > SCSI device sdd: drive cache: write back
> > SCSI device sdd: 28452960 512-byte hdwr sectors (14568 MB)
> > SCSI device sdd: drive cache: write back
> >  sdd: unknown partition table
> > Attached scsi disk sdd at scsi1, channel 0, id 0, lun 3
> > ACPI: PCI Interrupt 0000:07:05.0[A] -> GSI 73 (level, low) -> IRQ 50
> > Losing some ticks... checking if CPU frequency changed.
> > lpfc 0000:07:05.0: 2:1303 Link Up Event x1 received Data: x1 xf7 x8 x0
> > scsi2 : Emulex LP9002 2Gb PCI Fibre Channel Adapter on PCI bus 07
> device 28 irq 50
> >   Vendor: HP        Model: OPEN-E            Rev: 2114
> >   Type:   Direct-Access                      ANSI SCSI revision: 02
> > SCSI device sde: 28452960 512-byte hdwr sectors (14568 MB)
> > SCSI device sde: drive cache: write back
> > SCSI device sde: 28452960 512-byte hdwr sectors (14568 MB)
> > SCSI device sde: drive cache: write back
> >  sde: sde1
> > Attached scsi disk sde at scsi2, channel 0, id 0, lun 0
> >   Vendor: HP        Model: OPEN-E            Rev: 2114
> >   Type:   Direct-Access                      ANSI SCSI revision: 02
> > SCSI device sdf: 28452960 512-byte hdwr sectors (14568 MB)
> > SCSI device sdf: drive cache: write back
> > SCSI device sdf: 28452960 512-byte hdwr sectors (14568 MB)
> > SCSI device sdf: drive cache: write back
> >  sdf: unknown partition table
> > Attached scsi disk sdf at scsi2, channel 0, id 0, lun 1
> >   Vendor: HP        Model: OPEN-E            Rev: 2114
> >   Type:   Direct-Access                      ANSI SCSI revision: 02
> > SCSI device sdg: 28452960 512-byte hdwr sectors (14568 MB)
> > SCSI device sdg: drive cache: write back
> > SCSI device sdg: 28452960 512-byte hdwr sectors (14568 MB)
> > SCSI device sdg: drive cache: write back
> >  sdg: unknown partition table
> > Attached scsi disk sdg at scsi2, channel 0, id 0, lun 2
> >   Vendor: HP        Model: OPEN-E            Rev: 2114
> >   Type:   Direct-Access                      ANSI SCSI revision: 02
> > SCSI device sdh: 28452960 512-byte hdwr sectors (14568 MB)
> > SCSI device sdh: drive cache: write back
> > SCSI device sdh: 28452960 512-byte hdwr sectors (14568 MB)
> > SCSI device sdh: drive cache: write back
> >  sdh: unknown partition table
> > Attached scsi disk sdh at scsi2, channel 0, id 0, lun 3
> > inserting floppy driver for 2.6.9-55.ELsmp
> > Floppy drive(s): fd0 is 1.44M
> > FDC 0 is a National Semiconductor PC87306
> > Intel(R) PRO/1000 Network Driver - version 7.2.7-k2-NAPI
> > Copyright (c) 1999-2006 Intel Corporation.
> > ACPI: PCI Interrupt 0000:0a:01.0[A] -> GSI 97 (level, low) -> IRQ 58
> > e1000: 0000:0a:01.0: e1000_probe: (PCI-X:133MHz:64-bit)
> 00:11:0a:64:7e:da
> > divert: allocating divert_blk for eth0
> > e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
> > ACPI: PCI Interrupt 0000:0a:01.1[B] -> GSI 98 (level, low) -> IRQ 66
> > e1000: 0000:0a:01.1: e1000_probe: (PCI-X:133MHz:64-bit)
> 00:11:0a:64:7e:db
> > divert: allocating divert_blk for eth1
> > e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
> > tg3.c:v3.64-rh (July 31, 2006)
> > ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 25 (level, low) -> IRQ 201
> > divert: allocating divert_blk for eth2
> > eth2: Tigon3 [partno(N/A) rev 2100 PHY(5704)] (PCIX:133MHz:64-bit)
> 10/100/1000BaseT Ethernet 00:14:38:bf:5a:51
> > eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] Split[0] WireSpeed[1]
> TSOcap[0]
> > eth2: dma_rwctrl[769f4000] dma_mask[64-bit]
> > ACPI: PCI Interrupt 0000:03:01.1[B] -> GSI 26 (level, low) -> IRQ 209
> > divert: allocating divert_blk for eth3
> > eth3: Tigon3 [partno(N/A) rev 2100 PHY(5704)] (PCIX:133MHz:64-bit)
> 10/100/1000BaseT Ethernet 00:14:38:bf:5a:50
> > eth3: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1]
> TSOcap[1]
> > eth3: dma_rwctrl[769f4000] dma_mask[64-bit]
> > shpchp: acpi_shpchprm:\_SB_.PCI0 evaluate _BBN fail=0x5
> > shpchp: acpi_shpchprm:get_device PCI ROOT HID fail=0x5
> > shpchp: acpi_shpchprm:\_SB_.PCI0 evaluate _BBN fail=0x5
> > shpchp: acpi_shpchprm:get_device PCI ROOT HID fail=0x5
> > shpchp: acpi_shpchprm:\_SB_.PCI0 evaluate _BBN fail=0x5
> > shpchp: acpi_shpchprm:get_device PCI ROOT HID fail=0x5
> > shpchp: acpi_shpchprm:\_SB_.PCI0 evaluate _BBN fail=0x5
> > shpchp: acpi_shpchprm:get_device PCI ROOT HID fail=0x5
> > shpchp: acpi_shpchprm:\_SB_.PCI0 evaluate _BBN fail=0x5
> > shpchp: acpi_shpchprm:get_device PCI ROOT HID fail=0x5
> > hw_random hardware driver 1.0.0 loaded
> > shpchp: acpi_shpchprm:\_SB_.PCI0 evaluate _BBN fail=0x5
> > shpchp: acpi_shpchprm:get_device PCI ROOT HID fail=0x5
> > shpchp: acpi_shpchprm:\_SB_.PCI0 evaluate _BBN fail=0x5
> > shpchp: acpi_shpchprm:get_device PCI ROOT HID fail=0x5
> > ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 193
> > ehci_hcd 0000:00:1d.7: EHCI Host Controller
> > PCI: Setting latency timer of device 0000:00:1d.7 to 64
> > ehci_hcd 0000:00:1d.7: irq 193, pci mem ffffff0010086000
> > SELinux: initialized (dev usbdevfs, type usbdevfs), uses
> genfs_contexts
> > ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
> > PCI: cache line size of 128 is not supported by device 0000:00:1d.7
> > ehci_hcd 0000:00:1d.7: USB 2.0 enabled, EHCI 1.00, driver 2004-May-10
> > hub 1-0:1.0: USB hub found
> > hub 1-0:1.0: 8 ports detected
> > USB Universal Host Controller Interface driver v2.2
> > ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 169
> > uhci_hcd 0000:00:1d.0: UHCI Host Controller
> > PCI: Setting latency timer of device 0000:00:1d.0 to 64
> > uhci_hcd 0000:00:1d.0: irq 169, io base 0000000000002000
> > uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
> > hub 2-0:1.0: USB hub found
> > hub 2-0:1.0: 2 ports detected
> > ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 177
> > uhci_hcd 0000:00:1d.1: UHCI Host Controller
> > PCI: Setting latency timer of device 0000:00:1d.1 to 64
> > uhci_hcd 0000:00:1d.1: irq 177, io base 0000000000002020
> > uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
> > hub 3-0:1.0: USB hub found
> > hub 3-0:1.0: 2 ports detected
> > ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 185
> > uhci_hcd 0000:00:1d.2: UHCI Host Controller
> > PCI: Setting latency timer of device 0000:00:1d.2 to 64
> > uhci_hcd 0000:00:1d.2: irq 185, io base 0000000000002040
> > uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
> > hub 4-0:1.0: USB hub found
> > hub 4-0:1.0: 2 ports detected
> > ACPI: PCI Interrupt 0000:00:1d.3[A] -> GSI 16 (level, low) -> IRQ 169
> > uhci_hcd 0000:00:1d.3: UHCI Host Controller
> > PCI: Setting latency timer of device 0000:00:1d.3 to 64
> > uhci_hcd 0000:00:1d.3: irq 169, io base 0000000000002060
> > uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
> > hub 5-0:1.0: USB hub found
> > hub 5-0:1.0: 2 ports detected
> > md: Autodetecting RAID arrays.
> > md: autorun ...
> > md: ... autorun DONE.
> > ACPI: Power Button (FF) [PWRF]
> > EXT3 FS on dm-0, internal journal
> > device-mapper: dm-multipath version 1.0.5 loaded
> > device-mapper: dm-round-robin version 1.0.0 loaded
> > kjournald starting.  Commit interval 5 seconds
> > EXT3 FS on cciss/c0d0p1, internal journal
> > EXT3-fs: mounted filesystem with ordered data mode.
> > SELinux: initialized (dev cciss/c0d0p1, type ext3), uses xattr
> > SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> > kjournald starting.  Commit interval 5 seconds
> > EXT3 FS on dm-1, internal journal
> > EXT3-fs: mounted filesystem with ordered data mode.
> > SELinux: initialized (dev dm-1, type ext3), uses xattr
> > kjournald starting.  Commit interval 5 seconds
> > EXT3 FS on dm-2, internal journal
> > EXT3-fs: mounted filesystem with ordered data mode.
> > SELinux: initialized (dev dm-2, type ext3), uses xattr
> > kjournald starting.  Commit interval 5 seconds
> > EXT3 FS on dm-3, internal journal
> > EXT3-fs: mounted filesystem with ordered data mode.
> > SELinux: initialized (dev dm-3, type ext3), uses xattr
> > kjournald starting.  Commit interval 5 seconds
> > EXT3 FS on dm-4, internal journal
> > EXT3-fs: mounted filesystem with ordered data mode.
> > SELinux: initialized (dev dm-4, type ext3), uses xattr
> > kjournald starting.  Commit interval 5 seconds
> > EXT3 FS on dm-5, internal journal
> > EXT3-fs: mounted filesystem with ordered data mode.
> > SELinux: initialized (dev dm-5, type ext3), uses xattr
> > kjournald starting.  Commit interval 5 seconds
> > EXT3 FS on dm-6, internal journal
> > EXT3-fs: mounted filesystem with ordered data mode.
> > SELinux: initialized (dev dm-6, type ext3), uses xattr
> > Adding 2097144k swap on /dev/vg00/swap1.  Priority:-1 extents:1
> > SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses
> genfs_contexts
> > IA-32 Microcode Update Driver: v1.14 <tigran@veritas.com>
> > microcode: CPU0 already at revision 0x12 (current=0x12)
> > microcode: CPU1 already at revision 0x12 (current=0x12)
> > microcode: CPU2 already at revision 0x12 (current=0x12)
> > microcode: CPU3 already at revision 0x12 (current=0x12)
> > microcode: No new microdata for cpu 1
> > microcode: No new microdata for cpu 2
> > microcode: No new microdata for cpu 0
> > microcode: No new microdata for cpu 3
> > IA-32 Microcode Update Driver v1.14 unregistered
> > ip_tables: (C) 2000-2002 Netfilter core team
> > ip_conntrack version 2.1 (8192 buckets, 65536 max) - 456 bytes per
> conntrack
> > e1000: eth1: e1000_watchdog_task: NIC Link is Up 100 Mbps Half Duplex
> > i2c /dev entries driver
> > NET: Registered protocol family 10
> > Disabled Privacy Extensions on device ffffffff80408540(lo)
> > IPv6 over IPv4 tunneling driver
> > divert: not allocating divert_blk for non-ethernet device sit0
> > eth1: no IPv6 routers present
> > 
> > 
> > # cat /var/log/boot.log
> > Jan 31 15:02:31 corux38 syslog: syslogd startup succeeded
> > Jan 31 15:02:31 corux38 syslog: klogd startup succeeded
> > Jan 31 15:02:31 corux38 irqbalance: irqbalance startup succeeded
> > Jan 31 15:02:31 corux38 multipathd: multipathd startup succeeded
> > Jan 31 15:02:31 corux38 portmap: portmap startup succeeded
> > Jan 31 15:02:32 corux38 rc: Starting lm_sensors:  succeeded
> > Jan 31 15:02:32 corux38 xinetd: xinetd startup succeeded
> > Jan 31 15:02:32 corux38 ntpd: ntpd startup succeeded
> > Jan 31 15:02:32 corux38 vsftpd: vsftpd vsftpd succeeded
> > Jan 31 15:02:33 corux38 ssh-server-g3: Starting ssh-server-g3
> > Jan 31 10:01:59 corux38 rc.sysinit: -e
> > Jan 31 10:02:01 corux38 start_udev: Starting udev:  succeeded
> > Jan 31 10:02:25 corux38 rc.sysinit: -e
> > Jan 31 10:02:25 corux38 sysctl: net.ipv4.ip_forward = 0
> > Jan 31 10:02:25 corux38 sysctl: net.ipv4.conf.default.rp_filter = 1
> > Jan 31 10:02:25 corux38 sysctl:
> net.ipv4.conf.default.accept_source_route = 0
> > Jan 31 10:02:25 corux38 sysctl: kernel.sysrq = 0
> > Jan 31 10:02:25 corux38 sysctl: kernel.core_uses_pid = 1
> > Jan 31 10:02:25 corux38 sysctl: net.ipv4.conf.all.accept_source_route
> = 0
> > Jan 31 10:02:25 corux38 sysctl: net.ipv4.tcp_max_syn_backlog = 4096
> > Jan 31 10:02:25 corux38 sysctl: net.ipv4.conf.all.rp_filter = 1
> > Jan 31 10:02:25 corux38 sysctl: net.ipv4.tcp_syncookies = 1
> > Jan 31 10:02:25 corux38 sysctl: net.ipv4.conf.all.accept_redirects = 0
> > Jan 31 10:02:25 corux38 sysctl: net.ipv4.conf.default.accept_redirects
> = 0
> > Jan 31 10:02:25 corux38 sysctl: fs.file-max = 524288
> > Jan 31 10:02:25 corux38 sysctl: kernel.sem = 1024 32000 32 4096
> > Jan 31 10:02:25 corux38 rc.sysinit: Configuring kernel parameters:
> succeeded
> > Jan 31 15:02:26 corux38 date: Thu Jan 31 15:02:26 EST 2008
> > Jan 31 15:02:26 corux38 rc.sysinit: Setting clock  (localtime): Thu
> Jan 31 15:02:26 EST 2008 succeeded
> > Jan 31 15:02:26 corux38 rc.sysinit: Loading default keymap succeeded
> > Jan 31 15:02:26 corux38 rc.sysinit: Setting hostname corux38:
> succeeded
> > Jan 31 15:02:26 corux38 fsck: /dev/vg00/root: clean, 4335/131072
> files, 48559/262144 blocks
> > Jan 31 15:02:26 corux38 rc.sysinit: Checking root filesystem succeeded
> > Jan 31 15:02:26 corux38 rc.sysinit: Remounting root filesystem in
> read-write mode:  succeeded
> > Jan 31 15:02:26 corux38 lvm.static:   8 logical volume(s) in volume
> group vg00 now active
> > Jan 31 15:02:26 corux38 rc.sysinit: Setting up Logical Volume
> Management: succeeded
> > Jan 31 15:02:26 corux38 fsck: /boot: clean, 38/26104 files,
> 17822/104388 blocks
> > Jan 31 15:02:26 corux38 fsck: /dev/vg00/home: clean, 132/262144 files,
> 20580/524288 blocks
> > Jan 31 15:02:27 corux38 fsck: /dev/vg00/opt: clean, 83/524288 files,
> 36957/1048576 blocks
> > Jan 31 15:02:27 corux38 fsck: /dev/vg00/tmp: clean, 34/131072 files,
> 13541/262144 blocks
> > Jan 31 15:02:27 corux38 fsck: /dev/vg00/usr: clean, 30250/524288
> files, 169645/1048576 blocks
> > Jan 31 15:02:27 corux38 fsck: /dev/vg00/usrlocal: clean, 46/270368
> files, 17525/540672 blocks
> > Jan 31 15:02:27 corux38 fsck: /dev/vg00/var: clean, 395/1048576 files,
> 49124/2097152 blocks
> > Jan 31 15:02:27 corux38 rc.sysinit: Checking filesystems succeeded
> > Jan 31 15:02:27 corux38 rc.sysinit: Mounting local filesystems:
> succeeded
> > Jan 31 15:02:27 corux38 rc.sysinit: Enabling swap space:  succeeded
> > Jan 31 15:02:28 corux38 microcode_ctl: microcode_ctl startup succeeded
> > Jan 31 15:02:36 corux38 ssh-server-g3: done.
> > Jan 31 15:02:28 corux38 vgchange:   8 logical volume(s) in volume
> group "vg00" monitored
> > Jan 31 15:02:36 corux38 rc: Starting ssh-server-g3:  succeeded
> > Jan 31 15:02:28 corux38 lvm2-monitor: Starting monitoring for VG vg00:
> succeeded
> > Jan 31 15:02:36 corux38 crond: crond startup succeeded
> > Jan 31 15:02:28 corux38 cpuspeed: cpuspeed startup succeeded
> > Jan 31 15:02:28 corux38 iptables:  succeeded
> > Jan 31 15:02:36 corux38 atd: atd startup succeeded
> > Jan 31 15:02:29 corux38 sysctl: net.ipv4.ip_forward = 0
> > Jan 31 15:02:29 corux38 sysctl: net.ipv4.conf.default.rp_filter = 1
> > Jan 31 15:02:36 corux38 messagebus: messagebus startup succeeded
> > Jan 31 15:02:29 corux38 sysctl:
> net.ipv4.conf.default.accept_source_route = 0
> > Jan 31 15:02:29 corux38 sysctl: kernel.sysrq = 0
> > Jan 31 15:02:29 corux38 sysctl: kernel.core_uses_pid = 1
> > Jan 31 15:02:36 corux38 haldaemon: haldaemon startup succeeded
> > Jan 31 15:02:29 corux38 sysctl: net.ipv4.conf.all.accept_source_route
> = 0
> > Jan 31 15:02:29 corux38 sysctl: net.ipv4.tcp_max_syn_backlog = 4096
> > Jan 31 15:02:29 corux38 sysctl: net.ipv4.conf.all.rp_filter = 1
> > Jan 31 15:02:29 corux38 sysctl: net.ipv4.tcp_syncookies = 1
> > Jan 31 15:02:29 corux38 sysctl: net.ipv4.conf.all.accept_redirects = 0
> > Jan 31 15:02:29 corux38 sysctl: net.ipv4.conf.default.accept_redirects
> = 0
> > Jan 31 15:02:29 corux38 sysctl: fs.file-max = 524288
> > Jan 31 15:02:29 corux38 sysctl: kernel.sem = 1024 32000 32 4096
> > Jan 31 15:02:29 corux38 network: Setting network parameters:
> succeeded
> > Jan 31 15:02:29 corux38 network: Bringing up loopback interface:
> succeeded
> > Jan 31 15:02:31 corux38 network: Bringing up interface eth1:
> succeeded
> > Jan 31 15:03:08 corux38 haldaemon: haldaemon -TERM succeeded
> > Jan 31 15:03:08 corux38 messagebus: messagebus -TERM succeeded
> > Jan 31 15:03:08 corux38 atd: atd shutdown succeeded
> > Jan 31 15:03:09 corux38 vsftpd: vsftpd shutdown succeeded
> > Jan 31 15:03:09 corux38 xinetd: xinetd shutdown succeeded
> > Jan 31 15:03:09 corux38 crond: crond shutdown succeeded
> > Jan 31 15:03:09 corux38 ntpd: ntpd shutdown succeeded
> > Jan 31 15:03:09 corux38 irqbalance: irqbalance shutdown succeeded
> > Jan 31 15:03:09 corux38 multipathd: multipathd shutdown succeeded
> > Jan 31 15:03:09 corux38 portmap: portmap shutdown succeeded
> > Jan 31 15:05:36 corux38 syslog: syslogd startup succeeded
> > Jan 31 15:05:36 corux38 syslog: klogd startup succeeded
> > Jan 31 15:05:37 corux38 irqbalance: irqbalance startup succeeded
> > Jan 31 15:05:37 corux38 multipathd: multipathd startup succeeded
> > Jan 31 15:05:37 corux38 portmap: portmap startup succeeded
> > Jan 31 15:05:37 corux38 rc: Starting lm_sensors:  succeeded
> > Jan 31 15:05:37 corux38 xinetd: xinetd startup succeeded
> > Jan 31 15:05:37 corux38 ntpd: ntpd startup succeeded
> > Jan 31 15:05:38 corux38 vsftpd: vsftpd vsftpd succeeded
> > Jan 31 15:05:38 corux38 ssh-server-g3: Starting ssh-server-g3
> > Jan 31 10:05:03 corux38 rc.sysinit: -e
> > Jan 31 10:05:05 corux38 start_udev: Starting udev:  succeeded
> > Jan 31 10:05:29 corux38 rc.sysinit: -e
> > Jan 31 10:05:29 corux38 sysctl: net.ipv4.ip_forward = 0
> > Jan 31 10:05:29 corux38 sysctl: net.ipv4.conf.default.rp_filter = 1
> > Jan 31 10:05:29 corux38 sysctl:
> net.ipv4.conf.default.accept_source_route = 0
> > Jan 31 10:05:29 corux38 sysctl: kernel.sysrq = 0
> > Jan 31 10:05:29 corux38 sysctl: kernel.core_uses_pid = 1
> > Jan 31 10:05:29 corux38 sysctl: net.ipv4.conf.all.accept_source_route
> = 0
> > Jan 31 10:05:29 corux38 sysctl: net.ipv4.tcp_max_syn_backlog = 4096
> > Jan 31 10:05:29 corux38 sysctl: net.ipv4.conf.all.rp_filter = 1
> > Jan 31 10:05:29 corux38 sysctl: net.ipv4.tcp_syncookies = 1
> > Jan 31 10:05:29 corux38 sysctl: net.ipv4.conf.all.accept_redirects = 0
> > Jan 31 10:05:29 corux38 sysctl: net.ipv4.conf.default.accept_redirects
> = 0
> > Jan 31 10:05:29 corux38 sysctl: fs.file-max = 524288
> > Jan 31 10:05:29 corux38 sysctl: kernel.sem = 1024 32000 32 4096
> > Jan 31 10:05:29 corux38 rc.sysinit: Configuring kernel parameters:
> succeeded
> > Jan 31 15:05:30 corux38 date: Thu Jan 31 15:05:30 EST 2008
> > Jan 31 15:05:30 corux38 rc.sysinit: Setting clock  (localtime): Thu
> Jan 31 15:05:30 EST 2008 succeeded
> > Jan 31 15:05:30 corux38 rc.sysinit: Loading default keymap succeeded
> > Jan 31 15:05:30 corux38 rc.sysinit: Setting hostname corux38:
> succeeded
> > Jan 31 15:05:30 corux38 fsck: /dev/vg00/root: clean, 4335/131072
> files, 48559/262144 blocks
> > Jan 31 15:05:30 corux38 rc.sysinit: Checking root filesystem succeeded
> > Jan 31 15:05:30 corux38 rc.sysinit: Remounting root filesystem in
> read-write mode:  succeeded
> > Jan 31 15:05:30 corux38 lvm.static:   8 logical volume(s) in volume
> group vg00 now active
> > Jan 31 15:05:30 corux38 rc.sysinit: Setting up Logical Volume
> Management: succeeded
> > Jan 31 15:05:30 corux38 fsck: /boot: clean, 38/26104 files,
> 17822/104388 blocks
> > Jan 31 15:05:30 corux38 fsck: /dev/vg00/home: clean, 132/262144 files,
> 20580/524288 blocks
> > Jan 31 15:05:30 corux38 fsck: /dev/vg00/opt: clean, 83/524288 files,
> 36957/1048576 blocks
> > Jan 31 15:05:30 corux38 fsck: /dev/vg00/tmp: clean, 34/131072 files,
> 13541/262144 blocks
> > Jan 31 15:05:30 corux38 fsck: /dev/vg00/usr: clean, 30250/524288
> files, 169645/1048576 blocks
> > Jan 31 15:05:30 corux38 fsck: /dev/vg00/usrlocal: clean, 46/270368
> files, 17525/540672 blocks
> > Jan 31 15:05:31 corux38 fsck: /dev/vg00/var: clean, 395/1048576 files,
> 49141/2097152 blocks
> > Jan 31 15:05:31 corux38 rc.sysinit: Checking filesystems succeeded
> > Jan 31 15:05:31 corux38 rc.sysinit: Mounting local filesystems:
> succeeded
> > Jan 31 15:05:31 corux38 rc.sysinit: Enabling swap space:  succeeded
> > Jan 31 15:05:32 corux38 microcode_ctl: microcode_ctl startup succeeded
> > Jan 31 15:05:32 corux38 vgchange:   8 logical volume(s) in volume
> group "vg00" monitored
> > Jan 31 15:05:32 corux38 lvm2-monitor: Starting monitoring for VG vg00:
> succeeded
> > Jan 31 15:05:41 corux38 ssh-server-g3: done.
> > Jan 31 15:05:32 corux38 cpuspeed: cpuspeed startup succeeded
> > Jan 31 15:05:41 corux38 rc: Starting ssh-server-g3:  succeeded
> > Jan 31 15:05:32 corux38 iptables:  succeeded
> > Jan 31 15:05:32 corux38 sysctl: net.ipv4.ip_forward = 0
> > Jan 31 15:05:41 corux38 crond: crond startup succeeded
> > Jan 31 15:05:32 corux38 sysctl: net.ipv4.conf.default.rp_filter = 1
> > Jan 31 15:05:41 corux38 atd: atd startup succeeded
> > Jan 31 15:05:32 corux38 sysctl:
> net.ipv4.conf.default.accept_source_route = 0
> > Jan 31 15:05:32 corux38 sysctl: kernel.sysrq = 0
> > Jan 31 15:05:32 corux38 sysctl: kernel.core_uses_pid = 1
> > Jan 31 15:05:42 corux38 messagebus: messagebus startup succeeded
> > Jan 31 15:05:32 corux38 sysctl: net.ipv4.conf.all.accept_source_route
> = 0
> > Jan 31 15:05:32 corux38 sysctl: net.ipv4.tcp_max_syn_backlog = 4096
> > Jan 31 15:05:42 corux38 haldaemon: haldaemon startup succeeded
> > Jan 31 15:05:32 corux38 sysctl: net.ipv4.conf.all.rp_filter = 1
> > Jan 31 15:05:32 corux38 sysctl: net.ipv4.tcp_syncookies = 1
> > Jan 31 15:05:32 corux38 sysctl: net.ipv4.conf.all.accept_redirects = 0
> > Jan 31 15:05:32 corux38 sysctl: net.ipv4.conf.default.accept_redirects
> = 0
> > Jan 31 15:05:32 corux38 sysctl: fs.file-max = 524288
> > Jan 31 15:05:32 corux38 sysctl: kernel.sem = 1024 32000 32 4096
> > Jan 31 15:05:32 corux38 network: Setting network parameters:
> succeeded
> > Jan 31 15:05:32 corux38 network: Bringing up loopback interface:
> succeeded
> > Jan 31 15:05:36 corux38 network: Bringing up interface eth1:
> succeeded
> > 
> > 
> > # multipath -ll
> > mpath1 (00040026_05:84)
> > [size=13 GB][features="0"][hwhandler="0"]
> > \_ round-robin 0 [enabled]
> >  \_ 2:0:0:1 sdf 8:80  [active][ready]
> >  \_ 1:0:0:1 sdb 8:16  [active][ready]
> > 
> > mpath0 (00040026_05:83)
> > [size=13 GB][features="0"][hwhandler="0"]
> > \_ round-robin 0 [enabled]
> >  \_ 2:0:0:0 sde 8:64  [active][ready]
> >  \_ 1:0:0:0 sda 8:0   [active][ready]
> Content-Description: manual_run.txt
> 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

Content-Description: multipath_boot_log.txt
> %%
> %% running multipath from rc.sysinit
> %%
> load path identifiers cache
> ux_socket_connect error
> #
> # all paths in cache :
> #
> cciss!c0d0 blacklisted
> cciss!c0d1 blacklisted
> dm-0 blacklisted
> dm-1 blacklisted
> dm-2 blacklisted
> dm-3 blacklisted
> dm-4 blacklisted
> dm-5 blacklisted
> dm-6 blacklisted
> dm-7 blacklisted
> fd0 blacklisted
> hda blacklisted
> md0 blacklisted
> ram0 blacklisted
> ram10 blacklisted
> ram11 blacklisted
> ram12 blacklisted
> ram13 blacklisted
> ram14 blacklisted
> ram15 blacklisted
> ram1 blacklisted
> ram2 blacklisted
> ram3 blacklisted
> ram4 blacklisted
> ram5 blacklisted
> ram6 blacklisted
> ram7 blacklisted
> ram8 blacklisted
> ram9 blacklisted
> path sda not found in pathvec
> 
> ===== path info sda (mask 0x1f) =====
> bus = 1
> dev_t = 8:0
> size = 28452960
> vendor = HP      
> product = OPEN-E          
> rev = 2114
> h:b:t:l = 1:0:0:0
> tgt_node_name = 0x50060e80039c5a04
> serial = 40026 
> path checker = tur (controler setting)
> state = 2
> getprio = /bin/true (internal default)
> prio = 0
> getuid = /etc/xpdisk %n (controler setting)
> uid = 00040026_05:83 (callout)
> path sdb not found in pathvec
> 
> ===== path info sdb (mask 0x1f) =====
> bus = 1
> dev_t = 8:16
> size = 28452960
> vendor = HP      
> product = OPEN-E          
> rev = 2114
> h:b:t:l = 1:0:0:1
> tgt_node_name = 0x50060e80039c5a04
> serial = 40026 
> path checker = tur (controler setting)
> state = 2
> getprio = /bin/true (internal default)
> prio = 0
> getuid = /etc/xpdisk %n (controler setting)
> uid = 00040026_05:84 (callout)
> path sdc not found in pathvec
> 
> ===== path info sdc (mask 0x1f) =====
> bus = 1
> dev_t = 8:32
> size = 28452960
> vendor = HP      
> product = OPEN-E          
> rev = 2114
> h:b:t:l = 1:0:0:2
> tgt_node_name = 0x50060e80039c5a04
> serial = 40026 
> path checker = tur (controler setting)
> state = 2
> getprio = /bin/true (internal default)
> prio = 0
> getuid = /etc/xpdisk %n (controler setting)
> uid = 00040026_05:85 (callout)
> path sdd not found in pathvec
> 
> ===== path info sdd (mask 0x1f) =====
> bus = 1
> dev_t = 8:48
> size = 28452960
> vendor = HP      
> product = OPEN-E          
> rev = 2114
> h:b:t:l = 1:0:0:3
> tgt_node_name = 0x50060e80039c5a04
> serial = 40026 
> path checker = tur (controler setting)
> state = 2
> getprio = /bin/true (internal default)
> prio = 0
> getuid = /etc/xpdisk %n (controler setting)
> uid = 00040026_05:86 (callout)
> path sde not found in pathvec
> 
> ===== path info sde (mask 0x1f) =====
> bus = 1
> dev_t = 8:64
> size = 28452960
> vendor = HP      
> product = OPEN-E          
> rev = 2114
> h:b:t:l = 2:0:0:0
> tgt_node_name = 0x50060e80039c5a14
> path sdf not found in pathvec
> 
> ===== path info sdf (mask 0x1f) =====
> bus = 1
> dev_t = 8:80
> size = 28452960
> vendor = HP      
> product = OPEN-E          
> rev = 2114
> h:b:t:l = 2:0:0:1
> tgt_node_name = 0x50060e80039c5a14
> path sdg not found in pathvec
> 
> ===== path info sdg (mask 0x1f) =====
> bus = 1
> dev_t = 8:96
> size = 28452960
> vendor = HP      
> product = OPEN-E          
> rev = 2114
> h:b:t:l = 2:0:0:2
> tgt_node_name = 0x50060e80039c5a14
> path sdh not found in pathvec
> 
> ===== path info sdh (mask 0x1f) =====
> bus = 1
> dev_t = 8:112
> size = 28452960
> vendor = HP      
> product = OPEN-E          
> rev = 2114
> h:b:t:l = 2:0:0:3
> tgt_node_name = 0x50060e80039c5a14
> #
> # all paths :
> #
> 00040026_05:83  1:0:0:0 sda 8:0  [ready] HP      /OPEN-E          /2114
> 00040026_05:84  1:0:0:1 sdb 8:16  [ready] HP      /OPEN-E          /2114
> 00040026_05:85  1:0:0:2 sdc 8:32  [ready] HP      /OPEN-E          /2114
> 00040026_05:86  1:0:0:3 sdd 8:48  [ready] HP      /OPEN-E          /2114
>   2:0:0:0 sde 8:64  [faulty] HP      /OPEN-E          /2114
>   2:0:0:1 sdf 8:80  [faulty] HP      /OPEN-E          /2114
>   2:0:0:2 sdg 8:96  [faulty] HP      /OPEN-E          /2114
>   2:0:0:3 sdh 8:112  [faulty] HP      /OPEN-E          /2114
> Found matching wwid [00040026_05:83] in bindings file.
> Setting alias to mpath1
> pgpolicy = multibus (controler setting)
> selector = round-robin 0 (internal default)
> features = 0 (internal default)
> hwhandler = 0 (internal default)
> rr_weight = 2 (config file default)
> rr_min_io = 100 (config file default)
> no_path_retry = -1 (config file default)
> pg_timeout = NONE (internal default)
> 0 28452960 multipath 0 0 1 1 round-robin 0 1 1 8:0 100
> set ACT_CREATE: map does not exists
> message mpath1 0 switch_group 1
> 
> create: mpath1 (00040026_05:83)
> [size=13 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 
>  \_ 1:0:0:0 sda 8:0   [ready]
> 
> reloading features
> Found matching wwid [00040026_05:84] in bindings file.
> Setting alias to mpath2
> pgpolicy = multibus (controler setting)
> selector = round-robin 0 (internal default)
> features = 0 (internal default)
> hwhandler = 0 (internal default)
> rr_weight = 2 (config file default)
> rr_min_io = 100 (config file default)
> no_path_retry = -1 (config file default)
> pg_timeout = NONE (internal default)
> 0 28452960 multipath 0 0 1 1 round-robin 0 1 1 8:16 100
> set ACT_CREATE: map does not exists
> message mpath2 0 switch_group 1
> 
> create: mpath2 (00040026_05:84)
> [size=13 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 
>  \_ 1:0:0:1 sdb 8:16  [ready]
> 
> reloading features
> Found matching wwid [00040026_05:85] in bindings file.
> Setting alias to mpath3
> pgpolicy = multibus (controler setting)
> selector = round-robin 0 (internal default)
> features = 0 (internal default)
> hwhandler = 0 (internal default)
> rr_weight = 2 (config file default)
> rr_min_io = 100 (config file default)
> no_path_retry = -1 (config file default)
> pg_timeout = NONE (internal default)
> 0 28452960 multipath 0 0 1 1 round-robin 0 1 1 8:32 100
> set ACT_CREATE: map does not exists
> message mpath3 0 switch_group 1
> 
> create: mpath3 (00040026_05:85)
> [size=13 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 
>  \_ 1:0:0:2 sdc 8:32  [ready]
> 
> reloading features
> Found matching wwid [00040026_05:86] in bindings file.
> Setting alias to mpath4
> pgpolicy = multibus (controler setting)
> selector = round-robin 0 (internal default)
> features = 0 (internal default)
> hwhandler = 0 (internal default)
> rr_weight = 2 (config file default)
> rr_min_io = 100 (config file default)
> no_path_retry = -1 (config file default)
> pg_timeout = NONE (internal default)
> 0 28452960 multipath 0 0 1 1 round-robin 0 1 1 8:48 100
> set ACT_CREATE: map does not exists
> message mpath4 0 switch_group 1
> 
> create: mpath4 (00040026_05:86)
> [size=13 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 
>  \_ 1:0:0:3 sdd 8:48  [ready]
> 
> reloading features
> %%
> %% running multipath.dev
> %%
> add /block/sdh
> %%
> %% running multipath.dev
> %%
> add /block/md0
> %%
> %% running multipath.dev
> %%
> add /block/sdg
> %%
> %% running multipath.dev
> %%
> add /block/sde
> %%
> %% running multipath.dev
> %%
> add /block/dm-8
> %%
> %% running multipath.dev
> %%
> add /block/dm-9
> %%
> %% running multipath.dev
> %%
> add /block/dm-10
> %%
> %% running multipath.dev
> %%
> add /block/sdf
> %%
> %% running multipath.dev
> %%
> add /block/fd0
> %%
> %% running multipath.dev
> %%
> add /block/dm-11
> %%
> %% running multipath from rc.local
> %%
> create: mpath2 (00040026_05:85)
> [size=13 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 
>  \_ 1:0:0:2 sdc 8:32  [ready]
>  \_ 2:0:0:2 sdg 8:96  [ready]
> 
> %%
> %% running multipath.dev
> %%
> add /block/dm-10

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="always_wait.patch"

diff -urpN multipath-tools/libmultipath/discovery.c multipath-tools-patched/libmultipath/discovery.c
--- multipath-tools/libmultipath/discovery.c	2008-02-12 14:00:38.000000000 -0600
+++ multipath-tools-patched/libmultipath/discovery.c	2008-02-15 09:28:32.000000000 -0600
@@ -170,11 +170,6 @@ path_discovery (vector pathvec, struct c
 	return r;
 }
 
-/*
- * the daemon can race udev upon path add,
- * not multipath(8), ran by udev
- */
-#if DAEMON
 #define WAIT_MAX_SECONDS 5
 #define WAIT_LOOP_PER_SECOND 5
 
@@ -197,13 +192,6 @@ wait_for_file (char * filename)
 	}
 	return 1;
 }
-#else
-static int
-wait_for_file (char * filename)
-{
-	return 0;
-}
-#endif
 
 #define declare_sysfs_get_str(fname, fmt) \
 extern int \

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--4Ckj6UjgE2iN1+kY--
