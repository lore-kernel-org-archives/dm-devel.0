From: Tushar Sugandhi <tusharsu-1pm0nblsJy7Jp67UH1NAhkEOCMrvLtNR@public.gmane.org>
Subject: [PATCH v2 0/2] IMA: Add test for dm-crypt measurement
Date: Sun, 27 Sep 2020 20:56:03 -0700
Message-ID: <20200928035605.22701-1-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ltp-bounces+glt-ltp-list=m.gmane-mx.org-cunTk1MwBs91InPhgRC9rw@public.gmane.org>
List-Unsubscribe: <https://lists.linux.it/options/ltp>,
 <mailto:ltp-request-cunTk1MwBs91InPhgRC9rw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linux.it/pipermail/ltp/>
List-Post: <mailto:ltp-cunTk1MwBs91InPhgRC9rw@public.gmane.org>
List-Help: <mailto:ltp-request-cunTk1MwBs91InPhgRC9rw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linux.it/listinfo/ltp>,
 <mailto:ltp-request-cunTk1MwBs91InPhgRC9rw@public.gmane.org?subject=subscribe>
Errors-To: ltp-bounces+glt-ltp-list=m.gmane-mx.org-cunTk1MwBs91InPhgRC9rw@public.gmane.org
Sender: "ltp" <ltp-bounces+glt-ltp-list=m.gmane-mx.org-cunTk1MwBs91InPhgRC9rw@public.gmane.org>
To: zohar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, gmazyland-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pvorel-AlSwsSmVLrQ@public.gmane.org
Cc: nramas-1pm0nblsJy7Jp67UH1NAhkEOCMrvLtNR@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ltp-cunTk1MwBs91InPhgRC9rw@public.gmane.org
List-Id: dm-devel.ids

New functionality is being added to IMA to measure data provided by
kernel components. With this feature, IMA policy can be set to enable
measuring data provided by device-mapper targets. Currently one such
device-mapper target - dm-crypt, is being updated to use this
functionality. This new functionality needs test automation in LTP.

Some of the existing functionality in ima_keys.sh can be reused for
this, but it needs to be refactored into generic functions first.

Add a testcase which verifies that the IMA subsystem correctly measures
the data coming from a device-mapper target - dm-crypt.
Refactor common functionality in ima_keys.sh for this, and move the
generic functions to ima_setup.sh.

This series needs a kernel built on the following repo/branch/patches:
 repo: https://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git
 branch: next-integrity
 commit aa662fc04f5b ("ima: Fix NULL pointer dereference in ima_file_hash")

And the following patch series should be applied in the following order:
 1. https://patchwork.kernel.org/patch/11795559/
 2. https://patchwork.kernel.org/patch/11801525/
 3. https://patchwork.kernel.org/patch/11743715/

Change Log v2:
Incorporated feedback from Petr Vorel on v1.
 - Updated TST_NEEDS_CMDS to correctly reflects commands used in tests.
 - Removed unnecessary debugging info.
 - Refactored common functionality in ima_keys.sh, and moved the generic
   functions to ima_setup.sh.
 - Removed the use of eval, and replaced it with the recommended ROD()
   function.
 - All temporary files now get created under $TST_TMPDIR, instead of
   current directory.
 - Removed unnecessary TFAIL, to avoid double counting failures.
 - Updated log messages to be consistent.
 - Moved code to cleanup() to avoid code duplication.

Tushar Sugandhi (2):
  IMA: generalize key measurement tests
  IMA: Add test for dm-crypt measurement

 runtest/ima                                   |  1 +
 .../kernel/security/integrity/ima/README.md   | 20 +++++
 .../integrity/ima/tests/ima_dm_crypt.sh       | 60 ++++++++++++++
 .../security/integrity/ima/tests/ima_keys.sh  | 62 +++------------
 .../security/integrity/ima/tests/ima_setup.sh | 79 +++++++++++++++++++
 5 files changed, 173 insertions(+), 49 deletions(-)
 create mode 100755 testcases/kernel/security/integrity/ima/tests/ima_dm_crypt.sh

-- 
2.17.1


-- 
Mailing list info: https://lists.linux.it/listinfo/ltp
