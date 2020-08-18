From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH 0/5] multipath-tools series: coredump and memory
	leak bugfix
Date: Tue, 18 Aug 2020 20:59:15 +0800
Message-ID: <5ef5f58e-3a27-8959-3abb-4b4c401cc309@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: linfeilong@huawei.com, liuzhiqiang26@huawei.com
List-Id: dm-devel.ids

When I learn the multipath-tools source code and test it, I
find some bugs and fix them.

repo: openSUSE/multipath-tools
repo link: https://github.com/openSUSE/multipath-tools
branch: upstream-queue

lixiaokeng (5):
  libmultipath: fix a memory leak in set_ble_device
  libmultipath: fix NULL dereference in select_action
  multipathd: add reclear_pp_from_mpp in ev_remove_path
  multipathd: disable queueing for recreated map in uev_remove_map
  libmultipath: fix daemon memory leak in disassemble_map

 libmultipath/blacklist.c | 79 +++++++++++++++++++++-------------------
 libmultipath/blacklist.h |  4 +-
 libmultipath/configure.c | 30 +++++++++++----
 libmultipath/dmparser.c  | 14 ++++++-
 multipathd/main.c        | 28 ++++++++++++++
 tests/blacklist.c        | 31 +++++++---------
 6 files changed, 119 insertions(+), 67 deletions(-)
