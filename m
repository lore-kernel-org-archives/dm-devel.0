From: Petr Uzel <petr.uzel@suse.cz>
Subject: [multipath-tools] kpartx -a: resume ioctl failed:
	Invalid argument
Date: Tue, 16 Jun 2009 13:55:46 +0200
Message-ID: <20090616115546.GA704@localhost>
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
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi all,

I have a simple testing linear DM device:

dmsetup info
> Name:              test
> State:             ACTIVE
> Read Ahead:        256
> Tables present:    LIVE
> Open count:        0
> Event number:      0
> Major, minor:      253, 0
> Number of targets: 1

# Let's create a partition:
parted -s /dev/dm-0 mkpart primary ext2 0 10M

# Create devmapping with kpartx:
kpartx -v -a -p _part /dev/dm-0=20
> add map test_part1 (253:1): 0 19531 linear /dev/dm-0 1

dmsetup info test_part1
> Name:              test_part1
> State:             ACTIVE
> Read Ahead:        256
> Tables present:    LIVE
> Open count:        0
> Event number:      0
> Major, minor:      253, 1
> Number of targets: 1
> UUID: part1-dm-0

# Recreate the partition with different size:
parted -s /dev/dm-0 rm 1
parted -s /dev/dm-0 mkpart primary ext2 0 20M

# Try to recreate devmappings with kpartx:
kpartx -v -a -p _part /dev/dm-0=20
> device-mapper: resume ioctl failed: Invalid argument
> resume failed on test_part1
> add map test_part1 (253:1): 0 39062 linear /dev/dm-0 1

Note: the ioctl doesn't fail when kpartx is called multiple times without
changing the partition table on dm-0.

It happens with current multipath-tools from git. The bug is caused by
----
commit 44b1e84d7eb72a3c03cec486a227dc1beaa9ccd6
Author:     Hannes Reinecke <hare@suse.de>
AuthorDate: Mon Feb 9 13:59:57 2009 +0100
Commit:     Christophe Varoqui <christophe.varoqui@free.fr>
CommitDate: Wed Apr 22 01:44:53 2009 +0200

    Use noflush for kpartx

	kpartx has to use 'noflush' to be able to complete for an all-paths
	down scenario. Otherwise no uevent might be sent and multipath
	will stall.
----

The patch uses --noflush with DM_DEVICE_RESUME, but as far as I understan=
d it,
--noflush makes sense only with DM_DEVICE_SUSPEND.

Perhaps kpartx should suspend the mapping before doing reload?


--=20
Best regards / s pozdravem

Petr Uzel, Packages maintainer
---------------------------------------------------------------------
SUSE LINUX, s.r.o.                          e-mail: puzel@suse.cz
Lihovarsk=E1 1060/12                          http://www.suse.cz
190 00 Prague 9                            =20
Czech Republic                             =20
