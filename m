From: Lars Marowsky-Bree <lmb@novell.com>
Subject: RFC: multipath IO multiplex
Date: Fri, 5 Nov 2010 19:39:46 +0100
Message-ID: <20101105183946.GG25992@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi all,

this is a topic that came up during our HA miniconference at LPC. I
inherited the action item to code this, but before coding it, I thought
I'd get some validation on the design.

In a cluster environment, we occasionally have time critical IO - both
read and writes, for a mix of via-disk heartbeating, or the exchange of
poison pills.

MPIO plays hell with this, since an IO could potentially experience very
high latency during a path switch. Extending the timeouts to allow for
this is reasonably impractical.

However, our IO has certain properties that make it special - we have
rather careful patterns, they don't overlap, they are effectively single
page/single atomic write unit, and each node effectively writes to its
own area.

So the idea would be to, instead of relying on the active/passive access
pattern, to send the IO down all paths in parallel - and reporting
either the first success or the last failure.

(Clearly, this only works for active/active arrays; active/passive
setups still may have problems.)

Doing this in user-space is somewhat icky; short of scanning the devices
ourselves, or asking multipathd for each IO for the current list, we
have no good way to do that. But the kernel obviously has the correct
list at all times.

So, I think a special IO flag for block IO (ioctl, open() flag on the
device, whatever) that would cause dm-multipath to send the IO down all
paths (and, as mentioned, report either the last failure or first
success), seems to be the easiest way.

How would you prefer such a flag to be implemented and passed in, and
what do you think of the general use case?


Regards,
    Lars

-- =

Architect Storage/HA, OPS Engineering, Novell, Inc.
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde
