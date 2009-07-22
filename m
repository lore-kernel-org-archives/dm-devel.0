From: Jim Lester <Jim.Lester@compellent.com>
Subject: Multipath path ready but not active
Date: Wed, 22 Jul 2009 13:34:32 -0500
Message-ID: <6E9F6DF8BB260247A551EB65F5D86EDC90B59749@shandy.Beer.Town>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
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

We were doing some testing today with SLES, multipathing and iSCSI. Durin=
g the test we fail our port on the storage controller which causes the ta=
rget to move to a new port. The iSCSI initiator on the SLES box comes bac=
k just fine, but multipath doesn't re-activate the path, causing IO to ho=
ld.=20

mpatha (36000d3100003d5000000000000000013) dm-7 COMPELNT,Compellent Vol
[size=3D30G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D1][enabled]
 \_ 5:0:0:5 sdm 8:192 [failed][ready]

If we run 'multipath' from the command line the path becomes active again=
 and everything resumes. The failback parameter isn't set, so it should b=
e doing the default behavior of immediate, but even when we set it, it di=
dn't work correctly.=20

Below is our multipath.conf file as well as all the version involved. Doe=
s anybody have any input?

defaults {
        user_friendly_names             yes
        path_grouping_policy            multibus
}

blacklist {
        devnode         "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode         "^hd[a-z][[0-9]*]"
        vendor          "*"
}

blacklist_exceptions {
        vendor  "COMPELNT"
}

devices {
        device {
                vendor                          COMPELNT
                product                         "Compellent Vol"
                path_checker                    tur
                polling_interval                10
                no_path_retry                   queue
        }
}


Linux manns 2.6.16.60-0.21-smp #1 SMP Tue May 6 12:41:02 UTC 2008 x86_64 =
x86_64 x86_64 GNU/Linux
multipath-tools v0.4.8 (08/02, 2007)
iscsid version 2.0-868

---
Jim Lester | Linux/Mac Product Specialist
Jim.Lester@Compellent.com
(o) 952.294.2802
(c) 763.218.6012
Compellent Technologies | www.compellent.com
