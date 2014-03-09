From: Ritesh Raj Sarraf <rrs@debian.org>
Subject: [PATCH 1/3] Fix build failure with fomat-security.
	Specify the format type.
Date: Sun,  9 Mar 2014 17:26:33 +0530
Message-ID: <1394366195-3053-1-git-send-email-rrs@debian.org>
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
To: christophe.varoqui@opensvc.com
Cc: Ritesh Raj Sarraf <rrs@debian.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

cc -g -O2 -fPIE -fstack-protector --param=ssp-buffer-size=4 -Wformat
-Werror=format-security -D_FORTIFY_SOURCE=2 -O2 -g -pipe -Wall
-Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector
--param=ssp-buffer-size=4 -Wunused -Wstrict-prototypes -fPIC
-DLIB_STRING=\"lib\" -I.. -c -o rdac.o rdac.c
rdac.c: In function 'libcheck_check':
rdac.c:311:3: error: format not a string literal and no format arguments
[-Werror=format-security]
   MSG(c, (inqfail) ? MSG_RDAC_DOWN_TYPE("inquiry failed") :
   ^
rdac.c:311:3: error: format not a string literal and no format arguments
[-Werror=format-security]
cc1: some warnings being treated as errors
make[2]: *** [rdac.o] Error 1

Signed-off-by: Ritesh Raj Sarraf <rrs@debian.org>
---
 libmultipath/checkers/rdac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/checkers/rdac.c b/libmultipath/checkers/rdac.c
index e0b2ea4..00e3c44 100644
--- a/libmultipath/checkers/rdac.c
+++ b/libmultipath/checkers/rdac.c
@@ -308,7 +308,7 @@ libcheck_check (struct checker * c)
 done:
 	switch (ret) {
 	case PATH_DOWN:
-		MSG(c, (inqfail) ? MSG_RDAC_DOWN_TYPE("inquiry failed") :
+		MSG(c, "%s", (inqfail) ? MSG_RDAC_DOWN_TYPE("inquiry failed") :
 			checker_msg_string(&inq));
 		break;
 	case PATH_UP:
-- 
1.9.0
