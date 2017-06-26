From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-cache coherence issue
Date: Mon, 26 Jun 2017 15:56:17 -0400
Message-ID: <20170626195617.GA599@redhat.com>
References: <1ca408b4-0df2-d495-b899-28bded8217fa@gmx.de>
	<20170626113341.GA20683@nim> <20170626155808.GC20683@nim>
	<745c64ba-a5ec-363b-bc6f-2abd0d242b38@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <745c64ba-a5ec-363b-bc6f-2abd0d242b38@gmx.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Johannes Bauer <dfnsonfsduifb@gmx.de>
Cc: dm-devel@redhat.com, thornber@redhat.com
List-Id: dm-devel.ids

On Mon, Jun 26 2017 at  3:08pm -0400,
Johannes Bauer <dfnsonfsduifb@gmx.de> wrote:

> Hi Joe,
> 
> On 26.06.2017 17:58, Joe Thornber wrote:
> > On Mon, Jun 26, 2017 at 12:33:42PM +0100, Joe Thornber wrote:
> >> On Sat, Jun 24, 2017 at 03:56:54PM +0200, Johannes Bauer wrote:
> >>> So I seem to have a very basic misunderstanding of what the cleaner
> >>> policy/dirty pages mean. Is there a way to force the cache to flush
> >>> entirely? Apparently, "dmsetup wait" and/or "sync" don't do the job.
> >>
> >> I'll try and reproduce your scenario and get back to you.
> > 
> > Here's a similar scenario that I've added to the dm test suite:
> > 
> > https://github.com/jthornber/device-mapper-test-suite/commit/457e889b0c4d510609c0d7464af07f2ebee20768
> > 
> > It goes through all the steps you need to use to decommission a cache
> > with dirty blocks.  Namely:
> > 
> > - switch to writethrough mode (so new io can't create new dirty blocks)
> > - switch to the cleaner policy
> > - wait for clean
> > - remove the cache device before accessing the origin directly
> 
> Interesting, I did *not* change to writethrough. However, there
> shouldn't have been any I/O on the device (it was not accessed by
> anything after I switched to the cleaner policy).
> 
> On the advice of Zdenek Kabelac, who messaged me off-list, I therefore
> have indeed been convinced that using dm-cache "by hand" maybe is too
> dangerous (i.e., I had not accounted for "repairing" of a cache and am
> really still unsure what LVM does that) and that lvmcache is a better
> choice -- even though Ubuntu supports it really crappily for root devices:
> https://bugs.launchpad.net/ubuntu/+source/lvm2/+bug/1423796 a shame,
> it's been like this for over two years.
> 
> Anyways, I'll try to replicate my scenario again because I'm actually
> quite sure that I did everything correctly (I did it a few times).

Except you didn't first switch to writethrough -- which is _not_
correct.
