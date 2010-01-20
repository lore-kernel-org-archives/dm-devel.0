From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [RFC][PATCH 0/3] dm-raid1: fix deadlock at suspend
 after suspend was interrupted
Date: Wed, 20 Jan 2010 11:47:56 +0900
Message-ID: <4B566EDC.5070006@ct.jp.nec.com>
References: <4B5618D7.4050202@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4B5618D7.4050202@redhat.com>
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

Hi Yasui-san,

On 01/20/2010 05:40 AM +0900, Takahiro Yasui wrote:
> Hi,
> 
> This is a patch set to fix deadlock on suspending of mirror device.
> 
> 
> ISSUE
> =====
> 
> Suspend procedure on a dm-mirror device could cause deadlock on recovery_count
> semaphore.
> 
> When mirror_presuspend is called, recovery_count semaphore is acquired in
> dm_rh_stop_recovery() to stop recovery routine, but when an signal is caught
> in dm_wait_for_completion() or an error occurred in in dm_suspend(),
> the suspend process is interrupted without releasing recovery_count semaphore
> of a mirror device. This means that another suspend is executed, and then
> the suspend process gets stuck at dm_rh_stop_recovery().
> 
> When suspend procedure is interrupted, the device should work properly since
> the status of the device is not "suspended."
> 
> 
> SOLUTION
> ========
> 
> Introduce a target handler, cancel_presuspend, to cancel status changes
> done by a target specific presuspend handler.

How about using ->resume as a cancelling method?
Though you have to audit existing targets' ->resume handler,
I think it's better idea than adding another target handler
just for this purpose.

And in your dm-raid1 patch, cancelling log's presuspend which is used
by dm-log-userspace is missed.
So it seems that dm-raid1 can use ->resume to cancel presuspend.

Thanks,
Kiyoshi Ueda
