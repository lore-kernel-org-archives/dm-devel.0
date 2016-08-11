From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 2/4] multipath-tools: add checker callout to
 repair path
Date: Thu, 11 Aug 2016 15:33:51 -0500
Message-ID: <57ACE12F.20700@redhat.com>
References: <1470657710-28081-1-git-send-email-mchristi@redhat.com>
	<1470657710-28081-3-git-send-email-mchristi@redhat.com>
	<9d5dcfcd-2550-c9e9-94dc-47c34ebdb039@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030208040107020101040603"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9d5dcfcd-2550-c9e9-94dc-47c34ebdb039@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, christophe.varoqui@opensvc.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------030208040107020101040603
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 08/11/2016 10:50 AM, Bart Van Assche wrote:
> On 08/08/2016 05:01 AM, Mike Christie wrote:
>> This patch adds a callback which can be used to repair a path
>> if check() has determined it is in the PATH_DOWN state.
>>
>> The next patch that adds rbd checker support which will use this to
>> handle the case where a rbd device is blacklisted.
> 
> Hello Mike,
> 
> With this patch applied, with the TUR checker enabled in multipath.conf
> I see the following crash if I trigger SRP failover and failback:
> 
> ion-dev-ib-ini:~ # gdb ~bart/software/multipath-tools/multipathd/multipathd
> (gdb) handle SIGPIPE noprint nostop
> Signal        Stop      Print   Pass to program Description
> SIGPIPE       No        No      Yes             Broken pipe
> (gdb) run -d
> Aug 11 08:46:27 | sde: remove path (uevent)
> Aug 11 08:46:27 | mpathbe: adding map
> Aug 11 08:46:27 | 8:64: cannot find block device
> Aug 11 08:46:27 | Invalid device number 1
> Aug 11 08:46:27 | 1: cannot find block device
> Aug 11 08:46:27 | 8:96: cannot find block device
> Aug 11 08:46:27 | mpathbe: failed to setup multipath
> Aug 11 08:46:27 | dm-0: uev_add_map failed
> Aug 11 08:46:27 | uevent trigger error
> 
> Thread 4 "multipathd" received signal SIGSEGV, Segmentation fault.
> [Switching to Thread 0x7ffff7f8b700 (LWP 8446)]
> 0x0000000000000000 in ?? ()
> (gdb) bt
> #0  0x0000000000000000 in ?? ()
> #1  0x00007ffff6c41905 in checker_repair (c=0x7fffdc001ef0) at checkers.c:225
> #2  0x000000000040a760 in repair_path (vecs=0x66d7e0, pp=0x7fffdc001a40)
>     at main.c:1733
> #3  0x000000000040ab27 in checkerloop (ap=0x66d7e0) at main.c:1807
> #4  0x00007ffff79bb474 in start_thread (arg=0x7ffff7f8b700)
>     at pthread_create.c:333
> #5  0x00007ffff63243ed in clone ()
>     at ../sysdeps/unix/sysv/linux/x86_64/clone.S:109
> (gdb) up
> #1  0x00007ffff6c41905 in checker_repair (c=0x7fffdc001ef0) at checkers.c:225
> 225             c->repair(c);
> (gdb) print *c
> $1 = {node = {next = 0x0, prev = 0x0}, handle = 0x0, refcount = 0, fd = 0, 
>   sync = 0, timeout = 0, disable = 0, name = '\000' <repeats 15 times>, 
>   message = '\000' <repeats 255 times>, context = 0x0, mpcontext = 0x0, 
>   check = 0x0, repair = 0x0, init = 0x0, free = 0x0}
> 

Sorry about the stupid bug.

Could you try the attached patch. I found two segfaults. If check_path
returns less than 0 then we free the path and so we cannot call repair
on it. If libcheck_init fails it memsets the checker, so we cannot call
repair on it too.

I moved the repair call to the specific paths that the path is down.

--------------030208040107020101040603
Content-Type: text/x-patch;
	name="multipathd-only-call-repair-when-failed.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="multipathd-only-call-repair-when-failed.patch"

diff --git a/multipathd/main.c b/multipathd/main.c
index f34500c..9f213cc 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1442,6 +1442,16 @@ int update_path_groups(struct multipath *mpp, struct vectors *vecs, int refresh)
 	return 0;
 }
 
+void repair_path(struct path * pp)
+{
+	if (pp->state != PATH_DOWN)
+		return;
+
+	checker_repair(&pp->checker);
+	if (strlen(checker_message(&pp->checker)))
+		LOG_MSG(1, checker_message(&pp->checker));
+}
+
 /*
  * Returns '1' if the path has been checked, '-1' if it was blacklisted
  * and '0' otherwise
@@ -1606,6 +1616,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 			pp->mpp->failback_tick = 0;
 
 			pp->mpp->stat_path_failures++;
+			repair_path(pp);
 			return 1;
 		}
 
@@ -1700,7 +1711,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	}
 
 	pp->state = newstate;
-
+	repair_path(pp);
 
 	if (pp->mpp->wait_for_udev)
 		return 1;
@@ -1725,14 +1736,6 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	return 1;
 }
 
-void repair_path(struct vectors * vecs, struct path * pp)
-{
-	if (pp->state != PATH_DOWN)
-		return;
-
-	checker_repair(&pp->checker);
-}
-
 static void *
 checkerloop (void *ap)
 {
@@ -1804,7 +1807,6 @@ checkerloop (void *ap)
 					i--;
 				} else
 					num_paths += rc;
-				repair_path(vecs, pp);
 			}
 			lock_cleanup_pop(vecs->lock);
 		}

--------------030208040107020101040603
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------030208040107020101040603--
