From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH V5 0/2] multipath-tools: intermittent IO error
	accounting to improve reliability
Date: Thu, 21 Sep 2017 16:07:57 +0800
Message-ID: <1505981279-11288-1-git-send-email-guanjunxiong@huawei.com>
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
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com, hare@suse.de, mwilck@suse.com, mmandala@Brocade.com
Cc: guanjunxiong@huawei.com, chengjike.cheng@huawei.com, niuhaoxin@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

Hi ALL,

This patchset add a new method of path state checking based on accounting
IO error. This is useful in many scenarios such as intermittent IO error
an a path due to network congestion, or a shaky link.

PATCH 1/2 implements the algorithm that sends a couple of continuous IOs
to a path which suffers two failed events in less than a given time. Those
IOs are sent at a fix rate of 10 Hz.
PATCH 2/2 discard the original algorithm because of this:
the detect sample interval of that path checkers is so big/coarse that
it doesn't see what happens in the middle of the sample interval. We have
the PATCH 1/2 as a better method.

Changes from V4:
* path_io_err_XXX -> marginal_path_err_XXX. (Mumeendra)
* add one more parameters named marginal_path_double_failed_time instead
  of the fixed 60 seconds for the pre-checking of a shaky path. (Martin)
* fix for "reschedule checking after %d seconds" log 
* path_io_err_recovery_time -> marginal_path_err_recheck_gap_time.
* put the marginal path into PATH_SHAKY instead of PATH_DELAYED 
* Modify the commit comments to sync with the changes above.


Changes from V3:
* add a patch for discard the san_path_XXX_feature 
* fail the path in the kernel before enqueueing the path for checking
  rather than after knowing the checking result to make it more
  reliable. (Martin)
* use posix_memalign instead of manual alignment for direct IO buffer. (Martin) 
* use PATH_MAX to avoid certain compiler warning when opening file
  rather than FILE_NAME_SIZE. (Martin)
* discard unnecessary sanity check when getting block size (Martin)
* do not return 0 in send_each_aync_io if io_starttime of a path is
  not set(Martin)
* Wait 10ms instead of 60 second if every path is down. (Martin)
* rename handle_async_io_timeout to poll_async_io_timeout and use polling
  method because io_getevents does not return 0 if there are timeout IO
  and normal IO.
* rename hit_io_err_recover_time ro hit_io_err_recheck_time 
* modify the multipath.conf.5 and commit comments to keep sync with the
  above changes


Changes from V2:
* fix uncondistional rescedule forverver
* use script/checkpatch.pl in Linux to cleanup informal coding style
* fix "continous" and "internel" typos


Changes from V1:
* send continous IO instead of a single IO in a sample interval (Martin)
* when recover time expires, we reschedule the checking process (Hannes)
* Use the error rate threshold as a permillage instead of IO number(Martin)
* Use a common io_context for libaio for all paths (Martin)
* Other small fixes (Martin)


Junxiong Guan (2):
  multipath-tools: intermittent IO error accounting to improve
    reliability
  multipath-tools: discard san_path_err_XXX feature

 libmultipath/Makefile      |   5 +-
 libmultipath/config.c      |   3 -
 libmultipath/config.h      |  21 +-
 libmultipath/configure.c   |   7 +-
 libmultipath/dict.c        |  88 +++---
 libmultipath/io_err_stat.c | 744 +++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/io_err_stat.h |  15 +
 libmultipath/propsel.c     |  70 +++--
 libmultipath/propsel.h     |   7 +-
 libmultipath/structs.h     |  15 +-
 libmultipath/uevent.c      |  32 ++
 libmultipath/uevent.h      |   2 +
 multipath/multipath.conf.5 |  89 ++++--
 multipathd/main.c          | 140 ++++-----
 14 files changed, 1043 insertions(+), 195 deletions(-)
 create mode 100644 libmultipath/io_err_stat.c
 create mode 100644 libmultipath/io_err_stat.h

-- 
2.11.1
