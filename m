From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH V4 1/2] multipath-tools: intermittent IO
 error accounting to improve reliability
Date: Mon, 18 Sep 2017 22:36:53 +0800
Message-ID: <7035dfdb-1c49-aa3f-3836-1ec316707c47@huawei.com>
References: <1505619638-20912-1-git-send-email-guanjunxiong@huawei.com>
	<1505619638-20912-2-git-send-email-guanjunxiong@huawei.com>
	<fd6ead563a154984abc2654fd1a8ea30@BRMWP-EXMB12.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <fd6ead563a154984abc2654fd1a8ea30@BRMWP-EXMB12.corp.brocade.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Muneendra Kumar M <mmandala@Brocade.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>, "mwilck@suse.com" <mwilck@suse.com>
Cc: "chengjike.cheng@huawei.com" <chengjike.cheng@huawei.com>, "niuhaoxin@huawei.com" <niuhaoxin@huawei.com>, "shenhong09@huawei.com" <shenhong09@huawei.com>
List-Id: dm-devel.ids

Hi Muneendra,

Thanks for you feedback.  My comments are incline below.

On 2017/9/18 20:53, Muneendra Kumar M wrote:
> Hi Guan,
> This a good effort for detecting the intermittent IO error accounting to improve reliability.
> Your new algorithm is  mutually exclusive with san_path_err_XXX.
> It resolved the below issue which you have mentioned .
>>> Even the san_path_err_threshold , san_path_err_forget_rate and san_path_err_recovery_time is turned on,
>>> the detect sample interval of that path checkers is so big/coarse that it doesn't see what happens in the middle of the sample interval.
> 
> But I have some concerns.
> 
> Correct me if my understanding on the below line is correct
>>> On a particular path when a path failing events occur twice in 60 second due to an IO error, multipathd will fail the path and enqueue 
>>> this path into a queue of which each member is sent a couple of continuous direct reading asynchronous io at a fixed sample rate of 10HZ. 
> 
> Once we hit the above condition (2 errors in 60 secs) for a path_io_err_sample_time we keeps on injecting the asynchronous io at a fixed sample rate of 10HZ.
> And during this path_io_err_sample_time if we hit the the path_io_err_rate_threshold then we will not reinstantate this path for a path_io_err_recovery_time.
> Is this understanding correct?
>

Partial correct.
If we hit the above condition (2 errors in 60 secs), we will fail the path first before injecting a couple of asynchronous IOs to keep the testing not affected by other IOs.
And after this path_io_err_sample_time :
(1) if we hit the the path_io_err_rate_threshold, the failed path will keep unchanged  and then after the path_io_err_recovery_time
(which is confusing, sorry, I will rename it to "recheck"), we will reschedule this IO error checking process again.
(2) if we do NOT hit the path_io_err_rate_threshold, the failed path will reinstated by path checking thread in a tick (1 second) ASAP.


> If the above understanding is correct then my concern is :
> 1) On a particular path if we are seeing continuous errors but not within 60 secs (may be for every 120 secs) of duration how do we handle this. Still this a shaky link.
> This is what our customers are pointing out.
> And if i am not wrong the new algorithm will comes into place only  if a path failing events occur twice in 60 seconds.
> 
> Then this will not solve the intermittent IO error issue which we are seeing as the data is still going on the shaky path .
> I think this is the place where we need to pull in  in san_path_err_forget_rate .
> 

Yes .  I have thought about using some adjustable parameters such as san_path_err_pre_check_time and  san_path_err_threshold to cover ALL the scenarios the user encounters.
In the above fixed example,san_path_err_pre_check_time is set to 60 seconds, san_path_err_threshold is set 2.
However, if I adopt this, we have 5 parameters (san_path_err_pre_check_time and  san_path_err_threshold + 3 path_io_err_XXXs ) to support this feature. You know, mulitpath.conf
configuration is becoming more and more daunting as Martin pointed in the V1 of this patch.

But now, maybe it is acceptable for users to use the 5 parameters if we set san_path_err_pre_check_time and  san_path_err_threshold to some default values such as 60 second and 2 respectively.
**Martin** , **Muneendra**, how about this a little compromising method?  If it is OK , I will update in next version of patch.


> Our main intention to bring the san_path_err_XXX patch was ,if we are hitting   i/o errors on a path which are exceeding san_path_err_threshold within a san_path_err_forget_rate then 
> We are not supposed to reinstate the path for san_path_err_recovery_time.
> 
> 
> path_io_err_sample_time should be a  sub window of san_path_err_forget_rate.

No, path_io_err_sample_time take effects after san_path_err_forget_rate(equal to the above san_path_err_pre_check_time). They are conditionally in sequence.


> If the errors are not happening within 60 secs duration, still  we need to keep track of  the number of errors and if the error threshold is hit within san_path_err_forget_rate  then the path will not reinstate for recover_time seconds.
> With the combination of these two we can find the shaky path within path_io_err_sample_time / san_path_err_forget_rate.
> 
> Regards,
> Muneendra.
> 

san_path_err_forget_rate is hard to understand, shall we use san_path_err_pre_check_time instead?

Best Wishes
Guan


> 
> -----Original Message-----
> From: Guan Junxiong [mailto:guanjunxiong@huawei.com] 
> Sent: Sunday, September 17, 2017 9:11 AM
> To: dm-devel@redhat.com; christophe.varoqui@opensvc.com; mwilck@suse.com
> Cc: Muneendra Kumar M <mmandala@Brocade.com>; shenhong09@huawei.com; niuhaoxin@huawei.com; chengjike.cheng@huawei.com; guanjunxiong@huawei.com
> Subject: [PATCH V4 1/2] multipath-tools: intermittent IO error accounting to improve reliability
> 
> This patch adds a new method of path state checking based on accounting IO error. This is useful in many scenarios such as intermittent IO error an a path due to network congestion, or a shaky link.
> 
> Three parameters are added for the admin: "path_io_err_sample_time", "path_io_err_rate_threshold" and "path_io_err_recovery_time".
> If path_io_err_sample_time are set no less than 120 and path_io_err_recovery_time are set to a value greater than 0, when path failing events occur twice in 60 second due to an IO error, multipathd will fail the path and enqueue this path into a queue of which each member is sent a couple of continuous direct reading asynchronous io at a fixed sample rate of 10HZ. The IO accounting process for a path will last for path_io_err_sample_time. If the IO error rate on a particular path is greater than the path_io_err_rate_threshold, then the path will not reinstate for recover_time seconds unless there is only one active path.
> 
> If recover_time expires, we will reschedule this IO error checking process. If the path is good enough, we will claim it good.
> 
> This helps us place the path in delayed state if we hit a lot of intermittent IO errors on a particular path due to network/target issues and isolate such degraded path and allow the admin to rectify the errors on a path.
> 
> Signed-off-by: Junxiong Guan <guanjunxiong@huawei.com>
> ---
>  libmultipath/Makefile      |   5 +-
>  libmultipath/config.h      |   9 +
>  libmultipath/configure.c   |   3 +
>  libmultipath/dict.c        |  41 +++
>  libmultipath/io_err_stat.c | 743 +++++++++++++++++++++++++++++++++++++++++++++
>  libmultipath/io_err_stat.h |  15 +
>  libmultipath/propsel.c     |  53 ++++
>  libmultipath/propsel.h     |   3 +
>  libmultipath/structs.h     |   7 +
>  libmultipath/uevent.c      |  32 ++
>  libmultipath/uevent.h      |   2 +
>  multipath/multipath.conf.5 |  65 ++++
>  multipathd/main.c          |  56 ++++
>  13 files changed, 1032 insertions(+), 2 deletions(-)  create mode 100644 libmultipath/io_err_stat.c  create mode 100644 libmultipath/io_err_stat.h
> 
> diff --git a/libmultipath/Makefile b/libmultipath/Makefile index b3244fc7..dce73afe 100644
> --- a/libmultipath/Makefile
> +++ b/libmultipath/Makefile
