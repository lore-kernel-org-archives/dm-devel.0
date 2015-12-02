From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH 0/2] Introduce the request handling for dm-crypt
Date: Wed, 2 Dec 2015 20:46:54 +0800
Message-ID: <CAMz4kuLTuY5CpTfW4Gijesy1Pp9PxbWj076XeoV24Hj3EydifQ@mail.gmail.com>
References: <cover.1447233227.git.baolin.wang@linaro.org>
	<20151111181813.GD12236@redhat.com>
	<CAMz4kuKNAkFG4-f6TU1HRxgkAn+YX-D_tTQAWio-A_np3brr+A@mail.gmail.com>
	<20151112100422.GM12392@sirena.org.uk>
	<5644AFA2.6040201@kernel.dk>
	<20151113115144.GR12392@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151113115144.GR12392@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com, neilb@suse.com, linux-raid@vger.kernel.org, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>, keith.busch@intel.com, jmoyer@redhat.com, tj@kernel.org, bart.vanassche@sandisk.com, "Garg, Dinesh" <dineshg@quicinc.com>
List-Id: dm-devel.ids

Hi All,

These are the benchmarks for request based dm-crypt. Please check it.

=E4=B8=80=E3=80=81Environment
1. Hardware configuration
Board: Beaglebone black
Processor: Am335x 1GHz ARM Cortex-A8
RAM:512M
SD card:8G
Kernel version:4.4-rc1

2. Encryption method
(1) Use cbc(aes) cipher to encrypt the block device with dmsetup tool
dmsetup create dm-0 --table =E2=80=9C0 `blockdev --getsize /dev/mmcblk0=
p1`
crypt aes-cbc-plain:sha256 babebabebabebabebabebabebabebabe 0
/dev/mmcblk0p1  0=E2=80=9D

(2) Enable the AES engine by config
CONFIG_CRYPTO_HW=3Dy
CONFIG_CRYPTO_DEV_OMAP_AES=3Dy

(3) Limitation
We want to test it on ramdisk devices rather than slow media devices
(SD card) firstly, but here we can't use ramdisk to be mapped with
dmsetup tool. Cause ramdisk device is non-request-stackable device, it
can not be used for request-based dm.

=E4=BA=8C. Result summary
1. Results table
-----------------------------------------------------------------------=
------------------------
| Test                       | size    | bio           | request
| % change |
-----------------------------------------------------------------------=
------------------------
| dd sequential read   | 1G      | 5.6Mb/s   | 11.3Mb/s   | +101.8%   |
-----------------------------------------------------------------------=
------------------------
| dd sequential write  | 1G      | 4.2Mb/s   | 6.8Mb/s     | +61.9%    =
 |
-----------------------------------------------------------------------=
------------------------
| fio sequential read  | 1G      | 5336KB/s | 10928KB/s | +104.8%   |
-----------------------------------------------------------------------=
------------------------
| fio sequential write | 1G      | 4049KB/s | 6574KB/s   | +62.4%     |
-----------------------------------------------------------------------=
------------------------

2. Summary
=46rom all the test data with the dd/fio tools, the test results
basically are coincident though the different tools, so it can
basically reflect the IO performance effection by request based
opimization.

It has a larger IO performance effection for reading speed, and it'll
have a larger improvement (at least a double improvement) when
enabling the request based opimization.

Also it will have a big improvement for writing speed, and it is
increased about 50% when enabling the request based opimization. But
for random writing, it has a litle difference limited by slow hardware
random accessing.

=E4=B8=89. DD test procedure
dd can be used for simplified copying of data at the low level with
operating the raw devices.
dd can provide good basic coverage but isn't very realistic, and only
provide sequential IO accessing.
But we can use dd to read/write the raw devices without the
filesystem's caches effection, test result as below:

1. Sequential read:
(1) Sequential read 1G with bio based:
time dd if=3D/dev/dm-0 of=3D/dev/null bs=3D64K count=3D16384 iflag=3Ddi=
rect
1073741824 bytes (1.1 GB) copied, 192.091 s, 5.6 MB/s
real    3m12.112s
user    0m0.070s
sys     0m3.820s

(2) Sequential read 1G with requset based:
time dd if=3D/dev/dm-0 of=3D/dev/null bs=3D64K count=3D16384 iflag=3Ddi=
rect
1073741824 bytes (1.1 GB) copied, 94.8922 s, 11.3 MB/s
real    1m34.908s
user    0m0.030s
sys     0m4.000s

(3) Sequential read 1G without encryption:
time dd if=3D/dev/mmcblk0p1 of=3D/dev/null bs=3D64K count=3D16384 iflag=
=3Ddirect
1073741824 bytes (1.1 GB) copied, 58.49 s, 18.4 MB/s
real    0m58.505s
user    0m0.040s
sys     0m3.050s

2. Sequential write:
(1) Sequential write 1G with bio based:
time dd if=3D/dev/zero of=3D/dev/dm-0 bs=3D64K count=3D16384 oflag=3Ddi=
rect
1073741824 bytes (1.1 GB) copied, 253.477 s, 4.2 MB/s
real    4m13.497s
user    0m0.130s
sys     0m3.990s

(2) Sequential write 1G with requset based:
time dd if=3D/dev/zero of=3D/dev/dm-0 bs=3D64K count=3D16384 oflag=3Ddi=
rect
1073741824 bytes (1.1 GB) copied, 157.396 s, 6.8 MB/s
real    2m37.414s
user    0m0.130s
sys     0m4.190s

(3) Sequential write 1G without encryption:
time dd if=3D/dev/zero of=3D/dev/mmcblk0p1 bs=3D64K count=3D16384 oflag=
=3Ddirect
1073741824 bytes (1.1 GB) copied, 120.452 s, 8.9 MB/s
real    2m0.471s
user    0m0.050s
sys     0m3.820s

3. Summary:
we can see the sequential read/write speed with bio based is: 5.6MB/s
and 4.2MB/s, but when encrypting the block device with request based
things, the sequential read/write speed can be increased to: 11.3MB/s
and 6.8MBs. So sequential reading and writing speed have a big
different with request based, speed are increased by 101.8% and 61.9%.
Meanwhile we also can see the difference in 'sys' time with request
based optimizations.

=E4=B8=89=E3=80=81Fio test procedure
We specify the block size is 64K, and command like:
fio --filename=3D/dev/dm-0 --direct=3D1 --iodepth=3D1 --rw=3Dread --bs=3D=
64K
--size=3D1G --group_reporting --numjobs=3D1 --name=3Dtest_read

1. Sequential read 1G with bio based:
READ: io=3D1024.0MB, aggrb=3D5336KB/s, minb=3D5336KB/s, maxb=3D5336KB/s=
,
mint=3D196494msec, maxt=3D196494msec

2. Sequential write 1G with bio based:
WRITE: io=3D1024.0MB, aggrb=3D4049KB/s, minb=3D4049KB/s, maxb=3D4049KB/=
s,
mint=3D258954msec, maxt=3D258954msec

3. Sequential read 1G with request based:
READ: io=3D1024.0MB, aggrb=3D10928KB/s, minb=3D10928KB/s, maxb=3D10928K=
B/s,
mint=3D95947msec, maxt=3D95947msec

4. Sequential write 1G with request based:
WRITE: io=3D1024.0MB, aggrb=3D6574KB/s, minb=3D6574KB/s, maxb=3D6574KB/=
s,
mint=3D159493msec, maxt=3D159493msec

5. Summary:
(1) read:
The sequential read speed has a big improvment with reuest based
things, which is increased by 104.8% when the reuest based things are
enabled for dm-crypt. It can not be a really random read if we specify
the block size, so the data doesn't list the random read speed
improvements, though it show big improvements.

(2) write:
The sequential write speed has some improvements with request based,
which is increased about by 62.4%. But for random write, this part is
very hard to measure on an SD card though, because any random write
smaller than the underlying block size will cause long I/O latencies
at some point, which is can not show the improvements.

=E5=9B=9B=E3=80=81IO block size test
We also change the block size from 4K to 1M (most IO block size in
practice are much smaller than 1M) to see the block size influences
with reuest based for dm-crypt.

1. Sequential read 1G
(1) block size =3D 4k
time dd if=3D/dev/dm-0 of=3D/dev/null bs=3D4k count=3D262144 iflag=3Ddi=
rect
1073741824 bytes (1.1 GB) copied, 310.598 s, 3.5 MB/s
real    5m10.614s
user    0m0.610s
sys     0m36.040s

(2) block size =3D 64k
1073741824 bytes (1.1 GB) copied, 95.0489 s, 11.3 MB/s
real    1m35.071s
user    0m0.040s
sys     0m4.030s

(3) block size =3D 256k
1073741824 bytes (1.1 GB) copied, 84.3311 s, 12.7 MB/s
real    1m24.347s
user    0m0.050s
sys     0m1.950s

(4) block size =3D 1M
1073741824 bytes (1.1 GB) copied, 80.8778 s, 13.3 MB/s
real    1m20.893s
user    0m0.010s
sys     0m1.390s

2. Sequential write 1G
(1) block size =3D 4k
time dd if=3D/dev/zero of=3D/dev/dm-0 bs=3D4K count=3D262144 oflag=3Ddi=
rect
1073741824 bytes (1.1 GB) copied, 629.656 s, 1.7 MB/s
real    10m29.671s
user    0m0.790s
sys     0m33.550s

(2) block size =3D 64k
1073741824 bytes (1.1 GB) copied, 155.697 s, 6.9 MB/s
real    2m35.713s
user    0m0.040s
sys     0m4.110s

(3) block size =3D 256k
1073741824 bytes (1.1 GB) copied, 143.682 s, 7.5 MB/s
real    2m23.698s
user    0m0.040s
sys     0m2.500s

(4) block size =3D 1M
1073741824 bytes (1.1 GB) copied, 140.654 s, 7.6 MB/s
real    2m20.670s
user    0m0.040s
sys     0m2.090s

3. Summary
=46or request based things, some sequential bios/requests can merged
into one request to expand the IO size to be a big block handled by
hardware engine at one time. With the hardware acceleration, it can
improve the encryption/decryption speed, so the hardware engine can
play the best performance with big block size.

=46rom the data, we also can see the reading/writing speed can be
increased by expanding the block size, which means that it doesn't
help much for small sizes in. But when the block size is above 64K,
the speed dose not get the corresponding performance benefits, I think
the speed limitation is also in cryto that lets the bigger bios can't
get the similar performance benefits, which is need more
investigations.

On 13 November 2015 at 19:51, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Nov 12, 2015 at 08:26:26AM -0700, Jens Axboe wrote:
>> On 11/12/2015 03:04 AM, Mark Brown wrote:
>
>> >Android now wants to encrypt phones and tablets by default and have=
 been
>> >seeing substantial performance hits as a result, we can try to get
>> >people to share performance data from productionish systems but it =
might
>> >be difficult.
>
>> Well, shame on them for developing out-of-tree, looks like they are =
reaping
>> all the benefits of that.
>
>> Guys, we need some numbers, enough with the hand waving. There's no =
point
>> discussing this further until we know how much of a difference it ma=
kes to
>> handle X MB chunks instead of Y MB chunks. As was previously stated,=
 unless
>> there's a _substantial_ performance benefit, this patchset isn't goi=
ng
>> anywhere.
>
> Yeah, what I'm saying here is that there will issues getting the numb=
ers
> from relevant production systems - we are most likely to be looking a=
t
> proxies which are hopefully reasonably representative but there's lik=
ely
> to be more divergence than you'd see just running benchmark workloads=
 on
> similar systems to those used in production.



--=20
Baolin.wang
Best Regards
