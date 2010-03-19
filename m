From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm
	resume	ioctl.
Date: Fri, 19 Mar 2010 14:17:24 +0100
Message-ID: <4BA37964.1050502@redhat.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
	<ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>
	<4BA29CA4.9070000@redhat.com>	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>
	<20100319090656.GR6379@soda.linbit>	<ac3eb2511003190224u1eb19e4lfeda36bbab18939@mail.gmail.com>
	<4BA348B7.5070604@redhat.com>	<ac3eb2511003190316s30c106fdkfd94861c99f9802d@mail.gmail.com>
	<20100319121238.GB919@agk-dp.fab.redhat.com>
	<ac3eb2511003190516i52f651d3lcf2184e7c6d7635f@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ac3eb2511003190516i52f651d3lcf2184e7c6d7635f@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On 03/19/2010 01:16 PM, Kay Sievers wrote:
> On Fri, Mar 19, 2010 at 13:12, Alasdair G Kergon <agk@redhat.com> wrote:
>> E.g. Flagging a device as 'private' as discussed in an earlier mail.
> 
> Sure, that can all be done. Plain udev leaves dm and md devices
> completely to the subsystem own rules. It might be other tools which
> interfere here, and that might need to be synchronized to match on
> some values in the udev properties or sysfs.
> 
> Kay

Great. We have the flags in uevents, we have udev properties. We can't
put them directly in sysfs because of the reasons we already discussed
(it's also extended information related to exact device-mapper subsystem,
not easily accessible in the middle of processing from outer space).

Do we have these flags/properties available when processing the event
originated in the "watch rule" or "udevadm trigger". No. The information
is cleared from udev db and inaccessible.

That's what we need and what we tried to ask for (besides trying to solve
that problem with the ADD event).

Peter
