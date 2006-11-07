From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2.6.19 5/5] fs: freeze_bdev with semaphore
	not mutex
Date: Tue, 7 Nov 2006 23:23:03 +0000
Message-ID: <20061107232303.GB30653@agk.surrey.redhat.com>
References: <20061107183459.GG6993@agk.surrey.redhat.com>
	<20061107122837.54828e24.akpm@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061107122837.54828e24.akpm@osdl.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Srinivasa DS <srinivasa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 07, 2006 at 12:28:37PM -0800, Andrew Morton wrote:
> So...  what does this have to do with switching from mutex to semaphore?
 
I should have summarised the discussion, sorry.

This has always been a semaphore, but it got changed it to a mutex as part
of a global switch recently - and this indeed generated bug reports
from people who turn debugging on and report the error messages.

So the quick fix in this patch was to put things back how they were.


Now mutex.h states:
 * - only the owner can unlock the mutex
 * - task may not exit with mutex held

 * These semantics are fully enforced when DEBUG_MUTEXES is
 * enabled.

Which begs the question whether the stated semantics are stricter than
is actually necessary.

> If so, it's a bit sad to switch to semaphore just because of some errant
> debugging code.  Perhaps it would be better to create a new
> mutex_unlock_stfu() which suppresses the warning?
 
Ingo?

> > +	if (down_trylock(&bdev->bd_mount_sem))
> > +		return -EBUSY;
> > +
 
> This is a functional change which isn't described in the changelog.  What's
> happening here?

Srinivasa added it as a precaution.
Device-mapper should never fall foul of it, but confirming that is not
trivial unless you know the code well, so it's a useful check to prevent a
bug creeping back in.

Alasdair
-- 
agk@redhat.com
