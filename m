From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH 3/7] dm: add reserved_bio_based_ios module
	parameter
Date: Wed, 18 Sep 2013 08:17:01 -0700
Message-ID: <1379517421.32581.15.camel@bobble.lax.corp.google.com>
References: <alpine.LRH.2.02.1308261012400.12373@file01.intranet.prod.int.rdu2.redhat.com>
	<1379024698-10487-1-git-send-email-snitzer@redhat.com>
	<1379024698-10487-4-git-send-email-snitzer@redhat.com>
	<alpine.LRH.2.02.1309121845510.31794@file01.intranet.prod.int.rdu2.redhat.com>
	<20130912231135.GC31577@redhat.com>
	<alpine.LRH.2.02.1309121913160.3245@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1309121913160.3245@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Thu, 2013-09-12 at 19:17 -0400, Mikulas Patocka wrote:
> 
> On Thu, 12 Sep 2013, Mike Snitzer wrote:
> 
> > On Thu, Sep 12 2013 at  6:47pm -0400,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > We don't need this. bio-based i/o should be fine with a small mempool, 
> > > there is no need to make it tunable.
> > 
> > I'd like to get Frank's insight here.  He clearly had an interest in
> > tuning bio-based also.  While 16 shouldn't really hurt it could still be
> > artifically high.  I'm not opposed to exposing a sane default but
> > allowing other to experiemnt (in production workloads) with smaller
> > values that still enable forward progress should memory get exhausted.
> > 
> > Mike
> 
> I would do it this way: if Frank gets a measurable improvement in memory 
> consumption when the values is dropped from 16 to a lower number (4 or 
> maybe 1), then I would drop the value by default (don't make it tunable, 
> drop it for all users).
> 
> If there is no improvement when the value is lowered, I'd leave it as it 
> is, on 16.

I haven't had time to look at this lately, but I did see a small but
measurable reduction in memory consumption when I was dealing with this
before.  The real problem for us is the fact that we'll have tons of
these devices so even a small memory reduction means a lot when
multiplied by, say, a hundred devices across a thousand machines.  And
that's a _small_ number.

That said, I wouldn't want to see all Linux installs limited by our
specific case, which is why I would vote for a tunable rather than a
fixed, hardcoded value.
-- 
Frank Mayhar
310-460-4042
