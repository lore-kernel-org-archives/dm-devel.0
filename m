From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/4] multipath-tools: add checker callout to
 repair path
Date: Thu, 11 Aug 2016 14:41:39 -0700
Message-ID: <e4286ca9-01cb-5cc0-2d67-38f68c0a19cb@sandisk.com>
References: <1470657710-28081-1-git-send-email-mchristi@redhat.com>
	<1470657710-28081-3-git-send-email-mchristi@redhat.com>
	<9d5dcfcd-2550-c9e9-94dc-47c34ebdb039@sandisk.com>
	<57ACE12F.20700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <57ACE12F.20700@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <mchristi@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
List-Id: dm-devel.ids

On 08/11/2016 01:33 PM, Mike Christie wrote:
> Could you try the attached patch. I found two segfaults. If check_path
> returns less than 0 then we free the path and so we cannot call repair
> on it. If libcheck_init fails it memsets the checker, so we cannot call
> repair on it too.
>
> I moved the repair call to the specific paths that the path is down.

Hello Mike,

Thanks for the patch. Unfortunately even with this patch applied I can 
still trigger a segfault sporadically:

# valgrind --read-var-info=yes multipathd -d
Aug 11 14:02:21 | mpathbf: load table [0 2097152 multipath 3 
queue_if_no_path pg_init_retries 50 0 2 1 queue-length 0 1 1 8:160 1000 
queue-length 0 1 1 8:64 1000]
Aug 11 14:02:21 | mpathbf: event checker started
Aug 11 14:02:21 | sdk [8:160]: path added to devmap mpathbf
Aug 11 14:02:21 | sdd: add path (uevent)
==2452== Thread 4:
==2452== Jump to the invalid address stated on the next line
==2452==    at 0x0: ???
==2452==    by 0x409BBE: repair_path (main.c:1451)
==2452==    by 0x40A905: check_path (main.c:1715)
==2452==    by 0x40AE72: checkerloop (main.c:1808)
==2452==    by 0x5047473: start_thread (pthread_create.c:333)
==2452==    by 0x671B3EC: clone (clone.S:109)
==2452==  Address 0x0 is not stack'd, malloc'd or (recently) free'd
==2452==
==2452==
==2452== Process terminating with default action of signal 11 (SIGSEGV)
==2452==  Bad permissions for mapped region at address 0x0
==2452==    at 0x0: ???
==2452==    by 0x409BBE: repair_path (main.c:1451)
==2452==    by 0x40A905: check_path (main.c:1715)
==2452==    by 0x40AE72: checkerloop (main.c:1808)
==2452==    by 0x5047473: start_thread (pthread_create.c:333)
==2452==    by 0x671B3EC: clone (clone.S:109)
==2452==

(gdb) list main.c:1451
1446    void repair_path(struct path * pp)
1447    {
1448            if (pp->state != PATH_DOWN)
1449                    return;
1450
1451            checker_repair(&pp->checker);
1452            if (strlen(checker_message(&pp->checker)))
1453                    LOG_MSG(1, checker_message(&pp->checker));
1454    }
1455
