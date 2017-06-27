From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache coherence issue
Date: Tue, 27 Jun 2017 10:44:09 +0100
Message-ID: <20170627094409.GB4128@nim>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 26, 2017 at 10:36:23PM +0200, Johannes Bauer wrote:
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
> is in writeback mode? Would this also explain why the "dmsetup wait"
> hung indefinitely?

Some things to try to see if it makes a difference:

- unmount the cache before checksumming it so we know there's no IO from
  the page cache going in.

- deactivate the cache before checksumming the origin.

- Stop using encryption on top of cache and see if that makes a
  difference.

- Use 'dmsetup wait' properly, as Mike mentioned.  See the following code
  from dmtest:

    https://github.com/jthornber/device-mapper-test-suite/blob/master/lib/dmtest/cache_utils.rb#L28
    https://github.com/jthornber/device-mapper-test-suite/blob/master/lib/dmtest/device-mapper/event_tracker.rb

- use md5sum rather than your checksum program.  Humour me.



- Joe
