From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/4] multipath-tools: add checker callout to
 repair path
Date: Thu, 11 Aug 2016 08:50:56 -0700
Message-ID: <9d5dcfcd-2550-c9e9-94dc-47c34ebdb039@sandisk.com>
References: <1470657710-28081-1-git-send-email-mchristi@redhat.com>
	<1470657710-28081-3-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470657710-28081-3-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <mchristi@redhat.com>, dm-devel@redhat.com, christophe.varoqui@opensvc.com
List-Id: dm-devel.ids

On 08/08/2016 05:01 AM, Mike Christie wrote:
> This patch adds a callback which can be used to repair a path
> if check() has determined it is in the PATH_DOWN state.
> 
> The next patch that adds rbd checker support which will use this to
> handle the case where a rbd device is blacklisted.

Hello Mike,

With this patch applied, with the TUR checker enabled in multipath.conf
I see the following crash if I trigger SRP failover and failback:

ion-dev-ib-ini:~ # gdb ~bart/software/multipath-tools/multipathd/multipathd
(gdb) handle SIGPIPE noprint nostop
Signal        Stop      Print   Pass to program Description
SIGPIPE       No        No      Yes             Broken pipe
(gdb) run -d
Aug 11 08:46:27 | sde: remove path (uevent)
Aug 11 08:46:27 | mpathbe: adding map
Aug 11 08:46:27 | 8:64: cannot find block device
Aug 11 08:46:27 | Invalid device number 1
Aug 11 08:46:27 | 1: cannot find block device
Aug 11 08:46:27 | 8:96: cannot find block device
Aug 11 08:46:27 | mpathbe: failed to setup multipath
Aug 11 08:46:27 | dm-0: uev_add_map failed
Aug 11 08:46:27 | uevent trigger error

Thread 4 "multipathd" received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x7ffff7f8b700 (LWP 8446)]
0x0000000000000000 in ?? ()
(gdb) bt
#0  0x0000000000000000 in ?? ()
#1  0x00007ffff6c41905 in checker_repair (c=0x7fffdc001ef0) at checkers.c:225
#2  0x000000000040a760 in repair_path (vecs=0x66d7e0, pp=0x7fffdc001a40)
    at main.c:1733
#3  0x000000000040ab27 in checkerloop (ap=0x66d7e0) at main.c:1807
#4  0x00007ffff79bb474 in start_thread (arg=0x7ffff7f8b700)
    at pthread_create.c:333
#5  0x00007ffff63243ed in clone ()
    at ../sysdeps/unix/sysv/linux/x86_64/clone.S:109
(gdb) up
#1  0x00007ffff6c41905 in checker_repair (c=0x7fffdc001ef0) at checkers.c:225
225             c->repair(c);
(gdb) print *c
$1 = {node = {next = 0x0, prev = 0x0}, handle = 0x0, refcount = 0, fd = 0, 
  sync = 0, timeout = 0, disable = 0, name = '\000' <repeats 15 times>, 
  message = '\000' <repeats 255 times>, context = 0x0, mpcontext = 0x0, 
  check = 0x0, repair = 0x0, init = 0x0, free = 0x0}

Can you have a look at this?

Thanks,

Bart.
