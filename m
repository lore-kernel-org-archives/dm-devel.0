From: "Kumar, Vijay (STSD)" <vijay.kumar7@hp.com>
Subject: RE: multipath-tools multipath.conf.defaults
Date: Tue, 22 May 2007 15:33:24 +0530
Message-ID: <58FE8766C9D3FE4E8AF6B6B75A74AF8F097FE4E3@BGEEXC02.asiapacific.cpqcorp.net>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

Below, is it not /block/%n missing here.

>  #		getuid_callout		"/sbin/scsi_id -g -u -s"

Rather I would say, it should be as "/sbin/scsi_id -g -u -s /block/%n"
for getuid_callout.


Thanks,
Vijay Kumar



> -----Original Message-----
> From: dm-devel-bounces@redhat.com=20
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of=20
> bmarzins@sourceware.org
> Sent: Friday, May 18, 2007 1:17 AM
> To: dm-cvs@sourceware.org; dm-devel@redhat.com
> Subject: [dm-devel] multipath-tools multipath.conf.defaults
>=20
> CVSROOT:	/cvs/dm
> Module name:	multipath-tools
> Branch: 	RHEL5_FC6
> Changes by:	bmarzins@sourceware.org	2007-05-17 19:47:24
>=20
> Modified files:
> 	.              : multipath.conf.defaults=20
>=20
> Log message:
> 	Fixing typo in multipath.conf.defaults
>=20
> Patches:
> http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multi
> path.conf.defaults.diff?cvsroot=3Ddm&only_with_tag=3DRHEL5_FC6&r1=3D
> 1.5.4.2&r2=3D1.5.4.3
>=20
> --- multipath-tools/multipath.conf.defaults	2007/01/10=20
> 20:08:07	1.5.4.2
> +++ multipath-tools/multipath.conf.defaults	2007/05/17=20
> 19:47:24	1.5.4.3
> @@ -60,7 +60,7 @@
>  #               vendor                  "(COMPAQ|HP)"
>  #               product                 "HSV(1|2).*"
>  #		getuid_callout		"/sbin/scsi_id -g -u -s"
> -#               prio_callout            "/sbin/mpath_prio_alua %d"=09
> +#               prio_callout            "/sbin/mpath_prio_alua %n"=09
>  #		features		"0"
>  #		hardware_handler	"0"
>  #               path_grouping_policy    group_by_prio
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
