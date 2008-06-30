From: "Craig Simpson" <csimpson@visto.com>
Subject: Way to get IO stats on multipath alias?
Date: Mon, 30 Jun 2008 13:39:30 -0700
Message-ID: <ABFD05FF09D13E4883B757E75603624D013FAC27@ex-sea1.vistocorp.com>
References: <20080624225348.16387.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20080624225348.16387.qmail@sourceware.org>
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
List-Id: dm-devel.ids



OK so I make my alias in /etc/multipath.conf
        multipath {
                wwid                    1HITACHI_750140820017
                alias                   asm13
        }


And as expected all 4 paths are there and happy in Hitachi's
active/passive world

asm13 (1HITACHI_750140820017) dm-44 HITACHI,DF600F
[size=3D32G][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D2][active]
 \_ 1:0:0:17 sdbb 67:80   [active][ready]
 \_ 0:0:0:17 sdr  65:16   [active][ready]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:1:17 sdcq 69:224  [active][ready]
 \_ 1:0:1:17 sded 128:80  [active][ready]

Now I can do a iostat -x and get the stats for sdbb, sdr, dscq, and
sded.=20

But is there a way to collect statistics on asm13?=20

Really need to know how it is doing on that level. Ya I can get info on
dm-44, but that changes across reboots, and could be different on
different nodes on the cluster....=20

Help!!!!

Craig
