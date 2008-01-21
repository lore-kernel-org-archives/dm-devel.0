From: "Michael Di Domenico" <mdidomenico@gmail.com>
Subject: multiple paths question
Date: Mon, 21 Jan 2008 12:45:17 -0500
Message-ID: <97a7c7ed0801210945r46b1c363h11fcf3b92212f175@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

I'm a little confused over how multipathing works.  I've got a host
with a 2port HBA and a 4port Storage unit.  My multipath setup seems
to create 8 LUNS and then splitting them up into two groups.  This is
a single disk.  How do i get it to show me a single target instead of
dm-0 and dm-1?

[root@node1 ~]$ multipath -ll
mpath2 (HITACHI_DF500_B_) dm-0 HITACHI ,DF500
[size=1.0G][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 3:0:3:0 sdi 8:128 [active][ready]
 \_ 3:0:2:0 sdh 8:112 [active][ready]
 \_ 2:0:3:0 sde 8:64  [active][ready]
 \_ 2:0:2:0 sdd 8:48  [active][ready]
mpath3 (HITACHI_DF500_A_) dm-1 HITACHI ,DF500
[size=1.0G][features=1 queue_if_no_path][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 3:0:1:0 sdg 8:96  [active][ready]
 \_ 3:0:0:0 sdf 8:80  [active][ready]
 \_ 2:0:1:0 sdc 8:32  [active][ready]
 \_ 2:0:0:0 sdb 8:16  [active][ready]
