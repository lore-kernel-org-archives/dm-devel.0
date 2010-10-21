From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: failure in path between fc switch and storage: info
	request
Date: Thu, 21 Oct 2010 12:01:42 +0200
Message-ID: <AANLkTi=qhhKmUWKb-cbcnJfAF6dbHE+iRaNDfXmdyW4k@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hello,
I have some servers connected with two qlogic hba to two different fc switches.
Each fc switch is then connected to the two controllers of the storage
array (IBM DS6800), one port for each controller.
So my servers have 4 paths to a LUN.
They are RH EL 5.5 x86_64 with slghtly different minor versions of dm
(see below)

I had a problem with the gbic of one of the fc switches, connected to
the controller od the storage array.
So in this case the servers lose a path.
After gbic replacement, I register different behaviours.


1)  cluster of two servers that both have access to the storage
The same disk is seen in different mode by the two servers.
servera
mpath3 (3600507630efe0b0c0000000000000804) dm-5 IBM,1750500
[size=1.0G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
 \_ 1:0:1:8 sdaf 65:240 [active][undef]
 \_ 0:0:1:8 sdp  8:240  [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 0:0:0:8 sdh  8:112  [active][undef]
 \_ 1:0:0:8 sdx  65:112 [active][undef]

serverb
mpath3 (3600507630efe0b0c0000000000000804) dm-5 IBM,1750500
[size=1.0G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
 \_ 0:0:1:8 sdp  8:240  [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 0:0:0:8 sdh  8:112  [active][undef]
 \_ 1:0:0:8 sdx  65:112 [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:1:8 sdaf 65:240 [active][undef]

Here I have:
device-mapper-1.02.39-1.el5_5.2
device-mapper-event-1.02.39-1.el5_5.2
device-mapper-1.02.39-1.el5_5.2
device-mapper-multipath-0.4.7-34.el5_5.5

2) Standalone system with unique access to the luns
mpath22 (3600507630efe0b0c0000000000000400) dm-14 IBM,1750500
[size=60G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
 \_ 0:0:1:7  sdag 66:0   [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 0:0:0:7  sdac 65:192 [active][undef]
 \_ 1:0:0:7  sdak 66:64  [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:1:7  sdao 66:128 [active][undef]

Here I have:
device-mapper-1.02.39-1.el5_5.2
device-mapper-1.02.39-1.el5_5.2
device-mapper-event-1.02.39-1.el5_5.2
device-mapper-multipath-0.4.7-34.el5_5.6

3) another cluster of two servers. One of them  seems to have ok
conditions for some LUNS and for others it continues to register
failed
servera
mpath22 (3600507630efe0b0c0000000000000606) dm-17 IBM,1750500
[size=120G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
 \_ 2:0:3:11 sdbb 67:80  [active][undef]
 \_ 1:0:3:11 sdbo 68:32  [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:2:11 sdo  8:224  [active][undef]
 \_ 2:0:2:11 sdz  65:144 [active][undef]
...
mpath1 (3600507630efe0b0c0000000000000601) dm-8 IBM,1750500
[size=15G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
 \_ 1:0:3:2  sdao 66:128 [active][undef]
 \_ 2:0:3:2  sdaq 66:160 [failed][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:2:2  sdd  8:48   [active][undef]
 \_ 2:0:2:2  sdp  8:240  [active][undef]

serverb
mpath22 (3600507630efe0b0c0000000000000606) dm-11 IBM,1750500
[size=120G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
 \_ 1:0:1:11 sdar 66:176 [active][undef]
 \_ 2:0:1:11 sdbo 68:32  [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 2:0:0:11 sdao 66:128 [active][undef]
 \_ 1:0:0:11 sdm  8:192  [active][undef]

mpath1 (3600507630efe0b0c0000000000000601) dm-4 IBM,1750500
[size=15G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
 \_ 1:0:1:2  sdae 65:224 [active][undef]
 \_ 2:0:1:2  sdbb 67:80  [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:2  sdd  8:48   [active][undef]
 \_ 2:0:0:2  sdu  65:64  [active][undef]

here I have:
device-mapper-multipath-0.4.7-34.el5_5.4
device-mapper-1.02.39-1.el5_5.2
device-mapper-1.02.39-1.el5_5.2
device-mapper-event-1.02.39-1.el5_5.2


My relevant configuration in multipath.conf for all the systems is:
devices {
        device {
                vendor                  "IBM"
                product                 "1750500"
                getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
                prio_callout            "/sbin/mpath_prio_alua %d"
                features                "0"
                hardware_handler        "0"
                path_grouping_policy    group_by_prio
                failback                immediate
                rr_weight               uniform
                path_checker            tur
        }
}

Also, in cluster nodes I have lines such as:
        multipath {
                wwid                    3600507630efe0b0c0000000000000601
                alias                   mpath1
        }

for binding, to have both nodes see the storage LUNS with the same name

Any suggestions?
It seems that 3) after about half an hour is returned ok.
But for example 2) continues to have group composition anomalies....
how to re-set as originally?

Thanks in advance,
Gianluca
