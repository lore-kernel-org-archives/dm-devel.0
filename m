From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: multipathd leak
Date: Thu, 27 Oct 2005 12:14:23 +0200
Message-ID: <20051027101423.GA19853@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bmarzins@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

can you look into this leak reported by valgrind :
(valgrind --show-reachable=yes --leak-check=full -v multipathd/multipathd -d)

==2957== 16384 bytes in 1 blocks are definitely lost in loss record 10 of 10
==2957==    at 0x11B1BE96: malloc (vg_replace_malloc.c:149)
==2957==    by 0x11D41B61: dm_task_run (in /lib/libdevmapper.so.1.01)
==2957==    by 0x40444D: waiteventloop (main.c:481)
==2957==    by 0x40464C: waitevent (main.c:537)
==2957==    by 0x11C2FB1B: start_thread (in /lib/libpthread-2.3.5.so)
==2957==    by 0x1243B272: clone (in /lib/libc-2.3.5.so)

We miss a dm_task_destroy in the stop_waiter_thread path.
It seems related to the pthread_kill trickery you are familiar with.

Didn't we conclude the trickery was due to a glibc bug earlier ?
If so, can this be fixed in updates or  will it have to wait till RHEL5 ?

Regards,
cvaroqui
