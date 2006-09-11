From: Jie Gao <J.Gao@isu.usyd.edu.au>
Subject: multipath feature sticks
Date: Mon, 11 Sep 2006 10:34:50 +1000 (EST)
Message-ID: <Pine.GSO.4.58.0609111026520.4522@banquo.ucc.usyd.edu.au>
References: <m3veob7a9d.fsf@guaranine.beaverton.ibm.com>
	<200609101334.k8ADYeHM012649@r-dd.iij4u.or.jp>
	<m3mz97tzgf.fsf@guaranine.beaverton.ibm.com>
	<200609102354.k8ANsPoC018868@r-dd.iij4u.or.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200609102354.k8ANsPoC018868@r-dd.iij4u.or.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi All

Redhat Enterprise Linux AS update 4 patched up-to-date:
2.6.9-42.0.2.ELsmp #1 SMP Thu Aug 17 17:57:31 EDT 2006 x86_64 x86_64 x86_64 GNU/Linux
-------------------------------------------------------------------------------------

I have the following in my multipath.conf:

> grep no_path_retry /etc/multipath.conf
        no_path_retry           60
#       no_path_retry           fail
#       no_path_retry           queue
        no_path_retry           60
                no_path_retry           60
                no_path_retry           60
#               no_path_retry           5
#               no_path_retry           queue

As you can see, I had "no_path_retry queue" before and I have
since changed it to "no_path_retry 60".

The problem is that the value of "queue" somehow sticks:

> multipath -ll
3600d02300067d2b107ad9a43303d8200
[size=390 GB][features="1 queue_if_no_path"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 1:0:0:1 sdb 8:16 [active][ready]
 \_ 2:0:0:1 sdd 8:48 [active][ready]

3600d02300067d2f707d12552c2821300
[size=390 GB][features="1 queue_if_no_path"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 1:0:1:1 sdc 8:32 [active][ready]
 \_ 2:0:1:1 sde 8:64 [active][ready]

Rebooting does not solve this problem.

> dmsetup table
www_vg_01-www_lv_01: 0 314572800 linear 9:1 384
3600d02300067d2b107ad9a43303d8200: 0 819200000 multipath 1 queue_if_no_path 0 1 1 round-robin 0 2 1 8:16
100 8:48 100
3600d02300067d2f707d12552c2821300: 0 819200000 multipath 1 queue_if_no_path 0 1 1 round-robin 0 2 1 8:32
100 8:64 100

I know I can use dmsetup to reset it, but problem is there seems to
only two values that can be used with dmsetup: either queue_if_no_path
or fail_if_no_path; and the value does not stay across reboot.

Anybody can help?

Regards,



Jie
