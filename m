From: "Matthias Rudolph" <Matthias.Rudolph@hds.com>
Subject: multipath-tools prioritizer - different naming
	conventions
Date: Wed, 5 Jul 2006 12:27:37 +0100
Message-ID: <C67364BD62907640A033D1F4094CA7B704A9D734@UKSPKEVS101.corp.hds.com>
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
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>
List-Id: dm-devel.ids

Hi Christophe,
I have tested SLES 10 RC 3.
The multipath-tools-0.4.6-25.6 are included. And the Hitachi prioritizer
is also included now. I developed the prioritizer under the old name
/sbin/pp_hds_modular. But in the distribution is the new name
/sbin/mpath_prio_hds_modular used. It seems we have to change the file
hwtable.c so that the Hitachi entry points to the new name of the
prioritizer.
All other things works perfect now (after # mv
/sbin/mpath_prio_hds_modular /sbin/pp_hds_modular) with Hitachi
Enterprise and Modular Class w/o an adapted /etc/multipath.conf file.

WE HAVE TO CHANGE FROM:
	/*
	 * Hitachi controler family
	 *
	 * Maintainer : Matthias Rudolph
	 * Mail : matthias.rudolph@hds.com
	 */
	{
		.vendor        =3D "{HITACHI,HP}",
		.product       =3D "OPEN-*",
		.getuid        =3D DEFAULT_GETUID,
		.getprio       =3D NULL,
		.features      =3D DEFAULT_FEATURES,
		.hwhandler     =3D DEFAULT_HWHANDLER,
		.selector      =3D DEFAULT_SELECTOR,
		.pgpolicy      =3D MULTIBUS,
		.pgfailback    =3D FAILBACK_UNDEF,
		.rr_weight     =3D RR_WEIGHT_NONE,
		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
		.minio         =3D DEFAULT_MINIO,
		.checker_name  =3D READSECTOR0,
	},
	{
		.vendor        =3D "HITACHI",
		.product       =3D "DF*",
		.getuid        =3D DEFAULT_GETUID,
		.getprio       =3D "/sbin/pp_hds_modular %d",
		.features      =3D DEFAULT_FEATURES,
		.hwhandler     =3D DEFAULT_HWHANDLER,
		.selector      =3D DEFAULT_SELECTOR,
		.pgpolicy      =3D GROUP_BY_PRIO,
		.pgfailback    =3D -FAILBACK_IMMEDIATE,
		.rr_weight     =3D RR_WEIGHT_NONE,
		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
		.minio         =3D DEFAULT_MINIO,
		.checker_name  =3D READSECTOR0,
	},

CHANGE TO:
	/*
	 * Hitachi controler family
	 *
	 * Maintainer : Matthias Rudolph
	 * Mail : matthias.rudolph@hds.com
	 */
	{
		.vendor        =3D "{HITACHI,HP}",
		.product       =3D "OPEN-*",
		.getuid        =3D DEFAULT_GETUID,
		.getprio       =3D NULL,
		.features      =3D DEFAULT_FEATURES,
		.hwhandler     =3D DEFAULT_HWHANDLER,
		.selector      =3D DEFAULT_SELECTOR,
		.pgpolicy      =3D MULTIBUS,
		.pgfailback    =3D FAILBACK_UNDEF,
		.rr_weight     =3D RR_WEIGHT_NONE,
		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
		.minio         =3D DEFAULT_MINIO,
		.checker_name  =3D READSECTOR0,
	},
	{
		.vendor        =3D "HITACHI",
		.product       =3D "DF*",
		.getuid        =3D DEFAULT_GETUID,
		.getprio       =3D "/sbin/mpath_prio_hds_modular %d",
		.features      =3D DEFAULT_FEATURES,
		.hwhandler     =3D DEFAULT_HWHANDLER,
		.selector      =3D DEFAULT_SELECTOR,
		.pgpolicy      =3D GROUP_BY_PRIO,
		.pgfailback    =3D -FAILBACK_IMMEDIATE,
		.rr_weight     =3D RR_WEIGHT_NONE,
		.no_path_retry =3D NO_PATH_RETRY_UNDEF,
		.minio         =3D DEFAULT_MINIO,
		.checker_name  =3D READSECTOR0,
	},


Thanks a lot for your support
Matthias Rudolph
Hitachi Data Systems
