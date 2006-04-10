From: "D. North" <rold5@tditx.com>
Subject: HSG80, DM, multipath issues
Date: Mon, 10 Apr 2006 12:42:10 -0500
Message-ID: <20060410174210.GA3798@tditx.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hi.

Note: this starts as a multipath issue, but I traced it into DM also, and
ultimately, this is a behavior problem with the HSG80's, I think.

I am unable to get SuSE 10 and my HSG80's successfully working with multipath.
I believe this is because the HSG80's are not reporting geometry information
on the standby path to each lun, but seeing as I'm pretty stumped, I'm hoping
someone's got a better explanation or even a workaround.

I'm stone-cold new on the fibrechannel stuff, so it's easily possible I've set
up my configuration incorrectly.... And also, the multipath and dm stuff is new
to me as well, so I could've also have made some mistakes there too...

Starting with configuration info:
  SuSE 10 intel 32 bit, kernel 2.6.13-15.8, Multipath-tools 0.4.4-4 (from
     SuSE .... multipath itself claims to be version 0.4.5!!!!)
  1 QLA2200F single-attach to a EMC DS-16B switch (firmware flashed
    to bios 1.83)
  DS-16B is attached to the storage array on ports 1 & 2 on EACH HSG80.
  A single LUN, D4 is defined, and is online to controller 2 and is the
     lun I'm working with .... currently booting off this lun as /dev/sdb
     /dev/sda is "sort of" there, but gives errors to almost anything that
     tries to touch it
  Connection paths are of type 'SUN' on the HSG80
  HSG80 version V87F-7 configured MULTIBUS_FAILOVER, SCSI-3

Observed behavior is that the multipath tools do not accept the standby
path from the HSG, claiming a size mismatch. ... scsi inquiries are evidently
OK on standby for ident & existence, but geometry requests fail. shown below
after the output of the multipath command:

  # multipath -v3 -d
  :  (blacklists omitted ... sd{x} is not blacklisted)
  path sda not found in pathvec
   ===== path sda =====
  device sda is on bus scsi
  bus = 1
  dev_t = 8:0
  size = 2097152                 <-----------WRONG - WHERE does *THIS* come from?
  vendor = DEC     
  product = HSG80           
  rev = V87F
  h:b:t:l = 0:0:0:4
  tgt_node_name = 0x50001fe1000b0ad0
  serial = ZG03401489
  path checker = tur (controler setting)
  state = 1
  getprio = /bin/true (internal default)
  prio = 0
  getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
  uid = 360001fe1000b0ad00009034011590003 (callout)
  path sdb not found in pathvec

  ===== path sdb =====
  device sdb is on bus scsi
  bus = 1
  dev_t = 8:16
  size = 443027195             <--------------RIGHT
  vendor = DEC     
  product = HSG80           
  rev = V87F
  h:b:t:l = 0:0:2:4
  tgt_node_name = 0x50001fe1000b0ad0
  serial = ZG03401159
  path checker = tur (controler setting)
  state = 2
  getprio = /bin/true (internal default)
  prio = 0
  getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
  uid = 360001fe1000b0ad00009034011590003 (callout)
  #
  # all paths :
  #
  360001fe1000b0ad00009034011590003 0:0:0:4 sda  8:0     [faulty][HSG80           ]
  360001fe1000b0ad00009034011590003 0:0:2:4 sdb  8:16    [ready ][HSG80           ]
  path size mismatch : discard 360001fe1000b0ad00009034011590003
  pgpolicy = failover (LUN setting)
  selector = round-robin (LUN setting)
  features = 0 (internal default)
  hwhandler = 0 (internal default)
  0 2097152 multipath 0 0 2 1 round-robin 1 1 8:0 1000 round-robin 1 1 8:16 1000
  action preset to 1
  action set to 1

  # scsiinfo -g /dev/sdb
  Data from Rigid Disk Drive Geometry Page
  ----------------------------------------
  Number of cylinders                72391
  Number of heads                    24
  Starting write precomp             72391
  Starting reduced current           72391
  Drive step rate                    0
  Landing Zone Cylinder              0
  RPL                                0
  Rotational Offset                  0
  Rotational Rate                    3600
  
  # scsiinfo -g /dev/sda
  Unable to read Rigid Disk Geometry Page 04h

  #


Diagnostics I tried:

  1) I patched the multipath command to allow a faulty path on the same wwid to
     "fudge" a copt of the size from a good path to the same wwid in order to get past
     the multipath tools so I could try & get the device mapper set up.
   Results:
     Instead of (excerpts from unpatched multipath -v3 -d):
           0 2097152 multipath 0 0 2 1 round-robin 1 1 8:0 1000 round-robin 1 1 8:16 1000
           path size mismatch : discard 360001fe1000b0ad00009034011590003
     I can now get:
           0 443027195 multipath 0 0 2 1 round-robin 1 1 8:0 1000 round-robin 1 1 8:16 1000
           create: lun4 (360001fe1000b0ad00009034011590003)
           [size=211 GB][features="0"][hwhandler="0"]
           \_ round-robin [best]
             \_ 0:0:0:4 sda  8:0     [faulty]
           \_ round-robin 
             \_ 0:0:2:4 sdb  8:16    [ready ]
     Reissuing without -d results in:
           device-mapper ioctl cmd 9 failed: Invalid argument

  2) I tried to manually create the device map using the parameters generated in step 1:
            # dmsetup remove_all     ##just in case
            # echo 0 443027195 multipath 0 0 2 1 round-robin 1 1 8:0 1000 round-robin 1 1 8:16 1000 | dmsetup create lun4
            device-mapper ioctl cmd 9 failed: Invalid argument
            Command failed
            #
     This creates a /dev/mapper/lun4, marked active, but apparently non-working, since fdisk is unable to read
     from /dev/mapper/lun4. I'd sure like to know what that ioctl cmd 9 error is.... /var/log/messages now contains:
            Apr 10 11:23:46 orthus-san kernel: device-mapper: 4.4.0-ioctl (2005-01-12) initialised: dm-devel@redhat.com
            Apr 10 11:23:51 orthus-san kernel: device-mapper: dm-multipath version 1.0.4 loaded
            Apr 10 11:23:54 orthus-san kernel: device-mapper: dm-round-robin version 1.0.0 loaded
            Apr 10 11:23:54 orthus-san kernel: device-mapper: Unknown error
            Apr 10 11:23:54 orthus-san kernel: device-mapper: error adding target to table

  3) Then I dug into the dm_multipath module to try & track down the ioctl cmd 9 error.
     After adding debugging info into {kernel}/drivers/md/dm-mpath.c, I find that in parse_priority_group(),
     after the line:
       nr_params = 1 + nr_selector_args
     I log THIS with my debugging code:
       Apr 10 11:15:46 orthus-san kernel: nr_params is 1001, nr_selector_args = 1000, pg->nr_pgpaths is 8
     Whoops! ... THAT's not what I expected .... seems the parameters I sent to dmsetup are not what the
     dm module is expecting. Is this because MAYBE dmsetup treats its arguments differently than the direct
     calls into libdevmapper that multipath uses?

     In any case, THIS seems to pass parse-muster with dm_multipath in this kernel:
           # echo 0 443027195 multipath 0 0 2 1 round-robin 1 1 1 0 8:0 round-robin 1 1 1 0 8:16 | dmsetup create lun4
     BUT.... the result isn't any happier, just different:
           Apr 10 11:32:31 orthus-san kernel: device-mapper: device 8:0 too small for target
           Apr 10 11:32:31 orthus-san kernel: device-mapper: dm-multipath: error getting device
           Apr 10 11:32:31 orthus-san kernel: device-mapper: error adding target to table

     Note that 8:0 is the faulty path to the HSG's, an apparently has the same busted geometry information.... :(


Anyway ... I figure I'm either missing something big, or this is going to be a LOT harder to get working
than I care to mess with.

Questions I hope someone can help with are:

  a. (the big one!) Is there something I'm doing wrong, or a workaround, or something that would
     help me get this up & running

  b. Is the dmsetup test I show a valid way to be investigating this issue??

  c. Any ideas on what other things I could try?



Thanks!
-- 
David North, rold5@tditx.com
    The nicest thing about smacking your head against the the wall is.......The feeling you get when you stop - anon
