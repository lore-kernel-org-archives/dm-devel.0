From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 0/9] speeding up mpathpersist
Date: Mon, 27 May 2019 14:59:33 +0200
Message-ID: <20190527125942.8366-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

We've had reports that mpathpersist doesn't scale well in environments
with lots of IO devices. This patch set tries to address this problem
with a few optimizations:

 - instead of doing a full path discovery at startup, only look at
   paths that are part of the maps being worked on
 - allow multiple PR commands in a single run using "batch files",
   without re-discovering everything between PR commands
 - avoid looking at priorities

I've done some basic testing and it seems to work. It remains to be
seen what the effect on performance really is, but the amount of system
calls to be performed for a given set of mpathpersist actions should
be substantially reduced in any case, especially when using batching.

---
v2:
 - avoid memory leak with --batch-file (Ben Marzinski)
 - add documentation to usage() output and mpathpersist man page
 - integrate "mpathpersist.8: fix examples in man page" which I'd sent
   separately before


Martin Wilck (9):
  mpathpersist: call usage() just once on return
  mpathpersist: add option --batch-file (-f)
  mpathpersist: no need to treat error close() as fatal
  libmpathpersist: updatepaths: deal with missing pp->udev
  libmpathpersist: factor out initialization and teardown
  mpathpersist: initialize data structures only once
  libmpathpersist: don't bother with priorities
  mpathpersist.8: fix examples in man page
  mpathpersist.8: add documentation for --batch-file (-f)

 libmpathpersist/mpath_persist.c | 250 +++++++++++++++-----------------
 libmpathpersist/mpath_persist.h |  40 +++++
 mpathpersist/main.c             | 227 ++++++++++++++++++++++-------
 mpathpersist/main.h             |   1 +
 mpathpersist/mpathpersist.8     | 121 ++++++++++++++--
 5 files changed, 440 insertions(+), 199 deletions(-)

-- 
2.21.0
