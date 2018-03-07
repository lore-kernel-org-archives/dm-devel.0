From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/4] multipath-tools: important fixes for 0.7.5
Date: Thu,  8 Mar 2018 00:08:55 +0100
Message-ID: <20180307230859.14926-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Hi Christophe,

thanks for catching up. This series fixes immediate problems with
0.7.5. The first one corresponds to my previously posted
"[PATCH v3 2/2] multipathd: start marginal path checker thread lazily",
and fixes a crash. The others fix the problens reported by Xose.

Regards
Martin

Martin Wilck (4):
  libmultipath: fix crash on shutdown if io_err thread isn't running
  multipathd: fix -Wpointer-to-int-cast warning in uxlsnr
  multipath: fix clang warning in delegate_to_multipathd
  multipath-tools: build: prevent intermediate file deletion

 Makefile.inc                       | 1 +
 libmultipath/checkers/Makefile     | 2 ++
 libmultipath/foreign/Makefile      | 2 ++
 libmultipath/io_err_stat.c         | 3 +++
 libmultipath/prioritizers/Makefile | 2 ++
 multipath/main.c                   | 2 +-
 multipathd/uxlsnr.c                | 4 ++--
 tests/Makefile                     | 5 ++---
 8 files changed, 15 insertions(+), 6 deletions(-)

-- 
2.16.1
