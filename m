From: "shahid shaikh" <shahid.shaikh@patni.com>
Subject: RE: dm-devel Digest, Vol 12, Issue 5
Date: Thu, 10 Feb 2005 09:27:06 +0530
Message-ID: <000801c50f24$969c6b80$11051aac@pcp41116>
References: <20050209170004.3B2A8743E2@hormel.redhat.com>
Reply-To: shahid.shaikh@patni.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1108007509-16707-142"
In-Reply-To: <20050209170004.3B2A8743E2@hormel.redhat.com>
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

This is a multi-part message in MIME format...

------------=_1108007509-16707-142
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
	I am Shahid. I am very new to device driver writing. I have been working in
this field since last3months.

I want to test multipathing.
 I have AS4(2.6.9) and SLES9(2.6.5).
If any body can guide me  what configuration, tools and software i need to
test multipathing feature of Device Mapper.

It will very helpfull if somebody also give me the steps to follow to test
multipathing.

Thanks and Regards,
Shahid Shaikh.
Software Engineer.
Patni Computer Systems Ltd.






-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]On
Behalf Of dm-devel-request@redhat.com
Sent: Wednesday, February 09, 2005 10:30 PM
To: dm-devel@redhat.com
Subject: dm-devel Digest, Vol 12, Issue 5


Send dm-devel mailing list submissions to
	dm-devel@redhat.com

To subscribe or unsubscribe via the World Wide Web, visit
	https://www.redhat.com/mailman/listinfo/dm-devel
or, via email, send a message with subject or body 'help' to
	dm-devel-request@redhat.com

You can reach the person managing the list at
	dm-devel-owner@redhat.com

When replying, please edit your Subject line so it is more specific
than "Re: Contents of dm-devel digest..."


Today's Topics:

   1. Re: Some issues noticed in my testing. (Christophe Varoqui)
   2. Experiences with multipath-tools and EMC CLARiiON (Tore Anderson)
   3. 2.6.11-rc3-udm2 (Alasdair G Kergon)


----------------------------------------------------------------------

Message: 1
Date: Tue, 08 Feb 2005 22:55:45 +0100
From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: [dm-devel] Re: Some issues noticed in my testing.
To: "Caushik, Ramesh" <ramesh.caushik@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>
Message-ID: <42093561.9070008@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

Caushik, Ramesh wrote:

>Hi Christophe,
>
>
Hello,

>I noticed a failure in multipath-tools-0.4.2 when executing the
>following scenario.
>
>i) Run multipathd & multipath with 1 of 2 paths in the system available.
>ii)activate the other path.
>iii) run multipath again.
>
>Expect the newly inserted path to be incorporated into the original path
>groups. Does not happen. Traced it to a problem in the pgcmp2 function.
>Patch below should fix it.
>
I can't see this patch attached.
Can you resend it. (In diff -u format if possible)

> Also in step iii) above running multipath
>with a parameter (conf->dev) will not include the additional path into
>the particular mp because the select_alias function not called in the
>coalesce_paths function so the strncmp(mpp->alias,conf->dev,....) in
>main will always fail. Patch below should fix it.
>
>
>
Mr Goggin, EMC, already spotted this and a patch is present in my tree.
Thanks.

>Also while testing with a modified scsi_debug driver (to expose multiple
>paths to the same device) noticed that sysfs vendor name for the
>scsi_debug device is "Linux   " which fails to match with a "Linux"
>vendor name in the conf name and so device specific settings are not
>picked up. Think it is a good idea to chomp off trailing whitespace from
>vendor and product names. See patches below.  Regards,
>
>
>
Can you tell me if the following fits your needs here ?

--- multipath-tools-0.4.2/libmultipath/hwtable.c        2005-01-23
14:48:05.830203168 -0800
+++ multipath-tools-0.4.3-pre1/libmultipath/hwtable.c   2005-02-08
13:42:57.203660896 -0800
@@ -12,14 +12,18 @@
 extern struct hwentry *
 find_hw (vector hwtable, char * vendor, char * product)
 {
-       int i;
+       int i, vendor_len, product_len;
        struct hwentry * hwe;

+       vendor_len = strlen(vendor);
+       product_len = strlen(product);
+
        vector_foreach_slot (hwtable, hwe, i)
-               if (hwe->vendor && hwe->product &&
-                   strcmp(hwe->vendor, vendor) == 0 &&
+               if (hwe->vendor && vendor_len == strlen(hwe->vendor) &&
+                   strncmp(hwe->vendor, vendor, vendor_len) == 0 &&
+                   hwe->product && product_len == strlen(hwe->product) &&
                    (hwe->product[0] == '*' ||
-                       strcmp(hwe->product, product) == 0))
+                    strncmp(hwe->product, product, product_len) == 0))
                        return hwe;
        return NULL;
 }

Regards,
cvaroqui



------------------------------

Message: 2
Date: Wed, 9 Feb 2005 13:14:56 +0100
From: Tore Anderson <tore@linpro.no>
Subject: [dm-devel] Experiences with multipath-tools and EMC CLARiiON
To: dm-devel@redhat.com
Message-ID: <200502091314.56085.tore@linpro.no>
Content-Type: text/plain;  charset="utf-8"


  [Apologies if this is off-topic for this list, I couldn't find a
 dm-user counterpart for it.]

  I've been toying around with multipath-tools and an EMC CX200.  It hasn't
 been working all too well, but at least the developement are on the right
 track.  I thought I'd share my experiences here, as I would've loved to
 find this email in the archives myself a few weeks back.  :-)

  The hardware used has been a QLogic QLA2340 single-port HBA (the chip
 identifies itself as 2312, though) running on a pretty standard IA-32
 machine.  One switch, a McData Sphereon 4500, and of course the
 storage, a Dell|EMCB2 CLARiiON CX200.  As there's only a single fabric
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

  The sector number obviously changes from entry to entry.  Soon the
 paths are changed.  Due to the errors I guess it isn't asked to
 gracefully change paths by the CX200 or anything.  The multipath
 utility tells me this:

  navlelo (36006017cd00e0000343a961a3c5ed811)
  [size=10 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
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

  sync_cache: SCSI status: Check Condition
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

  kernel: SCSI error : <0 0 0 0> return code = 0x20000
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

  multipathd: 8:0 : emc_clariion_checker: query command indicates error
  kernel: SCSI error : <0 0 0 0> return code = 0x10000
  last message repeated 3 times

  Then a lot of stuff from multipathd:

  multipathd: dm-0 blacklisted
  [...repeated for all blacklisted devices...]
  multipathd: path checker already active : 8:0
  multipathd: path checker already active : 8:16
  multipathd: start up event loops
  multipathd: event checker startup : navlelo
  multipathd: waiter->event_nr = 5
  kernel: SCSI error : <0 0 0 0> return code = 0x10000
  last message repeated 5 times
  multipathd: checking paths
  kernel: SCSI error : <0 0 0 0> return code = 0x10000
  last message repeated 3 times

  At this point, I/O has begun flowing through sdb, and all the iostat
 columns for sda are down to 0.  Took some time, but the system now
 seems to work fine.

  Also it might be worth noting that multipathd provokes a SCSI error
 when it checks the paths, so this appears in the system log every five
 seconds:

  multipathd: checking paths
  kernel: SCSI error : <0 0 0 0> return code = 0x10000

  Output from the multipath utility is also somewhat interesting now:

  0:0:0:0: sg_io failed status 0x0 0x1 0x0 0x0
  0:0:0:0: Unable to get INQUIRY vpd 1 page 0x0.
  pb getting path info, free
  0:0:0:0: sg_io failed status 0x0 0x1 0x0 0x0
  0:0:0:0: Unable to get INQUIRY vpd 1 page 0x0.
  navlelo (36006017cd00e0000343a961a3c5ed811)
  [size=10 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
  \_ round-robin 0 [enabled]
    \_ 0:0:0:0 sda  8:0     [faulty][failed]
  \_ round-robin 0 [active][first]
    \_ 0:0:1:0 sdb  8:16    [ready ][active]

  Allright.  I'll try adding back the path to the first controller..

  multipathd: /sbin/multipath -v 0 -S navlelo
  multipathd: devmap event on navlelo
  kernel: SCSI error : <0 0 1 0> return code = 0x20000
  kernel: end_request: I/O error, dev sdb, sector 11534336
  multipathd: refresh devmaps list
  multipathd: devmap navlelo :
  multipathd: \_ 0 20971520 multipath
  multipathd: refresh failpaths list
  multipathd: dm-0 blacklisted
  [..repeated as above..]
  multipathd: path checker already active : 8:0
  multipathd: path checker already active : 8:16
  multipathd: start up event loops
  multipathd: event checker startup : navlelo
  multipathd: waiter->event_nr = 6
  multipathd: checking paths
  multipathd: 8:0 : emc_clariion_checker: Path healthy
  multipathd: /sbin/multipath -v 0 -S 8:0
  multipathd: reconfigure 8:0  multipath
  multipathd: /sbin/multipath -v 0 -S navlelo
  multipathd: devmap event on navlelo
  kernel: device-mapper: dm-emc: long trespass command will be send
  kernel: device-mapper: dm-emc: honor reservation bit will not be set
(default)
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

  kernel: EXT3-fs error (device dm-0): ext3_readdir: directory #2 contains a
hole at offset 0
  kernel: Aborting journal on device dm-0.
  kernel: printk: 3387 messages suppressed.
  kernel: Buffer I/O error on device dm-0, logical block 521
  kernel: lost page write due to I/O error on dm-0
  kernel: Buffer I/O error on device dm-0, logical block 0
  kernel: lost page write due to I/O error on dm-0
  kernel: ext3_abort called.
  kernel: EXT3-fs error (device dm-0): ext3_journal_start_sb: Detected
aborted journal
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
--
Tore Anderson



------------------------------

Message: 3
Date: Wed, 9 Feb 2005 15:03:23 +0000
From: Alasdair G Kergon <agk@redhat.com>
Subject: [dm-devel] 2.6.11-rc3-udm2
To: dm-devel@redhat.com
Message-ID: <20050209150323.GW10195@agk.surrey.redhat.com>
Content-Type: text/plain; charset=us-ascii

ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/2.6.11-rc3/2.6.11-rc3-u
dm2.tar.bz2

Same as udm1 with a bit of tidying up.

Simplified the locking for now: it uses the per-device multipath lock
everywhere.
We can refine this later to address the performance issues.
Updated version numbers and added a few more comments.

Please re-test and review this patchset - I'd like to submit patches 7-10
to -mm
after adding more documentation.

Alasdair



------------------------------

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

End of dm-devel Digest, Vol 12, Issue 5
***************************************



http://www.patni.com
World-Wide Partnerships. World-Class Solutions.
_____________________________________________________________________

This e-mail message may contain proprietary, confidential or legally
privileged information for the sole use of the person or entity to
whom this message was originally addressed. Any review, e-transmission
dissemination or other use of or taking of any action in reliance upon
this information by persons or entities other than the intended
recipient is prohibited. If you have received this e-mail in error
kindly delete  this e-mail from your records. If it appears that this
mail has been forwarded to you without proper authority, please notify
us immediately at netadmin@patni.com and delete this mail. 
_____________________________________________________________________

------------=_1108007509-16707-142
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
------------=_1108007509-16707-142--
