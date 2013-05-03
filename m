From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 05/16] Fix a couple of signal issues
Date: Fri, 3 May 2013 15:24:46 -0500
Message-ID: <20130503202445.GP6253@ether.msp.redhat.com>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
	<1367531197-8987-6-git-send-email-bmarzins@redhat.com>
	<51835AE3.7070604@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <51835AE3.7070604@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Fri, May 03, 2013 at 08:36:19AM +0200, Bart Van Assche wrote:
> On 05/02/13 23:46, Benjamin Marzinski wrote:
>> The patch cleans up some signal issues.
>> First, when the vecs locking around reconfigure got shuffled
>> around earlier, it was removed from sighup. This patch restores
>> that.
>>
>> Second, a new sigusr1 handler was created. However the existing
>> one was never removed.  Since signal handlers are per-process, and
>> not per-thread, the original handler will get overwritten by the
>> new one, so this patch deletes the original handler.
>>
>> Third, sighup locks the vecs lock and sigusr1 locks logq_lock.
>> However, these signals weren't being blocked before threads locked
>> those locks.  This patch blocks those signals while those locks
>> are being taken to avoid locking deadlocks.
>
> Are you aware that POSIX does not allow any locking function to be invoked 
> from inside a signal handler ? See e.g. 
> http://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.html#tag_15_04 
> and the text that starts with "The following table defines a set of 
> functions that shall be async-signal-safe. Therefore, applications can 
> invoke them, without restriction, from signal-catching functions" for a 
> list of C library functions that may be invoked from inside a signal 
> handler.

Um. no. I clearly wasn't aware of that. Nuts. So is the risk that a
signal will come into some thread that's not blocking it, and try to
acquire the pthread mutex at the same time as another thread that is
blocking the signal is trying to aquire the same mutex and that this
will corrupt the lock?

The Ubuntu man page for pthread_mutex_lock says

"The mutex functions are not async-signal safe. What this means is  that
 they should not be called from a signal handler. In particular, calling
 pthread_mutex_lock or pthread_mutex_unlock from a  signal handler  may
 deadlock the calling thread."

If that's the only risk, then blocking the signal before we lock the
mutexes should avoid the issue.  Since the point of mutexes is do deal
with multiple threads that are trying to acquire them at the same time,
it seems like they should be able to handle this when one of the threads
happens to be in a signal handler. Also, the locks in sighup were there
for a long time before they were removed, and while I have definitely
seen deadlocks when we don't remember to mask the signal before locking
on that thread, I've never encountered a bug that seems to be related to
a locking corruption like I speculated in the beginning of my reply.

Now, since my patch was to fix some potential deadlocks from using
pthread_mutex_locks in signal handlers, I do realize that the way
we are doing things isn't the safest way around.  Also, it seems pretty
obvious from looking at the URL you posted that we are in undefined
behavior territory, where if we are safe, it's solely based on the
some non-defined parts of the implementation. So I agree, we aren't
following the specs, and I'll work on redesigning things to avoid this.

But the locking I added in this patch fixes corruption that definitely
happens, and is very much able to crash multipathd.  I still think this
patch should go in, since those locks were previously there for a long
time, and I can easily crash multipathd by repeadly sending it sighups
without this patch.

Does that sound reasonable?

-Ben
>
> Bart.
