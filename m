From: mwilck@suse.com
Subject: [PATCH 4/4] tests: add README.md
Date: Mon,  2 Mar 2020 23:20:25 +0100
Message-ID: <20200302222025.21022-5-mwilck@suse.com>
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

Add a README explaining how to run the tests, and some of less obvious
stuff in the Makefile.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/README.md | 72 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)
 create mode 100644 tests/README.md

diff --git a/tests/README.md b/tests/README.md
new file mode 100644
index 00000000..6438a828
--- /dev/null
+++ b/tests/README.md
@@ -0,0 +1,72 @@
+# multipath-tools unit tests
+
+Unit tests are built and run by running `make test` in the top directory,
+or simply `make` in the `tests` subdirectory. The test output is saved as
+`<testname>.out`. The test programs are called `<testname>-test`, and can
+be run standalone e.g. for debugging purposes.
+
+## Notes on individual tests
+
+### Tests that require root permissions
+
+The following tests must be run as root, otherwise some test items will be
+skipped because of missing permissions, or the test will fail outright:
+
+ * `dmevents`
+ * `directio` (if `DIO_TEST_DEV` is set, see below)
+
+To run these tests, after building the tests as non-root user, change to the
+`tests` directory and run `make test-clean`; then run `make` again as root.
+
+### directio test
+
+This test includes test items that require a access to a block device. The
+device will be opened in read-only mode; you don't need to worry about data
+loss. However, the user needs to specify a device to be used. Set the
+environment variable `DIO_TEST_DEV` to the path of the device.
+Alternatively, create a file `directio_test_dev` under
+the `tests` directory containting a single line that sets this environment
+variable in Bourne Shell syntax, like this:
+
+    DIO_TEST_DEV=/dev/sdc3
+
+After that, run `make directio.out` as root in the `tests` directory to
+perform the test.
+
+## Adding tests
+
+The unit tests are based on the [cmocka test framework](https://cmocka.org/),
+and make use of cmocka's "mock objects" feature to simulate how the code behaves
+for different input values. cmocka achieves this by modifying the symbol
+lookup at link time, substituting "wrapper functions" for the originally
+called function. The Makefile contains code to make sure that `__wrap_xyz()`
+wrapper functions are automatically passed to the linker with matching
+`-Wl,--wrap` command line arguments, so that tests are correctly rebuilt if
+wrapper functions are added or removed.
+
+### Making sure symbol wrapping works: OBJDEPS
+
+Special care must be taken to wrap function calls inside a library. Suppose you want
+to wrap a function which is both defined in libmultipath and called from other
+functions in libmultipath, such as `checker_check()`. When `libmultipath.so` is
+created, the linker resolves calls to `checker_check()` inside the `.so`
+file. When later the test executable is built by linking the test object file with
+`libmultipath.so`, these calls can't be wrapped any more, because they've
+already been resolved, and wrapping works only for *unresolved* symbols.
+Therefore, object files from libraries that contain calls to functions
+which need to be wrapped must be explicitly listed on the linker command line
+in order to make the wrapping work. To enforce this, add these object files to
+the `xyz-test_OBJDEPS` variable in the Makefile.
+
+### Using wrapper function libraries: TESTDEPS
+
+Some wrapper functions are useful in multiple tests. These are maintained in
+separate input files, such as `test-lib.c` or `test-log.c`. List these files
+in the `xyz-test_TESTDEPS` variable for your test program if you need these
+wrappers.
+
+### Specifying library dependencies: LIBDEPS
+
+In order to keep the tests lean, not all libraries that libmultipath
+normally pulls in are used for every test. Add libraries you need (such as
+`-lpthread`) to the `xyz-test_LIBDEPS` variable.
-- 
2.25.0
