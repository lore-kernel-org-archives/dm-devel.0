From: syrius.ml@no-log.org
Subject: multipath and iscsi nullio/dm-zero tests
Date: Tue, 04 Mar 2008 00:32:01 +0100
Message-ID: <87ablfjsem.878x0zjsem@877igjjsem.message.id>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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


Hi,

I've setup a nullio iscsi target on a server. (and also a dm-zero
deviced exported as an iscsi target)

This server has 3 network cards. Each card has an ip in it's own
subnet.

I'm using a linux client. It also has 3 network cards and they are
setup in the same subnets.
The client opens 3 sessions to the iscsi target. Each session using
its own network card. (verified)

Both quad core intel cpu servers are running Debian/Etch
amd64. (linux 2.6.22, iscsitarget 0.4.15, multipath 0.4.7)

I'm using a simple multibus multipath setup.
multipath -ll gives:
test (1000000000000000000000000000000000000000000000000) dm-8
IET,VIRTUAL-DISK
[size=466T][features=0][hwhandler=0]
\_ round-robin 0 [prio=6][active]
 \_ 9:0:0:0  sdd 8:48  [active][ready]
 \_ 10:0:0:0 sde 8:64  [active][ready]
 \_ 11:0:0:0 sdf 8:80  [active][ready]

I've been doing simple checks with dd and I'm surprised by the
results.

dd if=/dev/zero of=/dev/dm-8 bs=4k count=10M
10485760+0 records in
10485760+0 records out
42949672960 bytes (43 GB) copied, 137.751 seconds, 312 MB/s

dd of=/dev/null if=/dev/dm-8 bs=4k count=10M
10485760+0 records in
10485760+0 records out
42949672960 bytes (43 GB) copied, 364.401 seconds, 118 MB/s

How is it 3 times slower when reading from the multipath device ?

Watching the network load, i can see the traffic is span to the 3
network cards.

and FYI:
dd of=/dev/null if=/dev/sdd bs=4k count=2M & dd of=/dev/null
if=/dev/sde bs=4k count=2M & dd of=/dev/null if=/dev/sdf bs=4k
count=2M &
gives:
8589934592 bytes (8.6 GB) copied, 87.7679 seconds, 97.9 MB/s
8589934592 bytes (8.6 GB) copied, 87.877 seconds, 97.7 MB/s
8589934592 bytes (8.6 GB) copied, 101.354 seconds, 84.8 MB/s

I first discovered this behavior with a real fileio target and I
thought it would be better to narrow things down.

I'm pretty sure I must be doing something wrong.
In the hope this is not off-topic, could you give me some hints ?

Cheers

-- 
