From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm resume
	ioctl.
Date: Fri, 19 Mar 2010 11:16:15 +0100
Message-ID: <ac3eb2511003190316s30c106fdkfd94861c99f9802d@mail.gmail.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
	<ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>
	<4BA29CA4.9070000@redhat.com>
	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>
	<20100319090656.GR6379@soda.linbit>
	<ac3eb2511003190224u1eb19e4lfeda36bbab18939@mail.gmail.com>
	<4BA348B7.5070604@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BA348B7.5070604@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 19, 2010 at 10:49, Milan Broz <mbroz@redhat.com> wrote:
> On 03/19/2010 10:24 AM, Kay Sievers wrote:
>> On Fri, Mar 19, 2010 at 10:06, Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
>>> Would introducing a KOBJ_READY_TO_BE_CONSUMED_BY_UDEV help?
>>
>> No, that's what "change" is for, and we already have these "change"
>> events for dm. Udev does not care if the device is ready or not, it
>> synchronizes /sys and /dev, and that works just fine with "change"
>> events.
>
> Udev (rules) do not not care if the device is ready?
>
> That's really news for me. So you are basically saying that dm ADD event is ok,
> and it is problem of udev rules that they react here on ADD event and run
> various scan over not-yet-ready device because it should wait for CHANGE?

It will not wait, the tools will just fail to open the device, and
udev will only create the basic device node, but not possible
metadata-based symlinks or anything like that. That is expected
behavior, udev will handle just fine. The needed information will only
be readable with the next "change" event, and be fully updated with
every "change" event after that.

Usually, it does not make much sense to distinguish between "add" and
"change" in userspace/udev rules. The called udev rules are the same,
and should just check a subsystem-provided property if they should go
ahead or ignore the device.

Udev itself handles "add" and "change" exactly the same way. The only
exception is network device renaming, which only runs on "add".

There are several subsystems that depend on updating everything with
"change" events when device configurations change. There is nothing
inherently wrong with this approach, as long as subsystems send the
proper "change" events and don't try to hide anything they have
registered.

Kay
