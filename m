From: Tore Anderson <tore@linpro.no>
Subject: Experiences with multipath-tools and EMC CLARiiON
Date: Wed, 9 Feb 2005 13:14:56 +0100
Message-ID: <200502091314.56085.tore@linpro.no>
Reply-To: dm-devel@redhat.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
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


  [Apologies if this is off-topic for this list, I couldn't find a
 dm-user counterpart for it.]

  I've been toying around with multipath-tools and an EMC CX200.  It hasn=
't
 been working all too well, but at least the developement are on the righ=
t
 track.  I thought I'd share my experiences here, as I would've loved to
 find this email in the archives myself a few weeks back.  :-)

  The hardware used has been a QLogic QLA2340 single-port HBA (the chip
 identifies itself as 2312, though) running on a pretty standard IA-32
 machine.  One switch, a McData Sphereon 4500, and of course the
 storage, a Dell|EMC=C2=B2 CLARiiON CX200.  As there's only a single fabr=
ic
 I've only been able to test basic failover between the two controllers,
 load balancing isn't possible unless you've got dual independent
 fabrics because only one controller will accept I/O to a LU at one
 point in time.  Software used:  2.6.10-udm1, multipath-tools 0.4.2,
 Debian Sarge.  Also there's a bonnie++ and a tiobench running
 constantly towards the LU when it's mounted.

  The host is configured thusly in the CX200's administrative interface:

  * Initiator type: CLARiiON Open
  * Failover mode: 1
  * Array CommPath: Enabled
  * Unit Serial Number: Array

  The configuration file I've ended up using has the following device
 section:

  device {
    # Data General Corporation, and for some reason five spaces.
    vendor                  "DGC     "
    # Shows up as "RAID 1", "RAID 5", etc.
    product                 "*"
    # This is probably only correct for single fabrics.
    path_grouping_policy    failover
    # No idea what the "0" means here..
    path_selector           "round-robin 0"
    # Nor any of the digits here.
    hardware_handler        "3 emc 0 0"
    # I wonder what "1" signifies..
    features                "1 queue_if_no_path"
    getuid_callout          "/sbin/scsi_id -g -s /block/%n"
    path_checker            emc_clariion
  }

  If anyone could shed some light on what all those digits are, that'd
 be nice.  Also if there's any obvious errors please let me know.  :-)

  Anyway, I end up with the following DM table:

  navlelo: 0 20971520 multipath 1 queue_if_no_path 1 emc 2 1 \
           round-robin 0 1 1 8:0 1000 round-robin 0 1 1 8:16 1000

  So, what works and what does not?  If I ask the CX200 to move the LU
 from the active controller to the non-active one, paths change within
 seconds, and I/O are moved to the other sd block device.  The system
 log is flooded with these lines in pairs:

    Device sda not ready.
    end_request: I/O error, dev sda, sector 7304072

  The sector number obviously changes from entry to entry.  Soon the=20
 paths are changed.  Due to the errors I guess it isn't asked to
 gracefully change paths by the CX200 or anything.  The multipath
 utility tells me this:

  navlelo (36006017cd00e0000343a961a3c5ed811)
  [size=3D10 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"1 emc"]
  \_ round-robin 0 [enabled]
    \_ 0:0:0:0 sda  8:0     [ready ][failed]
  \_ round-robin 0 [active][first]
    \_ 0:0:1:0 sdb  8:16    [ready ][active]

  Now, that the sda path is failed is obviously wrong.  It's there, but
 passive (just as sdb was before I migrated the LU to another
 controller).  Even though multipathd logs that it is checking paths,
 the state of the sda path doesn't change.  So if I try to move the LU
 back to the first controller, it believes both paths have failed and
 all I/O stops dead.

  I can however restart multipathd (while still having the LU mounted
 with heavy I/O to it), and the pathts are rediscovered.  For some
 reason, this makes dm-emc fail over the LU to the first controller (sda
 path), even though the sdb path was already up and running fine.  I
 don't know why this is, but if dm-emc (or multipathd?) insist on using
 the first controller (even though the LU has specified the second one
 as the default owner) there will be load balancing problem as the first
 controller will get all the I/O while the second one will sit there
 doing nothing.  Is it possible to change this behaviour somehow?

  Host-based failover doesn't seem to work, or at least I cannot figure
 out how to do it.  "sg_start -s /dev/sdb 1" gives me this:

  sync_cache: SCSI status: Check Condition=20
   Fixed format, current;  Sense key: Not Ready
   Additional sense: Logical unit not ready, manual intervention required

  I guess the "tresspass" command is a proprietary thing and what is
 needed is just a userspace utility that is able to send the same thing
 down the fibre as the dm-emc kernel module is.

  So, the fun part - actual path failures.  As there's other live
 systems using the SAN I couldn't actually yank fibres, so what I did
 is just to rezone the switch so that it loses connectivity to the
 controller.

  Disabling an active path at first works similarily to when I asked the
 CX200 to move the LU to another controller.  At first, the kernel log
 shows this:

  kernel: SCSI error : <0 0 0 0> return code =3D 0x20000
  kernel: end_request: I/O error, dev sda, sector 14201920
  kernel: end_request: I/O error, dev sda, sector 14201928

  These three lines are repeated quite a lot of times, before this one
 appears:

  kernel: device-mapper: dm-emc: emc_pg_init: sending switch-over command

  Now, silence.  No I/O is sent to the sdb path, and the sda one is
 obviously dead so nothing there either.  However, iostat uncovers that
 there's still a lot of I/O operation waiting in sda's queue, and the
 %util columns hovers around 100.  After 57 seconds the three lines
 above are repeated a number of times, and ends with these:

  multipathd: 8:0 : emc_clariion_checker: query command indicates error=20
  kernel: SCSI error : <0 0 0 0> return code =3D 0x10000
  last message repeated 3 times

  Then a lot of stuff from multipathd:

  multipathd: dm-0 blacklisted
  [...repeated for all blacklisted devices...]
  multipathd: path checker already active : 8:0=20
  multipathd: path checker already active : 8:16=20
  multipathd: start up event loops
  multipathd: event checker startup : navlelo
  multipathd: waiter->event_nr =3D 5
  kernel: SCSI error : <0 0 0 0> return code =3D 0x10000
  last message repeated 5 times
  multipathd: checking paths
  kernel: SCSI error : <0 0 0 0> return code =3D 0x10000
  last message repeated 3 times

  At this point, I/O has begun flowing through sdb, and all the iostat
 columns for sda are down to 0.  Took some time, but the system now
 seems to work fine.

  Also it might be worth noting that multipathd provokes a SCSI error
 when it checks the paths, so this appears in the system log every five
 seconds:

  multipathd: checking paths
  kernel: SCSI error : <0 0 0 0> return code =3D 0x10000

  Output from the multipath utility is also somewhat interesting now:

  0:0:0:0: sg_io failed status 0x0 0x1 0x0 0x0
  0:0:0:0: Unable to get INQUIRY vpd 1 page 0x0.
  pb getting path info, free
  0:0:0:0: sg_io failed status 0x0 0x1 0x0 0x0
  0:0:0:0: Unable to get INQUIRY vpd 1 page 0x0.
  navlelo (36006017cd00e0000343a961a3c5ed811)
  [size=3D10 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"1 emc"]
  \_ round-robin 0 [enabled]
    \_ 0:0:0:0 sda  8:0     [faulty][failed]
  \_ round-robin 0 [active][first]
    \_ 0:0:1:0 sdb  8:16    [ready ][active]

  Allright.  I'll try adding back the path to the first controller..

  multipathd: /sbin/multipath -v 0 -S navlelo
  multipathd: devmap event on navlelo
  kernel: SCSI error : <0 0 1 0> return code =3D 0x20000
  kernel: end_request: I/O error, dev sdb, sector 11534336
  multipathd: refresh devmaps list
  multipathd: devmap navlelo :
  multipathd: \_ 0 20971520 multipath
  multipathd: refresh failpaths list
  multipathd: dm-0 blacklisted
  [..repeated as above..]
  multipathd: path checker already active : 8:0=20
  multipathd: path checker already active : 8:16=20
  multipathd: start up event loops
  multipathd: event checker startup : navlelo
  multipathd: waiter->event_nr =3D 6
  multipathd: checking paths
  multipathd: 8:0 : emc_clariion_checker: Path healthy=20
  multipathd: /sbin/multipath -v 0 -S 8:0=20
  multipathd: reconfigure 8:0  multipath
  multipathd: /sbin/multipath -v 0 -S navlelo
  multipathd: devmap event on navlelo
  kernel: device-mapper: dm-emc: long trespass command will be send
  kernel: device-mapper: dm-emc: honor reservation bit will not be set (d=
efault)
  kernel: device-mapper: dm-emc: get_failover_bio: bio_alloc() failed.
  kernel: device-mapper: dm-emc: emc_trespass_get: no bio
  kernel: device-mapper: dm-emc: emc_pg_init: no rq
  kernel: device-mapper: dm-emc: get_failover_bio: bio_alloc() failed.
  kernel: device-mapper: dm-emc: emc_trespass_get: no bio
  kernel: device-mapper: dm-emc: emc_pg_init: no rq
  kernel: Buffer I/O error on device dm-0, logical block 1438113
  kernel: lost page write due to I/O error on dm-0

  The last two lines are repeated nine times (with different blocks),
 then two seconds later:

  multipathd: refresh devmaps list
  multipathd: devmap navlelo :
  multipathd: \_ 0 20971520 multipath
  multipathd: refresh failpaths list

  Both sda and sdb have only zeroes in iostat, and nothing interesting
 is to be seen in the logs.  After over a minute I get bored by waiting
 and did an "ls /mnt" (where the LU is mounted), and immediately got
 this:

  kernel: EXT3-fs error (device dm-0): ext3_readdir: directory #2 contain=
s a hole at offset 0
  kernel: Aborting journal on device dm-0.
  kernel: printk: 3387 messages suppressed.
  kernel: Buffer I/O error on device dm-0, logical block 521
  kernel: lost page write due to I/O error on dm-0
  kernel: Buffer I/O error on device dm-0, logical block 0
  kernel: lost page write due to I/O error on dm-0
  kernel: ext3_abort called.
  kernel: EXT3-fs error (device dm-0): ext3_journal_start_sb: Detected ab=
orted journal
  kernel: Remounting filesystem read-only

  Ouch.  :-(  The multipath binary only says "Alarmen gikk" (Norwegian
 for "The alarm went off" or something like that) when I try to get the
 current configuration.

  I guess I can conclude that the EMC CLARiiON support isn't quite ready
 for production with multipath-tools yet.  Unless of course there's
 anyone on the list who has any good suggestions as to how to make it
 work better..?

  Cristophe:  Should I make a summary of this email and add it to your
 TestedEnvironments page?  I'm not sure if I could've made it work by
 configuring multipathd in another way (for instance the numbers on the
 hardware_handler line I just found in some mailing list archive, I have
 no idea what they mean) - so I'm a bit afraid of ending up updating it
 with flat-out incorrect information.

  I'm happy to do more testing on this system for anyone who wants it.

Regards,
--=20
Tore Anderson

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
