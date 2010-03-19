From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event
	after	dm	resume	ioctl.
Date: Fri, 19 Mar 2010 16:05:22 +0100
Message-ID: <4BA392B2.50903@redhat.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>	<ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>	<4BA29CA4.9070000@redhat.com>	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>	<20100319090656.GR6379@soda.linbit>	<ac3eb2511003190224u1eb19e4lfeda36bbab18939@mail.gmail.com>	<4BA37B06.1040107@redhat.com>
	<4BA38567.1050106@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BA38567.1050106@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 03/19/2010 03:08 PM, Hannes Reinecke wrote:
> As mentioned earlier, CHANGE events do not carry any
> information about _what_ has changed.
> The udev rules / programs are expected to check for
> this themselves. So from that point of view yes, you
> cannot simply wait for 'the' CHANGE event as you
> might get more than one.
> 
> I guess most of this discussion could be solved if
> the CHANGE events would be modify to attach some
> enviroment variables indicating the nature of the change.
> 
> EG adding 'DM_STATE=LIVE' or whatever is appropriate
> here.

As for the variables, we already carry some important
information within uevents.

Generally, it carries hints for udev rules to instruct them
how they should be applied correctly, which parts should be
run based on the type of the device, it's real meaning with all
relations to other devices taken into account within that
DM subsystem used (e.g. LVM2's snapshots, mirrors...).

Most of this information is really not suitable to be stored
as a sysfs attribute since it deals with userspace notions,
an abstraction layer above device-mapper...

So the CHANGE event should carry all this information to
properly do all necessary actions and decisions while processing
the udev rules. This information is not easy to acquire by just
calling some program in userspace (from udev rules as most of
the others do). The device can be in the middle of processing
and that event could be just a part of the whole sequence
(also, it's not only that one device, we deal with all sorts
of relations among devices).

Now, the problem we're hitting are those artificial events
generated as a result of the "watch" rule and "udevadm trigger"
that could be triggered anytime. These are just plain events
that we can't even ignore. We have to apply all the rules for
them, but since we don't have the hints/flags, they are applied
incorrectly (creating nodes/symlinks where it is not appropriate,
calling programs from udev rules that are not appropriate etc.).

The proposal here was to keep such information in udev db
so it's still accessible while processing any of the "artificial"
events.

We can and already do provide some information in uevent's
environment, but the idea is broken by those spurious events.
As mentioned already, we made a proposal to make these bits of
information accessible even for the other events...

And the final solution needs cooperation from both sides.

Peter
