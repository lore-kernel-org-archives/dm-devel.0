From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 0/6] multipath-tools: Fix remaining shutdown
	delay issues
Date: Fri,  4 Jan 2019 18:59:08 +0100
Message-ID: <20190104175914.22784-1-mwilck@suse.com>
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
To: Chongyun Wu <wu.chongyun@h3c.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Hi Chongyun, Ben, all,

this patch set addresses the points where I can see that handling of
shutdown signals may be delayed, as discussed previously. Quoting my
previous post:

Let's summarize how multipathd exit works today:

 1. signal arrives
    (signal may be blocked while uxlsnr is busy, see above)
 2. signal is unblocked in uxlsnr thread (in ppoll())
 3. signal handler sets exit_sig()
 4. uxlsnr calls handle_signals()
 5. handle_signals()->exit_daemon() sets DAEMON_SHUTDOWN() and posts
config_cond (child may busy in reconfigure())
 6. child detects DAEMON_SHUTDOWN and quits main loop
 7. child locks vecs->lock (may cause wait)
 8. sets dm_queue_if_no_path, cancels threads, and exits.

I can imagine delays in step 1, 5, and 7, but not in ppoll().

This series addresses 1) in patch 5 and 6, 5) in patch 3, and 7) in patch 4.
The series also contains the part of Chongyun's previously posted patch
which I agree with.

The set is compile tested, but no more so far. Chongyun, I'd be grateful
if you could review it, and give it a try in your test setup.

Chongyun Wu (1):
  multipathd: fix daemon not really shutdown

Martin Wilck (5):
  multipathd: protect all access to running_state
  multipathd: allow shutdown during configure()
  multipathd: cancel threads early during shutdown
  multipathd: add code to handle blocked signals
  multipathd: uxlsnr: handle signals while busy

 libmultipath/configure.c |   5 ++
 libmultipath/discovery.c |   4 ++
 libmultipath/exit.h      |   5 ++
 mpathpersist/main.c      |   5 ++
 multipath/main.c         |   6 ++
 multipathd/cli.c         |  50 ++++++++++----
 multipathd/cli.h         |   2 +-
 multipathd/main.c        | 143 ++++++++++++++++++++++++++++-----------
 multipathd/main.h        |   1 +
 9 files changed, 166 insertions(+), 55 deletions(-)
 create mode 100644 libmultipath/exit.h

-- 
2.19.2
