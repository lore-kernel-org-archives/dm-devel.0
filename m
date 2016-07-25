From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH] multipath: fix multipath -l <devmap> without
	output
Date: Mon, 25 Jul 2016 10:41:38 -0300
Message-ID: <1469454098-4423-1-git-send-email-mauricfo@linux.vnet.ibm.com>
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
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
List-Id: dm-devel.ids

Currently, the multipath -l <devmap> output is empty, and an error
is printed to syslog:

    # ./multipath -l mpatha
    #

    # echo $?
    1

    # tail /var/log/messages
    ...
    ... multipath: mpatha: can't get udev device

That's due to dev_type not being initialized, and incorrectly evaluated.
So, initialize it to DEV_NONE, which is verified/reset by get_dev_type().

Now there's actual output and no error in syslog:

    # ./multipath -l mpatha
    mpatha (3600a0b800011e95c000055d855167d1c) dm-0 IBM,1815      FAStT
    ...

    # echo $?
    0

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>

(tested on '2613ce0 Bump version code to 0.6.2')
---
 multipath/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/main.c b/multipath/main.c
index 6ccece7..93376a9 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -511,7 +511,7 @@ main (int argc, char *argv[])
 	extern int optind;
 	int r = 1;
 	enum mpath_cmds cmd = CMD_CREATE;
-	enum devtypes dev_type;
+	enum devtypes dev_type = DEV_NONE;
 	char *dev = NULL;
 	struct config *conf;
 
-- 
1.8.3.1
