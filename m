From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 1/1] improve the performance of
	dm-log-userspace
Date: Tue, 10 Dec 2013 19:17:48 -0600
Message-ID: <CFEF63AA-BBCD-4D61-A43C-9D785E45182C@redhat.com>
References: <d16b09a5f29e29d77122c29f01ecaf7928dc4397.1386135157.git.dmzhang@suse.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d16b09a5f29e29d77122c29f01ecaf7928dc4397.1386135157.git.dmzhang@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Looks good.  Did you happen to post the accompanying userspace patches?  If you pass those along, I will review that also and test them together.  Once that's done, I will ACK.

 brassow

On Dec 3, 2013, at 11:35 PM, dongmao zhang wrote:

> modified workqueue calls on  Hayakawa's comments
> 
> In the cluster evironment, cluster write has poor performance.

</snip>

> 	spinlock_t flush_lock;
> 	struct list_head mark_list;
> 	struct list_head clear_list;
> +
> +	/*work queue for flush clear region*/

Use spaces after /* and before */

> +	struct workqueue_struct *dmlog_wq;
> +	struct delayed_work flush_log_work;
> +	atomic_t sched_flush;
> +	uint32_t integrated_flush;
> };

</snip>

> 	devices_rdata = kzalloc(devices_rdata_size, GFP_KERNEL);
> 	if (!devices_rdata) {
> 		DMERR("Failed to allocate memory for device information");
> @@ -246,6 +268,20 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
> 			DMERR("Failed to register %s with device-mapper",
> 			      devices_rdata);
> 	}
> +
> +

Extra newline...

The rest looks good.  (Cosmetic issues like this wouldn't prevent my ACK though.)
