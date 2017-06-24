From: Johannes Bauer <dfnsonfsduifb@gmx.de>
Subject: dm-cache coherence issue
Date: Sat, 24 Jun 2017 15:56:54 +0200
Message-ID: <1ca408b4-0df2-d495-b899-28bded8217fa@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: de-LU
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hello list,

I hope this is the correct place to ask my question. If not, I'd
appreciate a quick word where to better ask this and I'll be on my way.

I've setup a dm-cache setup and am trying to understand the
coherence/consistency between the origin device and cached device. For
this, I have setup a small usecase in which I have a 8 GiB "origin"
loopback device, a 1 GiB "cache/metadata" device:

dmsetup create TEST-dirty --table '0 2086912 linear /dev/loop1 0'
dmsetup create TEST-meta --table '0 10240 linear /dev/loop1 2086912'
dmsetup create TEST-device --table '0 16777216 cache
/dev/mapper/TEST-meta /dev/mapper/TEST-dirty /dev/loop0 512 1 writeback
default 0'

Then I calculate CRC32 of /dev/loop0 (origin device) and cached device
(/dev/mapper/TEST-device). They, in the current state (dirty pages!) differ:

./fast_crc32 -d /dev/loop0 /dev/mapper/TEST-device
Will also calculate CRC of block devices.
/dev/loop0 c2b7d8fd
/dev/mapper/TEST-device f34cf77a


Infos about the state:

Cache device size  : 8.00 GiB
Metadata block size: 4.00 kiB
Metadata usage     : 88.0 kiB / 5.00 MiB
Cache block size   : 256 kiB
Cache usage        : 807 MiB / 1019 MiB
Read hitrate       : 1.7% (34041 of 1984328)
Write hitrate      : 7.9% (2225 of 28312)
Demotions          : 0
Promotions         : 1050
Dirty              : 512 kiB (2 blocks)
Policy             : smq
Features           : writeback
Core arguments     : migration_threshold = 2048

This is expected so far. Now I try to completely flush/decommision the
cache:

dmsetup suspend TEST-device
dmsetup reload TEST-device --table '0 16777216 cache 253:5 253:4 7:0 512
0 cleaner 0'
dmsetup resume TEST-device
dmsetup wait TEST-device

Checking the state, all dirty pages are flushed:

Cache device size  : 8.00 GiB
Metadata block size: 4.00 kiB
Metadata usage     : 88.0 kiB / 5.00 MiB
Cache block size   : 256 kiB
Cache usage        : 807 MiB / 1019 MiB
Read hitrate       : 2.0% (40539 of 2049906)
Write hitrate      : 7.9% (2225 of 28312)
Demotions          : 0
Promotions         : 0
Dirty              : 0 bytes (0 blocks)
Policy             : cleaner
Features           : writeback
Core arguments     : migration_threshold = 2048

However, the checksums of origin and cached device STILL differ!

./fast_crc32 -d /dev/loop0 /dev/mapper/TEST-device
Will also calculate CRC of block devices.
/dev/loop0 c2b7d8fd
/dev/mapper/TEST-device f34cf77a

When I remove the TEST-device, however:

dmsetup remove TEST-device

Then, he device is synchronized:

./fast_crc32 -d /dev/loop0
Will also calculate CRC of block devices.
/dev/loop0 f34cf77a

So I seem to have a very basic misunderstanding of what the cleaner
policy/dirty pages mean. Is there a way to force the cache to flush
entirely? Apparently, "dmsetup wait" and/or "sync" don't do the job.

Also, I've encountered a couple of times now that after switching to the
"cleaner" policy, the "dmsetup wait" call hangs -- even though there are
definitely no hanging open I/O dependencies (no FS on these devices,
purely for testing). Why would this happen?

I'm using 4.10.6 on x86_64, BTW.

Any help greatly appreciated.
Best regards,
Johannes
