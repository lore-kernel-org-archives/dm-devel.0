From: Philippe Strauss <philippe.strauss@goelaan.ch>
Subject: multipath problems on RHEL4 with sun T4
Date: Fri, 29 Sep 2006 15:58:46 +0200
Message-ID: <451D2696.9020209@goelaan.ch>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

Hello,

we face problems setting up a linux RedHat entreprise 4
(RHEL4) server for SAN. The fibre-channel adapter are 2x
QLogic ISP2422, using the qal2400 linux driver.
The SAN array is a SUN T4.
The server is a SUN AMD EM64 box, hence we are using
the EM64 RedHat distro. Kernel is kernel-smp-2.6.9-42.EL.

we use multipath-tools to do failover between two paths
to the SAN array, redhat package name is
device-mapper-multipath-0.4.5-16.1.RHEL4

The problem is that one of the two paths continously
goes down and up, as detected by multipathd readsector0
or tur probe.

a "grep multipathd" of /var/log/messages:

Sep 28 17:52:48 alambix multipathd: 8:96: mark as failed
Sep 28 17:52:48 alambix multipathd: mpath2: remaining active paths: 1
Sep 28 17:52:52 alambix multipathd: 8:96: readsector0 checker reports
path is up
Sep 28 17:53:03 alambix multipathd: 8:96: reinstated
Sep 28 17:53:03 alambix multipathd: mpath2: remaining active paths: 2
Sep 28 17:53:03 alambix multipathd: 8:96: mark as failed
Sep 28 17:53:03 alambix multipathd: mpath2: remaining active paths: 1
Sep 28 17:53:07 alambix multipathd: 8:96: readsector0 checker reports
path is up
Sep 28 17:53:07 alambix multipathd: 8:96: reinstated
Sep 28 17:53:07 alambix multipathd: mpath2: remaining active paths: 2
Sep 28 17:53:08 alambix multipathd: 8:96: mark as failed
Sep 28 17:53:08 alambix multipathd: mpath2: remaining active paths: 1
Sep 28 17:53:12 alambix multipathd: 8:96: readsector0 checker reports
path is up
Sep 28 17:53:12 alambix multipathd: 8:96: reinstated
Sep 28 17:53:12 alambix multipathd: mpath2: remaining active paths: 2
Sep 28 17:53:28 alambix multipathd: 8:96: mark as failed
Sep 28 17:53:28 alambix multipathd: mpath2: remaining active paths: 1
Sep 28 17:53:32 alambix multipathd: 8:96: readsector0 checker reports
path is up
Sep 28 17:54:07 alambix multipathd: 8:96: reinstated
Sep 28 17:54:07 alambix multipathd: mpath2: remaining active paths: 2
Sep 28 17:54:07 alambix multipathd: 8:96: mark as failed
Sep 28 17:54:07 alambix multipathd: mpath2: remaining active paths: 1
Sep 28 17:54:12 alambix multipathd: 8:96: readsector0 checker reports
path is up
Sep 28 17:54:12 alambix multipathd: 8:96: reinstated
Sep 28 17:54:12 alambix multipathd: mpath2: remaining active paths: 2

There are no message from the qla2400 driver saying that
the fibre link is down or whatever, like when removing a fibre.
Also, after adding a new slice/LUN and rebooting, the
"flap" problem changed of hardware path, which makes a hardware
problem rather impossible, and indicating a logical problem.


the /etc/multipath.conf we are using:

#devnode_blacklist {
#        devnode "*"
#}

## Use user friendly names, instead of using WWIDs as names.
defaults {
        user_friendly_names yes
        #path_grouping_policy failover
        polling_interval 1
        #path_checker tur
        no_path_retry 3
}

device {
        vendor                  "SUN"
        product                 "T4"
        #path_grouping_policy    multibus
        path_grouping_policy failover
        #getuid_callout          "/sbin/scsi_id -g -u -s"
        #features               "1 queue_if_no_path"
}

We've tried all the commented configuration parameter
with no sucess.

The output of "multipath -l":

mpath2 (360003ba4d2f4200044aa7a1c0008ef8a)
[size=200 GB][features="1 queue_if_no_path"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 1:0:0:29 sdd 8:48  [active][ready]
 \_ 2:0:0:29 sdg 8:96  [active][ready]

mpath4 (360003ba4d2f4200044aa7a61000e5d3a)
[size=18 GB][features="1 queue_if_no_path"][hwhandler="0"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:31 sdc 8:32  [active][ready]
 \_ 2:0:0:31 sdf 8:80  [active][ready]

mpath3 (360003ba4d2f4200044aa7a40000c2246)
[size=119 GB][features="1 queue_if_no_path"][hwhandler="0"]
\_ round-robin 0 [enabled]
 \_ 1:0:0:30 sde 8:64  [active][ready]
 \_ 2:0:0:30 sdh 8:112 [active][ready]


thanks a lot.

-- 
Network & System Engineer
Goelaan SA, Switzerland
Tel. +41-22-960 98 20
Fax +41-22-960 98 21
http://www.goelaan.ch
