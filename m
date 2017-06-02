From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/5] misc multipath patches
Date: Thu,  1 Jun 2017 22:09:07 -0500
Message-ID: <1496372952-27110-1-git-send-email-bmarzins@redhat.com>
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

This is another collection of miscellaneous patches. The first one is
just a resend. The second is a change to how the rados checker is enable
that makes it easier to build packages for multiple architectures (since
librados isn't supported on all architectures yet). If people have
objections, I can continue to use the existing build option. The third
is a change that's necessary to get warning messages for bad config
files.  Another option would be to just change all the config warning
messages to the highest priority. The last two are bugfixes.

Benjamin Marzinski (5):
  libmultipath: add comment about resuming
  libmultipath: change how RADOS checker is enabled
  multipath: set verbosity to default during config
  mpath: skip device configs without vendor/product
  multipathd: fix "show maps json" crash

 Makefile.inc                   | 13 +++++++++++++
 libmultipath/checkers/Makefile |  3 ++-
 libmultipath/config.c          |  7 +++++++
 libmultipath/debug.c           |  3 ++-
 libmultipath/devmapper.c       |  3 +++
 multipathd/cli_handlers.c      |  6 ++++--
 6 files changed, 31 insertions(+), 4 deletions(-)

-- 
2.7.4
