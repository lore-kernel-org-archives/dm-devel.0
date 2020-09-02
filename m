From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH 00/14] multipath-tools series: some cleanups and
 fixes checked by codedex tool
Date: Wed, 2 Sep 2020 14:40:39 +0800
Message-ID: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
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
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

Hi:
    Now, we check multipath-tools codes with codedex tool. Here
are some some cleanups and fixes.

Zhiqiang Liu (7):
  multipathd: use MALLOC and check return value in cli_getprkey func
  kpartx: check return value of malloc in main func
  libmultipath: check return value of dm_mapname in sysfs_check_holders
  libmultipath: donot free *dst if REALLOC fails in merge_words
  libmultipath: check whether mp->features is NULl in assemble_map
  util/tests: use assert_non_null to ensure malloc returns non-null
    pointer
  mpathpersist: check whether malloc paramp->trnptid_list fails in
    handle_args func

lixiaokeng (7):
  multipathd: return if dm_get_major_minor failed in cli_add_map
  libmultipath: check malloc return value in print_foreign_topology
  libmultipath: use map instead of dm_task_get_name
  multipathd: check MALLOC return value in mpath_pr_event_handler_fn
  libmultipathpersist: use update_multipath_table/status in get_mpvec
  multipath: use update_multipath_table/status in check_useable_paths
  multipathpersist: delete unused variable in handle_args

 kpartx/kpartx.c                 |  4 +++
 libmpathpersist/mpath_persist.c | 11 ++-----
 libmultipath/devmapper.c        |  2 +-
 libmultipath/dmparser.c         | 18 +++++------
 libmultipath/foreign.c          |  4 +++
 libmultipath/sysfs.c            |  6 +++-
 mpathpersist/main.c             | 56 +++++++++++++++++++++++++++------
 multipath/main.c                |  9 ++----
 multipathd/cli_handlers.c       | 17 +++++++---
 multipathd/main.c               |  8 +++--
 tests/util.c                    |  2 ++
 11 files changed, 96 insertions(+), 41 deletions(-)

-- 
