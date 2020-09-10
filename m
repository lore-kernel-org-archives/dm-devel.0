From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH V4 00/14] multipath-tools series: some cleanups
 and fixes checked by codedex tool
Date: Thu, 10 Sep 2020 18:45:17 +0800
Message-ID: <f8c2133b-6c02-4cc4-59cd-162828154689@huawei.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel
	mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

Patches 01, 02, 04, 05, 06, 09, 11, 12, 14 have some changes

Patches 01, 02, 04, 05, 11, 12, 14: change commit message
Patches 06: move xmalloc before main
Patches 09: check strdup result in setup_map, add message
"mp->features must not be NULL" in assemble_map

Zhiqiang Liu (7):
  multipathd: check return value of malloc in cli_getprkey func
  kpartx: use xmalloc to instead of malloc in main func
  libmultipath: check return value of dm_mapname in sysfs_check_holders
  libmultipath: donot free *dst if REALLOC fails in merge_words
  libmultipath: check whether mpp->features is NUll in setup_map
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

 kpartx/kpartx.c                 | 36 +++++++++---------
 libmpathpersist/mpath_persist.c | 15 +++-----
 libmultipath/configure.c        |  5 +++
 libmultipath/devmapper.c        |  2 +-
 libmultipath/dmparser.c         | 18 ++++-----
 libmultipath/foreign.c          |  4 +-
 libmultipath/sysfs.c            |  6 ++-
 mpathpersist/main.c             | 66 +++++++++++++++++++++++++--------
 multipath/main.c                |  9 ++---
 multipathd/cli_handlers.c       |  4 +-
 multipathd/main.c               |  8 ++--
 tests/util.c                    |  2 +
 12 files changed, 106 insertions(+), 69 deletions(-)

--
