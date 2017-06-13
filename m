From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 0/4] Four multipath-tools patches
Date: Tue, 13 Jun 2017 09:33:35 -0700
Message-ID: <20170613163339.23005-1-bart.vanassche@sandisk.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Christophe,

This patch series consists of four small patches: one patch that improves
portability of the kpartx source code and three patches that address compiler
warnings reported by gcc 7. Please consider these patches for merging.

Thanks,

Bart.

Bart Van Assche (4):
  kpartx: Improve portability of set_loop()
  libmultipath: Simplify assemble_map()
  libmultipath/datacore: Remove dead code
  multipath: Fix a potential buffer overflow

 kpartx/lopart.c                      | 10 ++----
 libmultipath/dmparser.c              | 67 +++++++++++++++++-------------------
 libmultipath/prioritizers/datacore.c | 10 +-----
 multipathd/cli_handlers.c            | 14 ++++----
 4 files changed, 40 insertions(+), 61 deletions(-)

-- 
2.12.2
