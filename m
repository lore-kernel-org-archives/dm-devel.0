From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH V4 0/2] multipath-tools: intermittent IO error
	accounting to improve reliability
Date: Sun, 17 Sep 2017 11:40:36 +0800
Message-ID: <1505619638-20912-1-git-send-email-guanjunxiong@huawei.com>
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
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com, mwilck@suse.com
Cc: guanjunxiong@huawei.com, chengjike.cheng@huawei.com, mmandala@brocade.com, niuhaoxin@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

Hi ALL,

This patchset add a new method of path state checking based on accounting
IO error. This is useful in many scenarios such as intermittent IO error
an a path due to network congestion, or a shaky link.

PATCH 1/2 implements the algorithm that sends a couple of continuous IOs
at a fix rate of 10 Hz.
PATCH 2/2 discard the original algorithm because of this:
the detect sample interval of that path checkers is so big/coarse that
it doesn't see what happens in the middle of the sample interval. We have
the PATCH 1/2 as a better method.


Changes from V3:
* discard the 
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
 libmultipath/config.h      |  18 +-
 libmultipath/configure.c   |   6 +-
 libmultipath/dict.c        |  74 ++---
 libmultipath/io_err_stat.c | 743 +++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/io_err_stat.h |  15 +
 libmultipath/propsel.c     |  54 ++--
 libmultipath/propsel.h     |   6 +-
 libmultipath/structs.h     |  14 +-
 libmultipath/uevent.c      |  32 ++
 libmultipath/uevent.h      |   2 +
 multipath/multipath.conf.5 |  62 ++--
 multipathd/main.c          | 130 ++++----
 14 files changed, 971 insertions(+), 193 deletions(-)
 create mode 100644 libmultipath/io_err_stat.c
 create mode 100644 libmultipath/io_err_stat.h

-- 
2.11.1
