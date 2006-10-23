From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: dm-snapshot scalability - chained delta snapshots
	approach
Date: Mon, 23 Oct 2006 19:16:02 +0200
Message-ID: <62b0912f0610231016r23585c34y6308cb3540ed926c@mail.gmail.com>
References: <44DA246B020000B60000BD22@lucius.provo.novell.com>
	<44DB5BDD020000B60000BD96@lucius.provo.novell.com>
	<44DB5C21.F25D.00B6.0@novell.com> <451A5915.F25D.00B6.0@novell.com>
	<20060927091700.GA6314@X40.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060927091700.GA6314@X40.redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Haripriya S wrote:
> Approach 1 - Chained delta snapshots
>
> Advantages:
> 1. Very simple, adds very few lines of code to existing dm-snap code.

Nice.

> 2. Does not change the dm-snapshot architecture, and no changes
> required in LVM or EVMS

Nice.

> 3. Since the COW copies due to origin write will always go to the most
> recent snapshot, snapshot COW devices can be created with less size.
> Whenever the COW allocation increase beyond say 90%, a new snapshot can
> be created which will take all the subsequent COW copies. This may avoid
> making COW devices invalid.

Nice !!!!!

> Disadvantages:
> 1. snapshots which were independent previously are now dependent on
> each other. Corruption of one COW device will affect the other snapshots
> as well.

Fixing dm-snapshot so devices do not get corrupted would make
dm-snapshot immensely more useful.
One way of doing that is to provoke bugs to more quickly become
visible to the user.  I think your patch might accomplish this.
Another way is to keep the code simple.  I'd say your patch does that.

(A third way is extensive testing, and a fourth is mathematically
proving that the code is sane.  But who has the time and energy ;-).)

Overall, what you're doing looks like a good thing for stability.

> 2. Will have a small impact in snapshot read performance,
> currently (if I understood right)

Minor disadvantage compared to the massive improvements seen in write speed.
Can be optimized on later.

(Fx. caching a list of which exceptions exist other places in the chain..)

> 3. There is a need to change the disk exception structure

Hopefully there's a version number on disk which allows incompatible
tools to skip lv's or whatever.

If not, this is a great excuse to create one.

> 4. When snapshots are deleted the COW exceptions have to be transferred
> to the next snapshot in the write chain.

Jan Blunck wrote:
> This means that every snapshot still has its own exception store.
> This would make deletion of snapshots unnecessary complex.

Complex, how?

Necessary operations (in order listed):
 * Acquire exclusive lock on this snapshot.
 * Check that next snapshot has room for exceptions, abort if not.
 * Acquire exclusive lock on next snapshot.
 * Move all exceptions to next snapshot.
 * Unlock next snapshot.
 * Remove this snapshot.
 * Done...

Sounds simple to me, but maybe I'm missing the point.

> It moves the work (copying of chunks)
> to the deletion of the snapshot.

Snapshot deletion is usually a "low privilege" task, something done
to redeem disk space on a periodic schedule.  It is not something a
user absolutely needs to finish immediately.  Sounds like a very
fair deal to me, but then again, I'm just a user.

> We discussed some of the ideas about snapshots here at the dm summit. The
> general ideas are as follows:
>
> - one exception store per origin device that is shared by all snapshots

Now that sounds complex.

> Although that includes a complete redesign of the exception store code.

Especially when you say stuff like that :-).

> The throughput issues should be addressed by only
> writing to one exception store.

Wouldn't this make debugging more complex, and further add to
the difficulty of snapshot resizing?
