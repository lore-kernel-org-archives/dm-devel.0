From: Ignat Korchagin <ignat@cloudflare.com>
Subject: [RFC PATCH 0/1] dm-crypt excessive overhead
Date: Fri, 19 Jun 2020 17:41:31 +0100
Message-ID: <20200619164132.1648-1-ignat@cloudflare.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, dm-crypt@saout.de, linux-kernel@vger.kernel.org
Cc: Ignat Korchagin <ignat@cloudflare.com>, kernel-team@cloudflare.com
List-Id: dm-devel.ids

This is a follow up from the long-forgotten [1], but with some more convincing
evidence. Consider the following script:

#!/bin/bash -e

# create 4G ramdisk
sudo modprobe brd rd_nr=1 rd_size=4194304

# create a dm-crypt device with NULL cipher on top of /dev/ram0
echo '0 8388608 crypt capi:ecb(cipher_null) - 0 /dev/ram0 0' | sudo dmsetup create eram0

# create a dm-crypt device with NULL cipher and custom force_inline flag
echo '0 8388608 crypt capi:ecb(cipher_null) - 0 /dev/ram0 0 1 force_inline' | sudo dmsetup create inline-eram0

# read all data from /dev/ram0
sudo dd if=/dev/ram0 bs=4k iflag=direct | sha256sum

# read the same data from /dev/mapper/eram0
sudo dd if=/dev/mapper/eram0 bs=4k iflag=direct | sha256sum

# read the same data from /dev/mapper/inline-eram0
sudo dd if=/dev/mapper/inline-eram0 bs=4k iflag=direct | sha256sum

This script creates a ramdisk (to eliminate hardware bias in the benchmark) and
two dm-crypt instances on top. Both dm-crypt instances use the NULL cipher
to eliminate potentially expensive crypto bias (the NULL cipher just uses memcpy
for "encyption"). The first instance is the current dm-crypt implementation from
5.8-rc1, the second is the dm-crypt instance with a custom new flag enabled from
the patch attached to this thread. On my VM (Debian in VirtualBox with 4 cores
on 2.8 GHz Quad-Core Intel Core i7) I get the following output (formatted for
better readability):

# plain ram0
1048576+0 records in
1048576+0 records out
4294967296 bytes (4.3 GB, 4.0 GiB) copied, 21.2305 s, 202 MB/s
8479e43911dc45e89f934fe48d01297e16f51d17aa561d4d1c216b1ae0fcddca  -

# eram0 (current dm-crypt)
1048576+0 records in
1048576+0 records out
4294967296 bytes (4.3 GB, 4.0 GiB) copied, 53.2212 s, 80.7 MB/s
8479e43911dc45e89f934fe48d01297e16f51d17aa561d4d1c216b1ae0fcddca  -

# inline-eram0 (patched dm-crypt)
1048576+0 records in
1048576+0 records out
4294967296 bytes (4.3 GB, 4.0 GiB) copied, 21.3472 s, 201 MB/s
8479e43911dc45e89f934fe48d01297e16f51d17aa561d4d1c216b1ae0fcddca  -

As we can see, current dm-crypt implementation creates a significant IO
performance overhead (at least on small IO block sizes) for both latency and
throughput. We suspect offloading IO request processing into workqueues and
async threads is more harmful these days with the modern fast storage. I also
did some digging into the dm-crypt git history and much of this async processing
is not needed anymore, because the reasons it was added are mostly gone from the
kernel. More details can be found in [2] (see "Git archeology" section).

We have been running the attached patch on different hardware generations in
more than 200 datacentres on both SATA SSDs and NVME SSDs and so far were very
happy with the performance benefits.

[1]: https://www.spinics.net/lists/dm-crypt/msg07516.html
[2]: https://blog.cloudflare.com/speeding-up-linux-disk-encryption/

Ignat Korchagin (1):
  Add DM_CRYPT_FORCE_INLINE flag to dm-crypt target

 drivers/md/dm-crypt.c | 55 +++++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 12 deletions(-)

-- 
2.20.1
