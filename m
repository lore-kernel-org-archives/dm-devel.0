From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/8] multipath-tools: missing patches in 0.7.5
Date: Thu,  8 Mar 2018 00:15:43 +0100
Message-ID: <20180307231551.15162-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, Chongyun Wu <wu.chongyun@h3c.com>
List-Id: dm-devel.ids

Hi Christophe,

I'm reposting the following patches that have been reviewed already.
I think they should be merged.
(Well, the last one has not officially been reviewed but it makes no
functional changes and I'm quite positive Bart would approve).

Regards,
Martin

Bart Van Assche (4):
  libmultipath, alloc_path_with_pathinfo(): Ensure that pp->wwid is
    '\0'-terminated
  kpartx: Improve reliability of find_loop_by_file()
  libmultipath: Fix sgio_get_vpd()
  Introduce the ibmultipath/unaligned.h header file

Chongyun Wu (2):
  multipathd: add lock protection for cli_list_status
  libmultipath: enable feature disable changed wwid by default

Martin Wilck (2):
  libmultipath: fix wrong output of "multipath -t"
  libmultipath: remove FREE_CONST() again

 kpartx/lopart.c                       |  7 ++++---
 libmpathpersist/mpath_pr_ioctl.c      |  8 ++++----
 libmultipath/checkers/hp_sw.c         |  4 ++--
 libmultipath/defaults.h               |  2 +-
 libmultipath/devmapper.c              |  7 +++----
 libmultipath/dict.c                   | 25 ++++++++++++++---------
 libmultipath/discovery.c              | 17 +++++++++-------
 libmultipath/memory.h                 |  6 ------
 libmultipath/prioritizers/alua_rtpg.c | 13 ++++++------
 libmultipath/prioritizers/alua_spc3.h | 35 ++------------------------------
 libmultipath/prioritizers/ontap.c     |  4 ++--
 libmultipath/uevent.c                 | 12 +++++------
 libmultipath/uevent.h                 |  6 +++---
 libmultipath/unaligned.h              | 38 +++++++++++++++++++++++++++++++++++
 multipathd/main.c                     | 18 ++++++++---------
 tests/uevent.c                        | 16 +++++++--------
 16 files changed, 115 insertions(+), 103 deletions(-)
 create mode 100644 libmultipath/unaligned.h

-- 
2.16.1
