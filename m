From: Jorge Niedbalski <jorge.niedbalski@canonical.com>
Subject: [PATCH] Fixing the find_loop_by_file function to
 properly compare the filename by respecting the LO_NAME_SIZE.
Date: Fri, 26 Jun 2015 16:08:51 -0300
Message-ID: <CAEDyR0Q+eSMcd443jAK=mb2EC0=dWSXcvN3c86BC6ru_bhJEng@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This fixes the bug reported on https://bugs.launchpad.net/ubuntu/+source/mult
ipath-tools/+bug/1469143

Signed-off-by: Jorge Niedbalski <jorge.niedbalski@canonical.com>
---
 kpartx/lopart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 6f83048..e92aeed 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -123,7 +123,7 @@ find_loop_by_file (const char * filename)
  continue;
  }

- if (0 == strcmp(filename, loopinfo.lo_name)) {
+ if (0 == strncmp(filename, loopinfo.lo_name, strlen(l
oopinfo.lo_name))) {
  close (fd);
  return xstrdup(dev); /*found */
  }
-- 
2.1.4
