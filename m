From: "Daniel Keisling" <daniel.keisling@austin.ppdi.com>
Subject: RE: RE: Temporarily squelching multipathd errors
Date: Fri, 21 Nov 2008 13:54:01 -0600
Message-ID: <65F9ACC78BD8304BAAEB817634C62D4C06EAFB63@AUSMAIL01.americas.ppdi.local>
References: <1216456070.7364.4.camel@plop><65F9ACC78BD8304BAAEB817634C62D4C06C1C4D1@AUSMAIL01.americas.ppdi.local>
	<E154952FA1D141C18A9A128FEC40B34D@pitagora.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <E154952FA1D141C18A9A128FEC40B34D@pitagora.it>
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

I am still getting multipath errors when unpresenting and presenting
LUNs.  I've traced it down to getting path failures everytime I either
remove or add a LUN to the system.  The strange thing is that I get path
errors for maps that aren't related to the LUNs I am deleting or adding.
In this case, I am deleting the LUN with the map 'mpath18,' but other
maps complain whenever the LUN is deleted:

Nov 21 13:47:05 ausracdbd01 multipathd: checker failed path 67:208 in
map orabackup_hs
Nov 21 13:47:05 ausracdbd01 kernel: device-mapper: multipath: Failing
path 67:208.
Nov 21 13:47:08 ausracdbd01 multipathd: checker failed path 70:160 in
map mpath18
Nov 21 13:47:08 ausracdbd01 kernel: device-mapper: multipath: Failing
path 70:160.
Nov 21 13:47:09 ausracdbd01 multipathd: checker failed path 69:0 in map
orabackup_hs
Nov 21 13:47:09 ausracdbd01 kernel: device-mapper: multipath: Failing
path 69:0.
Nov 21 13:47:10 ausracdbd01 multipathd: checker failed path 65:192 in
map ph1d
Nov 21 13:47:10 ausracdbd01 kernel: device-mapper: multipath: Failing
path 65:192.
Nov 21 13:47:10 ausracdbd01 multipathd: checker failed path 65:224 in
map limsd
Nov 21 13:47:10 ausracdbd01 kernel: device-mapper: multipath: Failing
path 65:224.
Nov 21 13:47:10 ausracdbd01 multipathd: checker failed path 65:240 in
map limsd_arch


Sometimes I only get 5-10 "checker failed path" errors, other times I
get 30+. =20

Can anyone give me any advice?  These are OCFS2 filesystems on RHEL5
attached to a HP EVA8000. =20

[root@ausracdbd01 ~]# rpm -qa | grep mapper=20
device-mapper-1.02.20-1.el5=20
device-mapper-1.02.20-1.el5=20
device-mapper-multipath-0.4.7-12.el5=20

Relevant /etc/multipath.conf entries:
### HP Storageworks Arrays.
defaults {
        udev_dir                /dev
        polling_interval        10
        selector                "round-robin 0"
        path_grouping_policy    failover
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        prio_callout            "/bin/true"
        path_checker            tur
        rr_min_io               100
        rr_weight               uniform
        failback                immediate
        no_path_retry           12
        user_friendly_names     yes
        bindings_file           "/var/lib/multipath/bindings"


devices {

        # For EVA3000(HSV101) / EVA5000(HSV111) / EVA4000/6000 / EVA8000
        device {
                vendor                  "HP|COMPAQ"
        product                 "HSV1[01]1 \(C\)COMPAQ|HSV[23][01]0"
        path_grouping_policy    group_by_prio
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        path_checker            tur
        path_selector           "round-robin 0"
        prio_callout            "/sbin/mpath_prio_alua /dev/%n"
        rr_weight               uniform
        failback                immediate
        hardware_handler        "0"
        no_path_retry           12
        }



TIA,

Daniel

> -----Original Message-----
> From: dm-devel-bounces@redhat.com=20
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of Domenico Viggiani
> Sent: Thursday, October 30, 2008 11:15 AM
> To: 'device-mapper development'
> Subject: [dm-devel] RE: Temporarily squelching multipathd errors
>=20
> > From Daniel Keisling:
> >
> > What is proper procedure to completely remove all SCSI=20
> > devices and multipath maps so that multipathd will not=20
> > generate error messages when the LUN is unpresented from the system?
>=20
> This is my recipe:
>=20
> - Take a note of "multipath -ll" output (SCSI-IDs, long multipath
> identifiers, etc)
> - Umount filesystem
> - Deactivate VG
> 	vgchange -an vg_XXX
> - Export VG
> 	vgexport vg_XXX
> - Remove multipath
> 	multipath -f <long-multipath-identifier>
> - Unpresent/destroy array LUN
> - Remove SCSI devices
> 	echo 1 > /sys/bus/scsi/drivers/sd/<SCSI-ID>/delete
> 	... (for all paths)
> - Edit fstab
>=20
>=20
> --
> Domenico Viggiani
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
>=20

______________________________________________________________________
This email transmission and any documents, files or previous email
messages attached to it may contain information that is confidential or
legally privileged. If you are not the intended recipient or a person
responsible for delivering this transmission to the intended recipient,
you are hereby notified that you must not read this transmission and
that any disclosure, copying, printing, distribution or use of this
transmission is strictly prohibited. If you have received this transmissi=
on
in error, please immediately notify the sender by telephone or return ema=
il
and delete the original transmission and its attachments without reading
or saving in any manner.
