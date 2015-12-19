From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: [RFC] zodcache - auto-start dm-cache devices
Date: Fri, 18 Dec 2015 18:01:59 -0600
Message-ID: <n526pn$phb$1@ger.gmane.org>
References: <n508c1$8dl$1@ger.gmane.org>
	<20151218185110.GA25064@agk-dp.fab.redhat.com>
	<56747182.2030404@gmail.com> <56747558.7030507@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56747558.7030507@redhat.com>
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

On 12/18/2015 03:06 PM, Zdenek Kabelac wrote:
> Sure - as long as you do not need to solve any 'security/safety' points,
> you can do things in a simple way.

What security/safety concerns do you have with this approach?

> But how do you plan to support any power-failures and recoveries ?

A zodcache device is a dm-cache device built from several dm-linear
devices.  AFAICT, that's exactly what a LVM cache LV is, so I would
expect that they would handle such events in exactly the same way.

> When someone pick drive to other system - what is going to happen ?

If the system already has zodcache support then things should pretty
much "just work".  If not, it takes exactly one program to manually
start a device, and the only dependencies are dm-cache and libdevmapper.

> Are you going to write your own 'lvm2-like' tools to do the job ?

Absolutely not.  This is not intended to compete with LVM.  In fact, I
would expect that using zodcache devices as LVM PVs to be the most
use case.  (It's certainly what I'm doing.)

> Are you going to maintain this over long time period ?

If people use it, then yes.

> You really should have started from RFE on lvm2 enhancements to better
> suite
> your needs -  since IMHO there are no SIMPLE things when we talk about
> devices...

But isn't that the beauty of device mapper?  The hard work has already
been done, and I'm just adding the bits to set things up.  (I'm not
doing anything that couldn't be done with dmsetup.)

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
-------- "I grew up before Mark Zuckerberg invented friendship" --------
========================================================================
