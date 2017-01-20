From: Gris Ge <fge@redhat.com>
Subject: [PATCH 0/5] [multipath-tools] Misc fixes for JSON API.
Date: Fri, 20 Jan 2017 21:38:57 +0800
Message-ID: <1484919542-11087-1-git-send-email-fge@redhat.com>
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
To: dm-devel@redhat.com
Cc: Gris Ge <fge@redhat.com>
List-Id: dm-devel.ids

Patch 5/5 is a resend.
Other patches are rework of 'multipath: Introducing multipath C API' patch set.

Gris Ge (5):
  multipath-tools: libmultipath: fix gcc link failure on
    rcu_register_thread_mb.
  multipath-tools: libmultipath: Removed unused functions.
  multipath-tools: New way to limit the IPC command length.
  multipath-tools: Set errno mpath_recv_reply() when failure
  multipath-tools: Perform socket client uid check on IPC commands.

 libmpathcmd/mpath_cmd.c |  6 +--
 libmultipath/Makefile   |  2 +-
 libmultipath/uxsock.c   | 99 +++++++++++++++----------------------------------
 libmultipath/uxsock.h   | 11 +++++-
 multipathd/main.c       | 12 +++++-
 multipathd/uxlsnr.c     | 27 ++++++++++++--
 multipathd/uxlsnr.h     |  4 +-
 7 files changed, 80 insertions(+), 81 deletions(-)

-- 
1.8.3.1
