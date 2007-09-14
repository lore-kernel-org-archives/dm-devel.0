From: "James Fillman" <JFillman@cucbc.com>
Subject: path priorities on Sun's 6140
Date: Fri, 14 Sep 2007 15:02:02 -0700
Message-ID: <66F461DD7EDEEF4AA928FCC80B425B520468B7@c2kp01mail.cucbc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
content-class: urn:content-classes:message
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

I'm running RHEL5 with QLogic HBA's and a Sun 6140 SAN. The host type
I'm using for my servers is 'Solaris (with DMP)'. This turns AVT mode
one. For some reason, the two controllers are returning the same
priority value to my priority call out program (mpath_prio_tpc).

Can anyone briefly explain what the mpath_prio_tpc utility does and
where these priority values come from?

The output of multipath -v2 -ll is:

[root@vlxq02md cluster]# multipath -v2 -ll
mdi_logging (3600a0b800029f8e80000064d46e565e7) dm-9 SUN,CSM200_R
[size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][active]
 \_ 1:0:0:2 sdd 8:48  [active][ready]
 \_ 1:0:1:2 sdg 8:96  [active][ready]

Where is should be:

[root@vlxq02md cluster]# multipath -v2 -ll
mdi_logging (3600a0b800029f8e80000064d46e565e7) dm-9 SUN,CSM200_R
[size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D3][active]
 \_ 1:0:0:2 sdd 8:48  [active][ready]
\_ round-robin 0 [prio=3D0][active]
 \_ 1:0:1:2 sdg 8:96  [active][ready]

I've gotten this working at my other data center with the same
hardware/software configuration. At the moment, I'm pointing my finger
at the SAN hardware but I don't have much to back it up with.

here's my multipath.conf file:

blacklist
{
         devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st|sda)[0-9]*"
}

defaults
{
        udev_dir                /dev
        polling_interval        10
        selector                "round-robin 0"
        path_grouping_policy    group_by_prio
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        prio_callout            "/sbin/mpath_prio_tpc /dev/%n"
        path_checker            readsector0
        rr_min_io               100
        rr_weight               priorities
        failback                immediate
        no_path_retry           queue
        user_friendly_name      yes
}

devnode_blacklist
{
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st|sda)[0-9]*"
        devnode "^hd[a-z][0-9]*"
        devnode "^cciss!c[0-9]d[0-9]*"
}

multipaths
{
         multipath
        {
                wwid                   3600a0b800029cc400000120946e56616
                alias                  mdi_deploys
        }
         multipath
        {
                wwid                   3600a0b800029f8e80000064d46e565e7
                alias                  mdi_logging
        }
         multipath
        {
                wwid                   3600a0b800029cc4000001140468531fa
                alias                  primary_logging
        }
}

devices
{
        device
        {
                vendor                  "SUN"
                product                 "CSM200_R"
                path_grouping_policy    group_by_prio
                path_checker            readsector0
                prio_callout            "/sbin/mpath_prio_tpc /dev/%n"
                getuid_callout          "/sbin/scsi_id -g -u -s
/block/%n"
                rr_weight               uniform
                rr_min_io               1000
                features                "1 queue_if_no_path"
        }
}

cheers,
--james
