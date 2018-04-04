From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/4] multipathd: decrease log verbosity
Date: Wed,  4 Apr 2018 18:21:56 +0200
Message-ID: <20180404162200.6518-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This patch set decreases the log level of some messages that we see often
time and that aren't usually helpful for debugging.

Martin Wilck (4):
  multipathd: decrease log level of "spurious uevent" message
  libmultipath: decrease log level of uevent filter/merge messages
  multipathd: decrease log level of waiter thread start/stop msgs
  libmpathpersist: decrease log level of various messages

 libmpathpersist/mpath_persist.c  |  2 +-
 libmpathpersist/mpath_pr_ioctl.c | 32 ++++++++++++++++----------------
 libmultipath/uevent.c            |  4 ++--
 multipathd/main.c                |  2 +-
 multipathd/waiter.c              |  4 ++--
 5 files changed, 22 insertions(+), 22 deletions(-)

-- 
2.16.1
