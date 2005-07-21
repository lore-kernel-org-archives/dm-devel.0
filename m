From: Philipp Niemann <niemann@dimdi.de>
Subject: Multipathing hints request
Date: Thu, 21 Jul 2005 16:31:12 +0200
Message-ID: <20050721143110.GD4240@pan.dimdi.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hello list, nice to meet you.

As I am new to the list I am not quite shure if the topic is correct,
but...

Around here I have two EMC Clariion 4500 Storage Arrays, two Brocade Silkworms
each building a fabric, and two QLogic 2340 HBA in my PC. For now I am
using debian stable (sarge) with a vanilla kernel-2.6.12.3 compiled with
all I can get from the md/devmapper part of config.

I want the OS to use the two HBAs for path failover. The Clariion is an
activce/passive device.

I use the multipath-tools written by Christophe Varoqui and others,
version 0.4.2.4-2 as packaged with debian. There is a more up to date
one on the project homepage but I haved bothered yet.

Is this the right list to ask for help/suggestions? What details would
you like to have then? If not the right list, where to post?

More details:

HBA1 is connected to Clariion1_SPA and Clariion2_SPA via fabric1
HBA2 is connected to Clariion1_SPB and Clariion2_SPB via fabric2

I have the devices in /proc/partitions (total of 5 LUNs configured, each
with 2 path makes 10 devices in /proc/partitions)

I have multipath configured like this:

# multipath -lv2 # should be group-by-node-name policy
3600601602001f1a665653dbe010465c5
[size=22 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled][first]
  \_ 6:0:0:0 sda  8:0     [ready ][active]
  \_ 7:0:1:0 sdh  8:112   [faulty][active]

360060160200161a037f90d75dfca84f7
[size=20 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active][first]
  \_ 6:0:1:1 sde  8:64    [faulty][active]
  \_ 7:0:0:1 sdg  8:96    [ready ][active]

3600601602001f1a600a524d18275c0b2
[size=20 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled][first]
  \_ 6:0:0:1 sdb  8:16    [ready ][active]
  \_ 7:0:1:1 sdi  8:128   [faulty][active]

3600601602001f1a6e0c6fdbae081bd89
[size=20 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled][first]
  \_ 6:0:0:2 sdc  8:32    [faulty][active]
  \_ 7:0:1:2 sdj  8:144   [ready ][active]

360060160200161a06215f38ffbb2d6e9
[size=20 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled][first]
  \_ 6:0:1:0 sdd  8:48    [faulty][active]
  \_ 7:0:0:0 sdf  8:80    [ready ][active]


I think this doesn't look too bad. Ready/Faulty match the default owner for the
LUN on the Clariion. I am able to create a filesystem say on
360060160200161a037f90d75dfca84f7, which might appear as dm-4 in /proc/partitions

    BTW: Anyone to know what "hwhandler" tells me? Can I change it? Same for
        "features".
    BTW2: I'd prefer to use "emc" instead of "round-robin". How?
        I concluded something like that might be possible as dm-round-robin
            and dm-emc exist

I am able to mount that filesystem and to create files on it. I prefer doing something
like dd if=/dev/zero of=/mnt/test bs=1024 count=$((1024*1024*19)). That way I have
plenty of time to do some failover tests.

My problem (finally): If I pull the cable establishing the path to sdg, I get
almost immediate hard IO errors, corrupting the filesystem. The devmapper
won't switch to the second path, though it recognizes the failing
disk sdg and disables the path 8:96. How do I do that properly?

Thanks for ideas,
Philipp Niemann

BTW3: Anyone with a hint how to do this with a non-customized RHES 4.0 or 3.0?
No multipath-tools there :(
-- 
Philipp Niemann                                       DIMDI
Abteilung D / AG D4
Peripherie / UNIX-Systembetreuer     Waisenhausgasse 36-38a
Tel. : 0221/4724-281                            50676 Koeln
