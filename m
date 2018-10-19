From: "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
Subject: Re: dm_cache BUG() after power loss
Date: Fri, 19 Oct 2018 15:17:51 +0200
Message-ID: <20181019131750.vunsciklcwsevdv7@sesse.net>
References: <20181009160051.xlcpnnmyvhbivglk@sesse.net>
	<20181019130350.GA11067@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181019130350.GA11067@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Fri, Oct 19, 2018 at 09:03:50AM -0400, Mike Snitzer wrote:
> Please provide the "dmsetup table" line for the cache device if you can.

It's torn down by now, unfortunately. I can create a new volume and set it
up, if it helps you?

> Are you using writeback mode?

No, it's writethrough. I'd love to use writeback, but I've lost too much data
to it, so I don't really trust it anymore. :-/

Is writethrough actually pure writethrough? When recovering, I had repeated
rounds of:

  - Get to initramfs, which tried to set up the cache and failed.
  - fsck the real, underlying volume, which had lots of corruption.
  - Boot from it.
  - Reboot.
  - Repeat to step 1.

In particular, the volume seemed to become corrupt over and over again
(indicating that dm-cache was writing something to it before it failed),
until I took out the lines fromcachetab.

> Given the "block manager: array validator check failed for block 2156"
> error it could easily be that you need to run cache_check and
> cache_repair.

I hadn't heard of these tools before, and they're not mentioned in
device-mapper/cache.txt. (They should probably have been mentioned in the
error message, too.) Where can I find them?

> Joe (cc'd) may have more specific repair guidance for
> you (though Joe is going on vacation.. bad timing).

Repair is way too late anyway; like I wrote in the original message, I had to
just clear out the entire cache volume to get anywhere.

/* Steinar */
-- 
Homepage: https://www.sesse.net/
