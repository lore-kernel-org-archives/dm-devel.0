From: Joe Thornber <thornber@redhat.com>
Subject: Re: Multisnap / dm-thin
Date: Thu, 19 Jan 2012 14:58:05 +0000
Message-ID: <20120119145742.GA12793@ubuntu>
References: <4F16A07C.7040705@shiftmail.org> <20120119093343.GB3942@ubuntu>
	<4F180AB2.3060801@shiftmail.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4F180AB2.3060801@shiftmail.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 19, 2012 at 01:21:06PM +0100, Spelic wrote:
> On 01/19/12 10:33, Joe Thornber wrote:
> but it seems to talk about a snapshot of an external origin.
> Supporting a readonly external origin is easy but it's not what I want.
> Supporting a r/w external origin... I don't know how it could ever
> be done since you won't receive notifications of the underlying
> origin changing. Would that be made with a sort of hook points in
> all device types in the kernel?
> 
> Seems a big can of worms to go that way just for my use case.
> For my use case it would be simpler if there was a way to fully
> preallocate a contiguous origin in thinp, and then the ability to
> disable discard implementation when it gets implemented. Clearly
> this would go against the name "thin".

The trouble with having a contiguous image within the pool, is you
then need to keep track of every other thin device that is sharing a
block.  If you write to the block you'd then have to update the
metadata for all these snaps, destroying the nice time complexity
properties (at the momement breaking sharing only changes the metadata
for the device being written too).

I'll think some more about this, but I don't think I've got a quick
answer for you.

> Another question: is support from userspace (LVM) planned? Is there
> an ETA? Will that be from you or we are waiting for LVM people to
> pick it up?
> Because being just DM it seems a bit hard to use.

Grab the latest lvm2 source from cvs.  It has thinp support.

- Joe
