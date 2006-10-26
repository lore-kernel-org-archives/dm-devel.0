From: "Arumugam, Anburaja (STSD)" <anburaja.arumugam@hp.com>
Subject: RE: Wrong entries in hwtable.c for Hitachi Storage
	indevice-mapper-multipath-0.4.5-16.1.RHEL4.src.rpm
Date: Thu, 26 Oct 2006 21:38:09 +0530
Message-ID: <7EB526165496DF4ABE1A64C5CE0BB59B03D29DAF@bgeexc01.asiapacific.cpqcorp.net>
References: <C67364BD62907640A033D1F4094CA7B70608E51D@UKSPKEVS101.corp.hds.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <C67364BD62907640A033D1F4094CA7B70608E51D@UKSPKEVS101.corp.hds.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hello Alasdair/All


The recommended entries for the HP Storageworks Arrays are as follows:
  	  r +=3D store_hwe_ext(hw, "HP", "HSV101*", GROUP_BY_PRIO,
DEFAULT_GETUID,
                    "/sbin/mpath_prio_alua %n", "0","1
queue_if_no_path", "tur",
                    -FAILBACK_IMMEDIATE, NULL);
        r +=3D store_hwe_ext(hw, "COMPAQ", "HSV111*", GROUP_BY_PRIO,
DEFAULT_GETUID,
                    "/sbin/mpath_prio_alua %n", "0", "1
queue_if_no_path", "tur",
                    -FAILBACK_IMMEDIATE, NULL);
        r +=3D store_hwe_ext(hw, "HP", "HSV200", GROUP_BY_PRIO,
DEFAULT_GETUID,
                    "/sbin/mpath_prio_alua %n", "0", "1
queue_if_no_path", "tur",
                    -FAILBACK_IMMEDIATE, NULL);
        r +=3D store_hwe_ext(hw, "HP", "HSV210", GROUP_BY_PRIO,
DEFAULT_GETUID,
                    "/sbin/mpath_prio_alua %n", "0", "1
queue_if_no_path", "tur",
                    -FAILBACK_IMMEDIATE, NULL);
        r +=3D store_hwe_ext(hw, "HP", "OPEN-*", MULTIBUS, DEFAULT_GETUID=
,
NULL, "0", "0",
                    "tur", -FAILBACK_IMMEDIATE, NULL);

Currently HP recommends the above parameters in /etc/multipath.conf by
means of Configuration Guide for the HP Storageworks Arrays to override
the current default settings in hwtable.c.

Please let me know if any information needed further on this.

Thanks,
Anbu



-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Matthias Rudolph
Sent: Wednesday, October 25, 2006 3:06 PM
To: dm-devel@redhat.com
Subject: [dm-devel] Wrong entries in hwtable.c for Hitachi Storage
indevice-mapper-multipath-0.4.5-16.1.RHEL4.src.rpm

Hi all,

I checked the latest dm-multipath in RHEL4U4 with Hitachi Storage
Arrays. Normally it should work now without a modified or created
/etc/multipath.conf. But it does not. I beliefe the file hwtable.c of
the source is not correct. The right entries on kernel.org did not found
the way to the RedHat package. Here my suggestions for file hwtable.c:

Wrong lines (please delete):
	r +=3D store_hwe_ext(hw, "HP", "OPEN-.", MULTIBUS, DEFAULT_GETUID,
NULL,
		"0", "0", "tur", FAILBACK_UNDEF, NULL);
	r +=3D store_hwe(hw, "HITACHI", "DF400", MULTIBUS,
DEFAULT_GETUID);
	r +=3D store_hwe(hw, "HITACHI", "DF500", MULTIBUS,
DEFAULT_GETUID);
	r +=3D store_hwe(hw, "HITACHI", "DF600", MULTIBUS,
DEFAULT_GETUID);
	r +=3D store_hwe_ext(hw, "HITACHI", "DF600F*", GROUP_BY_PRIO,
		DEFAULT_GETUID, "/sbin/mpath/prio_hds_modular %d", "0",
"0",
 		"readsector0", -FAILBACK_IMMEDIATE, NULL);

Correct lines (please add):
	r +=3D store_hwe_ext(hw, "{HITACHI,HP}", "OPEN-.*", MULTIBUS,
		DEFAULT_GETUID, NULL, "0", "0", "readsector0",
FAILBACK_UNDEF,
		NULL);
	r +=3D store_hwe_ext(hw, "HITACHI", "DF.*", GROUP_BY_PRIO,
		DEFAULT_GETUID, "/sbin/mpath_prio_hds_modular %d", "0",
"0",
		"readsector0", -FAILBACK_IMMEDIATE, NULL);

I hope the regular expressions are correct for dm-multipath.
The file multipath.conf.defaults does also not match the entries in file
hwtable.c.

A temporary fix for the problem above is to create the file
/etc/multipath.conf with the entries below:

devices {
	device {
		vendor                  "HITACHI"
		product                 "DF.*"
		path_grouping_policy    group_by_prio
		prio_callout            "/sbin/pp_hds_modular %d"
		path_checker            readsector0
		getuid_callout          "/sbin/scsi_id -g -u -s
/block/%n"
		failback                immediate
		}
	device {
		vendor                  "HITACHI"
		product                 "OPEN-.*"
		path_grouping_policy    multibus
		path_checker            readsector0
		getuid_callout          "/sbin/scsi_id -g -u -s
/block/%n"
		}
	}


Regards
Matthias Rudolph

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
