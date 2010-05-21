From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: add devname module aliases to allow module on-demand
	auto-loading
Date: Fri, 21 May 2010 22:20:02 +0200
Message-ID: <AANLkTimrz9wyVKe0Mdabc_zylZt0JmpVxgf7ab2Bw55B__13668.4144301855$1274473342$gmane$org@mail.gmail.com>
References: <1274371640.302.5.camel@yio.site>
	<AANLkTilI3RYcybjG7b1juTa3H31ImxQI1-2R_l7q0yc1@mail.gmail.com>
	<AANLkTinQwEqFKAiyAwVPwmzLtUXJkaOdZ0c88O_tfp-1@mail.gmail.com>
	<201005211909.29326.knikanth@suse.de>
	<AANLkTimGBgpqB7HEZrecv7uEis6L8b5Yv7jfD6iv_f4J@mail.gmail.com>
	<20100521182325.GO3991@agk-dp.fab.redhat.com>
	<AANLkTimuciWfkVwn7dKVeKL38WpMiCvgAxGx4ngAankW@mail.gmail.com>
	<20100521193251.GP3991@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100521193251.GP3991@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kay Sievers <kay.sievers@vrfy.org>, Nikanth Karthikesan <knikanth@suse.de>, Peter Rajnoha <prajnoha@redhat.com>, Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@red>
List-Id: dm-devel.ids

On Fri, May 21, 2010 at 21:32, Alasdair G Kergon <agk@redhat.com> wrote:
> On Fri, May 21, 2010 at 08:51:49PM +0200, Kay Sievers wrote:
>> The kernel itself creates /dev/mapper/control today.
>
> Must have missed that patch:)
> Userspace lvm and dm code is certainly not tied to that today.
>
> The device node that userspace lvm and dm tools use is under the
> complete control of this userspace code: it chooses the name, and
> creates or fixes it if it doesn't already exist with the required
> properties: anything devtmpfs is relevant only if it guessed the
> right name that this *completely independent* userspace code
> chooses to use and already created it exactly as required.
>
> If we were to move to a fixed name for the control device and hand
> control of that name to the kernel, then obviously this userspace
> code would need adjusting to respect that.

Upstream udev has no primary device node naming anymore, it's all
controlled by the kernel. In fact, recent udev versions log errors if
userspace defines names which disagree with the kernel-provided names,
or the kernel-created nodes.

There is no "abstraction" anymore, the kernel defines the API today,
and device naming is 100% inside the kernel.

Udev's job is manage permissions, and to create meaningful symlinks
which may change during lifetime of a kernel device.

The primary kernel device name is always in sync with "dmesg",
"proc/sys" and "/dev" these days. Only the symlinks may change at any
time, reflecting the current state of the device.

Kay
