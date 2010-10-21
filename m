From: "Ulrich Windl" <Ulrich.Windl-LOEJiUoeGm199bV2EpccEXqWYbMAw+HU@public.gmane.org>
Subject: Q: md-RAID1 creation with I/O error (attempt to access beyond
 end of device)
Date: Thu, 21 Oct 2010 13:16:20 +0200
Message-ID: <4CC03D24020000A100010898@gwsmtp1.uni-regensburg.de>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncCLzCps7fBhCJwoDmBBoEStFrjg-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-Disposition: inline
To: open-iscsi <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

Hi,

not an iSCSI question, but maybe here's the right audience: I had sucessful=
ly created a RAID1 using mdadm, multipath, iSCSI and some SAN storage on SL=
ES10 SP3+Updates on x86_64. When I tried to do the same thing on a comparab=
le machine, the RAID could not be created, because something tried to acces=
s the disk at a bad position. I reapeated the attempt with another set of d=
isks of the same size, and it also failed.

Details:
# mdadm --verbose --create /dev/md5 --raid-devices=3D2 --level=3Draid1 --bi=
tmap=3Dinternal --assume-clean /dev/mapper/EVA1_L232_host05 /dev/mapper/EVA=
2_L232_host05
mdadm: /dev/mapper/EVA1_L232_host05 appears to be part of a raid array:
    level=3Draid1 devices=3D2 ctime=3DThu Oct 21 12:26:18 2010
mdadm: /dev/mapper/EVA2_L232_host05 appears to be part of a raid array:
    level=3Draid1 devices=3D2 ctime=3DThu Oct 21 12:26:18 2010
mdadm: size set to 31457216K
Continue creating array? y
mdadm: RUN_ARRAY failed: Input/output error
mdadm: stopped /dev/md5
hostname:~ # tail -24 /var/log/messages                                    =
     Oct 21 12:28:05 hostname kernel: md: md5 stopped.
Oct 21 12:28:07 hostname kernel: md: md5 stopped.
Oct 21 12:29:46 hostname kernel: md: bind<dm-21>
Oct 21 12:29:46 hostname kernel: md: bind<dm-14>
Oct 21 12:29:46 hostname kernel: raid1: raid set md5 active with 2 out of 2=
 mirrors
Oct 21 12:29:46 hostname kernel: md5: bitmap file is out of date (0 < 1) --=
 forcing full recovery
Oct 21 12:29:46 hostname kernel: md5: bitmap file is out of date, doing ful=
l recovery
Oct 21 12:29:46 hostname kernel: attempt to access beyond end of device
Oct 21 12:29:46 hostname kernel: dm-14: rw=3D8, want=3D62914568, limit=3D62=
914560
Oct 21 12:29:46 hostname kernel: attempt to access beyond end of device
Oct 21 12:29:46 hostname kernel: dm-21: rw=3D8, want=3D62914568, limit=3D62=
914560
Oct 21 12:29:46 hostname kernel: md5: bitmap initialized from disk: read 15=
/16 pages, set 489472 bits, status: -5
Oct 21 12:29:46 hostname kernel: md5: failed to create bitmap (-5)
Oct 21 12:29:46 hostname kernel: md: pers->run() failed ...
Oct 21 12:29:46 hostname kernel: md: md5 stopped.
Oct 21 12:29:46 hostname kernel: md: unbind<dm-14>
Oct 21 12:29:46 hostname kernel: md: export_rdev(dm-14)
Oct 21 12:29:46 hostname kernel: md: unbind<dm-21>
Oct 21 12:29:46 hostname kernel: md: export_rdev(dm-21)

hostname:~ # mdadm --query -X /dev/mapper/EVA2_L232_host05
mdadm: WARNING: bitmap file is not large enough for array size 62914432!

        Filename : /dev/mapper/EVA2_L232_host05
           Magic : 6d746962
         Version : 4
            UUID : c522ab5a:24f292a0:0b3d7356:64ade12a
          Events : 0
  Events Cleared : 0
           State : Out of date
       Chunksize : 64 KB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 31457216 (30.00 GiB 32.21 GB)
          Bitmap : 489472 bits (chunks), 489472 dirty (100.0%)
hostname:~ # mdadm --query -X /dev/mapper/EVA1_L232_host05
mdadm: WARNING: bitmap file is not large enough for array size 62914432!

        Filename : /dev/mapper/EVA1_L232_host05
           Magic : 6d746962
         Version : 4
            UUID : c522ab5a:24f292a0:0b3d7356:64ade12a
          Events : 0
  Events Cleared : 0
           State : Out of date
       Chunksize : 64 KB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 31457216 (30.00 GiB 32.21 GB)
          Bitmap : 489472 bits (chunks), 489472 dirty (100.0%)

"blockdev --getsize" reports "62914560" for each LUN being used.

Regards,
Ulrich


--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe@google=
groups.com.
For more options, visit this group at http://groups.google.com/group/open-i=
scsi?hl=3Den.
