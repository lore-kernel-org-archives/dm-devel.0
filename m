From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] device mapper changes for 5.9
Date: Tue, 18 Aug 2020 14:22:57 -0700
Message-ID: <CAHk-=wj95eQxPOEMHe8j3zmpZYHbv8kZ0nz8fUUCO6acENTs0w@mail.gmail.com>
References: <20200807160327.GA977@redhat.com> <CAHk-=wiC=g-0yZW6QrEXRH53bUVAwEFgYxd05qgOnDLJYdzzcA@mail.gmail.com>
 <20200807204015.GA2178@redhat.com> <CAMeeMh_=M3Z7bLPN3_SD+VxNbosZjXgC_H2mZq1eCeZG0kUx1w@mail.gmail.com>
 <CALrw=nHD81X4YCpuk-Pp9_FSFba6LZEVUwo-YkYh1nL9pEbzpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CALrw=nHD81X4YCpuk-Pp9_FSFba6LZEVUwo-YkYh1nL9pEbzpA@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: John Dorminy <jdorminy@redhat.com>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-block <linux-block@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Damien Le Moal <damien.lemoal@wdc.com>, JeongHyeon Lee <jhs2.lee@samsung.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, Mikulas Patocka <mpatocka@redhat.com>, Ming Lei <ming.lei@redhat.com>, yangerkun <yangerkun@huawei.com>
List-Id: dm-devel.ids

On Tue, Aug 18, 2020 at 2:12 PM Ignat Korchagin <ignat@cloudflare.com> wrote:
>
> Additionally if one cares about latency

I think everybody really deep down cares about latency, they just
don't always know it, and the benchmarks are very seldom about it
because it's so much harder to measure.

> they will not use HDDs for the workflow and HDDs have much higher IO latency than CPU scheduling.

I think by now we can just say that anybody who uses HDD's don't care
about performance as a primary issue.

I don't think they are really interesting as a benchmark target - at
least from the standpoint of what the kernel should optimize for.

People have HDD's for legacy reasons or because they care much more
about capacity than performance.  Why should _we_ then worry about
performance that the user doesn't worry about?

I'm not saying we should penalize HDD's, but I don't think they are
things we should primarily care deeply about any more.

               Linus
