From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH] dm/dax: Fix table reference counts
Date: Fri, 18 Sep 2020 13:23:23 -0700
Message-ID: <20200918202323.GL2540965@iweiny-DESK2.sc.intel.com>
References: <160045867590.25663.7548541079217827340.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <160045867590.25663.7548541079217827340.stgit@dwillia2-desk3.amr.corp.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, dm-devel@redhat.com, Adrian Huang <ahuang12@lenovo.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Sep 18, 2020 at 12:51:15PM -0700, Dan Williams wrote:
> A recent fix to the dm_dax_supported() flow uncovered a latent bug. When
> dm_get_live_table() fails it is still required to drop the
> srcu_read_lock(). Without this change the lvm2 test-suite triggers this
> warning:
> 
>     # lvm2-testsuite --only pvmove-abort-all.sh
> 
>     WARNING: lock held when returning to user space!
>     5.9.0-rc5+ #251 Tainted: G           OE
>     ------------------------------------------------
>     lvm/1318 is leaving the kernel with locks still held!
>     1 lock held by lvm/1318:
>      #0: ffff9372abb5a340 (&md->io_barrier){....}-{0:0}, at: dm_get_live_table+0x5/0xb0 [dm_mod]
> 
> ...and later on this hang signature:
> 
>     INFO: task lvm:1344 blocked for more than 122 seconds.
>           Tainted: G           OE     5.9.0-rc5+ #251
>     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>     task:lvm             state:D stack:    0 pid: 1344 ppid:     1 flags:0x00004000
>     Call Trace:
>      __schedule+0x45f/0xa80
>      ? finish_task_switch+0x249/0x2c0
>      ? wait_for_completion+0x86/0x110
>      schedule+0x5f/0xd0
>      schedule_timeout+0x212/0x2a0
>      ? __schedule+0x467/0xa80
>      ? wait_for_completion+0x86/0x110
>      wait_for_completion+0xb0/0x110
>      __synchronize_srcu+0xd1/0x160
>      ? __bpf_trace_rcu_utilization+0x10/0x10
>      __dm_suspend+0x6d/0x210 [dm_mod]
>      dm_suspend+0xf6/0x140 [dm_mod]
> 
> Fixes: 7bf7eac8d648 ("dax: Arrange for dax_supported check to span multiple devices")
> Cc: <stable@vger.kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Reported-by: Adrian Huang <ahuang12@lenovo.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/md/dm.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index fb0255d25e4b..4a40df8af7d3 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1136,15 +1136,16 @@ static bool dm_dax_supported(struct dax_device *dax_dev, struct block_device *bd
>  {
>  	struct mapped_device *md = dax_get_private(dax_dev);
>  	struct dm_table *map;
> +	bool ret = false;
>  	int srcu_idx;
> -	bool ret;
>  
>  	map = dm_get_live_table(md, &srcu_idx);
>  	if (!map)
> -		return false;
> +		goto out;
>  
>  	ret = dm_table_supports_dax(map, device_supports_dax, &blocksize);
>  
> +out:
>  	dm_put_live_table(md, srcu_idx);

Wow that is an odd interface for the kernel.  Especially since map is not
passed back in.  But yea looks correct.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

>  
>  	return ret;
> 
