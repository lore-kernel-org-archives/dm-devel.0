From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 23/24] domap(): never return DOMAP_RETRY
	in daemon mode
Date: Tue, 11 Dec 2018 11:41:45 -0600
Message-ID: <20181211174145.GG13270@octiron.msp.redhat.com>
References: <20181203193624.21870-1-mwilck@suse.com>
	<20181203193624.21870-6-mwilck@suse.com>
	<20181203234548.GA13270@octiron.msp.redhat.com>
	<f38d7a41bb82324eb0d6d362bf68ba637012899e.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <f38d7a41bb82324eb0d6d362bf68ba637012899e.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: mwilck+gmail@suse.de, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Dec 09, 2018 at 10:06:05PM +0100, Martin Wilck wrote:
> On Mon, 2018-12-03 at 17:45 -0600,  Benjamin Marzinski  wrote:
> 
> TL;DR: I'm 99.7% sure we don't need lock_multipath() any more.
> 
> The historic reason is 4d7a270:
> 
>     'Multiple multipath(8) execs can race with udev storm.
>     
>     We can simulate this with the following :
>     "multipath -F; /sbin/multipath 8:16 & /sbin/multipath 8:32"
>     
>     Problem arise when two runs are about to create the same map.
>     One will fail, leaving us with a choice : abord or retry.'
> 
> This commit was made at a time (October 2005) when multipath was called
> directly from udev rules to set up maps. Earlier versions of multipath
> had a general locking that would not allow multiple multipath commands
> to run in parallel, but that has been removed later. This was an
> attempt to lock only (would-be) members of one specific map.
> 
> Obviously, the goal of this patch wouldn't be achieved any more since
> the lock has been change to non-exclusive (1c50cd32). Multiple
> multipath instances run happily on members of the same set now. I
> haven't tested it, but I believe the historic race "/sbin/multipath
> 8:16 & /sbin/multipath 8:32" still exists; just we don't run multipath
> this way from udev rules any more. 
> 
> lock_multipath() doesn't help us void this race, as we can't go back to
> exclusive locking. If we want to avoid it, we could create a lock file
> from the WWID before calling domap(), /dev/shm/multipath/$WWID.lock or
> so. Or we could use a SYSV semaphore set.

I vote for removing lock_multipath(). Personally, I've never seen anyone
report the anything that looks like a multiple creation race since we've
changed the locking to shared, so I'm fine with leaving it out, but I
certainly wouldn't NAK a patch that added useful locking back in.

-Ben
