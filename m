From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm resume
	ioctl.
Date: Fri, 19 Mar 2010 12:14:24 +0100
Message-ID: <4BA35C90.7000301@redhat.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
	<ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>
	<4BA29CA4.9070000@redhat.com>
	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>
	<20100319090656.GR6379@soda.linbit>
	<ac3eb2511003190224u1eb19e4lfeda36bbab18939@mail.gmail.com>
	<4BA348B7.5070604@redhat.com>
	<ac3eb2511003190316s30c106fdkfd94861c99f9802d@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ac3eb2511003190316s30c106fdkfd94861c99f9802d@mail.gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 03/19/2010 11:16 AM, Kay Sievers wrote:

> There are several subsystems that depend on updating everything with
> "change" events when device configurations change. There is nothing
> inherently wrong with this approach, as long as subsystems send the
> proper "change" events and don't try to hide anything they have
> registered.

ok, this is perfectly fine with dm devices, CHANGE announces all
changes. Just I am not sure if all consumers of events (and separate
rules authors) know about that, I saw so many problems with
failing something when wrongly reacting to ADD event...

Also it means that after ADD the by-uuid* and similar symlinks
cannot be yet trusted - if the UUID is read from device and device
is not yet ready.

Well. And what should happen if anyone generate
artificial CHANGE event before the real first CHANGE event comes from
subsystem? (yes, I am looking at you, OPTIONS+="watch" thing for example)

According to above, rules must be written such way that every ADD/CHANGE
event must expect that device is not ready, so it can create only
partial info in udev, is it correct?
(this is of course no problem if the rules are the same for both cases)

Milan
--
mbroz@redhat.com
