From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/3] sysfs representation of stacked devices
	(dm/md common)
Date: Fri, 17 Feb 2006 18:44:35 +0000
Message-ID: <20060217184435.GM12169@agk.surrey.redhat.com>
References: <43F60F31.1030507@ce.jp.nec.com> <43F60F8C.8090207@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <43F60F8C.8090207@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>, Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Make sure you test this properly under low memory situations.

On Fri, Feb 17, 2006 at 01:01:48PM -0500, Jun'ichi Nomura wrote:
> This patch provides common functions to create symlinks in sysfs
> between stacked device and its slaves.

dm_swap_table() mustn't block waiting for memory to become
free (except in a controlled way e.g. with a mempool, but
it would need more than that here).

Here, dm_swap_table() leads to kmalloc() getting called
in sysfs_add_link().

[e.g. Consider the extreme case where the dm device
you're changing is your swap device.  While dm_swap_table()
runs, no I/O will get through to your swap device.]

If you can't avoid the sysfs code allocating memory, then
you must find a way of doing it before the dm suspend or
after the dm resume.
e.g. Do the sysfs memory allocations for the links prior to 
the dm suspend [which may have happened in a previous system call] 
and then use a different function to move them into place during
dm_swap_table() without performing further memory allocations?
[Lazy workaround is to set PF_MEMALLOC again...]

Alasdair
-- 
agk@redhat.com
