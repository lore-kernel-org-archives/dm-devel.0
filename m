From: mwilck@suse.com
Subject: [PATCH 2/4] tests/Makefile: allow setting DIO_TEST_DEV
	in the environment
Date: Mon,  2 Mar 2020 23:20:23 +0100
Message-ID: <20200302222025.21022-3-mwilck@suse.com>
References: <20200302222025.21022-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200302222025.21022-1-mwilck@suse.com>
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

This change has two effects: 1. no error message is printed if
the directio_test_dev file doesn't exist, and 2. DIO_TEST_DEV
can be set in the environment, or on the "make" command line.
It's still possible to set DIO_TEST_DEV via the directio_test_dev
file if preferred.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tests/Makefile b/tests/Makefile
index 6e3e9ca2..5f6583a0 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -18,12 +18,14 @@ TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
 .SILENT: $(TESTS:%=%.o)
 .PRECIOUS: $(TESTS:%=%-test)
 
-DIO_TEST_DEV = $(shell sed -n -e 's/^[[:space:]]*DIO_TEST_DEV[[:space:]]*=[[:space:]]*\([^[:space:]\#]\+\).*/\1/p' < directio_test_dev)
-
 all:	$(TESTS:%=%.out)
 
 # test-specific compiler flags
 # XYZ-test_FLAGS: Additional compiler flags for this test
+
+ifneq ($(wildcard directio_test_dev),)
+DIO_TEST_DEV = $(shell sed -n -e 's/^[[:space:]]*DIO_TEST_DEV[[:space:]]*=[[:space:]]*\([^[:space:]\#]\+\).*/\1/p' < directio_test_dev)
+endif
 ifneq ($(DIO_TEST_DEV),)
 directio-test_FLAGS := -DDIO_TEST_DEV=\"$(DIO_TEST_DEV)\"
 endif
-- 
2.25.0
