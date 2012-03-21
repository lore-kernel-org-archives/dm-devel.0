From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-table: delayed cleanup for dm_table_destroy()
Date: Tue, 20 Mar 2012 21:20:28 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1203202112190.23255@file.rdu.redhat.com>
References: <1332172428-35948-1-git-send-email-hare@suse.de>
	<1332172428-35948-2-git-send-email-hare@suse.de>
	<1332172428-35948-3-git-send-email-hare@suse.de>
	<1332172428-35948-4-git-send-email-hare@suse.de>
	<Pine.LNX.4.64.1203191714090.10651@file.rdu.redhat.com>
	<4F68A3D8.40005@suse.de> <20120320194307.GD30980@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120320194307.GD30980@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Tue, 20 Mar 2012, Mike Snitzer wrote:

> I once wanted to replace all msleep(1); with cpu_relax();:
> http://www.redhat.com/archives/dm-devel/2010-September/msg00100.html
> 
> But Alasdair wasn't sure if cpu_relax() would provide the required
> delay effect:
> https://www.redhat.com/archives/dm-devel/2011-June/msg00080.html

cpu_relax() would basically kill the kernel if compiled without preempt.

cpu_relax() makes the current processor sleep for a little moment, but it 
doesn't schedule a different process.

cpu_relax() is useful in spinlocks - so that process waiting on a spinlock 
is not slowing down the other process on a CPU with hyperthreading.


There was another possibility --- replace msleep(1) with yield(). The 
problem with yield() is that if the process has readltime priority and 
calls yield(), it doesn't give CPU to a different process with a lower 
priority. So it would cause deadlock if executed with realtime priority. 
msleep(1) doesn't have this problem, so it's the best.

Mikulas
