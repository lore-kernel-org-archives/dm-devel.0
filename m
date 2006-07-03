From: Kevin Taylor <ktaylor.dmmp@placemark.com>
Subject: IBM (Adaptec) DS400 SAN support - sponsorship
Date: Mon, 03 Jul 2006 10:18:48 -0500
Message-ID: <1151939929.3663.41.camel@wolfhound.placemark.pmi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hello devs,

I'm hoping that I can find the right person to help me on this list, as
it seems this list is, by far, the greatest collection of people with
expertise regarding dm-multipath.

My desire:

To locate a person who can write a hardware handler for the DS400 that
will allow proper active/passive fail-over/fail-back, which we would be
happy to sponsor financially (for contribution back to the project, of
course).

My situation:

Our company has an existing IBM DS400 SAN that we are trying to deploy
as part of a Oracle RAC project.  In doing testing and analysis of the
device and proper configuration of it for this purpose, I have learned
that in a two controller configuration, this device is active/passive,
and that in dm-multipath this results in the following configuration
profile (from "multipath -ll" with all controllers connected):

---------------------------------------------

ora_admin (20000d126733eaf14)
[size=10 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:3 sde 8:64  [active][faulty]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:1:3 sdk 8:160 [active][ready]

20000d126733eaf17
[size=10 MB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:0 sdb 8:16  [active][faulty]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:1:0 sdh 8:112 [active][ready]

ora_data1 (20000d126733eaf10)
[size=200 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:5 sdg 8:96  [active][faulty]
\_ round-robin 0 [prio=1][enabled]
 \_ 1:0:1:5 sdm 8:192 [active][ready]

ora_archive (20000d126733eaf15)
[size=50 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:4 sdf 8:80  [active][faulty]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:1:4 sdl 8:176 [active][ready]

ora_redo2 (20000d126733eaf0b)
[size=68 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:0:2 sdd 8:48  [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:0:1:2 sdj 8:144 [active][faulty]

ora_redo1 (20000d126733eaf0a)
[size=68 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:0:1 sdc 8:32  [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:0:1:1 sdi 8:128 [active][faulty]

---------------------------------------------

And when controller 1 is unplugged, the configuration does the
following:

ora_admin (20000d126733eaf14)
[size=10 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:3 sde 8:64  [active][faulty]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:1:3 sdk 8:160 [active][ready]

20000d126733eaf17
[size=10 MB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:0 sdb 8:16  [active][faulty]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:1:0 sdh 8:112 [active][ready]

ora_data1 (20000d126733eaf10)
[size=200 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:5 sdg 8:96  [failed][faulty]
\_ round-robin 0 [prio=1][enabled]
 \_ 1:0:1:5 sdm 8:192 [active][ready]

ora_archive (20000d126733eaf15)
[size=50 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:4 sdf 8:80  [failed][faulty]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:1:4 sdl 8:176 [active][ready]

ora_redo2 (20000d126733eaf0b)
[size=68 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 1:0:0:2 sdd 8:48  [failed][faulty]
\_ round-robin 0 [enabled]
 \_ 1:0:1:2 sdj 8:144 [active][faulty]

ora_redo1 (20000d126733eaf0a)
[size=68 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:1 sdc 8:32  [failed][faulty]
\_ round-robin 0 [enabled]
 \_ 1:0:1:1 sdi 8:128 [failed][faulty]

--------------------------------------------------

And when controller 2 is unplugged, the configuration does the
following:

ora_admin (20000d126733eaf14)
[size=10 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:3 sde 8:64  [active][faulty]
\_ round-robin 0 [active]
 \_ 1:0:1:3 sdk 8:160 [failed][faulty]

20000d126733eaf17
[size=10 MB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:0 sdb 8:16  [active][faulty]
\_ round-robin 0 [active]
 \_ 1:0:1:0 sdh 8:112 [failed][faulty]

ora_data1 (20000d126733eaf10)
[size=200 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:5 sdg 8:96  [active][faulty]
\_ round-robin 0 [enabled]
 \_ 1:0:1:5 sdm 8:192 [active][faulty]

ora_archive (20000d126733eaf15)
[size=50 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:4 sdf 8:80  [active][faulty]
\_ round-robin 0 [active]
 \_ 1:0:1:4 sdl 8:176 [failed][faulty]

ora_redo2 (20000d126733eaf0b)
[size=68 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:0:2 sdd 8:48  [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:0:1:2 sdj 8:144 [active][faulty]

ora_redo1 (20000d126733eaf0a)
[size=68 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=1][active]
 \_ 1:0:0:1 sdc 8:32  [active][ready]
\_ round-robin 0 [enabled]
 \_ 1:0:1:1 sdi 8:128 [failed][faulty]

--------------------------------------------------

I believe that without a proper hardware handler to instruct the DS400
to activate the passive controller and shift all LUNS in a timely
fashion, that this storage unit will not be able to be used in a
multipath manner for controller failover.  Of course, it's quite
possible that I am wrong, and there may be another way to make this
active/passive configuration work without a hardware handler, and I'd be
very happy to hear about any alternatives anyone may suggest.

Would anyone here be willing to talk with me about our sponsorship of
expanding the supported hardware list for dm-multipath to include this
device?  Does anyone know a person not already on this list who might be
a good possibility as a developer for such a project?

Thanks for you time in reviewing my post, and would appreciate any
ideas, device, or direction any of you can provide.

Sincerely,

Kevin Taylor
