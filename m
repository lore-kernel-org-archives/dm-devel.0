From: John Dorminy <jdorminy@redhat.com>
Subject: Re: [git pull] device mapper changes for 5.9
Date: Tue, 18 Aug 2020 16:39:52 -0400
Message-ID: <CAMeeMh_=M3Z7bLPN3_SD+VxNbosZjXgC_H2mZq1eCeZG0kUx1w@mail.gmail.com>
References: <20200807160327.GA977@redhat.com> <CAHk-=wiC=g-0yZW6QrEXRH53bUVAwEFgYxd05qgOnDLJYdzzcA@mail.gmail.com>
 <20200807204015.GA2178@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200807204015.GA2178@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, device-mapper development <dm-devel@redhat.com>, linux-block <linux-block@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Damien Le Moal <damien.lemoal@wdc.com>, Ignat Korchagin <ignat@cloudflare.com>, JeongHyeon Lee <jhs2.lee@samsung.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, Mikulas Patocka <mpatocka@redhat.com>, Ming Lei <ming.lei@redhat.com>, yangerkun <yangerkun@huawei.com>
List-Id: dm-devel.ids

For what it's worth, I just ran two tests on a machine with dm-crypt
using the cipher_null:ecb cipher. Results are mixed; not offloading IO
submission can result in -27% to +23% change in throughput, in a
selection of three IO patterns HDDs and SSDs.

(Note that the IO submission thread also reorders IO to attempt to
submit it in sector order, so that is an additional difference between
the two modes -- it's not just "offload writes to another thread" vs
"don't offload writes".) The summary (for my FIO workloads focused on
parallelism) is that offloading is useful for high IO depth random
writes on SSDs, and for long sequential small writes on HDDs.
Offloading reduced throughput for immensely high IO depths on SSDs,
where I would guess lock contention is reducing effective IO depth to
the disk; and for low IO depths of sequential writes on HDDs, where I
would guess (as it would for a zoned device) preserving submission order
is better than attempting to reorder before submission.

Two test regimes: randwrite on 7xSamsung SSD 850 PRO 128G, somewhat
aged, behind a LSI MegaRAID card providing raid0. 6 processors
(Intel(R) Xeon(R) CPU E5-1650 v2 @ 3.50GHz); 128G RAM; and seqwrite,
on a software raid0 (512k chunk size) of 4 HDDs on the same machine
specs. Scheduler 'none' for both. LSI card in writethrough cache mode.
All data in MB/s.


depth    jobs    bs    dflt    no_wq    %chg    raw disk
----------------randwrite, SSD--------------
128    1    4k    282    282    0    285
256    4    4k    251    183    -27    283
2048    4    4k    266    283    +6    284
1    4    1m    433    414    -4    403
----------------seqwrite, HDD---------------
128    1    4k    87    107    +23    86
256    4    4k    101    90     -11    91
2048    4    4k    273    233    -15    249
1    4    1m    144    146    +1    146
