From: Yu Chen <yu.c.chen@intel.com>
Subject: Re: [4.1-rc1][Hibernation failed]  bisect result  included
Date: Tue, 05 May 2015 10:30:28 +0800
Message-ID: <55482B44.6060407@intel.com>
References: <36DF59CE26D8EE47B0655C516E9CE6402CA0E2@SHSMSX101.ccr.corp.intel.com> <59629198.7WWMERNz9P@vostro.rjw.lan> <20150504142654.GA985@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20150504142654.GA985@redhat.com>
Sender: linux-pm-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Dan Ehrenberg <dehrenberg@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>, "Lu, Aaron" <aaron.lu@intel.com>, Martin Steigerwald <martin@lichtvoll.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 05/04/2015 10:26 PM, Mike Snitzer wrote:
> On Mon, May 04 2015 at 10:08am -0400,
> Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>
>> On Sunday, May 03, 2015 03:54:39 PM Chen, Yu C wrote:
>>> Hi,all,
>>> When we are doing QA test, a hibernation failor was found on latest kernel 4.1-rc1,
>>> resume from hibernation failed with the following error:
>>>
>>> PM: Hibernation image not present or could not be loaded.
>>>
>>> Bisect shows following commit might trigger this problem:
>>> commit 283e7ad0241155710f99a9f39d13313a53336926
>>>
>>> The  reason for failor is that, some distribution use klibc in initrd
>>> to restore the image, and klibc will provide kernel with the device
>>> format of major:minor:offset,
>>> for example, 8:3:0 represents a swap partition, and klibc will
>>> echo 8:3:0 > /sys/power/resume to resume the system manually.
>>> However in current implementation, format of 8:3:0 will be regarded
>>> as an invalid device, so restoring from hibernation failed.
>>>
>>> Do we need to add support for device format like 8:3:0?
>>> I'm happy to debug more specifically if you can let me know what
>>> would be of use, and I've also attached a temporary patch
>>> for this problem, not sure if it is suitable,  thanks.
>>
>> It'd be better to send the patch inline so it is not lost in replies.
>> Reproduced below.
>>
>> Dan, Mike, any chance to look at this?  It is a functional regression for
>> some people.
>
> Sorry about this.  Wasn't aware that such a strange format was being
> used.  The proposed patch looks good to me (formatting is a bit weird
> though, the last "&dummy) == 3)) {" line shouldnt be needed if previous
> line isn't indented so far.
>

Thank you very much, Mike and Rafeal,
I'll send another version titled with V2 for review.

Best Regards,
Yu

> Unless other more official init maintainer(s) want to pick this fix up:
> since I committed the commit that caused this regression I can pick this
> patch up and get it to Linus for 4.1-rc3 inclussion via linux-dm.git.
> Please just let me know, thanks!
>
>> ---
>>  From a65d76c143b315c322b5c7a9fb365703c9f32798 Mon Sep 17 00:00:00 2001
>> From: Chen Yu <yu.c.chen@intel.com>
>> Date: Sun, 3 May 2015 22:35:05 +0800
>> Subject: [RFC] init: support device of major:minor:offset format
>>
>> Distribution like Ubuntu uses klibc rather than uswsusp to resume
>> system from hibernation, which will treat swap partition/file in
>> the form of major:minor:offset. For example, 8:3:0 represents a
>> swap partition in klibc, and klibc's resume process in initrd will
>> finally echo 8:3:0 to /sys/power/resume for manually restoring.
>> However in current implementation, 8:3:0 will be treated as an invalid
>> device format, and it is found that manual resumming from hibernation
>> will fail on lastest kernel.
>>
>> This patch adds support for device with major:minor:offset format
>> when resumming from hibernation.
>>
>> Reported-by: Prigent, Christophe <christophe.prigent@intel.com>
>>
>> Signed-off-by: Chen Yu <yu.c.chen@intel.com>
>> ---
>>   init/do_mounts.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/init/do_mounts.c b/init/do_mounts.c
>> index 8369ffa..2d36bf1 100644
>> --- a/init/do_mounts.c
>> +++ b/init/do_mounts.c
>> @@ -225,10 +225,12 @@ dev_t name_to_dev_t(const char *name)
>>   #endif
>>
>>   	if (strncmp(name, "/dev/", 5) != 0) {
>> -		unsigned maj, min;
>> +		unsigned maj, min, offset;
>>   		char dummy;
>>
>> -		if (sscanf(name, "%u:%u%c", &maj, &min, &dummy) == 2) {
>> +		if ((sscanf(name, "%u:%u%c", &maj, &min, &dummy) == 2) ||
>> +			(sscanf(name, "%u:%u:%u:%c", &maj, &min, &offset,
>> +			&dummy) == 3)) {
>>   			res = MKDEV(maj, min);
>>   			if (maj != MAJOR(res) || min != MINOR(res))
>>   				goto fail;
>> --
>> 1.9.1
>>
>>

