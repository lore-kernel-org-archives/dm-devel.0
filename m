From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH V4 1/2] multipath-tools: intermittent IO
 error accounting to improve reliability
Date: Tue, 19 Sep 2017 09:32:37 +0800
Message-ID: <e596eefc-2d42-e840-57cf-6219d43de9d9@huawei.com>
References: <1505619638-20912-1-git-send-email-guanjunxiong@huawei.com>
	<1505619638-20912-2-git-send-email-guanjunxiong@huawei.com>
	<fd6ead563a154984abc2654fd1a8ea30@BRMWP-EXMB12.corp.brocade.com>
	<7035dfdb-1c49-aa3f-3836-1ec316707c47@huawei.com>
	<1505764297.12944.2.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1505764297.12944.2.camel@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, Muneendra Kumar M <mmandala@Brocade.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "chengjike.cheng@huawei.com" <chengjike.cheng@huawei.com>, "niuhaoxin@huawei.com" <niuhaoxin@huawei.com>, "shenhong09@huawei.com" <shenhong09@huawei.com>
List-Id: dm-devel.ids



On 2017/9/19 3:51, Martin Wilck wrote:
> On Mon, 2017-09-18 at 22:36 +0800, Guan Junxiong wrote:
>> Hi Muneendra,
>>
>> Thanks for you feedback.  My comments are incline below.
>>
>> On 2017/9/18 20:53, Muneendra Kumar M wrote:
>>> Hi Guan,
>>> This a good effort for detecting the intermittent IO error
>>> accounting to improve reliability.
>>> Your new algorithm is  mutually exclusive with san_path_err_XXX.
>>> It resolved the below issue which you have mentioned .
>>>>> Even the san_path_err_threshold , san_path_err_forget_rate and
>>>>> san_path_err_recovery_time is turned on,
>>>>> the detect sample interval of that path checkers is so
>>>>> big/coarse that it doesn't see what happens in the middle of
>>>>> the sample interval.
>>>
>>> But I have some concerns.
>>>
>>> Correct me if my understanding on the below line is correct
>>>>> On a particular path when a path failing events occur twice in
>>>>> 60 second due to an IO error, multipathd will fail the path and
>>>>> enqueue 
>>>>> this path into a queue of which each member is sent a couple of
>>>>> continuous direct reading asynchronous io at a fixed sample
>>>>> rate of 10HZ. 
>>>
>>> Once we hit the above condition (2 errors in 60 secs) for a
>>> path_io_err_sample_time we keeps on injecting the asynchronous io
>>> at a fixed sample rate of 10HZ.
>>> And during this path_io_err_sample_time if we hit the the
>>> path_io_err_rate_threshold then we will not reinstantate this path
>>> for a path_io_err_recovery_time.
>>> Is this understanding correct?
>>>
>>
>> Partial correct.
>> If we hit the above condition (2 errors in 60 secs), we will fail the
>> path first before injecting a couple of asynchronous IOs to keep the
>> testing not affected by other IOs.
>> And after this path_io_err_sample_time :
>> (1) if we hit the the path_io_err_rate_threshold, the failed path
>> will keep unchanged  and then after the path_io_err_recovery_time
>> (which is confusing, sorry, I will rename it to "recheck"), we will
>> reschedule this IO error checking process again.
>> (2) if we do NOT hit the path_io_err_rate_threshold, the failed path
>> will reinstated by path checking thread in a tick (1 second) ASAP.
>>
>>
>>> If the above understanding is correct then my concern is :
>>> 1) On a particular path if we are seeing continuous errors but not
>>> within 60 secs (may be for every 120 secs) of duration how do we
>>> handle this. Still this a shaky link.
>>> This is what our customers are pointing out.
>>> And if i am not wrong the new algorithm will comes into place
>>> only  if a path failing events occur twice in 60 seconds.
>>>
>>> Then this will not solve the intermittent IO error issue which we
>>> are seeing as the data is still going on the shaky path .
>>> I think this is the place where we need to pull in  in
>>> san_path_err_forget_rate .
>>>
>>
>> Yes .  I have thought about using some adjustable parameters such as
>> san_path_err_pre_check_time and  san_path_err_threshold to cover ALL
>> the scenarios the user encounters.
>> In the above fixed example,san_path_err_pre_check_time is set to 60
>> seconds, san_path_err_threshold is set 2.
>> However, if I adopt this, we have 5 parameters
>> (san_path_err_pre_check_time and  san_path_err_threshold + 3
>> path_io_err_XXXs ) to support this feature. You know, mulitpath.conf 
>> configuration is becoming more and more daunting as Martin pointed in
>> the V1 of this patch.
>>
>> But now, maybe it is acceptable for users to use the 5 parameters if
>> we set san_path_err_pre_check_time and  san_path_err_threshold to
>> some default values such as 60 second and 2 respectively.
>> **Martin** , **Muneendra**, how about this a little compromising
>> method?  If it is OK , I will update in next version of patch.
> 
> Hm, that sounds a lot like san_path_err_threshold and
> san_path_err_forget_rate, which you were about to remove.
> 
> Maybe we can simplify the algorithm by checking paths which fail in a
> given time interval after they've been reinstated? That would be one
> less additional parameter.
> 

"san_path_double_fault_time"  is great.  One less additional parameter and
still covering most scenarios are appreciated.


> The big question is: how do administrators derive appropriate values
> for these parameters for their environment? IIUC the values don't
> depend on the storage array, but rather on the environment as a whole;
> all kinds of things like switches, cabling, or even network load can
> affect the behavior, so multipathd's hwtable will not help us provide
> good defaults. Yet we have to assume that a very high percentage of
> installations will just use default or vendor-recommended values. Even
> if the documentation of the algorithm and its parameters was perfect
> (which it currently isn't), most admins won't have a clue how to set
> them. AFAICS we don't even have a test procedure to derive the optimal
> settings experimentally, thus guesswork is going to be applied, with
> questionable odds for success.
> 
> IOW: the whole stuff is basically useless without good default values.
> It would be up to you hardware guys to come up with them.
> 

I agree.  So let users to come up with those values. What we can do  is
to log the testing result such as path_io_err_rate in the given sample
time.

>> san_path_err_forget_rate is hard to understand, shall we use Regards
>> san_path_err_pre_check_time
> 
> A 'rate' would be something which is measured in Hz, which is not the
> case here. Calling it a 'time' is more accurate. If we go with my
> proposal above, we might call it "san_path_double_fault_time".
> 
> Regards
> Martin
> 

Regards
Guan
