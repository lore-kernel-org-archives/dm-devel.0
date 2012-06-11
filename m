From: Milan Broz <gmazyland-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] cryptsetup 1.5.0-rc1 (add veritysetup)
Date: Mon, 11 Jun 2012 16:27:15 +0200
Message-ID: <4FD60043.1050301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
List-Unsubscribe: <http://www.saout.de/mailman/options/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.saout.de/pipermail/dm-crypt>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=help>
List-Subscribe: <http://www.saout.de/mailman/listinfo/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=subscribe>
Errors-To: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
Sender: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
To: dm-crypt <dm-crypt-4q3lyFh4P1g@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids


The testing release candidate cryptsetup 1.5.0-rc1 is available at

   http://code.google.com/p/cryptsetup/

Feedback and bug reports are welcomed.

(Please report all bugs even in kernel dm-verity part, thanks!)

Cryptsetup 1.5.0 RC1 Release Notes
==================================

This testing release candidate version covers mainly
inclusion of new veritysetup tool (and related libcryptsetup extensions).

Please note that API extension and on-disk superblock can change in next
1.5.0 release candidate (despite it is not expected).

Changes since version 1.4.3
~~~~~~~~~~~~~~~~~~~~~~~~~~~
Introduce veritysetup tool for dm-verity target management.

The dm-verity device-mapper target was added to Linux kernel 3.4 and
provides transparent integrity checking of block devices using a cryptographic
digest provided by the kernel crypto API. This target is read-only.

It is meant to be setup as part of a verified boot path (it was originally
developed by Chrome OS authors as part of verified boot infrastructure).

For deeper description please see http://code.google.com/p/cryptsetup/wiki/DMVerity
and kernel dm-verity documentation.

The libcryptsetup library was extended to support manipulation
with dm-verity kernel module and new veritysetup CLI tool is added.

There are no additional library requirements (it uses the same crypto
backend as cryptsetup).

If you want compile cryptsetup without veritysetup tool,
use --disable-veritysetup configure option.
For other configuration option see configure --help and veritysetup --help
(e.g. default parameters).

Supported libcryptsetup functions new CRYPT_VERITY type:
  crypt_init
  crypt_init_by_name
  crypt_set_data device
  crypt_get_type
  crypt_format
  crypt_load
  crypt_get_active_device
  crypt_activate_by_volume_key (volume key == root hash here)
  crypt_dump
and new introduced function
  crypt_get_verity_info

Please see comments in libcryptsetup.h and veritysetup.c as an code example
how to use CRYPT_VERITY API.

The veritysetup tool supports these operations:

  veritysetup format <data_device> <hash_device>
    Formats <hash_device> (calculates all hash areas according to <data_device>).
    This is initial command to prepare device <hash_device> for later verification.

  veritysetup create <name> <data_device> <hash_device> <root_hash>
    Creates (activates) a dm-verity mapping with <name> backed by device <data_device>
    and using <hash_device> for in-kernel verification.

  veritysetup verify <data_device> <hash_device> <root_hash>
    Verifies data in userspace (no kernel device is activated).

  veritysetup remove <name>
    Removes activated device from kernel (similar to dmsetup remove).

  veritysetup status <name>
    Reports status for the active kernel dm-verity device.

  veritysetup dump <hash_device>
    Reports parameters of verity device from on-disk stored superblock.

For more info see veritysetup --help and veritysetup man page.

Other changes
~~~~~~~~~~~~~

  * Both data and header device can now be a file and
    loop device is automatically allocated.

  * Require only up to last keyslot area for header device, previously
    backup (and activation) required device/file of size up to data start
    offset (data payload).

  * Fix header backup and restore to work on files with large data offset.
    Backup and restore now works even if backup file is smaller than data offset.

Appendix: Examples of veritysetup use
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

 Format device using default parameters, info and final root hash is printed:
 # veritysetup format /dev/sdb /dev/sdc
 VERITY header information for /dev/sdc
 UUID:                   fad30431-0c59-4fa6-9b57-732a90501f75
 Hash type:              1
 Data blocks:            52224
 Data block size:        4096
 Hash block size:        4096
 Hash algorithm:         sha256
 Salt:                   5cc52759af76a092e0c21829cd0ef6938f69831bf86926525106f92a7e9e3aa9
 Root hash:              7aefa4506f7af497ac491a27f862cf8005ea782a5d97f6426945a6896ab557a1

 Activation of device in-kernel:
 # veritysetup create vr /dev/sdb /dev/sdc 7aefa4506f7af497ac491a27f862cf8005ea782a5d97f6426945a6896ab557a1
 Note - if device is corrupted, kernel mapping is created but will report failure:
 Verity device detected corruption after activation.

 Userspace verification:
 # veritysetup verify /dev/sdb /dev/sdc 7aefa4506f7af497ac491a27f862cf8005ea782a5d97f6426945a6896ab557a1
  Verification failed at position 8192.
  Verification of data area failed.

 Active device status report:
 # veritysetup status vr
 /dev/mapper/vr is active.
   type:        VERITY
   status:      verified
   hash type:   1
   data block:  4096
   hash block:  4096
   hash name:   sha256
   salt:        5cc52759af76a092e0c21829cd0ef6938f69831bf86926525106f92a7e9e3aa9
   data device: /dev/sdb
   size:        417792 sectors
   mode:        readonly
   hash device: /dev/sdc
   hash offset: 8 sectors

 Dump of on-disk superblock information:
 # veritysetup dump /dev/sdc
 VERITY header information for /dev/sdc
 UUID:                   fad30431-0c59-4fa6-9b57-732a90501f75
 Hash type:              1
 Data blocks:            52224
 Data block size:        4096
 Hash block size:        4096
 Hash algorithm:         sha256
 Salt:                   5cc52759af76a092e0c21829cd0ef6938f69831bf86926525106f92a7e9e3aa9

 Remove mapping:
 # veritysetup remove vr
_______________________________________________
dm-crypt mailing list
dm-crypt-4q3lyFh4P1g@public.gmane.org
http://www.saout.de/mailman/listinfo/dm-crypt
