From: Parke <parke.nexus@gmail.com>
Subject: possible bug with kpartx -d and absolute paths
Date: Mon, 22 Jun 2015 12:56:39 -0700
Message-ID: <CAPxz1+YdrxmDbYuvu1PmiO-eJJ2G1E5XxA=D=zFxp=Nm=WbHTw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

On Ubuntu 14.04:
kpartx version 0.4.9-3ubuntu7.2 has interesting behavior.
kpartx from version 0.5.0 built from source misbehaves identically.

The following works as expected:

cd /
kpartx -a mnt/path/to/disk.img
kpartx -d mnt/path/to/disk.img

However, if I use absolute paths, instead of relative paths, -a will
succeed, and -d will unexpectedly silently have no effect.

kpartx -a /mnt/path/to/disk.img
kpartx -d /mnt/path/to/disk.img    # silently has no effect

In this case, to delete the partition mappings, I need to:

kpartx -d /dev/loop0
losetup -d /dev/loop0

Further investigation revealed that kpartx is unexpectedly confused by
different files that happen to have the same name:

cd /mnt/path/to
kpartx -a disk.img    # succeeds, as expected

cd ..
kpartx -d to/disk.img    # silently has no effect

cd /tmp
touch disk.img
kpartx -d disk.img    # unexpectedly unmaps /mnt/path/to/disk.img and
detaches /dev/loop0

Cheers,

Parke
