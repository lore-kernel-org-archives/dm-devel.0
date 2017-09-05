From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH] multipath-tools: intermittent IO error
 accounting to improve reliability
Date: Tue, 5 Sep 2017 09:36:00 +0800
Message-ID: <2735a984-8e37-fc43-d29d-db46e51751b9@huawei.com>
References: <1503396479-12692-1-git-send-email-guanjunxiong@huawei.com>
	<1503926901.4546.26.camel@suse.com>
	<a82c0dc5-0aae-7c22-400d-9efc63f6bbaa@huawei.com>
	<1504553802.4605.10.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1504553802.4605.10.camel@suse.com>
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
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com, chengjike.cheng@huawei.com, niuhaoxin@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

Hello Martin,
Thanks for your remarks. I will adopt those in the next V4 patch.
Some comments inline.

Best Wishes
Guan Junxiong

On 2017/9/5 3:36, Martin Wilck wrote:
> On Tue, 2017-08-29 at 11:18 +0800, Guan Junxiong wrote:
> 
>> Three parameters are added for the admin:
>>>> "path_io_err_sample_time",
>>>> "path_io_err_num_threshold" and "path_io_err_recovery_time".
>>>> If path_io_err_sample_time and path_io_err_recovery_time are set
>>>> to a
>>>> value greater than 0, when a path fail event occurs due to an IO
>>>> error,
>>>> multipathd will enqueue this path into a queue of which each
>>>> member
>>>> is
>>>> sent direct reading asynchronous io at a fixed sample rate of
>>>> 100HZ. 
>>>
>>> 1. I don't think it's prudent to start the flakiness check for
>>> every
>>> PATH_DOWN event. Rather, the test should only be started for paths
>>> that
>>> have failed repeatedly in a certain time frame, so that we have
>>> reason
>>> to assume they're flaky.
>>>
>>
>> Sounds reasonable. And IMO, at least two new options of
>> multipath.conf
>> should be introduced: time frame and threshold if we let the admin
>> to tune this. OTOH, if we don't want to bother the admin, we handle
>> the pre-flacky check automatically.  Maybe 60 second of time frame
>> and 2 PATH_UP->PATH_DOWNH events of thredshold is reasonable.
>> Which solution do you prefer?
> 
> I wonder if the exisiting san_path_err_threshold etx. could be reused
> for that. As I said before, I can't imagine that they could be used
> reasonably in parallel with your approach, anyway. I can't help youwith the default values, you have done the testing. 
> 

The existing san_path_err_XXX feature could be reused if we drop
the san_path_err_recovery_time and keep  san_path_err_threadshold
and san_path_err_forget_rate. I will adopt this in V4.




>>> 2. How did you come up with the 100Hz sample rate value? It sounds
>>> quite high in the first place (that was my first thought when I
>>> read
>>> it), and OTOH those processes that run into intermittent IO errors
>>> are
>>> probably the ones that do I/O almost continuously, so maybe reading
>>> continuously for a limited time is the better idea?
>>>
>>
>> I am afraid of whether reading for a limited time will affect the
>> usable
>> bandwidth of the true up-layer transaction. If not, reading
>> continuously
>> is the nearest to the real case.
>> How about 10Hz sample rate and 10ms continuous reading?  In other
>> words,
>> every 100ms interval, we read continuously for 10ms.
>>
>>
>>> 3. I would suggest setting the dm status of paths undergoing the
>>> flakiness test to "failed" immediately. That way the IO caused by
>>> the
>>> test will not interfere with the regular IO on the path. 
>>>
OK, it's better the checking process will not interfere with the regular IO
on the path. I will adopt this in V4.
If we set the dm status of paths undergoing the flakiness test to
"failed" immediately, the path_io_err_XXX can _not_ work in parallel with
san_path_err_XXX feature. So the san_path_err_XXX feature will be dropped
or reused.


>>> 4. I can see that you chose aio to avoid having to create a
>>> separate
>>> thread for each path being checked. But I'm wondering whether using
>>> aio
>>> for this is a good choice in general. My concern with aio is that
>>> to my
>>> knowledge there's no good low-level cancellation mechanism. When
>>> you
>>> io_cancel() one of your requests, you can be sure not to get
>>> notified
>>> of its completion any more, but that doesn't mean that it wouldn't
>>> continue to lurk down in the block layer. But I may be overlooking
>>> essential stuff here.
>>>
>>>> Thethr
>>>> IO accounting process for a path will last for
>>>> path_io_err_sample_time.
>>>> If the number of IO error on a particular path is greater than
>>>> the
>>>> path_io_err_num_threshold, then the path will not reinstate for
>>>
>>> It would be more user-friendly to allow the user to specify the
>>> error
>>> rate threshold as a percentage
>>
>> Error rate threshold as a percentage is not enough to distinguish
>> small
>> error rate. How about a permillage rate (1/1000)?
>>
>>
>>>> +struct io_err_stat_path *find_err_path_by_dev(vector pathvec,
>>>> char
>>>> *dev)
>>>
>>> You are re-implementing generic functionality here
>>> (find_path_by_dev),
>>> why?
>>>
>>
>> Yes, because the structure is different: struct  io_err_stat_path and
>> struct path.
> 
> Why don't you just add a struct io_err_stat_path* in "struct path"?

Great advice. Just a pointer in "struct path" . I will adopt this in V4. Thanks.

> Regards,
> Martin
> 

Best Wishes
Guan Junxiong
