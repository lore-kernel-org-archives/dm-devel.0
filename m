From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 0/7] speeding up mpathpersist
Date: Sat, 18 May 2019 00:56:56 +0200
Message-ID: <20190517225703.16295-1-mwilck@suse.com>
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
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dbond@redhat.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
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
seen what the effect on performance really is.

Regards
Martin

Martin Wilck (7):
  mpathpersist: call usage() just once on return
  mpathpersist: add option --batch-file (-f)
  mpathpersist: no need to treat error close() as fatal
  libmpathpersist: updatepaths: deal with missing pp->udev
  libmpathpersist: factor out initialization and teardown
  mpathpersist: initialize data structures only once
  libmpathpersist: don't bother with priorities

 libmpathpersist/mpath_persist.c | 250 +++++++++++++++-----------------
 libmpathpersist/mpath_persist.h |  40 +++++
 mpathpersist/main.c             | 218 +++++++++++++++++++++-------
 mpathpersist/main.h             |   1 +
 4 files changed, 320 insertions(+), 189 deletions(-)

-- 
2.21.0
