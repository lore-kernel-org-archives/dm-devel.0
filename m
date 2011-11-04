From: hegdevasant <vahegde1@linux.vnet.ibm.com>
Subject: [PATCH] Add missing break statement in kpartx.
Date: Fri, 04 Nov 2011 15:35:22 +0530
Message-ID: <4EB3B8E2.2090002@linux.vnet.ibm.com>
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

  This patch adds missing break statement in kpartx.

Signed-off-by: Vasant Hegde <vahegde1@linux.vnet.ibm.com>

---
  kpartx/kpartx.c |    2 ++
  1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 05dfce7..0711450 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -241,6 +241,7 @@ main(int argc, char **argv){
      while ((arg = getopt(argc, argv, short_opts)) != EOF) switch(arg) {
          case 'r':
              ro=1;
+            break;
          case 'f':
              force_devmap=1;
              break;
@@ -267,6 +268,7 @@ main(int argc, char **argv){
              break;
          case 's':
              sync = 1;
+            break;
          case 'u':
              what = UPDATE;
              break;
-- 
1.7.3.4
