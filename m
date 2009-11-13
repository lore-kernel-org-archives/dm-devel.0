From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 0/2] Add suspended state check for target
	messages
Date: Fri, 13 Nov 2009 19:22:16 +0900
Message-ID: <4AFD3358.7000007@ct.jp.nec.com>
References: <20091113080637.17587.64935.stgit@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091113080637.17587.64935.stgit@localhost.localdomain>
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

Hi Mike,

On 11/13/2009 05:06 PM +0900, Mike Anderson wrote:
> This patch adds a accessor function that allows determining if a
> mapped_device is in the suspended state and then adds this check to the
> multipath targets multipath_message function.
> 
> As previously described in the email at the archive url provided below the
> target_message ioctl can call into the target after suspend completes.
> This can cause new work to be queued and actions to be taken by the target
> that should be prevented in the suspended state.
> 
> http://permalink.gmane.org/gmane.linux.kernel.device-mapper.devel/10486
> 
> ---
> 
> Mike Anderson (2):
>       dm: Add accessor dm_table_md_suspended
>       dm: Add suspended check to multipath_message

Thank you for the patch.
But this patch-set doesn't solve the race problem.

Multipath must start rejecting message ioctl *before* flushing
workqueues in postsuspend.
  (*) With my patch, all multipath works are flushed in postsuspend.
      http://patchwork.kernel.org/patch/59556/

However, your patch starts rejecting message ioctl *after* postsuspend.
So there is a small window below:
  dm_suspend()                        multipath_message()
  ------------------------------------------------------------------
  dm_table_post_suspend()
    -> flush_multipath_works()
                                      if (!test_bit(DMF_SUSPENDED))
                                          queue_work()
  set_bit(DMF_SUSPENDED)
  ...
  dm_swap_table()
                                      [de]activate_path()

Thanks,
Kiyoshi Ueda
