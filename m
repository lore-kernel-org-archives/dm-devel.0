From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/6] More Misc Multipath patches
Date: Wed, 10 Oct 2018 13:01:07 -0500
Message-ID: <1539194473-6243-1-git-send-email-bmarzins@redhat.com>
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

Here are the patches that I've built up while getting my last batch
accepted, as well as a change for the tur checker to hopefully
address Martin's short term objections to commit 455242d
(libmultipath: fix tur checker timeout).

Benjamin Marzinski (6):
  multipath: tweak logging style
  multipathd: check for NULL udevice in cli_add_path
  libmultipath: remove max_fds code duplication
  multipathd: set return code for multipathd commands
  mpathpersist: fix registration rollback issue
  libmultipath: timeout on unresponsive tur thread

 libmpathpersist/mpath_persist.c | 16 +++-------------
 libmultipath/checkers/tur.c     |  6 +++---
 libmultipath/devmapper.c        |  8 ++++----
 libmultipath/util.c             | 31 +++++++++++++++++++++++++++++++
 libmultipath/util.h             |  1 +
 multipath/main.c                | 12 +-----------
 multipathd/cli_handlers.c       |  4 ++++
 multipathd/main.c               | 41 +++++++++--------------------------------
 multipathd/uxclnt.c             | 13 ++++++++-----
 9 files changed, 64 insertions(+), 68 deletions(-)

-- 
2.7.4
