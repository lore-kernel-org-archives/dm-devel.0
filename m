From: Achim Warnecke <achim.warnecke@de.ibm.com>
Subject: DM-Multipather with initialization probem ?
Date: Mon, 28 Jan 2008 15:53:54 +0100
Message-ID: <OF8A591D76.E8A19332-ONC12573DE.005111F7-C12573DE.0051D727@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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



After setup of 40 vdisks, zoning of two switches, etc. and starting I/O I
did a goodpath-test with Redhat 5.1.
Everything worked fine. During running the failover test's the
dm-multipather didn't handle to re-establish
all paths correctly.

I tried running multipathd with "-v4" option for verbose logging. And
changed the
line "daemon $DAEMON" with "daemon $DAEMON -v4" in /etc/init.d/multipathd
file
and restarted the daemon by running "/etc/init.d/multipathd restart" again.

After that the failover worked fine, with and without the -v4 option.
In my setup this behavior is reproducible.
Could there be a connection with specifically starting the multipathd ?

--------before teststart--------
QL_0 (36005076801b080fb7000000000000dac) dm-16 IBM,2145
[size=500M][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=100][active]
 \_ 5:0:1:0  sdbu 68:128 [active][ready]
 \_ 4:0:0:0  sdci 69:96  [active][ready]
\_ round-robin 0 [prio=20][enabled]
 \_ 5:0:0:0  sdbg 67:160 [active][ready]
 \_ 4:0:1:0  sdcw 70:64  [active][ready]
QL_10 (36005076801b080fb7000000000000db5) dm-26 IBM,2145
[size=2.0G][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=100][active]
 \_ 5:0:0:10 sdbq 68:64  [active][ready]
 \_ 4:0:1:10 sddg 70:224 [active][ready]
\_ round-robin 0 [prio=20][enabled]
 \_ 5:0:1:10 sdce 69:32  [active][ready]
 \_ 4:0:0:10 sdcs 70:0   [active][ready]
[root@x455-tic-1 ~]#

Kind regards, Achim
