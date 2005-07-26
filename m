From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: mptools output
Date: Tue, 26 Jul 2005 16:29:24 +0200
Message-ID: <20050726142924.GA23052@averon.dyndns.org>
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

Hello,

I'd like to receive comments on this proposed tools output :

From this :

iet_lun1 (0IET_____ISCSI___________00000000d20600000b00000000000000)
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [disabled]
  \_ 1:0:0:2  sdc 8:32  [ready ][failed]
  \_ 2:0:0:2  sde 8:64  [ready ][active]
  \_ 24:0:0:2 sdg 8:96  [ready ][active]
  \_ 25:0:0:2 sdi 8:128 [ready ][active]

To that :

iet_lun1 (0IET_____ISCSI___________00000000d20600000b00000000000000)
[size=33 GB][features="0"][hwhandler="0"]
\_ round-robin 0        D
  \_ 1:0:0:2  sdc 8:32  FA.
  \_ 2:0:0:2  sde 8:64  AA.
  \_ 24:0:0:2 sdg 8:96  AA.
  \_ 25:0:0:2 sdi 8:128 AA.

PG status bit :
A(ctive), D(isabled) or E(nabled)

Path status bits :
1 = path state as seen by the kernel device mapper
    F(ailed) or A(ctive)
2 = path state as seen by checkers
    F(ailed), A(ctive), G(host), S(haky) or .(unchecked)
3 = claimed
    C(laimed) or .(unclaimed)

I find it easier to eye-parse that way, but maybe others don't agree.

Waiting for comments (not too long),
regards,
cvaroqui
