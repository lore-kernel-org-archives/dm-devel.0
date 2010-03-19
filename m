From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm resume
	ioctl.
Date: Fri, 19 Mar 2010 13:14:51 +0100
Message-ID: <ac3eb2511003190514l14f81b29u11222d3e09ae5d82@mail.gmail.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
	<4BA29CA4.9070000@redhat.com>
	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>
	<20100319090656.GR6379@soda.linbit>
	<ac3eb2511003190224u1eb19e4lfeda36bbab18939@mail.gmail.com>
	<4BA348B7.5070604@redhat.com>
	<ac3eb2511003190316s30c106fdkfd94861c99f9802d@mail.gmail.com>
	<4BA35C90.7000301@redhat.com>
	<ac3eb2511003190444s4536d984s216e737c1c7b45e3@mail.gmail.com>
	<4BA3693A.9030101@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BA3693A.9030101@redhat.com>
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

On Fri, Mar 19, 2010 at 13:08, Milan Broz <mbroz@redhat.com> wrote:
> On 03/19/2010 12:44 PM, Kay Sievers wrote:
>> On Fri, Mar 19, 2010 at 12:14, Milan Broz <mbroz@redhat.com> wrote:
>>> On 03/19/2010 11:16 AM, Kay Sievers wrote:
>>> Well. And what should happen if anyone generate
>>> artificial CHANGE event before the real first CHANGE event comes from
>>> subsystem? (yes, I am looking at you, OPTIONS+="watch" thing for example)
>>
>> We retrieve the device state and if it's not ready, we just exit.
>
> How? By scanning/opening it?
>
> Scan on uninitialised device can lock the device and break initialisation,
> "-EBUSY" - isn't it race?

Whatever is appropriate, be it a control device node, sysfs, or the
device itself. The simplest case would be the "size" check, MD checks
a sysfs attribute, others just try to open. For dm we used to call
dmsetup and rely on its returned information.

> So all applications, which run some kind of configuration of device
> should expect that device can be randomly locked by udev rules...
>
> [Yes, it happens. I solved several problems in cryptsetup where various
> udev scans open and locks keyslot device.
> (Ignoring the fact that it contains key material, in this case it was
> not security problem - the material is still obfuscated.)
> These are now masked in udev rules, but I do not like this approach much.]

Yes, some tools may need to synchronize with the eventually running
events. Plain udev does ignore all dm devices regarding the tools
which open the device. It's all in the special subsystem rules, which
might need to take care of synchronization.

>> Yeah, usually it does not create any meta-information besides the
>> primary device node.
>
> Unfortunately it is not the DM/LVM etc case - we had always symlinks
> and long device names etc.

But these are passed from an earlier event run. Usually they are just
retrieved the same way again.

Kay
