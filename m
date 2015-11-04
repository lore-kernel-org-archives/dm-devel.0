From: Raman Shishniou <rommer@ibuffed.com>
Subject: dm-era crash
Date: Wed, 4 Nov 2015 19:34:12 +0300
Message-ID: <563A3384.9070900@ibuffed.com>
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

Hello,

I tried to set up new era device and found the following issue:
kernel panics if I don't write anything to the era device after
initial creation.

# lvs -o lv_name,vg_name,attr,size
  LV   VG   Attr       LSize
  data vg   -wi-a----- 64.00g
  meta vg   -wi-a----- 64.00m
# blockdev --getsize /dev/vg/data
134217728
# dd if=/dev/zero of=/dev/vg/meta bs=1M count=64 oflag=direct
64+0 records in
64+0 records out
67108864 bytes (67 MB) copied, 0.0468122 s, 1.4 GB/s
# dmsetup create era --table '0 134217728 era /dev/vg/meta /dev/vg/data 128'
# dmsetup remove era
# dmsetup create era --table '0 134217728 era /dev/vg/meta /dev/vg/data 128'
<< crash >>

after rebooting:
# era_check /dev/vg/meta
examining superblock
missing eras from writeset tree
  value size mismatch: expected 12, but got 8.  This is not the btree you are looking for.

era_check: /usr/include/boost/optional/optional.hpp:630: boost::optional<T>::reference_const_type boost::optional<T>::get() const [with T = unsigned int; boost::optional<T>::reference_const_type = const unsigned int&]: Assertion `this->is_initialized()' failed.
Aborted (core dumped)

After manual investigating superblock (using struct from
drivers/md/dm-era-target.c), I found that the roots of
the current_writeset and writeset_tree points to the
same block number:

checksum:                    0xA06B0358
flags:                       0x00000000
blocknr:                     0
uuid:                        00000000000000000000000000000000
magic:                       2126579579
version:                     1
data block size:             128 sectors
metadata block size:         8 sectors
total data blocks:           262144
current era:                 2
current writeset/total bits: 262144
current writeset/root:       1
writeset tree root:          1
era array root:              9
metadata snapshot:           0

Simple workaround is to write something to /dev/mapper/era after initial creation.
