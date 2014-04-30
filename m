From: Jose Castillo <jcastillo@redhat.com>
Subject: [PATCH] Fix segfault when fast_io_fail_tmo is empty in
	config file.
Date: Wed, 30 Apr 2014 10:20:13 +0200
Message-ID: <1398846013-2601-1-git-send-email-jcastillo@redhat.com>
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

If the option "fast_io_fail_tmo" is specified in multipath.conf, without a value, the command 'multipathd reconfigure' segfaults.
With the patch included here, multipathd returns "error parsing config file" and does not segfaults.

Signed-off-by: Jose Castillo <jcastillo@redhat.com>
---
 libmultipath/dict.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 9db4725..91d9b83 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -43,6 +43,9 @@ def_fast_io_fail_handler(vector strvec)
 	char * buff;
 
 	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
 	if (strlen(buff) == 3 && !strcmp(buff, "off"))
 		conf->fast_io_fail = MP_FAST_IO_FAIL_OFF;
 	else if (sscanf(buff, "%d", &conf->fast_io_fail) != 1 ||
-- 
1.9.0
