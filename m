From: "Darryl Dixon" <esrever_otua@pythonhacker.is-a-geek.net>
Subject: Multipath not re-activating failed paths?
Date: Fri, 15 Sep 2006 11:53:40 +1200 (NZST)
Message-ID: <46253.203.97.62.217.1158278020.squirrel@pythonhacker.is-a-geek.net>
Reply-To: esrever_otua@pythonhacker.is-a-geek.net,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
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

Hi All,

I have a working dm-multipath set up with a multipath root device. For
some reason, while multipath seems to correctly use both paths, and will
gracefully handle the failing of a path (uninterrupted IO works OK), it
does not seem to want to detect once the failed path has come back up
again. In other words, in my two-path setup, it will load balance between
the paths, continue successfully on one path when one fails, but it will
then be 'stuck' on that path forever until the next reboot, even if the
first path is back up and otherwise working fine.

From what I can understand of the multipath.conf settings, the paths
should be tested every 5 seconds, and should be marked 'active' once they
come back up.

How can I best go about debugging/investigating this?

My setup details:
Machine:     HP Blade BL25P with QLogic dual-ported HBA
Storage:     Two paths to SUN 3510
OS:          RHEL4 x86_64
DM package:  device-mapper-multipath-0.4.5-16.1.RHEL4
uname -r:    2.6.9-42.0.2.ELsmp

contents of /etc/multipath.conf:
----------8<----------[cut]
devnode_blacklist {
       devnode "^cciss!c[0-9]d[0-9]*"
}

defaults {
    user_friendly_names yes
    no_path_retry fail
    path_grouping_policy multibus
    failback immediate

}

multipaths {
    multipath {
        wwid   3500000e01190e340
        alias  os
    }
}
----------8<----------[cut]

Output of multipath -l:
----------8<----------[cut]
3500000e01190e100
[size=3D68 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [active]
 \_ 0:0:3:0 sdd 8:48  [active]
 \_ 1:0:3:0 sdh 8:112 [active]

3500000e01190e3f0
[size=3D68 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [active]
 \_ 0:0:1:0 sdb 8:16  [active]
 \_ 1:0:0:0 sde 8:64  [active]

os (3500000e01190e340)
[size=3D68 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [active]
 \_ 0:0:0:0 sda 8:0   [active]
 \_ 1:0:2:0 sdg 8:96  [active]

3500000e01190e310
[size=3D68 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [active]
 \_ 0:0:2:0 sdc 8:32  [active]
 \_ 1:0:1:0 sdf 8:80  [active]
----------8<----------[cut]

Contents of /dev/mapper/:
----------8<----------[cut]
brw-rw----  1 root disk 253,  3 Sep 15  2006 3500000e01190e100
brw-rw----  1 root disk 253,  2 Sep 15  2006 3500000e01190e310
brw-rw----  1 root disk 253,  1 Sep 15  2006 3500000e01190e3f0
crw-------  1 root root  10, 63 Sep 15  2006 control
brw-rw----  1 root disk 253,  0 Sep 15  2006 os
brw-rw----  1 root disk 253,  4 Sep 15  2006 os1
brw-rw----  1 root disk 253,  5 Sep 15  2006 os2
brw-rw----  1 root disk 253,  6 Sep 15  2006 os3
----------8<----------[cut]

Output of df -k:
----------8<----------[cut]
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/os2       50394996  29944792  17890248  63% /
/dev/mapper/os1         101086     23801     72066  25% /boot
none                   5036176         0   5036176   0% /dev/shm
----------8<----------[cut]


Any and all pointers or assistance appreciated.

regards,
Darryl Dixon
http://www.winterhouseconsulting.com
