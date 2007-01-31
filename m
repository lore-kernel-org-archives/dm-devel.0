From: =?iso-8859-1?Q?Lo=EFc?= Minier <lool+redhat@via.ecp.fr>
Subject: Weird discrepancy between /dev/mapper/* and /dev/dm-*
	devices breaks lilo
Date: Wed, 31 Jan 2007 11:47:37 +0100
Message-ID: <20070131104737.GA29370@bee.dooz.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
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

        Hi,

 When issuing the same dmsetup commands on two device nodes with the
 same major/minor, the results are puzzling:
 bee:~# file /dev/dm-1
 /dev/dm-1: block special (254/1)
 bee:~# file /dev/mapper/bee--sata-refuge
 /dev/mapper/bee--sata-refuge: block special (254/1)
 bee:~# dmsetup table /dev/mapper/bee--sata-refuge
 0 131072 linear 8:2 117440896
 bee:~# dmsetup table /dev/dm-1
 dm_task_set_name: Device /dev/dm-1 not found
 Command failed

 (Same problem with short names:)
 bee:~# dmsetup table bee--sata-refuge
 0 131072 linear 8:2 117440896
 bee:~# dmsetup table dm-1
 device-mapper: table ioctl failed: No such device or address
 Command failed


 This is a problem hitting lilo relatively hard as it has logic to
 ignore devices with the same major/minor; that is, if lilo sees "dm-1"
 first and then the corresponding /dev/mapper device, it will drop any
 reference to the mapper device.  As having /boot on RAID 1 for lilo
 requires calling "dmsetup table" on the root device, this breaks lilo
 for a lot of people.

 Of course, it would be possible to patch lilo to explicitely skip
 /dev/dm-* devices, but it seems this would be a workaround instead of
 the real fix.


 This is under 2.6.18 and libdevmapper 1.02.12-1.


 You can find more details in Debian bug
 <http://bugs.debian.org/401393>, the bug was triggered by the addition
 of the /dev/dm-* device in udev (see <http://bugs.debian.org/392623>),
 and affects other distributions as well,
 <https://launchpad.net/distros/ubuntu/+source/lilo-installer/+bug/23835>=
.


 (RAID 1 support in lilo comes from a third-party patch added in the
 Debian packaging.)

   Bye,
--=20
Lo=EFc Minier <lool@dooz.org>
