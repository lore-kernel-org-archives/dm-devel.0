From: John Dorminy <jdorminy@redhat.com>
Subject: Re: [git pull] device mapper changes for 5.9
Date: Wed, 19 Aug 2020 00:25:20 -0400
Message-ID: <CAMeeMh_4j9EyOB3evyHi536d8kocH3egPdGO_FZj+G5iZzkVrQ@mail.gmail.com>
References: <20200807160327.GA977@redhat.com> <CAHk-=wiC=g-0yZW6QrEXRH53bUVAwEFgYxd05qgOnDLJYdzzcA@mail.gmail.com>
 <20200807204015.GA2178@redhat.com> <CAMeeMh_=M3Z7bLPN3_SD+VxNbosZjXgC_H2mZq1eCeZG0kUx1w@mail.gmail.com>
 <CALrw=nHD81X4YCpuk-Pp9_FSFba6LZEVUwo-YkYh1nL9pEbzpA@mail.gmail.com> <CAHk-=wj95eQxPOEMHe8j3zmpZYHbv8kZ0nz8fUUCO6acENTs0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wj95eQxPOEMHe8j3zmpZYHbv8kZ0nz8fUUCO6acENTs0w@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ignat Korchagin <ignat@cloudflare.com>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-block <linux-block@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Damien Le Moal <damien.lemoal@wdc.com>, JeongHyeon Lee <jhs2.lee@samsung.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, Mikulas Patocka <mpatocka@redhat.com>, Ming Lei <ming.lei@redhat.com>, yangerkun <yangerkun@huawei.com>
List-Id: dm-devel.ids

Your points are good. I don't know a good macrobenchmark at present,
but at least various latency numbers are easy to get out of fio.

I ran a similar set of tests on an Optane 900P with results below.
'clat' is, as fio reports, the completion latency, measured in usec.
'configuration' is [block size], [iodepth], [jobs]; picked to be a
varied selection that obtained excellent throughput from the drive.
Table reports average, and 99th percentile, latency times as well as
throughput. It matches Ignat's report that large block sizes using the
new option can have worse latency and throughput on top-end drives,
although that result doesn't make any sense to me.

Happy to run some more there or elsewhere if there are suggestions.

devicetype    configuration    MB/s    clat mean    clat 99%
------------------------------------------------------------------
nvme base    1m,32,4     2259    59280       67634
crypt default    1m,32,4     2267    59050       182000
crypt no_w_wq    1m,32,4     1758    73954.54    84411
nvme base    64k,1024,1    2273    29500.92    30540
crypt default    64k,1024,1    2167    29518.89    50594
crypt no_w_wq    64k,1024,1    2056    31090.23    31327
nvme base    4k,128,4    2159      924.57    1106
crypt default    4k,128,4    1256     1663.67    3294
crypt no_w_wq    4k,128,4    1703     1165.69    1319

Ignat, how do these numbers match up to what you've been seeing?

-John


On Tue, Aug 18, 2020 at 5:23 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, Aug 18, 2020 at 2:12 PM Ignat Korchagin <ignat@cloudflare.com> wrote:
> >
> > Additionally if one cares about latency
>
> I think everybody really deep down cares about latency, they just
> don't always know it, and the benchmarks are very seldom about it
> because it's so much harder to measure.
>
> > they will not use HDDs for the workflow and HDDs have much higher IO latency than CPU scheduling.
>
> I think by now we can just say that anybody who uses HDD's don't care
> about performance as a primary issue.
>
> I don't think they are really interesting as a benchmark target - at
> least from the standpoint of what the kernel should optimize for.
>
> People have HDD's for legacy reasons or because they care much more
> about capacity than performance.  Why should _we_ then worry about
> performance that the user doesn't worry about?
>
> I'm not saying we should penalize HDD's, but I don't think they are
> things we should primarily care deeply about any more.
>
>                Linus
>
