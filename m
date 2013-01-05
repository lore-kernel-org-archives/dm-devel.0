From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH] libmpathpersist: correct function description in
 mpath_persist.h and man file
Date: Sat, 05 Jan 2013 18:16:09 +0800
Message-ID: <50E7FD69.4050105@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
To: christophe.varoqui@opensvc.com, dm-devel@redhat.com
List-Id: dm-devel.ids

* For mpath_persistent_reserve_out, we have "#define MPATH_PRTPE_EA_RO 
     0x06".
   Correct the description of the function prototype 
mpath_persistent_reserve_out
   in mpath_persist.h and man file.
* Correct typo in the description for the function prototype
   mpath_persistent_reserve_in in mpath_persist.h

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
  libmpathpersist/mpath_persist.h                |    8 ++++----
  libmpathpersist/mpath_persistent_reserve_out.3 |    2 +-
  2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/libmpathpersist/mpath_persist.h 
b/libmpathpersist/mpath_persist.h
index 42294e9..d8ff6f2 100644
--- a/libmpathpersist/mpath_persist.h
+++ b/libmpathpersist/mpath_persist.h
@@ -194,15 +194,15 @@ extern int mpath_lib_exit (void );
   *
   * @fd:    The file descriptor of a multipath device. Input argument.
   * @rq_servact: PRIN command service action. Input argument
- * @resp: The response from PRIN service action. The resp is a struct 
specified below. The caller should
+ * @resp: The response from PRIN service action. The resp is a struct 
specified above. The caller should
   *     manage the memory allocation of this struct
   * @noisy: Turn on debugging trace: Input argument. 0->Disable, 1->Enable
   * @verbose: Set verbosity level. Input argument. value:[0-3]. 
0->disabled, 3->Max verbose
   *
   * RESTRICTIONS:
   *
- * RETURNS: MPATH_PR_SUCCESS if PR command successful else returns any 
of the PR status (specified
- *     above).
+ * RETURNS: MPATH_PR_SUCCESS if PR command successful else returns any 
of the status specified
+ *       above in RETURN_STATUS.
   *
   */
  extern int mpath_persistent_reserve_in (int fd, int rq_servact, struct 
prin_resp *resp,
@@ -217,7 +217,7 @@ extern int mpath_persistent_reserve_in (int fd, int 
rq_servact, struct prin_resp
   * @rq_scope: Persistent reservation scope. The value should be always 
LU_SCOPE (0h).
   * @rq_type: Persistent reservation type. The valid values of 
persistent reservation types are
   *    5h (Write exclusive - registrants only)
- *    8h (Exclusive access - registrants only)
+ *    6h (Exclusive access - registrants only)
   *    7h (Write exclusive - All registrants)
   *    8h (Exclusive access - All registrants).
   * @paramp: PROUT command parameter data. The paramp is a struct which 
describes PROUT
diff --git a/libmpathpersist/mpath_persistent_reserve_out.3 
b/libmpathpersist/mpath_persistent_reserve_out.3
index 44f950b..f7f84ff 100644
--- a/libmpathpersist/mpath_persistent_reserve_out.3
+++ b/libmpathpersist/mpath_persistent_reserve_out.3
@@ -26,7 +26,7 @@ sends PR OUT command to the DM device and gets the 
response.
  .I rq_type
  .B Persistent reservation type. The valid values of persistent 
reservation types are
        5h (Write exclusive - registrants only)
-      8h (Exclusive access - registrants only)
+      6h (Exclusive access - registrants only)
        7h (Write exclusive - All registrants)
        8h (Exclusive access - All registrants).
  .br
-- 
1.7.10.4
