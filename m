From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 0/7] multipathd 'cookie' handling rework
Date: Mon,  9 May 2016 12:52:58 +0200
Message-ID: <1462791185-2903-1-git-send-email-hare@suse.de>
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
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi all,

here's now the second attempt to fixup the 'cookie' handling
in multipath-tools.
I've removed the patch to pass in a cookie as an argument
for dm_addmap_reload() and dm_simplecmd().
And I've removed all instances where we had been calling
dm_udev_complete() after failing to set the cookie to a task.

As usual, reviews and comments are welcome.

Hannes Reinecke (7):
  devmapper: do not flush I/O for DM_DEVICE_CREATE
  devmapper: do not call dm_udev_complete if dm_task_set_cookie() failed
  configure: Rename ACT_RENAME2 to ACT_FORCERENAME
  devmapper: wait for udev in dm_simplecmd_noflush()
  multipathd: wait for udev in cli_resume()
  devmapper: remove 'udev_sync' argument from dm_simplecmd_noflush()
  libmultipath: Fixup 'DM_DEVICE_RELOAD' handling

 libmultipath/configure.c  | 20 ++++---------
 libmultipath/configure.h  |  2 +-
 libmultipath/devmapper.c  | 75 +++++++++++++++++++++++++++++++----------------
 libmultipath/devmapper.h  |  4 +--
 multipathd/cli_handlers.c |  4 +--
 5 files changed, 60 insertions(+), 45 deletions(-)

-- 
2.6.6
