From: k-ueda@ct.jp.nec.com
Subject: [PATCH] execute_program() fix in multipath-tools-0.4.4
Date: Wed, 27 Apr 2005 18:26:24 -0400 (EDT)
Message-ID: <48696.8194054954$1114640527@news.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
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

Hi Christophe,

If there is no space (' ') in callout strings, the callout isn't called
in multipath-tools-0.4.4.

For example, in the default multipath.conf, default_prio_callout
is set as "/bin/false".  But it's not called due to this bug.
If I set it as "/bin/false ", it works.

Regards,
Ky (Kiyoshi Ueda)


--- multipath-tools-0.4.4/libmultipath/callout.c	2005-04-14 13:17:17.000000000 -0400
+++ execute-program-fix/libmultipath/callout.c	2005-04-28 05:29:30.228646923 -0400
@@ -29,8 +29,8 @@ int execute_program(char *path, char *va
 	int i;
 
 	i = 0;
+	strfieldcpy(arg, path);
 	if (strchr(path, ' ')) {
-		strfieldcpy(arg, path);
 		pos = arg;
 		while (pos != NULL) {
 			if (pos[0] == '\'') {
@@ -39,11 +39,13 @@ int execute_program(char *path, char *va
 				argv[i] = strsep(&pos, "\'");
 				while (pos[0] == ' ')
 					pos++;
-		} else {
+			} else {
 				argv[i] = strsep(&pos, " ");
 			}
 			i++;
 		}
+	} else {
+		argv[i++] = arg;
 	}
 	argv[i] =  NULL;
 
