From: JeongHyeon Lee <jhs2.lee@samsung.com>
Subject: Re: New mode DM-Verity error handling
Date: Mon, 22 Jun 2020 09:27:27 +0900
Message-ID: <3df0c938-6b7d-4c02-e243-22e0d95e3de0@samsung.com>
References: <CGME20200618070250epcas1p409eb2ddd19ecc5d55c219ac3dc884f25@epcas1p4.samsung.com>
        <98eac3fc-c399-625d-5730-29853b3a0771@samsung.com>
        <20200618154444.GB18007@redhat.com> <20200618165006.GA103290@google.com>
        <20200618170952.GA18057@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20200618170952.GA18057@redhat.com>
Content-Language: en-US
Sender: linux-doc-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Sami Tolvanen <samitolvanen@google.com>
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com, corbet@lwn.net
List-Id: dm-devel.ids

Hello Dear DM-Verity maintainers.
Thank you for your reply.

I agreed with you that "the device should be put in a failed state and 
left for admin recovery"
As dear Sami told us, When Android device occurred panic, restarting and 
to save the logs to bootloader also recovery log.
Of course Using the restart mode on systems without firmware support 
won't make sense.
However, on Android devices, restart or panic mode makes sense.

In android, the behavior is different depend on the binary type.
here are 3 type like user / userdebug / eng (engineering).

When kernel panic occurs, it operates as follows
  * kernel panic in user binary(low)-> restart mode
  * kernel panic in eng binary(mid) -> upload mode

It's actually at the debug level.
All users are set to low, but change it build option or others.
but Most users do not know.

You might think, "Why do you need a panic instead of reboot?"

To start with, It's easy to analyze what the device has problem.
If we use restart mode, it's difficult to analyze because device is 
rebooted without logging.(not remain log)
And If use panic mode, samsung takes snapshots(save log etc) when 
occurred panic.(Maybe other company or Android are same).
So We look for a debugging log and the analyze kind of problem in device 
as well as dm-verity.
In the development stage, most of them are use in eng mode.
when panic occurs, it goes to upload mode, so it is convenient to 
analyze whether it is HW problem / SW problem.
In most cases it was a hardware issue. Since we are a manufacturer, the 
HW problem is also important.

Also, users using Android devices can recognize that there is a problem 
with my device through a reboot.
Users don't know the exact reason, but they think that rebooting is wrong.
As mentioned above, in user mode, panic operates in reboot mode.
The user sees that device is rebooting and thinks there is a problem.
They uploads QnA to Samsung members App or visit service center for repair.
Then, developers need to get the log the device used by users to check 
what the problem is. So We are using panic to get the log.

What's more, reboot/panic may seem wrong, but from a security 
perspective, I think it's really important when looking at dm-verity.
Of course, I think the maintainers already know it.
To the important partition or Android devices system, will be protected 
using dm-verity.
We can make the partition(want to protect) into a read-only partition, 
compare the digest, and check whether there are any problems.
If a malicious user or hacker can damage the system or important 
partition may change something.
At this time, we can defend against further hacking by generating a 
panic or restart.
This will make the security feel strong. So reboot mode and panic mode 
will be required.

We have long explained why we need it.
Through this, Samsung needs a panic mode, so please read it carefully 
and give feedback.

Thank you :D
Jeonghyeon Lee


On 19/06/2020 02:09, Mike Snitzer wrote:
> On Thu, Jun 18 2020 at 12:50pm -0400,
> Sami Tolvanen <samitolvanen@google.com> wrote:
>
>> On Thu, Jun 18, 2020 at 11:44:45AM -0400, Mike Snitzer wrote:
>>> I do not accept that panicing the system because of verity failure is
>>> reasonable.
>>>
>>> In fact, even rebooting (via DM_VERITY_MODE_RESTART) looks very wrong.
>>>
>>> The device should be put in a failed state and left for admin recovery.
>> That's exactly how the restart mode works on some Android devices. The
>> bootloader sees the verification error and puts the device in recovery
>> mode. Using the restart mode on systems without firmware support won't
>> make sense, obviously.
> OK, so I need further justification from Samsung why they are asking for
> this panic mode.
>
> Thanks,
> Mike
>
>
>
