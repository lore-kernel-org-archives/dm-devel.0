From: "Matthias Rudolph" <Matthias.Rudolph@hds.com>
Subject: Wrong entries in hwtable.c for Hitachi Storage in
	device-mapper-multipath-0.4.5-16.1.RHEL4.src.rpm
Date: Wed, 25 Oct 2006 10:35:40 +0100
Message-ID: <C67364BD62907640A033D1F4094CA7B70608E51D@UKSPKEVS101.corp.hds.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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
