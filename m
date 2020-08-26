From: mwilck@suse.com
Subject: [PATCH v2 00/10] multipath-tools: valgrind tests & fixes
Date: Wed, 26 Aug 2020 11:58:57 +0200
Message-ID: <20200826095907.5576-1-mwilck@suse.com>
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

Hi Christophe and Ben,

this series  adds a make target to run unit tests under valgrind, and fixes
the issues I found using this test target.

It contains the patches I sent yesterday ([PATCH 1/5] multipath-tools tests:
fix memory leak in alias test), but in a different order / numbering,
which seems more appropriate now.

Regards,
Martin

Martin Wilck (10):
  multipath-tools: Makefile.inc: fix compilation with gcc 4.x
  multipath-tools: Makefile: add "valgrind-test" target
  multipath-tools tests: fix memory leak in alias test
  multipath-tools tests: fix memory leak in hwtable test
  multipath-tools tests: fix memory leak in vpd test
  libmultipath: fix memory leak in ble handlers
  libmultipath: fix enable_foreign memory leak
  libmultipath: fix invalid memory access in is_token()
  libmultipath: alloc_strvec: NULL-initialize strvec elements
  libmultipath: validate_config_strvec(): avoid out-of-bounds access

 Makefile              |  3 +++
 Makefile.inc          |  2 +-
 libmultipath/config.c |  2 ++
 libmultipath/dict.c   | 12 +++++++++---
 libmultipath/parser.c | 17 +++++++++++------
 multipath/main.c      |  2 +-
 tests/Makefile        | 13 +++++++++++--
 tests/README.md       |  8 ++++++++
 tests/alias.c         |  2 ++
 tests/hwtable.c       |  4 ++++
 tests/vpd.c           | 18 ++++++++----------
 11 files changed, 60 insertions(+), 23 deletions(-)

-- 
2.28.0
