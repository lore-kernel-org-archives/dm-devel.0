From: mwilck@suse.com
Subject: [PATCH 00/11] Minor fixes for multipath-tools
Date: Tue, 12 May 2020 00:39:20 +0200
Message-ID: <20200511223931.18261-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Hi Christophe, hi Ben,

This series fixes a couple of issues I recently found with the 32bit build
of multipath-tools, and after integrating our CI into the automated builds
on our build server.

Regards
Martin

Martin Wilck (11):
  multipath-tools: Makefile: more dependency fixes for parallel build
  multipath-tools: Makefile.inc: separate out OPTFLAGS
  multipath-tools: Makefile.inc: allow user settings for LDFLAGS
  multipath-tools: Makefile.inc: set -Wno-error=clobbered
  libmultipath: discovery.c: use %z qualifier for size_t
  libmultipath: eliminate more signed/unsigned comparisons
  libmultipath: set_uint: fix parsing for 32bit
  multipath-tools tests/Makefile: add -lmpathcmd to LIBDEPS
  multipath tools tests/Makefile: Fix OBJDEPS for hwtable-test
  multipath-tools tests/test-lib.c: drop __wrap_is_claimed_by_foreign
  multipath-tools tests/directio: fix -Wmaybe-uninitalized warning

 Makefile                              |  5 +++--
 Makefile.inc                          | 16 ++++++++--------
 libmpathpersist/mpath_pr_ioctl.c      |  2 +-
 libmultipath/dict.c                   | 11 +++++++----
 libmultipath/discovery.c              | 16 ++++++++--------
 libmultipath/print.c                  | 12 ++++++------
 libmultipath/prioritizers/alua_spc3.h |  2 +-
 multipathd/cli_handlers.c             | 20 ++++++++++----------
 multipathd/main.c                     |  2 +-
 tests/Makefile                        |  4 ++--
 tests/directio.c                      |  2 +-
 tests/test-lib.c                      |  6 ------
 12 files changed, 48 insertions(+), 50 deletions(-)

-- 
2.26.2
