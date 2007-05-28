From: Joe MacDonald <joe@deserted.net>
Subject: Deadlock (livelock?) in LVM2 and dm-snapshot
Date: Mon, 28 May 2007 17:24:12 -0400
Message-ID: <20070528212412.GB2120@deserted.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2056914953=="
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: joe.macdonald@gmail.com
List-Id: dm-devel.ids


--===============2056914953==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y1L3PTX8QE8cb2T+"
Content-Disposition: inline


--Y1L3PTX8QE8cb2T+
Content-Type: multipart/mixed; boundary="VdOwlNaOFKGAtAAV"
Content-Disposition: inline


--VdOwlNaOFKGAtAAV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey dm-folks,

I hope this is the right place for this problem, it's kind of a weird
one that I can't seem to pin down, but it's connected to adding and
removing backup volumes in a volume group when using dm-snapshot.

I'll attach the scripts I'm using that demonstrates the problem pretty
quickly (usually within a few seconds of starting the third of the three
scripts (four, really, but snapshot-test.sh is invoked from step-1.sh,
not by a user), but always in less than ten minutes) on my hardware.

What happens is I start up my tests which are contrived versions of the
behaviour observed in a live system.  There's a lot of disk activity but
periodically we need to do a full filesystem backup so we've got this
setup where we have a single volume group and we add a backup volume to
the group for a brief time.  The backup is done and the backup volume is
removed.  It seems to be a the lvremove step where we get a deadlock,
but I can't really tell where and we don't get a panic or backtrace or
anything.  Not surprisingly, everything else in the system seems to be
fine, just the shell doing the lvremove and any other shell that tries
to touch the logical volumes in the group look like the system has hung.
The machine is still quite responsive to anything else, which kind of
makes debugging this harder that it otherwise would be.

I've been using things like LOCKDEP and spinlock debugging code in the
kernel without much success.  The only thing I've got to go on right
now, other than the test cases which aren't pointing me in the right
direction, is that this was failing in 2.6.20 but never fails in 2.6.21
under any amount of load I can generate, but yesterday and today I've
been trying it out on 2.6.22-rc3 and the problem is back.

Anyway, the steps to reproduce:

- from one login shell run step-1.sh
- from another login shell run filegen.sh& and killer.sh&
- wait a few seconds to at most ten minutes, you'll see step-1.sh stop
  producing output before then.

I'm using a Dell Precision 390n with an Intel Core 2 Duo E6300 on the
board.  The problem also seems to appear on UP systems, but it's
definitely a lot easier to have happen on MP hardware.  The test scripts
are set up to do ext3 right now but there are a few commented lines that
you can switch to work with XFS.  I'm more interested in getting XFS
working, but the problem happens on both and XFS also seems to generate
moderately frequent, unrelated backtraces and I don't want to confuse
the matter.  In case it helps, here's the results of lvcreate --version:

  LVM version:     2.02.25 (2007-04 27)
  Library version: 1.02.19 (2007-04-27)
  Driver version:  4.11.0

I'd really appreciate any help or pointers or even advice at what
sections of code to look at that anyone might have.

Thanks.

--=20
Joe MacDonald
:wq

--VdOwlNaOFKGAtAAV
Content-Type: application/x-sh
Content-Disposition: attachment; filename="snapshot-test.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0Asuccess=3D0=0Afail=3D0=0Acnt=3D0=0Amaxcnt=3D5000=0AVG=3D"vg1"=
=0AORIGVDISK=3D"vdisk1"=0A# Appropriate for XFS=0A#MOUNTOPTS=3D"-t xfs -ono=
uuid,ro"=0A# Seems to be needed for ext3=0AMOUNTOPTS=3D"-t ext3 -oro"=0A=0A=
while [ $cnt -lt $maxcnt ]=0Ado=0A       cnt=3D$(($cnt + 1))=0A       =0A  =
     if lvcreate -L100 -s -n backup /dev/$VG/$ORIGVDISK >/dev/null 2>&1=0A =
      then=0A               if ! [ -d /backup ]=0A               then =0A  =
                     mkdir /backup=0A       fi              =0A=0A       if=
 mount $MOUNTOPTS /dev/$VG/backup /backup >/dev/null 2>&1=0A       then=0A =
              if find /backup -print | cpio -o >/var/tmp/backup.cpio >/dev/=
null 2>&1=0A               then=0A                       success=3D$(($succ=
ess + 1))=0A               else    =0A                       fail=3D$(($fai=
l + 1))=0A               fi      =0A               umount /backup >/dev/nul=
l 2>&1=0A       fi=0A       lvremove -f $VG/backup >/dev/null 2>&1=0A      =
 fi=0A       echo "Tries: $cnt Success: $success Fail: $fail"=0A       slee=
p 1=0Adone=0A=0Aecho=0Aecho "Finished - Tries: $cnt Successes: $success Fai=
lures: $fail"=0A=0Aexit 0=0A
--VdOwlNaOFKGAtAAV
Content-Type: application/x-sh
Content-Disposition: attachment; filename="filegen.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A=0AMNT=3D"/mnt"=0ASUBDIR=3D$$=0A=0Aif [ ! -d $MNT/$SUBDIR ]=
=0Athen=0A       mkdir $MNT/$SUBDIR=0Afi=0Awhile /bin/true=0Ado=0A       fo=
r FILE in `ls /bin`=0A       do=0A               cp /bin/$FILE $MNT/$SUBDIR=
/$FILE.tmp=0A               mv -f $MNT/$SUBDIR/$FILE.tmp $MNT/$SUBDIR/$FILE=
=0A       done=0A       sync=0Adone=0A
--VdOwlNaOFKGAtAAV
Content-Type: application/x-sh
Content-Disposition: attachment; filename="step-1.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0Aecho y | pvcreate -ff /dev/sda7=0Avgcreate vg1 /dev/sda7=0Avg=
scan=0Avgchange -a y=0Alvcreate -L 100 --name vdisk1 vg1=0A#mkfs -t xfs /de=
v/vg1/vdisk1=0Amkfs -t ext3 /dev/vg1/vdisk1=0Amount /dev/vg1/vdisk1 /mnt=0A=
lvcreate -L100 -s -n backup /dev/vg1/vdisk1=0Alvremove -f vg1/backup=0Ash s=
napshot-test.sh=0A
--VdOwlNaOFKGAtAAV
Content-Type: application/x-sh
Content-Disposition: attachment; filename="killer.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0Awhile [ 1 ] ; do=0A   find /lib |awk '{print "/mnt/lib"$1}' |=
xargs mkdir -p $e=0A   find /lib /usr /bin |awk '{print "/mnt/lib"$1}' |xar=
gs mkdir -p $e=0A   sync=0A   mv /mnt/lib /mnt/lib2=0A   rm -rf /mnt/lib2=
=0A   sync=0A   date=0Adone=0A
--VdOwlNaOFKGAtAAV--

--Y1L3PTX8QE8cb2T+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (OpenBSD)

iD8DBQFGW0h8wFvcllog0XwRAlGfAJ4wkslUF0Yg9GGkonWx+g9M+6Bc+QCgil2e
3flp50IdPmFYF+VprVbVC0k=
=/XHA
-----END PGP SIGNATURE-----

--Y1L3PTX8QE8cb2T+--


--===============2056914953==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2056914953==--
