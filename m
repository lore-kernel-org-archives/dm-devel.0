From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm
	resume	ioctl.
Date: Fri, 19 Mar 2010 12:00:29 +0000
Message-ID: <20100319120029.GA919@agk-dp.fab.redhat.com>
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
Content-Disposition: inline
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
Cc: device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

We've been over all this ground before, but here it is again FWIW

On Fri, Mar 19, 2010 at 11:16:15AM +0100, Kay Sievers wrote:
> It will not wait, the tools will just fail to open the device, and
> udev will only create the basic device node, but not possible
> metadata-based symlinks or anything like that. That is expected
> behavior, udev will handle just fine. The needed information will only
> be readable with the next "change" event, and be fully updated with
> every "change" event after that.
 
But while userspace code responding to the uevents is fiddling with the
new node deciding what to do, the userspace code (e.g. lvm2) that is
creating the device tree is continuing to manipulate it as these
are multi-step processes.  If code triggered by the uevents runs
alongside the lvm2 code, stuff fails.  (E.g. lvm2 wants exclusive access
which it can't get because something reacting to the uevent opened the
device temporarily - even though we could have told it not to bother as
it would find nothing of interest on it yet - a concept of 'ignored'
or 'private' devices).  So we require a synchronisation mechanism so
that the lvm2 code can wait for *everything* triggered by the uevents to
finish before proceeding.  (Or alternatively a mechanism to flag that
other code reacting to uevents should ignore these devices at this
stage.)  We attempted to add the synchronisation ourselves
(95-dm-notify.rules) but I think you pointed out there are still things
outside our control that can be triggered without a mechanism to wait
for them to finish.

Alasdair
