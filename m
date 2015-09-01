From: Andy Grover <agrover@redhat.com>
Subject: Re: dm-delay: Add a message to change delay
Date: Tue, 1 Sep 2015 07:17:46 -0700
Message-ID: <55E5B38A.4020101@redhat.com>
References: <1441056276-14288-1-git-send-email-agrover@redhat.com>
	<20150901020557.GA31620@redhat.com> <55E53169.1030105@redhat.com>
	<20150901121427.GA2906@redhat.com> <20150901130934.GA14882@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150901130934.GA14882@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 09/01/2015 06:09 AM, Mike Snitzer wrote:
> On Tue, Sep 01 2015 at  8:14am -0400,
> Vivek Goyal <vgoyal@redhat.com> wrote:
>
>> On Mon, Aug 31, 2015 at 10:02:33PM -0700, Andy Grover wrote:
>>> On 08/31/2015 07:05 PM, Vivek Goyal wrote:
>>>> On Mon, Aug 31, 2015 at 02:24:36PM -0700, Andy Grover wrote:
>>>>> This enables runtime modification of the read and write delay values.
>>>>>
>>>>> Make sure if the delay time is reduced to flush currently-delayed
>>>>> bios first, to maintain ordering.
>>>>>
>>>>> Signed-off-by: Andy Grover <agrover@redhat.com>
>>>>> ---
>>>>>   Documentation/device-mapper/delay.txt |  8 +++++++
>>>>>   drivers/md/dm-delay.c                 | 42 +++++++++++++++++++++++++++++++++++
>>>>>   2 files changed, 50 insertions(+)
>>>>>
>>>>> diff --git a/Documentation/device-mapper/delay.txt b/Documentation/device-mapper/delay.txt
>>>>> index 15adc55..9e80751 100644
>>>>> --- a/Documentation/device-mapper/delay.txt
>>>>> +++ b/Documentation/device-mapper/delay.txt
>>>>> @@ -10,6 +10,14 @@ Parameters:
>>>>>   With separate write parameters, the first set is only used for reads.
>>>>>   Delays are specified in milliseconds.
>>>>>
>>>>> +Message Interface
>>>>> +-----------------
>>>>> +The delay target will accept a message of the following format:
>>>>> +
>>>>> +set_delay <read_delay> [<write_delay>]
>>>>> +
>>>>
>>>> Hi Andy,
>>>>
>>>> So if I want to change only write_delay and keep read_delay same, how do
>>>> I do that. Do I have to keep track of existing delay values in user space
>>>> and pass same value in read_delay to achieve this.
>>>>
>>>> Thanks
>>>> Vivek
>>>
>>> Hi Vivek,
>>>
>>> Yes I suppose userspace would either need to remember read_delay so as to
>>> not change it while setting write_delay, or I guess it could read the
>>> existing values by getting table status before sending the message. Is this
>>> reasonable, or do you think it would be better to, say, have separate
>>> messages for setting the two values, or some other message style?
>>
>> Ideally I think we should have those --key=value type of arguments which
>> we don't have yet. So that option is not feasible I guess.
>>
>> If latest values are readable from status, then I think single message
>> sounds reasoanble to me.
>
> As Zdenek already effectively said: there is no need for this patch.
> You don't need to use a message when a table reload would suffice to
> change the parameter that is already passed on the table ctr.
>
> Any layer that would be trained to send a message can just as easily be
> trained to reload the table to achieve the same result.

Ah I see. Thanks for the explanations. Noflush suspend & table reload is 
better for this.

Regards -- Andy
