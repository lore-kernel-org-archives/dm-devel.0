From: Douglas McClendon <dmc.fedora@filteredperception.org>
Subject: Re: semop failed for cookie?
Date: Wed, 28 Apr 2010 22:32:54 -0500
Message-ID: <4BD8FDE6.40507@filteredperception.org>
References: <4BD74F99.8020605@filteredperception.org>
	<20100427223323.GB29708@agk-dp.fab.redhat.com>
	<4BD8C0B2.7020509@filteredperception.org>
	<20100429000045.GF29708@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100429000045.GF29708@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 04/28/2010 07:00 PM, Alasdair G Kergon wrote:
> On Wed, Apr 28, 2010 at 06:11:46PM -0500, Douglas McClendon wrote:
>> device-mapper: snaphots: Unable to perform snapshot handover until
>> source is suspended.
>
> It has never been OK to have the same snapshot metadata in use
> simultaneously in two targets at once (because of caching in memory).
> It's the responsibility of userspace to adhere to the correct semantics
> or live with the potential data corruption if they are violated.  It
> sounds like your process may fall into that second category.

Yeah, I had a hunch I was 'getting away with something'.  I.e. I wasn't 
acutely aware of the 3 differentiatable phases of the create.  In my 
case, literally nothing would happen while both instances were 'live', 
except the handoff.  And it seemed to work very reliably.  I.e. I would do

dmsetup create --table="same as rootfs's table (a snapshot)" rootfs-copy
dmsetup reload --table"mirror, goodside rootfs-copy, badside harddisk" 
rootfs
dmsetup resume rootfs

I guess I'll have to learn the new snapshot handover stuff.  Just let me 
know if you suspect some impossibility here.  Or if there is a magic 
--live-dangerously flag I can use :)

-dmc


>
> Part of the process of adding snapshot merging support involved
> providing a controlled method for handing over the snapshot metadata
> from one target instance to another.
>
> If you are trying to move a snapshot from one target to another, then
> you must either deactivate the snapshot first (older kernels) or (newer
> kernels) make use of the 'snapshot handover' mechanism as the message
> suggests.
>
> Alasdair
