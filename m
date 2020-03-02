From: mwilck@suse.com
Subject: [PATCH 1/4] Remove tests/directio_test_dev
Date: Mon,  2 Mar 2020 23:20:22 +0100
Message-ID: <20200302222025.21022-2-mwilck@suse.com>
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

This file is designed to be customized and will therefore differ from
the committed version in every serious development environment. I find
that inconvenient, as the file needs to be stashed away before every
serious git activity, and could easily be committed by mistake.

Follow-up patches will enable various alternative ways to set the
DIO_TEST_DEV during build.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/directio_test_dev | 4 ----
 1 file changed, 4 deletions(-)
 delete mode 100644 tests/directio_test_dev

diff --git a/tests/directio_test_dev b/tests/directio_test_dev
deleted file mode 100644
index d64e6238..00000000
--- a/tests/directio_test_dev
+++ /dev/null
@@ -1,4 +0,0 @@
-# To run the directio tests on an actual block device, uncomment the line
-# starting with DIO_TES_DEV, and set it to the appropriate device
-
-# DIO_TEST_DEV=/dev/sdb
-- 
2.25.0
