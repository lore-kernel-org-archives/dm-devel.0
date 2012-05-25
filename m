From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 0/2] multipath: compile cleanup
Date: Thu, 24 May 2012 23:57:41 -0500
Message-ID: <1337921863-26482-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

When the multipath code is compiled with the standard redhat rpm cflags,
there are a number of warnings that get issued, some about real problems.

These patches switch multipath to use those cflags, and then clean up
warnings. If people want upstream to continue using the existing cflags,
I don't particularly mind.  I really included the first patch to make sure
people can see the warnings that the second patch corrects.

Also, some of the warnings are for actual errors, and how to fix them is
obvious.  Others won't actually cause problems, and if people object to
the changes I made to make them go away, I'm happy to fix them differently. 

Benjamin Marzinski (2):
  multipath: Build with standard rpm cflags
  multipath: Fix warnings from stricter compile options.

 Makefile.inc                     |    6 +++++-
 libmpathpersist/mpath_persist.c  |   10 +++++++---
 libmpathpersist/mpath_pr_ioctl.c |    9 +++++++++
 libmultipath/alias.c             |    8 ++++++--
 mpathpersist/main.c              |    2 --
 multipathd/main.c                |   24 +++++++++++++++++++-----
 6 files changed, 46 insertions(+), 13 deletions(-)

-- 
1.7.7
