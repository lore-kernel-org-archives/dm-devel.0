From: Nuno Fernandes <npf-mlists@eurotux.com>
Subject: RHEL5 and RDAC/Multipath
Date: Mon, 24 Sep 2007 14:39:12 +0100
Message-ID: <200709241439.12426.npf-mlists@eurotux.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

We've bought and IBM BladecenterH and IBM DS4700 storage.
We are using Redhat Enterprise Linux 5 and we are trying to put multipath=
=20
working.

RHEL5 we are using uses 2.6.18-8.1.3.el5xen. We've ported rdac patch=20
(http://kernel.org/pub/linux/kernel/people/agk/patches/2.6/2.6.21/dm-mpat=
h-rdac.patch)=20
to RHEL5 kernel. We've also updated multipath-tools to support=20
mpath_prio_rdac.

Our multipath.conf is:

devnode_blacklist {
=A0 =A0 =A0 =A0 devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
=A0 =A0 =A0 =A0 devnode "^hd[a-z]"
=A0 =A0 =A0 =A0 devnode "^cciss!c[0-9]d[0-9]*"
=A0 =A0 =A0 =A0 #USB 4G Flash drive inside HS21
=A0 =A0 =A0 =A0 devnode "sda"=20
}

defaults {
=A0 =A0 =A0 =A0 multipath_tool =A0"/sbin/multipath -v0"
=A0 =A0 =A0 =A0 udev_dir =A0 =A0 =A0 =A0/dev
=A0 =A0 =A0 =A0 polling_interval 5
=A0 =A0 =A0 =A0 default_selector =A0 =A0 =A0 =A0"round-robin 0"
=A0 =A0 =A0 =A0 default_getuid_callout =A0"/sbin/scsi_id -g -u -s /block/=
%n"
=A0 =A0 =A0 =A0 #default_prio_callout =A0 =A0"/bin/true"
=A0 =A0 =A0 =A0 failback =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0immediate
=A0 =A0 =A0 =A0 path_checker =A0 =A0 =A0 =A0 =A0 =A0rdac
=A0 =A0 =A0 =A0 hardware_handler =A0 =A0 =A0 =A0"1 rdac"
=A0 =A0 =A0 =A0 prio_callout =A0 =A0 =A0 =A0 =A0 =A0"/sbin/mpath_prio_tpc=
 /dev/%n"
=A0 =A0 =A0 =A0 path_grouping_policy =A0 =A0group_by_prio
}

multipaths {
=A0 =A0 =A0 =A0 multipath {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wwid =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A03600a0b8000320bea0000048f46e52137
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 alias =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 client_data
=A0 =A0 =A0 =A0 }
}

When we start multipath -v2 it creates multipath devices. I can see 2 act=
ive=20
paths (active controler) and 2 ghost paths (standby controler).
When i unplug 2 active fibre that connect the fabric to DS4700, multipath=
=20
reports I/O errors and doesn't failover the controler.

Any ideas?

Thanks for any help
Nuno Fernandes
