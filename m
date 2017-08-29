From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH] multipath-tools: intermittent IO error
 accounting to improve reliability
Date: Tue, 29 Aug 2017 09:16:48 +0800
Message-ID: <4098fde5-5c21-eec8-63f5-2deb1050cb50@huawei.com>
References: <1503396479-12692-1-git-send-email-guanjunxiong@huawei.com>
	<6cd9c342-b3c9-5ec0-153a-d7a4d431cc64@suse.de>
	<508b849f-026c-7365-7a4c-f2e8b2ef01a4@huawei.com>
	<1503918784.4546.24.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1503918784.4546.24.camel@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, chengjike.cheng@huawei.com, niuhaoxin@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

Hi Martin,

Thanks for your comment. My reply inline.

On 2017/8/28 19:13, Martin Wilck wrote:
> On Thu, 2017-08-24 at 17:59 +0800, Guan Junxiong wrote:
>> Hi, Hannes
>>      Thanks for your comments. My reply inline.
>>
>> On 2017/8/22 23:37, Hannes Reinecke wrote:
>>> - As we now have advanced path selectors the overall consensus is
>>> that
>>> those selectors _should_ be able to handle these situations; ie for
>>> a
>>> flaky path the path selector should switch away from it and move
>>> the
>>> load to other, unaffected paths.
>>> Have you checked if the existing path selectors are able to cope
>>> with
>>> this situation? If not, why not?
>>
>> The existing path selectors in the kernel space are able to fail_path
>> the flaky path when certain IO errors occurs. However only the user-
>> space
>> multipathd's checkers can detect whether the path is up. Therefore,
>> for path
>> with long-time intermittent IO or flaky path, that path selectors
>> suffers
>> from taking in the path and taking out the path _again_  _and_
>> _again_.
>> Even the san_path_err_threshold , san_path_err_forget_rate and
>> san_path_err_recovery_time
>> is turned on, the detect sample interval of that path checkers is so
>> big/coarse
>> that it doesn't see what happens in the middle of the sample
>> interval.
> 
> I have the concern that we are introducing too many different
> regulation algorithms. We have path selectors, path checkers,
> san_path_err_XXX, and now path_io_err_XXX as well. We must be certain
> that these play together in a well-defined fashion (most importantly,
> avoid that one mechanism activates a path while the other is in the
> process of tearing it down, etc.). 

Yes, I will pay more attention to this. Current way to coordinate those
regulation algorithms is to use flags such as path->disable_reinstate
for san_path_err_XXX and path->io_err_disable_reinstate for path_io_err_XXX.

> We must also avoid causing user
> confusion, as multipath configuration is already a daunting task for
> many. Your new algorithm should be mutually exclusive with
> san_path_err_XXX. Perhaps we should even consider dropping the
> san_path_err_XXX options entirely if we choose to adopt your new
> approach.
> 

I wanted to drop san_path_err_XXX, but I was afraid of breaking current
user configuration. However, as the san_path_err_XXX algorithm was merged
on February 2017, dropping it has less impact on current user configuration.
I will drop san_path_err_XXX before introducing current new path_io_err_XXX
in the next updated patch.

>>> - However, flaky path detection is implemented, it will work most
>>> efficiently when moving I/O _away_ from the flaky path. However, in
>>> doing so we don't have a mechanism to figure out if and when the
>>> path is
>>> useable again (as we're not sending I/O to it, and the TUR or any
>>> other
>>> path checker might not be affected from the flaky behaviour).
>>> So when should we declare a path as 'good' again?
>>
>> In this patch, the flaky path will stay only
>> path_io_err_recovery_time seconds
>> if there are more than one active path. After only
>> path_io_err_recovery_time seconds,
>> the flaky path will stay in normal, which means , when path checker
>> detects it
>> is up, it will reinstate into the usable path.
>>
>> However, how about we schedule the intermittent IO checking process
>> again when
>> the path_io_err_recovery_time seconds expires. If the number of IO
>> erros is less
>> than path_io_err_num_threshold, we declare the path as 'good' again.
> 
> That sounds like a reasonable improvement over the original patch.
>

I will integrate that.

> Regards,
> Martin
> 

Best Wishes,
Guan Junxiong
