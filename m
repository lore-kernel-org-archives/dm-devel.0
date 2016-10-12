From: Michael Wang <yun.wang@profitbricks.com>
Subject: [RFC] unreleased lock after handler failure
Date: Wed, 12 Oct 2016 09:59:13 +0200
Message-ID: <018d2a56-5c23-4a61-5b27-8fe80a6283a8@profitbricks.com>
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
To: christophe.varoqui@opensvc.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi, folks

While we are testing with the latest multipathd, we encounter issue that once
'del map' failed, all the following operation will show 'error -1 receiving packet'
whatever how long the timeout has been set (we have applied the latest fix which
make sure the poll will last for 10 seconds).

After some debugging we found that inside parse_cmd(), the pthread_cleanup_pop()
rely on '!r' as indicator for locked or not, while this will be overwritten if
the handler return failed (1 in our case), and then the unlock will be missed.

After applied below fix the problem got solved, although the del map failed, the
other operation can still works.

Could you please help to review whether this is really the problem to be fixed
like that?

Regards,
Michael Wang



diff --git a/multipathd/cli.c b/multipathd/cli.c
index e8a9384..50161be 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -481,6 +481,7 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
                tmo.tv_sec = 0;
        }
        if (h->locked) {
+               int locked = 0;
                struct vectors * vecs = (struct vectors *)data;
 
                pthread_cleanup_push(cleanup_lock, &vecs->lock);
@@ -491,10 +492,11 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
                        r = 0;
                }
                if (r == 0) {
+                       locked = 1;
                        pthread_testcancel();
                        r = h->fn(cmdvec, reply, len, data);
                }
-               pthread_cleanup_pop(!r);
+               pthread_cleanup_pop(locked);
        } else
                r = h->fn(cmdvec, reply, len, data);
        free_keys(cmdvec);
