From: Jason Price <japrice@gmail.com>
Subject: dm-multipath fails when 1 path is taken offline
Date: Thu, 26 May 2011 12:19:28 -0400
Message-ID: <BANLkTiknZgOPo0OYwzKRS0J9N0xxciudVA@mail.gmail.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I've apparently got multipath configured 'correctly', however it seems to
favor one path over the other.  I can tell this by watching the switch
traffic... traffic only flows down one path.  When I take the 'non-prefered'
path offline the logs notice, and take down the path.  I can bring that path
back online and the path reconnects.

However, when I take the 'preferred' path offline, the volume shows
Input/Output errors, and forces the volume into read-only mode.

Background:
Running v0.4.9 of device-mapper-multipath
Hitachi AMS2500 array, using ports 0F and 1F
Brocade 5300 switches, split into two fabrics.  (fabric A, port 30,
fabric B port 30)
Host has a qlogic 2462 card with two ports in use.

Current multipath.conf:

blacklist {
        devnode "^sda$"
}

defaults {
                checker_timeout         5
                polling_interval        5
}

multipaths {
        multipath {
                wwid 360060e8010053b90052fb06900000190
                alias                   vrp
#               path_selector           "round-robin 0"
        }
}

results of 'multipath -ll'

# multipath -ll
vrp (360060e8010053b90052fb06900000190) dm-8 HITACHI,DF600F
size=70G features='1 queue_if_no_path' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=1 status=enabled
| `- 6:0:0:0 sdc 8:32 active ready running
`-+- policy='round-robin 0' prio=0 status=enabled
  `- 5:0:0:0 sdb 8:16 active ready running

I've also worked with several revisions of the multipath.conf file.  If I
remember correctly, with some device stanza revisions, I've had multipath -ll
returning this result instead:

# multipath -ll
vrp (360060e8010053b90052fb06900000190) dm-8 HITACHI,DF600F
size=70G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
|- 6:0:0:0 sdc 8:32 active ready running
`- 5:0:0:0 sdb 8:16 active ready running

However, both are affected by the same problem.

Excerpt from /etc/fstab:
LABEL=vrp-db            /vrp-db                 ext3    defaults        0 2

relevant line from pvscan:
  PV /dev/mpath/vrp   VG vrpdg     lvm2 [70.00 GB / 0    free]

relevant line from vgscan:
  Found volume group "vrpdg" using metadata type lvm2

While I'd prefer an 'active-active' setup, I'd accept an active/passive
setup, provided it failed over correctly... preferably with a fast failback.

I'm more than happy to provide any other information.

--Jason
(Please CC: me on any replies... I'm not sure I've successfully subscribed
to this mailing list)
