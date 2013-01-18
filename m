From: Daniel Browning <db@kavod.com>
Subject: A thin-p over 256 GiB fails with I/O errors with
	non-power-of-two chunk
Date: Fri, 18 Jan 2013 02:19:10 -0800
Message-ID: <201301180219.10467.db@kavod.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Why do I get the following error, and what should I do about it? When I 
create a raid0 md with a non-power-of-two chunk size (e.g. 1152K instead of 
512K), then create a thinly-provisioned volume that is over 256 GiB, I get 
the following dmesg error when I try to create a file system on it:

    "make_request bug: can't convert block across chunks or bigger than 1152k 4384 127"

This bubbles up to mkfs.xfs as

    "libxfs_device_zero write failed: Input/output error"

What I find interesting is that it seems to require all three conditions 
(chunk size, thin-p, and >256 GiB) in order to fail. Without those, it seems 
to work fine:

    * Power-of-two chunk (e.g. 512K), thin-p vol, >256 GiB? Works.
    * Non-power-of-two chunk (e.g. 1152K), thin-p vol, <256 GiB? Works.
    * Non-power-of-two chunk (e.g. 1152K), regular vol, >256 GiB? Works.
    * Non-power-of-two chunk (e.g. 1152K), thin-p vol, >256 GiB? FAIL.

Attached is a self-contained test case to reproduce the error, version 
numbers, and an strace. Thank you in advance,
--
Daniel Browning
Kavod Technologies

Appendix A. Self-contained reproduce script
===========================================================
dd if=/dev/zero of=loop0.img bs=1G count=150; losetup /dev/loop0 loop0.img
dd if=/dev/zero of=loop1.img bs=1G count=150; losetup /dev/loop1 loop1.img
mdadm --create /dev/md99 --verbose --level=0 --raid-devices=2 \
      --chunk=1152K /dev/loop0 /dev/loop1
pvcreate /dev/md99
vgcreate test_vg /dev/md99
lvcreate --size 257G --type thin-pool --thinpool test_thin_pool test_vg
lvcreate --virtualsize 257G --thin test_vg/test_thin_pool --name test_lv
mkfs.xfs /dev/test_vg/test_lv

# That is where the error occurs. Next is cleanup.
lvremove -f /dev/test_vg/test_lv
lvremove -f /dev/mapper/test_vg-test_thin_pool
vgremove -f test_vg
pvremove /dev/md99
mdadm --stop /dev/md99
mdadm --zero-superblock /dev/loop0 /dev/loop1
losetup -d /dev/loop0 /dev/loop1
rm loop*.img

Appendix B. Versions
===========================================================
Distro:          CentOS 6.3
Kernel:          3.7.2-1.el6xen.x86_64 from dev.crc.id.au
LVM version:     2.02.99(2)-git (2012-10-22)
Library version: 1.02.78-git (2012-10-22)
Driver version:  4.23.0
XFS userspace:   xfsprogs-3.1.1-7.el6.x86_64

Appendix C. strace of mkfs.xfs
===========================================================
See http://pastebin.com/raw.php?i=hLLm0jVC for the full strace. An excerpt:

lseek(4, 137975840768, SEEK_SET)        = 137975840768
write(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 262144) = 262144
write(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 262144) = 262144
write(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 262144) = -1 EIO (Input/output error)
