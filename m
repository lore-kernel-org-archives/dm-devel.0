From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-cache coherence issue
Date: Mon, 26 Jun 2017 17:34:36 -0400
Message-ID: <20170626213436.GA1003@redhat.com>
References: <1ca408b4-0df2-d495-b899-28bded8217fa@gmx.de>
	<20170626113341.GA20683@nim> <20170626155808.GC20683@nim>
	<745c64ba-a5ec-363b-bc6f-2abd0d242b38@gmx.de>
	<20170626195617.GA599@redhat.com>
	<5319af39-68eb-a732-0818-26f7d21ecbf1@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5319af39-68eb-a732-0818-26f7d21ecbf1@gmx.de>
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

On Mon, Jun 26 2017 at  4:36pm -0400,
Johannes Bauer <dfnsonfsduifb@gmx.de> wrote:

> On 26.06.2017 21:56, Mike Snitzer wrote:
> 
> >> Interesting, I did *not* change to writethrough. However, there
> >> shouldn't have been any I/O on the device (it was not accessed by
> >> anything after I switched to the cleaner policy).
> [...]
> >> Anyways, I'll try to replicate my scenario again because I'm actually
> >> quite sure that I did everything correctly (I did it a few times).
> > 
> > Except you didn't first switch to writethrough -- which is _not_
> > correct.
> 
> Absolutely, very good to know. So even without any I/O being request,
> dm-cache is allowed to "hold back" pages as long as the dm-cache device
> is in writeback mode?

s/pages/blocks/

The "dmsetup status" output for a DM cache device is showing dirty
accounting is in terms of cache blocks.

> Would this also explain why the "dmsetup wait" hung indefinitely?

You need to read the dmsetup man page, dmsetup wait" has _nothing_ to do
with waiting for IO to complete.  It is about DM events, without
specifying an event_nr you're just waiting for the device's event
counter to increment (which may never happen if you aren't doing
anything that'd trigger an event).  See:

"       wait [--noflush] device_name [event_nr]
              Sleeps until the event counter for device_name exceeds
              event_nr.  Use -v to see the event number returned.  To
              wait until the next event is triggered, use info to find
              the last event number.  With --noflush, the thin target
              (from version 1.3.0) doesn't commit any
              outstanding changes to disk before reporting its statistics."

> I do think I followed a tutorial that I found on the net regarding this.
> Scary that such a crucial fact is missing there. The fact that dirty
> pages are reported as zero just gives the impression that everything is
> coherent, when in fact it's not.

I'll concede that it is weird that you're seeing a different md5sum for
the origin vs the cache (that is in writeback mode yet reports 0 dirty
blocks).

But I think there is some important detail that would explain it; sadly
I'd need to dig in and reproduce on a testbed to identify it.  Maybe Joe
will be able to offer a quick answer?
