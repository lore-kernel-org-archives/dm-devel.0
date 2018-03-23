From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/2] Fix RCU hang
Date: Fri, 23 Mar 2018 15:00:44 -0500
Message-ID: <1521835246-29080-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

I have run into a RCU related hang with multipathd, when I reconfigured
and then shutdown multipathd in quick succession.  I haven't been able
to recreate it without manually adding a sleep() call to the code, but I
have figured out what could have caused it.

While the rcu code is waiting for a grace period to elapse, no threads
can register or unregister as rcu reader threads. If for some reason, a
thread never calls put_multipath_config() to exit a read side critical
section, then any threads trying to start or stop will hang. This can
happen if a thread is cancelled between calls to get_multipath_config()
and put_multipath_config(), and multipathd is reconfigured (which causes
the rcu code to wait for a grace period).

The only threads that get cancelled before the end of multipathd (at
least in the setup I was running) are the waiter threads and the tur
checker threads. The tur checker threads never hit a cancellation point
while in a read side critcal section (although they do have read side
critical sections due to using condlog, so they need to register with
the rcu code). The waiter threads can do this, but only while holding
the vecs lock, which should protect them from being cancelled.

The other threads occasionally hit cancellation points inside read side
critical sections while not protected by the vecs lock.  What appears to
have happened is that one of the threads was taking a long time in a
read side critical section starting before the reconfigure call to
call_rcu().  It remained in that section until the reconfigure ended,
and multipathd was shutdown, cancelling the thread.  I can easily
reproduce this by adding a sleep() into one of these sections.

The second patch may be overkill. In it, I fix all the multipathd code
to either not have a cancellation point in a read side critical section,
or to use a pthread_cleanup_handler. I could just fix the code that is
called without holding the vecs lock, since you can guarantee that the
waiter threads will never be cancelled while holding the vecs lock, and
that main threads can't hold a vecs lock while reconfigure is running,
and reconfigure will never run after the main threads have been
cancelled.  I did this for three reasons.

1. Without digging more into the rcu code, I couldn't be sure that the
reader thread simply needed to be in a quiescent state after call_rcu()
to count for the grace period. Since call_rcu() uses another thread to
wait for the grace period, it seemed possible that this rcu thread would
start checking threads for being in a queiescent state some time after
call_rcu() happened.  If this is the case, then holding the vecs lock
would protect a thread from having the rcu code start to wait for a
grace period.  This could probably be overcome be forcing the main
threads to be cancelled while holding the vecs lock, so that they 
could simply never be cancelled in these sections.

2. It seems sloppy to have threads exit without correctly finishing
their read side critical sections, even if we know that the rcu won't be
waiting for a grace period again before multipathd is shut down.

3. This would be adding one more surprising thing for the vecs lock to
be be in charge of. 

Benjamin Marzinski (2):
  multipathd: register threads that use rcu calls
  multipath: fix rcu thread cancellation hang

 libmultipath/checkers/rbd.c |  7 +++-
 libmultipath/checkers/tur.c |  9 +++--
 libmultipath/config.h       |  2 +-
 libmultipath/configure.c    | 90 +++++++++++++++++++++++++++------------------
 libmultipath/devmapper.c    | 10 +++--
 libmultipath/discovery.c    | 13 +++++--
 libmultipath/parser.c       |  3 +-
 libmultipath/structs_vec.c  |  9 +++--
 libmultipath/uevent.c       | 15 +++++---
 libmultipath/wwids.c        | 18 +++++----
 mpathpersist/main.c         |  2 +-
 multipath/main.c            |  2 +-
 multipathd/cli_handlers.c   | 86 +++++++++++++++++++++++++++----------------
 multipathd/main.c           | 64 +++++++++++++++++++++-----------
 tests/globals.c             |  2 +-
 15 files changed, 209 insertions(+), 123 deletions(-)

-- 
2.7.4
