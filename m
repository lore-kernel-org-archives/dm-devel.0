From: Ondrej Kozina <okozina@redhat.com>
Subject: Re: [PATCH 0/3] dm-crypt: Adds support for wiping key
 when doing suspend/hibernation
Date: Fri, 17 Apr 2015 10:52:46 +0200
Message-ID: <5530C9DE.2040302@redhat.com>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>	<20150406130045.GA18583@redhat.com>
	<201504061529.57299@pali>	<20150409131208.GA9504@redhat.com>	<20150409132836.GD12339@atrey.karlin.mff.cuni.cz>	<20150409140842.GA9779@redhat.com>
	<mgnv2g$if5$2@ger.gmane.org> <20150417075211.GC403@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150417075211.GC403@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Alex Elsayed <eternaleye@gmail.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

On 04/17/2015 09:52 AM, Mike Snitzer wrote:
> On Thu, Apr 16 2015 at  5:23am -0400,
> Alex Elsayed <eternaleye@gmail.com> wrote:
>
>> Mike Snitzer wrote:
>>
>>> On Thu, Apr 09 2015 at  9:28am -0400,
>>> Pali Roh=E1r <pali.rohar@gmail.com> wrote:
>>>
>>>> On Thursday 09 April 2015 09:12:08 Mike Snitzer wrote:
>>>>> On Mon, Apr 06 2015 at  9:29am -0400,
>>>>> Pali Roh=E1r <pali.rohar@gmail.com> wrote:
>>>>>
>>>>>> On Monday 06 April 2015 15:00:46 Mike Snitzer wrote:
>>>>>>> On Sun, Apr 05 2015 at  1:20pm -0400,
>>>>>>>
>>>>>>> Pali Roh=E1r <pali.rohar@gmail.com> wrote:
>>>>>>>> This patch series increase security of suspend and hibernate
>>>>>>>> actions. It allows user to safely wipe crypto keys before
>>>>>>>> suspend and hibernate actions starts without race
>>>>>>>> conditions on userspace process with heavy I/O.
>>>>>>>>
>>>>>>>> To automatically wipe cryto key for <device> before
>>>>>>>> hibernate action call: $ dmsetup message <device> 0 key
>>>>>>>> wipe_on_hibernation 1
>>>>>>>>
>>>>>>>> To automatically wipe cryto key for <device> before suspend
>>>>>>>> action call: $ dmsetup message <device> 0 key
>>>>>>>> wipe_on_suspend 1
>>>>>>>>
>>>>>>>> (Value 0 after wipe_* string reverts original behaviour - to
>>>>>>>> not wipe key)
>>>>>>>
>>>>>>> Can you elaborate on the attack vector your changes are meant
>>>>>>> to protect against?  The user already authorized access, why
>>>>>>> is it inherently dangerous to _not_ wipe the associated key
>>>>>>> across these events?
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> yes, I will try to explain current problems with cryptsetup
>>>>>> luksSuspend command and hibernation.
>>>>>>
>>>>>> First, sometimes it is needed to put machine into other hands.
>>>>>> You can still watch other person what is doing with machine, but
>>>>>> once if you let machine unlocked (e.g opened luks disk), she/he
>>>>>> can access encrypted data.
>>>>>>
>>>>>> If you turn off machine, it could be safe, because luks disk
>>>>>> devices are locked. But if you enter machine into suspend or
>>>>>> hibernate state luks devices are still open. And my patches try
>>>>>> to achieve similar security as when machine is off (=3D no crypto
>>>>>> keys in RAM or on swap).
>>>>>>
>>>>>> When doing hibernate on unencrypted swap it is to prevent leaking
>>>>>> crypto keys to hibernate image (which is stored in swap).
>>>>>>
>>>>>> When doing suspend action it is again to prevent leaking crypto
>>>>>> keys. E.g when you suspend laptop and put it off (somebody can
>>>>>> remove RAMs and do some cold boot attack).
>>>>>>
>>>>>> The most common situation is:
>>>>>> You have mounted partition from dm-crypt device (e.g. /home/),
>>>>>> some userspace processes access it (e.g opened firefox which
>>>>>> still reads/writes to cache ~/.firefox/) and you want to drop
>>>>>> crypto keys from kernel for some time.
>>>>>>
>>>>>> For that operation there is command cryptsetup luksSuspend, which
>>>>>> suspend dm device and then tell kernel to wipe crypto keys. All
>>>>>> I/O operations are then stopped and userspace processes which
>>>>>> want to do some those I/O operations are stopped too (until you
>>>>>> call cryptsetup luksResume and enter correct key).
>>>>>>
>>>>>> Now if you want to suspend/hiberate your machine (when some of dm
>>>>>> devices are suspeneded and some processes are stopped due to
>>>>>> pending I/O) it is not possible. Kernel freeze_processes function
>>>>>> will fail because userspace processes are still stopped inside
>>>>>> some I/O syscall (read/write, etc,...).
>>>>>>
>>>>>> My patches fixes this problem and do those operations (suspend dm
>>>>>> device, wipe crypto keys, enter suspend/hiberate) in correct
>>>>>> order and without race condition.
>>>>>>
>>>>>> dm device is suspended *after* userspace processes are freezed
>>>>>> and after that are crypto keys wiped. And then computer/laptop
>>>>>> enters into suspend/hibernate state.
>>>>>
>>>>> Wouldn't it be better to fix freeze_processes() to be tolerant of
>>>>> processes that are hung as a side-effect of their backing storage bei=
ng
>>>>> suspended?  A hibernate shouldn't fail simply because a user chose to
>>>>> suspend a DM device.
>>>>>
>>>>> Then this entire problem goes away and the key can be wiped from
>>>>> userspace (like you said above).
>>>>
>>>> Still there will be race condition. Before hibernation (and device
>>>> poweroff) we should have synced disks and filesystems to prevent data
>>>> lose (or other damage) as more as we can. And if there will be some
>>>> application which using lot of I/O (e.g normal firefox) then there
>>>> always will be race condtion.
>>>
>>> The DM suspend will take care of flushing any pending I/O.  So I don't
>>> see where the supposed race is...
>>>
>>> Anything else that is trapped in userspace memory will be there when the
>>> machine resumes.
>>>
>>>> So proper way is to wipe luks crypto keys *after* userspace processes
>>>> are freezed.
>>>
>>> I know you believe that I'm just not accepting that at face value.
>>
>> Um, pardon me if I'm being naive, but what about the case of hibernation
>> where the swapdev and the root device are both LVs on the same dm_crypt
>> device?
>>
>> The kernel is writing to swap _after_ userspace processes are all frozen;
>> that seems to me like an ordering dependency entirely incompatible with
>> userspace dropping the key...
>
> Good point, definitely not compatible with the Pali's approach.

Ouch! I'm afraid this effectively killed one of my experiments with =

dm-crypt suspend. Good to get reminded sooner than later!

> (but is swap really configured ontop of the same dm-crypt device like
> this in practice?  I've not heard of that being a common pattern but I
> could just be sheltered)

yes. It's one among many perfectly valid setups.

(For some the goal here would be to have whole disk encrypted including =

boot partition unlocked during boot)
