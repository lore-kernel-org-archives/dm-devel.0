From: Marc Lehmann <schmorp@schmorp.de>
Subject: all cache blocks marked as dirty in writethrough mode,
 "Data loss may occur", constant write activity
Date: Sun, 29 Jun 2014 00:54:53 +0200
Message-ID: <20140628225452.GA570@schmorp.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

[I am not subscribed to the list, CC: appreciated]

Hi!

I tried to look for contact info for dm-cache bug reports, and decided to
write to this list. If this is the wrong way to report errors, pointers on
the correct way are appreciated. Also, if this report is bogus, I apologise
in advance :)

Anyway, I tried out dm-cache on debian kernel 3.14-0.bpo.1-amd64
(3.14.7-1~bpo70+1) and 3.14-1-amd64 (3.14.7-1), both had essentially the
same behaviour. I previously tried on a 3.12 kernel, which showed none of
these issues.

Namely, after creating a writethrough dm-cache mapping, removing it,
and setting it up again, the whole cache is marked as dirty and written
back to the origin device, which obviously shouldn't happen when using
writethrough. I noticed this because my box was very sluggish for a while
after each reboot (due to the hige write load).

On further inspection, I get kernel error messages on "dmsetup remove" of the
dm-cache device:

   [ 3137.734148] device-mapper: space map metadata: unable to allocate new metadata block
   [ 3137.734152] device-mapper: cache: could not resize on-disk discard bitset
   [ 3137.734153] device-mapper: cache: could not write discard bitset
   [ 3137.734155] device-mapper: space map metadata: unable to allocate new metadata block
   [ 3137.734155] device-mapper: cache metadata: begin_hints failed
   [ 3137.734156] device-mapper: cache: could not write hints
   [ 3137.734159] device-mapper: space map metadata: unable to allocate new metadata block
   [ 3137.734160] device-mapper: cache: could not write cache metadata.  Data loss may occur.

I used the formula "4MB + 16 * nr_blocks" to create the metadata device,
so it shouldn't be too small (the cache device is 10G, blocksize is 64kb,
and the calculated metadata partition has about 6MB).

I still get the above messages after increasing the metadata partition to
40MB. Only after increasing it to 70MB did the error go away, which also
stopped all cache blocks to be marked as dirty.

Even with the 70MB metadata partition, behaviour is strange: dmsetup
remove takes 18 seconds, with one cpu having 100% sys time with no I/O,
and while the partitions are mounted, there is a constant 4kb write
activity to each cache partition, with no activity on the origin partition
(which causes ~1GB/day unnecessary wear).

Obviously dm-cache should not ever mark blocks as dirty in writethrough
mode, and obviously, the metadata requirements are much higher than
documented. Also, I think dm-cache should not constantly write to the
cache partition when the system is idle.

Details:

All devices are lvm volumes.

I tried with both a 9TB and 19TB volume, both showed the same behaviour:

   RO    RA   SSZ   BSZ   StartSec            Size   Device
   rw   256   512  4096          0   9499955953664   /dev/dm-7
   rw   256   512  4096          0  20450918793216   /dev/dm-5

The cache devices are both 10G:

   RO    RA   SSZ   BSZ   StartSec            Size   Device
   rw   256   512  4096          0     10737418240   /dev/dm-11
   rw   256   512  4096          0     10737418240   /dev/dm-12

I use a script which divides the cache device into a 128kb header
"partition", a metadata partition and a cache block partition. The working
configuration is (the first line of each block is the cache partition
mapping by lvm, followed by header/metadata/block mappings, followed by
the cache mapping):

   vg_cerebro-cache_bp: 0 20971520 linear 8:17 209715584
   cache-bp-header: 0 256 linear 253:12 0
   cache-bp-meta: 0 144384 linear 253:12 256
   cache-bp-cache: 0 20826880 linear 253:12 144640
   cache-bp: 0 18554601472 cache 253:22 253:23 253:7 128 1 writethrough mq 2 sequential_threshold 32

   vg_cerebro-cache_wd: 0 20971520 linear 8:17 188744064
   cache-wd-header: 0 256 linear 253:11 0
   cache-wd-meta: 0 144384 linear 253:11 256
   cache-wd-cache: 0 20826880 linear 253:11 144640
   cache-wd: 0 39943200768 cache 253:16 253:17 253:5 128 1 writethrough mq 2 sequential_threshold 32

The configuration where the kernel complains about a too small metadata
partition is:

   vg_cerebro-cache_bp: 0 20971520 linear 8:17 209715584
   cache-bp-header: 0 256 linear 253:12 0
   cache-bp-meta: 0 78848 linear 253:12 256
   cache-bp-cache: 0 20892416 linear 253:12 79104
   cache-bp: 0 18554601472 cache 253:22 253:23 253:7 128 1 writethrough mq 2 sequential_threshold 32

   vg_cerebro-cache_wd: 0 20971520 linear 8:17 188744064
   cache-wd-header: 0 256 linear 253:11 0
   cache-wd-meta: 0 78848 linear 253:11 256
   cache-wd-cache: 0 20892416 linear 253:11 79104
   cache-wd: 0 39943200768 cache 253:16 253:17 253:5 128 1 writethrough mq 2 sequential_threshold 32

If more details are needed, drop me a note.

Greetings,
Marc Lehmann

-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=====/_/_//_/\_,_/ /_/\_\
