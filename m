From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH V2 00/14] multipath-tools series: some cleanups
 and fixes checked by codedex tool
Date: Tue, 8 Sep 2020 14:50:03 +0800
Message-ID: <a3672ace-9637-20e2-04ce-857e364ffdb3@huawei.com>
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
Content-Language: en-GB
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, dm-devel mailing list <dm-devel@redhat.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

Patches 01, 02, 04, 05, 06, 09, 11, 12, 14 have some changes.

Changes in V2:
- patch 01: set major and minor to -1 at begining, as suggested
  by Martin Wilck
- patch 02: chanege malloc to calloc to calloc, as suggested by
  Martin Wilck
- patch 04: delete seting ret when jump to out, as suggested by
  Martin Wilck
- patch 05: turn back MALLOC to malloc and reomve error message,
  as suggested by Martin Wilck
- patch 06: change malloc to xmalloc, as suggested by Martin Wilck
- patch 09: use ?: instead of checking mp->features, as suggested
  by Benjamin Marzinski
- patch 11: change num_transport to num_transportids to combine them,
  as suggested by Benjamin Marzinski
- patch 12: delete continue and add remove_map, as suggested by
  Martin Wilck
- patch 14: modify patch because of patch 11 "mpathpersist: check
  whether malloc paramp->trnptid_list fails in handle_args func"
  changing

Zhiqiang Liu (7):
  multipathd: use MALLOC and check return value in cli_getprkey func
  kpartx: check return value of malloc in main func
  libmultipath: check return value of dm_mapname in sysfs_check_holders
  libmultipath: donot free *dst if REALLOC fails in merge_words
  libmultipath: check whether mp->features is NUll in assemble_map
  util/tests: use assert_non_null to ensure malloc returns non-null
    pointer
  mpathpersist: check whether malloc paramp->trnptid_list fails in
    handle_args func

lixiaokeng (7):
  multipathd: initialize major and minor in cli_add_map
  libmultipath: change malloc to calloc in print_foreign_topology
  libmultipath: use map instead of dm_task_get_name
  multipathd: check MALLOC return value in mpath_pr_event_handler_fn
  libmultipathpersist: use update_multipath_table/status in get_mpvec
  multipath: use update_multipath_table/status in check_useable_paths
  multipathpersist: delete unused variable in handle_args

 kpartx/kpartx.c                 |  5 ++-
 libmpathpersist/mpath_persist.c | 15 +++-----
 libmultipath/devmapper.c        |  2 +-
 libmultipath/dmparser.c         | 17 +++------
 libmultipath/foreign.c          |  4 +-
 libmultipath/sysfs.c            |  6 ++-
 mpathpersist/main.c             | 66 +++++++++++++++++++++++++--------
 multipath/main.c                |  9 ++---
 multipathd/cli_handlers.c       |  4 +-
 multipathd/main.c               |  8 ++--
 tests/util.c                    |  2 +
 11 files changed, 86 insertions(+), 52 deletions(-)

--
