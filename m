From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 0/1] dm-crypt excessive overhead
Date: Tue, 23 Jun 2020 11:22:36 -0400
Message-ID: <20200623152235.GB19657@redhat.com>
References: <20200619164132.1648-1-ignat@cloudflare.com>
 <20200619165548.GA24779@redhat.com>
 <CY4PR04MB3751F148CCFAAC99A7F05CF7E7970@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200623150118.GA19657@redhat.com>
 <CALrw=nHNJTX3kzv2Q=dc6hYr=d8S2=gT0VHkWigS1pmwr9ps5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALrw=nHNJTX3kzv2Q=dc6hYr=d8S2=gT0VHkWigS1pmwr9ps5Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Mikulas Patocka <mpatocka@redhat.com>, "dm-crypt@saout.de" <dm-crypt@saout.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "agk@redhat.com" <agk@redhat.com>, "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>
List-Id: dm-devel.ids

On Tue, Jun 23 2020 at 11:07am -0400,
Ignat Korchagin <ignat@cloudflare.com> wrote:

> Do you think it may be better to break it in two flags: one for read
> path and one for write? So, depending on the needs and workflow these
> could be enabled independently?

If there is a need to split, then sure.  But I think Damien had a hard
requirement that writes had to be inlined but that reads didn't _need_
to be for his dm-zoned usecase.  Damien may not yet have assessed the
performance implications, of not have reads inlined, as much as you
have.

So let's see how Damien's work goes and if he trully doesn't need/want
reads to be inlined then 2 flags can be created.

Mike
