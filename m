From: Tore Anderson <tore@linpro.no>
Subject: Re: path priorities on Sun's 6140
Date: Sat, 15 Sep 2007 11:08:36 +0200
Message-ID: <46EBA114.10408@linpro.no>
References: <66F461DD7EDEEF4AA928FCC80B425B520468B7@c2kp01mail.cucbc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <66F461DD7EDEEF4AA928FCC80B425B520468B7@c2kp01mail.cucbc.com>
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

* James Fillman

> I'm running RHEL5 with QLogic HBA's and a Sun 6140 SAN. The host type
> I'm using for my servers is 'Solaris (with DMP)'. This turns AVT
> mode one. For some reason, the two controllers are returning the same
> priority value to my priority call out program (mpath_prio_tpc).

   Try path_grouping_policy group_by_serial?

> Can anyone briefly explain what the mpath_prio_tpc utility does and=20
> where these priority values come from?

   It calls out to the supplied SCSI device and returns a different
  integer depending on if the controller is the preferred owner for the
  volume and if it actually is.  The values has changed quite a bit from
  version to version, but if I recall correctly they are in your version:

   Device is a path to the preferred and active controller =3D 6
   Device is a path to the preferred and inactive controller =3D 4
   Device is a path to the least preferred and active controller =3D 3
   Device is a path to the least preferred and inactive controller =3D 1

   Since you have group_by_prio and they end up in the same path group it
  seems the prio callout doesn't work (you can test this yourself by
  running =C2=ABmpath_prio_tpc /dev/sdx=C2=BB).  When I used AVT I set th=
e hosts to
  host type AIX_FO, which seemed to work fine for me at least.  Try that?

   You're also using path_checker readsector0 with AVT which is really
  bad.  Every time multipathd checks a path to the passive controller the
  volume vil move there, which will interrupt I/O for several seconds.
  Use the tur checker instead.

   However, are you _really_ sure you want AVT mode?  Support for RDAC
  mode was recently added to dm-multipath (both a hardware handler and
  a path checker), and using this is normally vastly superior to AVT
  mode.  The Linux kernel itself (partition scan on boot) as well as a
  lot of applications (LVM, mdadm, fdisk, etc.) believe reading from
  block devices is a harmless thing to do.  However with AVT mode this
  I/O will cause a volume to transfer and I/O to be interrupted, and
  paths will fail.  With AVT you won't be able to boot node A in a
  cluster without interrupting the I/O flow of the rest of the nodes, nor
  manage LVM on any node in a cluster without also interrupting I/O
  (unless you've configured LVM to stay away from your multipathed
  devices).

   PS:  If you have I/O failures happening on your hosts when you do
  changes to the storage domains setup, this is due to a mis-feature in
  the 6140 that makes it dim its fibre ports whenever a change is made.
  They said this was done to make all hosts relogin and automatically
  discover new volumes with no manual rescan needed, but the fabric
  relogin interrupts I/O and causes path failures.  But there is hope.  I
  was told yesterday that in the next firmware release we can opt to
  toggle this =C2=ABfeature=C2=BB off.  Go pester Sun to get it.  ;-)

Regards
--=20
Tore Anderson
