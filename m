From: "Claudio Tassini" <claudio.tassini@gmail.com>
Subject: multipath.conf don't being read
Date: Sun, 26 Nov 2006 22:18:19 +0100
Message-ID: <39fdf1c70611261318t2f7aba20j4f319d4793cfd87d@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0726096404=="
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

--===============0726096404==
Content-Type: multipart/alternative;
	boundary="----=_Part_45029_15452786.1164575899728"

------=_Part_45029_15452786.1164575899728
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all

I'm trying to understand how dm works on a RHEL 4u4, ( and RHCS and GFS
too). I have two QLC HBAs connected to a Sun Storage 3510 via a couple of
SANBOX2 switches. Initially I uncommented all the entries in the
configuration file to make some test and I manage to discover the three luns
which where recognized correctly whit their path:

[root@store1 ~]# multipath -ll
3600c0ff00000000009897a30ae0b0401
[size=369 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=2][active]
 \_ 1:0:1:1 sde 8:64  [active][ready]
 \_ 2:0:1:1 sdh 8:112 [active][ready]

3600c0ff00000000009897a30ae0b0400
[size=40 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=2][active]
 \_ 1:0:1:0 sdd 8:48  [active][ready]
 \_ 2:0:1:0 sdg 8:96  [active][ready]

3600c0ff00000000009897a5a29e3f800
[size=1091 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=2][active]
 \_ 1:0:0:0 sdc 8:32  [active][ready]
 \_ 2:0:0:0 sdf 8:80  [active][ready]

Now, the problem is:
1) the default configuration should provide a failover policy, but it seems
that it is actually using an active-active one
2) Any change I make to /etc/multipath.conf , the output of multipath -ll
remains the same. Also tried to flush and reload, restart the daemon etc..
Always the same.
3) If even I REMOVE the configuration file and reboot the server, it keeps
discovering the same paths! :

[root@store1 ~]# ls /etc/multipath.conf
ls: /etc/multipath.conf: No such file or directory
[root@store1 ~]# multipath -ll
3600c0ff00000000009897a30ae0b0401
[size=369 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=2][active]
 \_ 1:0:1:1 sde 8:64  [active][ready]
 \_ 2:0:1:1 sdh 8:112 [active][ready]

3600c0ff00000000009897a30ae0b0400
[size=40 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=2][active]
 \_ 1:0:1:0 sdd 8:48  [active][ready]
 \_ 2:0:1:0 sdg 8:96  [active][ready]

3600c0ff00000000009897a5a29e3f800
[size=1091 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=2][active]
 \_ 1:0:0:0 sdc 8:32  [active][ready]
 \_ 2:0:0:0 sdf 8:80  [active][ready]
[root@store1 ~]# multipath -v2 -F
[root@store1 ~]#
[root@store1 ~]# multipath -ll
[root@store1 ~]#
[root@store1 ~]# /etc/init.d/multipathd restart
Stopping multipathd daemon:                                [  OK  ]
Starting multipathd daemon:                                [  OK  ]
[root@store1 ~]#
[root@store1 ~]# multipath -v2 -ll
[root@store1 ~]# multipath -v2 -d
create: SSEAGATE_ST973401LSUN72G0210CB0H____________3LB0CB0H
[size=68 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=1]
 \_ 0:0:0:0 sda 8:0   [ready]

create: SSEAGATE_ST973401LSUN72G0210BTPF____________3LB0BTPF
[size=68 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=1]
 \_ 0:0:1:0 sdb 8:16  [ready]

create: 3600c0ff00000000009897a5a29e3f800
[size=1091 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=2]
 \_ 1:0:0:0 sdc 8:32  [ready]
 \_ 2:0:0:0 sdf 8:80  [ready]

create: 3600c0ff00000000009897a30ae0b0400
[size=40 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=2]
 \_ 1:0:1:0 sdd 8:48  [ready]
 \_ 2:0:1:0 sdg 8:96  [ready]

create: 3600c0ff00000000009897a30ae0b0401
[size=369 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=2]
 \_ 1:0:1:1 sde 8:64  [ready]
 \_ 2:0:1:1 sdh 8:112 [ready]
[root@store1 ~]# multipath -v2 -ll
[root@store1 ~]# multipath -v2
create: 3600c0ff00000000009897a5a29e3f800
[size=1091 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=2]
 \_ 1:0:0:0 sdc 8:32  [ready]
 \_ 2:0:0:0 sdf 8:80  [ready]

create: 3600c0ff00000000009897a30ae0b0400
[size=40 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=2]
 \_ 1:0:1:0 sdd 8:48  [ready]
 \_ 2:0:1:0 sdg 8:96  [ready]

create: 3600c0ff00000000009897a30ae0b0401
[size=369 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=2]
 \_ 1:0:1:1 sde 8:64  [ready]
 \_ 2:0:1:1 sdh 8:112 [ready]

[root@store1 ~]# multipath -v2 -ll
3600c0ff00000000009897a30ae0b0401
[size=369 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=2][active]
 \_ 1:0:1:1 sde 8:64  [active][ready]
 \_ 2:0:1:1 sdh 8:112 [active][ready]

3600c0ff00000000009897a30ae0b0400
[size=40 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=2][active]
 \_ 1:0:1:0 sdd 8:48  [active][ready]
 \_ 2:0:1:0 sdg 8:96  [active][ready]

3600c0ff00000000009897a5a29e3f800
[size=1091 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [prio=2][active]
 \_ 1:0:0:0 sdc 8:32  [active][ready]
 \_ 2:0:0:0 sdf 8:80  [active][ready]

[root@store1 ~]#


How is it possible??

Thanks in advance


-- 
Claudio Tassini

------=_Part_45029_15452786.1164575899728
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all<br><br>I'm trying to understand how dm works on a RHEL 4u4, (
and RHCS and GFS too). I have two QLC HBAs connected to a Sun Storage
3510 via a couple of SANBOX2 switches. Initially I uncommented all the
entries in the configuration file to make some test and I manage to
discover the three luns which where recognized correctly whit their
path:
<br><br clear="all">[root@store1 ~]# multipath -ll<br>3600c0ff00000000009897a30ae0b04<div id="mb_0">01<br>[size=369 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>\_ round-robin 0 [prio=2][active]<br>&nbsp;\_ 1:0:1:1 sde 8:64&nbsp; [active][ready]
<br>&nbsp;\_ 2:0:1:1 sdh 8:112 [active][ready]<br><br>3600c0ff00000000009897a30ae0b0400<br>[size=40 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>\_ round-robin 0 [prio=2][active]<br>&nbsp;\_ 1:0:1:0 sdd 8:48&nbsp; [active][ready]
<br>&nbsp;\_ 2:0:1:0 sdg 8:96&nbsp; [active][ready]<br><br>3600c0ff00000000009897a5a29e3f800<br>[size=1091 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>\_ round-robin 0 [prio=2][active]<br>&nbsp;\_ 1:0:0:0 sdc 8:32&nbsp; [active][ready]
<br>&nbsp;\_ 2:0:0:0 sdf 8:80&nbsp; [active][ready]<br><br>Now, the problem is:<br>1) the default configuration should provide a failover policy, but it seems that it is actually using an active-active one<br>2)
Any change I make to /etc/multipath.conf , the output of multipath -ll
remains the same. Also tried to flush and reload, restart the daemon
etc.. Always the same.
<br>3) If even I REMOVE the configuration file and reboot the server, it keeps discovering the same paths! :<br><br>[root@store1 ~]# ls /etc/multipath.conf<br>ls: /etc/multipath.conf: No such file or directory<br>[root@store1

 ~]# multipath -ll<br>3600c0ff00000000009897a30ae0b0401<br>[size=369 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>\_ round-robin 0 [prio=2][active]<br>&nbsp;\_ 1:0:1:1 sde 8:64&nbsp; [active][ready]<br>&nbsp;\_ 2:0:1:1 sdh 8:112 [active][ready]
<br><br>3600c0ff00000000009897a30ae0b0400<br>[size=40 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>\_ round-robin 0 [prio=2][active]<br>&nbsp;\_ 1:0:1:0 sdd 8:48&nbsp; [active][ready]<br>&nbsp;\_ 2:0:1:0 sdg 8:96&nbsp; [active][ready]
<br><br>3600c0ff00000000009897a5a29e3f800<br>[size=1091 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>\_ round-robin 0 [prio=2][active]<br>&nbsp;\_ 1:0:0:0 sdc 8:32&nbsp; [active][ready]<br>&nbsp;\_ 2:0:0:0 sdf 8:80&nbsp; [active][ready]
<br>[root@store1 ~]# multipath -v2 -F<br>[root@store1 ~]#<br>[root@store1 ~]# multipath -ll<br>[root@store1 ~]#<br>[root@store1 ~]# /etc/init.d/multipathd restart<br>Stopping multipathd daemon:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [&nbsp; OK&nbsp; ]
<br>Starting multipathd daemon:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [&nbsp; OK&nbsp; ]<br>[root@store1 ~]#<br>[root@store1 ~]# multipath -v2 -ll<br>[root@store1 ~]# multipath -v2 -d<br>create: SSEAGATE_ST973401LSUN72G0210CB0H____________3LB0CB0H
<br>[size=68 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>\_ round-robin 0 [prio=1]<br>&nbsp;\_ 0:0:0:0 sda 8:0&nbsp;&nbsp; [ready]<br><br>create: SSEAGATE_ST973401LSUN72G0210BTPF____________3LB0BTPF<br>[size=68 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]
<br>\_ round-robin 0 [prio=1]<br>&nbsp;\_ 0:0:1:0 sdb 8:16&nbsp; [ready]<br><br>create: 3600c0ff00000000009897a5a29e3f800<br>[size=1091 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>\_ round-robin 0 [prio=2]<br>&nbsp;\_ 1:0:0:0 sdc 8:32&nbsp; [ready]
<br>&nbsp;\_ 2:0:0:0 sdf 8:80&nbsp; [ready]<br><br>create: 3600c0ff00000000009897a30ae0b0400<br>[size=40 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>\_ round-robin 0 [prio=2]<br>&nbsp;\_ 1:0:1:0 sdd 8:48&nbsp; [ready]<br>&nbsp;\_ 2:0:1:0 sdg 8:96&nbsp; [ready]
<br><br>create: 3600c0ff00000000009897a30ae0b0401<br>[size=369 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>\_ round-robin 0 [prio=2]<br>&nbsp;\_ 1:0:1:1 sde 8:64&nbsp; [ready]<br>&nbsp;\_ 2:0:1:1 sdh 8:112 [ready]<br>[root@store1

 ~]# multipath -v2 -ll<br>[root@store1 ~]# multipath -v2<br>create: 3600c0ff00000000009897a5a29e3f800<br>[size=1091 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>\_ round-robin 0 [prio=2]<br>&nbsp;\_ 1:0:0:0 sdc 8:32&nbsp; [ready]
<br>&nbsp;\_ 2:0:0:0 sdf 8:80&nbsp; [ready]<br><br>create: 3600c0ff00000000009897a30ae0b0400<br>[size=40 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>\_ round-robin 0 [prio=2]<br>&nbsp;\_ 1:0:1:0 sdd 8:48&nbsp; [ready]<br>&nbsp;\_ 2:0:1:0 sdg 8:96&nbsp; [ready]
<br><br>create: 3600c0ff00000000009897a30ae0b0401<br>[size=369 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>\_ round-robin 0 [prio=2]<br>&nbsp;\_ 1:0:1:1 sde 8:64&nbsp; [ready]<br>&nbsp;\_ 2:0:1:1 sdh 8:112 [ready]<br><br>[root@store1

 ~]# multipath -v2 -ll<br>3600c0ff00000000009897a30ae0b0401<br>[size=369 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>\_ round-robin 0 [prio=2][active]<br>&nbsp;\_ 1:0:1:1 sde 8:64&nbsp; [active][ready]<br>&nbsp;\_ 2:0:1:1 sdh 8:112 [active][ready]
<br><br>3600c0ff00000000009897a30ae0b0400<br>[size=40 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>\_ round-robin 0 [prio=2][active]<br>&nbsp;\_ 1:0:1:0 sdd 8:48&nbsp; [active][ready]<br>&nbsp;\_ 2:0:1:0 sdg 8:96&nbsp; [active][ready]
<br><br>3600c0ff00000000009897a5a29e3f800<br>[size=1091 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>\_ round-robin 0 [prio=2][active]<br>&nbsp;\_ 1:0:0:0 sdc 8:32&nbsp; [active][ready]<br>&nbsp;\_ 2:0:0:0 sdf 8:80&nbsp; [active][ready]
<br><br>[root@store1 ~]#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br><br><br>How is it possible??<br><br>Thanks in advance</div><br clear="all"><br>-- <br>Claudio Tassini

------=_Part_45029_15452786.1164575899728--


--===============0726096404==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0726096404==--
