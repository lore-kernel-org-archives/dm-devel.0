From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] device mapper changes for 5.9
Date: Tue, 18 Aug 2020 14:02:27 -0700
Message-ID: <CAHk-=wjsz_w4zyJMHSL78MuOfxKcjDDfk2GfM2ZpjSjkOfzfwQ@mail.gmail.com>
References: <20200807160327.GA977@redhat.com> <CAHk-=wiC=g-0yZW6QrEXRH53bUVAwEFgYxd05qgOnDLJYdzzcA@mail.gmail.com>
 <20200807204015.GA2178@redhat.com> <CAMeeMh_=M3Z7bLPN3_SD+VxNbosZjXgC_H2mZq1eCeZG0kUx1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAMeeMh_=M3Z7bLPN3_SD+VxNbosZjXgC_H2mZq1eCeZG0kUx1w@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: John Dorminy <jdorminy@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-block <linux-block@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Damien Le Moal <damien.lemoal@wdc.com>, Ignat Korchagin <ignat@cloudflare.com>, JeongHyeon Lee <jhs2.lee@samsung.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, Mikulas Patocka <mpatocka@redhat.com>, Ming Lei <ming.lei@redhat.com>, yangerkun <yangerkun@huawei.com>
List-Id: dm-devel.ids

On Tue, Aug 18, 2020 at 1:40 PM John Dorminy <jdorminy@redhat.com> wrote:
>
>    The summary (for my FIO workloads focused on
> parallelism) is that offloading is useful for high IO depth random
> writes on SSDs, and for long sequential small writes on HDDs.

Do we have any non-microbenchmarks that might be somewhat
representative of something, and might be used to at least set a
default?

Or can we perhaps - even better - dynamically notice whether to offload or not?

I suspect that offloading is horrible for any latency situation,
particularly with any modern setup where the SSD is fast enough that
doing scheduling to another thread is noticeable.

After all, some people are working on polling IO, because the result
comes back so fast that taking the interrupt is unnecessary extra
work. Those people admittedly have faster disks than most of us, but
..

At least from a latency angle, maybe we could have the fairly common
case of a IO depth of 1 (because synchronous reads) not trigger it.

It looks like you only did throughput benchmarks (like pretty much
everybody always does, because latency benchmarks are a lot harder to
do well).

                 Linus
