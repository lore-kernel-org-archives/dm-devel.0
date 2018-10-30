From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 0/7] multipathd: make uxlsnr errors really
	fatal
Date: Tue, 30 Oct 2018 22:22:42 +0100
Message-ID: <20181030212249.31127-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Christophe,

this series, based on top of the recently submitted
"various multipath-tools patches (v2)" and "checkers overhaul (v3)"
series, fixes a problem that I recently observed: despite
ee01e841 "multipathd: handle errors in uxlsnr as fatal", multipathd
sometimes doesn't quit when the socket setup fails.

While at that, I stumbled upon init_path_check_interval(), wondered
about its purpose, and came to the conclusion that can be quite
easily obsoleted.

----
Changes v1->v2:
  04/07: Fixed problem observed by Ben.

Martin Wilck (7):
  libmultipath: set pp->checkint in store_pathinfo()
  multipathd: remove init_path_check_interval()
  multipathd: print error message if checkint is not initialized
  multipathd: open client socket early
  multipathd: set DAEMON_CONFIGURE from uxlsnr thread
  multipathd: make DAEMON_SHUTDOWN a terminal state
  multipathd: only grab conf once for filter_path()

 libmultipath/defaults.h   |   1 +
 libmultipath/dict.c       |  14 ++++-
 libmultipath/discovery.c  |   1 +
 libmultipath/structs.c    |   1 +
 multipathd/cli_handlers.c |  10 ++--
 multipathd/main.c         | 104 ++++++++++++++++++++++++--------------
 multipathd/uxlsnr.c       |  11 +---
 multipathd/uxlsnr.h       |   2 +-
 8 files changed, 92 insertions(+), 52 deletions(-)

-- 
2.19.1
