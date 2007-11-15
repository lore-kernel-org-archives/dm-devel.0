From: Tore Anderson <tore@linpro.no>
Subject: Re: device-errors and multipath device access issue
Date: Thu, 15 Nov 2007 18:15:41 +0100
Message-ID: <473C7EBD.8010305@linpro.no>
References: <2085496865@web.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2085496865@web.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: devzero@web.de
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

* Tore Anderson

> Maybe it has a way of being configured in a fake active/active
> configuration where I/O can be processed on both controllers at the
> same time.  I believe newer EMC CLARiiON and HP EVA can be set up in
> ALUA mode which does the trick. HDS AMS does something similar which
> work mostly the same way.

* devzero@web.de

> yes - but i don`t think the admin wants to touch such essential
> configuration to get rid of error messages in the kernel-log....

Today I played around with a CX500 in EMC's lab (I'm considering buying 
another CLARiiON), and I got to test the ALUA mode quite a bit.  It 
works very well, and I'd recommend you to pester your admin to get it.

Basically what it does is that if I/O is received on the passive 
controller, it's just redirected to the active controller on an internal 
interconnect (and the replies are routed the same way back out again). 
So it looks and feels just like a true active/active setup, you'll not 
get I/O errors on any of the paths.  Supposedly there is a slight 
increase in latency on I/O that pass through the passive controller, but 
that was not noticeable in my simple benchmarks using multibus topology.

The system was dedicated to my tests, though, so I'm not promising it's 
okay to be using multibus in production on a busy system.  A better way 
to set it up is to be using mpath_prio_emc and group_by_prio like 
before, but with no hardware handler.  If dm-multipath decides to change 
priority groups the I/O will simply pass through the passive controller 
for some minutes until the CX realises that most of the I/O is going in 
the wrong way, and trespasses the volume automatically.  Small bursts of 
stray I/O to the passive controller (like those your proprietary 
application causes) will be processed fine (with the very slight latency 
increase), but it won't affect the production I/O going through 
dm-multipath straight to the active controller.  It's really nice for 
use with dm-multipath - and it'll solve all of your problems.

There's an ALUA hardware handler in the making too - I assume it will 
make it possible for dm-multipath to explicitly trespass the volume on 
PG change (instead of relying on the CX to automatically move the LUN). 
  In my opinion, though, that's not needed for a production quality 
setup with ALUA on the CLARiiON (maybe it's mostly inteded for other 
ALUA-capable arrays that might not have the auto-trespass feature).

ALUA mode is configured on a per-host basis (set it to failover mode 4, 
CLARiiON Open), so your admin shouldn't worry about changing it. 
However it is a very recently added feature (you'll need FLARE 26), so 
you might have to persuade him to invite EMC over for an upgrade session.

Regards
-- 
Tore Anderson
