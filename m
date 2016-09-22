From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: add swap_slot_free_notify handler
Date: Wed, 21 Sep 2016 20:14:28 -0400
Message-ID: <20160922001428.GA12676@redhat.com>
References: <1474499386-27436-1-git-send-email-wonhong.kwon@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1474499386-27436-1-git-send-email-wonhong.kwon@lge.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Wonhong Kwon <wonhong.kwon@lge.com>
Cc: gunho.lee@lge.com, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Wed, Sep 21 2016 at  7:09pm -0400,
Wonhong Kwon <wonhong.kwon@lge.com> wrote:

> swap_slot_free_notify callback has been added to block_device_operations to
> allow freeing memory allocated by RAM-based swap device like zram or zswap
> more aggressively.
> 
> In case of device mapper, it is also required if mapped target is being
> used as swap device and it uses some in-memory metadata for swap entries.
> This patch introduces swap_slot_free_notify callback into dm_blk_ops and
> target device can implement its own handler to handle this via
> slot_free_notify in target_type.
> 
> Signed-off-by: Wonhong Kwon <wonhong.kwon@lge.com>

This change to DM core only makes sense once we have an upstream DM
target that implements slot_free_notify hook.
