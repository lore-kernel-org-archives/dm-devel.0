From: prz <prz@net4u.ch>
Subject: crosscompiling with ulibC ...
Date: Mon, 30 Jul 2007 16:50:01 +0200
Message-ID: <46ADFA99.8080308@net4u.ch>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

fails due to the broken AC_FUNC_MALLOC on configure (well-known issue 
with ulibC). Here's the trivia fix
if you guys care

    thanks for the software

    -- tony



--- device-mapper.1.02.21/configure.in     2007-07-30 16:40:03.000000000 
+0200
+++ device-mapper.1.02.21/configure.in     2007-07-30 16:40:15.000000000 
+0200
@@ -86,6 +86,6 @@
 dnl -- Checks for functions
 AC_CHECK_FUNCS(memset mkdir rmdir strchr strdup strerror strrchr 
uname,,AC_MSG_ERROR(bailing out))
 AC_FUNC_CLOSEDIR_VOID
-AC_FUNC_MALLOC
+#AC_FUNC_MALLOC
 AC_FUNC_STAT
 AC_FUNC_VPRINTF
