From: huang.wei56@zte.com.cn
Subject: [PATCH] segment faulty occured in add_feature()
Date: Tue, 1 Nov 2016 08:44:49 +0800
Message-ID: <1477961089-9164-1-git-send-email-huang.wei56@zte.com.cn>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: wei huang <huang.wei56@zte.com.cn>, tang.junhui@zte.com.cn, zhang.kai16@zte.com.cn, dm-devel@redhat.com, bart.vanassche@sandisk.com
List-Id: dm-devel.ids

From: wei huang <huang.wei56@zte.com.cn>

Problem:
Multipathd segment faulty occured when device policy was configured in multipath.conf as follow:
#This is a device configuration just for COMPELNT device
devices {
       device {
               vendor                  COMPELNT
               dev_loss_tmo            120
               scheduler               deadline
       }
}

The call trace is:
Program received signal SIGSEGV, Segmentation fault.
0x00007f4eaaf49251 in __strstr_sse2 () from /lib64/libc.so.6
(gdb) bt
#0  0x00007f4eaaf49251 in __strstr_sse2 () from /lib64/libc.so.6
#1  0x00007f4eabba879c in add_feature (f=f@entry=0x211b248, n=n@entry=0x7f4eabbc530a queue_if_no_path)
    at structs.c:524
#2  0x00007f4eabba6993 in merge_hwe (src=0x2148c70, dst=0x211b220) at config.c:359
#3  factorize_hwtable (hw=0x214b800, n=n@entry=77) at config.c:452
#4  0x00007f4eabba7850 in load_config (file=file@entry=0x4144c8 /etc/multipath.conf) at config.c:651
#5  0x0000000000408959 in reconfigure (vecs=vecs@entry=0x2128ae0) at main.c:2078
#6  0x00000000004063c6 in child (param=0x0) at main.c:2483
#7  main (argc=<optimized out>, argv=<optimized out>) at main.c:2725
(gdb) up
#1  0x00007f4eabba879c in add_feature (f=f@entry=0x211b248, n=n@entry=0x7f4eabbc530a queue_if_no_path)
    at structs.c:524
524             if (strstr(*f, n))
(gdb) p *f
 = 0x0

Reasons:
When multipathd loads config, it will call merge_hwe() to merge the features between default_hw[] and config.
If the vender is not configured features in default_hw[], dst->features's value will be null. So strstr()'s first
parameter *f is null in add_feature(),too.

Signed-off-by: wei huang <huang.wei56@zte.com.cn>
---
 libmultipath/structs.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index fee58e5..f673325 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -520,6 +520,17 @@ add_feature (char **f, char *n)
 	if (!n || *n == '0')
 		return 0;
 
+	/* default feature is null */
+	if(!*f)
+	{
+		l = asprintf(&t, "1 %s", n);
+		if(l == -1)
+			return 1;
+			
+		*f = t;
+		return 0;
+	}
+
 	/* Check if feature is already present */
 	if (strstr(*f, n))
 		return 0;
-- 
2.8.1.windows.1
