From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH] multipath-tools: intermittent IO error
 accounting to improve reliability
Date: Thu, 24 Aug 2017 17:59:53 +0800
Message-ID: <508b849f-026c-7365-7a4c-f2e8b2ef01a4@huawei.com>
References: <1503396479-12692-1-git-send-email-guanjunxiong@huawei.com>
	<6cd9c342-b3c9-5ec0-153a-d7a4d431cc64@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6cd9c342-b3c9-5ec0-153a-d7a4d431cc64@suse.de>
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
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, chengjike.cheng@huawei.com, niuhaoxin@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

Hi, Hannes
     Thanks for your comments. My reply inline.

On 2017/8/22 23:37, Hannes Reinecke wrote:
> On 08/22/2017 12:07 PM, Guan Junxiong wrote:
>> This patch adds a new method of path state checking based on accounting
>> IO error. This is useful in many scenarios such as intermittent IO error
>> an a path due to network congestion, or a shaky link.
>>
>> Three parameters are added for the admin: "path_io_err_sample_time",
>> "path_io_err_num_threshold" and "path_io_err_recovery_time".
>> If path_io_err_sample_time and path_io_err_recovery_time are set to a
>> value greater than 0, when a path fail event occurs due to an IO error,
>> multipathd will enqueue this path into a queue of which each member is
>> sent direct reading asynchronous io at a fixed sample rate of 100HZ. The
>> IO accounting process for a path will last for path_io_err_sample_time.
>> If the number of IO error on a particular path is greater than the
>> path_io_err_num_threshold, then the path will not reinstate for
>> path_io_err_recovery_time seconds.
>>
>> This helps us place the path in delayed state if we hit a lot of
>> intermittent IO errors on a particular path due to network/target
>> issues and isolate such degraded path and allow the admin to rectify
>> the errors on a path.
>>
>> Signed-off-by: Junxiong Guan <guanjunxiong@huawei.com>
>> ---
> There have been several attempts for this over the years; if you check
> the mail archive for 'flaky patch' you're bound to hit several threads
> discussing this.
> However, each has floundered for several problems:
> 
> - As we now have advanced path selectors the overall consensus is that
> those selectors _should_ be able to handle these situations; ie for a
> flaky path the path selector should switch away from it and move the
> load to other, unaffected paths.
> Have you checked if the existing path selectors are able to cope with
> this situation? If not, why not?

The existing path selectors in the kernel space are able to fail_path
the flaky path when certain IO errors occurs. However only the user-space
multipathd's checkers can detect whether the path is up. Therefore, for path
with long-time intermittent IO or flaky path, that path selectors suffers
from taking in the path and taking out the path _again_  _and_ _again_.
Even the san_path_err_threshold , san_path_err_forget_rate and san_path_err_recovery_time
is turned on, the detect sample interval of that path checkers is so big/coarse
that it doesn't see what happens in the middle of the sample interval.

Therefore, this patch introduces new method of detecting path state of IO erros
especially for intermittent IO errors.

> - But even if something like this is implemented, the real problem here
> is reliability. Multipath internally only considers two real path
> states; useable and unuseable. Consequently the flaky path needs to be
> placed in one of these; so with your patch after enough errors
> accumulate the flaky path will be placed in an unuseable state
> eventually. If a failover event occurs the daemon cannot switch to the
> flaky paths, and the system becomes unuseable even though I/O could be
> sent via the flaky paths.

Currently this patch will reinstate the flaky path if there is no active
path after at most 1 tick. There is a windows time the system becomes
unusable even though I/O could be sent via the flaky paths.Thanks for
spotting this scenario. I will updated a patch solving this:
If there is the only one active paths after a failover event occurs,
the flaky path will reinstate as soon as possible because will can
catch the DM_fail path event from udev event.

> - However, flaky path detection is implemented, it will work most
> efficiently when moving I/O _away_ from the flaky path. However, in
> doing so we don't have a mechanism to figure out if and when the path is
> useable again (as we're not sending I/O to it, and the TUR or any other
> path checker might not be affected from the flaky behaviour).
> So when should we declare a path as 'good' again?

In this patch, the flaky path will stay only path_io_err_recovery_time seconds
if there are more than one active path. After only path_io_err_recovery_time seconds,
the flaky path will stay in normal, which means , when path checker detects it
is up, it will reinstate into the usable path.

However, how about we schedule the intermittent IO checking process again when
the path_io_err_recovery_time seconds expires. If the number of IO erros is less
than path_io_err_num_threshold, we declare the path as 'good' again.


> Cheers,
> 
> Hannes
> 

Best wishes to you
Guan Junxiong
