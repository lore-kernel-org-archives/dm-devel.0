From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 0/4] misc multipath patches
Date: Tue, 10 Sep 2019 17:39:17 -0500
Message-ID: <1568155161-9343-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

These are a couple of disconnected multipath patches.

Benjamin Marzinski (4):
  mpathpersist: remove broken/unused code
  libmultipath: EMC PowerMax NVMe device config
  mpathpersist: fix leaks
  libmultipath: fix mpcontext initialization

 libmpathpersist/mpath_persist.c      | 16 ++++----------
 libmultipath/checkers.c              | 29 ++++++++++++++++++++++++--
 libmultipath/checkers.h              |  1 +
 libmultipath/checkers/cciss_tur.c    |  5 +++++
 libmultipath/checkers/directio.c     |  5 +++++
 libmultipath/checkers/emc_clariion.c |  7 +++++++
 libmultipath/checkers/hp_sw.c        |  5 +++++
 libmultipath/checkers/rdac.c         |  5 +++++
 libmultipath/checkers/readsector0.c  |  5 +++++
 libmultipath/checkers/tur.c          |  5 +++++
 libmultipath/discovery.c             |  2 ++
 libmultipath/hwtable.c               |  6 ++++++
 mpathpersist/main.c                  | 31 ++++++++++++++++++----------
 13 files changed, 97 insertions(+), 25 deletions(-)

-- 
2.17.2
