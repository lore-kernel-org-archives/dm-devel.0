From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 2] dm log userspace rearrange ctr args
Date: Fri, 28 Aug 2009 00:34:50 -0500
Message-ID: <1251437690.16038.9.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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

The internally generated constructor argument (device size) is
necessary for creating userspace logs.  However, it is difficult
to strip out from our stored string when we wish to print
back what the original string we were given.

The fix is simply to re-order the arguments in the string -
putting the internally generated argument first instead of
last.  (This makes it easy to skip over it later.)

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-log-userspace-base.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-log-userspace-base.c
+++ linux-2.6/drivers/md/dm-log-userspace-base.c
@@ -111,10 +111,9 @@ static int build_constructor_string(stru
 		return -ENOMEM;
 	}
 
-	for (i = 0, str_size = 0; i < argc; i++)
-		str_size += sprintf(str + str_size, "%s ", argv[i]);
-	str_size += sprintf(str + str_size, "%llu",
-			    (unsigned long long)ti->len);
+	str_size = sprintf(str, "%llu", (unsigned long long)ti->len);
+	for (i = 0; i < argc; i++)
+		str_size += sprintf(str + str_size, " %s", argv[i]);
 
 	*ctr_str = str;
 	return str_size;
