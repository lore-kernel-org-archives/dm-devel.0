From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: multipath-tools and queue-length/service-time path
	selectors oops
Date: Mon, 28 Sep 2009 16:41:48 +0900
Message-ID: <4AC068BC.7040301@ct.jp.nec.com>
References: <20090911213435.GA1590@thumper2> <4AADA753.6000205@ct.jp.nec.com>
	<20090914151251.GA17421@thumper2> <4AAEF795.9060301@ct.jp.nec.com>
	<20090915143509.GA22993@thumper2> <4AB2E471.9010802@ct.jp.nec.com>
	<20090924192859.GA14887@thumper2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090924192859.GA14887@thumper2>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andy <genanr@emsphone.com>, Christophe Varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Andy and Christophe,

On 09/25/2009 04:29 AM +0900, Andy wrote:
> On Fri, Sep 18, 2009 at 10:37:53AM +0900, Kiyoshi Ueda wrote:
>> Hi Andy,
>>
>> Sorry for the late reply.
>>
>> On 09/15/2009 11:35 PM +0900, Andy wrote:
>>> Now, I have another question. Why does the queue-length selector not use all
>>> my paths?
>>>
>>> Sep 15 09:25:44 | loop0: device node name blacklisted
>>> Sep 15 09:25:44 | loop1: device node name blacklisted
>> <snip>
>>> Sep 15 09:25:44 | params = 0 0 1 1 queue-length 0 4 1 8:64 8 8:144 8 8:224 8 65:48 8 
>>> Sep 15 09:25:44 | status = 2 0 0 0 1 1 A 0 4 1 8:64 A 0 0 8:144 A 0 0 8:224 A 0 0 65:48 A 0 0 
>>> Sep 15 09:25:44 | 8: not found in pathvec
>>> Sep 15 09:25:44 | Invalid device number 8
>>> Sep 15 09:25:44 | Invalid device number 8
>> <snip>
>>> reload: u02 (350002ac000020246) undef 3PARdata,VV
>>> size=100G features='0' hwhandler='0' wp=undef
>>> `-+- policy='queue-length 0' prio=4 status=undef
>>>   |- 1:0:0:3 sde 8:64  active ready running
>>>   |- 1:0:1:3 sdj 8:144 active ready running
>>>   |- 2:0:0:3 sdo 8:224 undef ready running
>>>   `- 2:0:1:3 sdt 65:48 undef ready running
>>> Sep 15 09:25:49 | Invalid device number 8
>>> Sep 15 09:25:49 | Invalid device number 8
>>>
>>>
>>> u02 (350002ac000020246) dm-3 3PARdata,VV
>>> size=100G features='0' hwhandler='0' wp=rw
>>> `-+- policy='queue-length 0' prio=2 status=active
>>>   |- 1:0:0:3 sde 8:64  active ready running
>>>   |- #:#:#:# -   #:#   active faulty running
>>>   |- 1:0:1:3 sdj 8:144 active ready running
>>>   `- #:#:#:# -   #:#   active faulty running
>> Actual device configuration seems to be working fine, but the getting
>> information from the configured device seems to be failing due to
>> table parsing problem in disassemble_map().
>> (The RHEL5's device-mapper-multipath package works fine.
>>  So the problem seems to be introduced during upstream development.)
>>
>> I guess the attached patch works around the problem. Please try it.
>> Please note that this patch may *NOT* be a complete fix.
>> Some more codes for new dynamic load balancers may be needed.
>>
>> By the way, unfortunatelly, I can't work on this next week.
>> I'll look at this more after that.  Sorry for the inconvenience.
>>
> 
> I've been busy myself.  But, I did want to let you know that your patches
> worked.

Thank you for your testing, Andy.


Christophe,
I found that you have already applied the patch:
    http://git.kernel.org/?p=linux/storage/multipath-tools/.git;a=commit;h=6a3b111e5e1fb6661a6fe4ff5a44397128279a10

Although the patch is not related to the new dynamic load balancers
directly, it definitely fixes a bug of the table parser.
Thank you very much.

As for the actual parsers of the new load balancers, I'll investigate
the needs and post as separate patches.

Thanks,
Kiyoshi Ueda
