From: Tore Anderson <tore@linpro.no>
Subject: Re: Round Robin vs Active/Passive
Date: Wed, 21 May 2008 20:23:41 +0200
Message-ID: <483468AD.7@linpro.no>
References: <8a6b34b03e0524aa66c862534fee9b7a@www3.mail.volny.cz><18484.2693.62883.535755@notabene.brown>	<ABFD05FF09D13E4883B757E75603624D011E95B6@ex-sea1.vistocorp.com>
	<ABFD05FF09D13E4883B757E75603624D011E95BB@ex-sea1.vistocorp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ABFD05FF09D13E4883B757E75603624D011E95BB@ex-sea1.vistocorp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Michael Denney <mdenney@visto.com>
List-Id: dm-devel.ids

* Craig Simpson
> 
> My Hitachi AMS200 is an Active/Passive array says Hitachi. 
> By looking at asm13 I see all my paths active. Did use the
> "path_grouping_policy    multibus" when creating that alias. 

The AMS200 is indeed an active/passive array, but it's "fakes"
active/active behaviour - if the passive controller receives an I/O
operation it will redirect it internally to the active one which will
process it and return it back to the passive controller, which in turn
returns it back to the initiator, which have no idea that this happens
at all.

So you can use it as a true active/active array, but I'd recommend
against it for two reasons;  first, there might be a slight processing
overhead to route I/O through the passive controller (as well as a
slight increase in latency), second, you might risk saturating the
interconnect between the controllers with re-routed I/O if you have lots
of volumes using the array in this way (this might or might not be a
real problem depending on how the hardware is built).

So what you should do is to distinguish between paths to the active
controller and run round-robin on all of these, while having fail-over
to the set of paths to the passive controller.  An example on how this
looks:

mysql (36006016034301f0004582492ab21dd11)
[size=40 GB][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=2][active]
 \_ 4:0:2:0 sds 65:32 [active][ready]
 \_ 3:0:2:0 sdu 65:64 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 4:0:3:0 sdr 65:16 [active][ready]
 \_ 3:0:3:0 sdt 65:48 [active][ready]

I/O is here balanced between sds and sdu, which have the highest
priority.  sdr and sdt will only be used should both sds and sdu fail.
This is accomplished by the following two configuration settings:

path_grouping_policy group_by_prio
prio_callout "/sbin/mpath_prio_emc_silent /dev/%n"

(This is an EMC array.)

You should be able to do the same using mpath_prio_hdc_modular as the
prio_callout.  Last I checked this callout wasn't actually able to
determine which controller is the preferred for a given volume (one of
the reasons I bought an EMC instead), but did a simplistic check which
was something along the lines of "controller 0 is preferred for all
volumes with an even LUN;  controller 1 for all volumes with an odd
LUN".  So even though this probably won't match reality unless you take
care to configure the AMS accordingly, you will get the desired effect -
round robin between the paths to one controller, failover to the paths
to the other.  The AMS is also clever enough to understand that if
you're only sending I/O to the passive controller it will automatically
change the ownership of the volume to the controller actually receiving
I/O, so you won't have the problem of I/O being re-routed between
controllers.

The downside is that you can't decide which controller is the preferred
one for a given volume, so if you have two highly active volumes with
odd LUNs and two mostly idle one with even LUNs you won't be able to
split the load equally between the controllers.

Regards,
-- 
Tore Anderson
