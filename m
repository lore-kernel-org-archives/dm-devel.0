From: Srinivas Ramani <srinivas.ramani@oracle.com>
Subject: Re: [PATCH] multipath-tools: Pillar/Axiom supports
	failback=immediate
Date: Sun, 31 Jul 2016 15:09:09 -0700 (PDT)
Message-ID: <cf3964a6-4356-41b7-b577-f494e8b6e923@default>
References: <<1469913348-9350-1-git-send-email-xose.vazquez@gmail.com>
	<e46f78fd-b5cd-4498-a96e-d30b6a58d0d3@default>
	<4527a2e7-83b8-7c19-041d-a01fdb5cd684@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="__14700029538762339abhmp0001.oracle.com"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4527a2e7-83b8-7c19-041d-a01fdb5cd684@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: development <dm-devel@redhat.com>, device-mapper@redhat.com
List-Id: dm-devel.ids

--__14700029538762339abhmp0001.oracle.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Xose;

I agree.

/*
         * Pillar Data controller family
         *
         * Maintainer : Srinivasan Ramani
         * Mail : srinivas.ramani@oracle.com
         */
        {
                .vendor        =3D "^Pillar(  )?$",
                .product       =3D "^Axiom"
                .getuid        =3D DEFAULT_GETUID,
                .features      =3D DEFAULT_FEATURES,
                .hwhandler     =3D DEFAULT_HWHANDLER,
                .selector      =3D DEFAULT_SELECTOR,
                .pgpolicy      =3D GROUP_BY_PRIO,
                .pgfailback    =3D -FAILBACK_IMMEDIATE,
                .rr_weight     =3D RR_WEIGHT_NONE,
                .no_path_retry =3D NO_PATH_RETRY_UNDEF,
                .minio         =3D DEFAULT_MINIO,
                .checker_name  =3D TUR,
                .prio_name     =3D PRIO_ALUA,
        },
        /*
         * Oracle FS controller family
         *
         * Maintainer : Srinivasan Ramani
         * Mail : srinivas.ramani@oracle.com
         */
        {
                .vendor        =3D "^Oracle(  )?$",
                .product       =3D "^Oracle FS",
                .getuid        =3D DEFAULT_GETUID,
                .features      =3D DEFAULT_FEATURES,
                .hwhandler     =3D DEFAULT_HWHANDLER,
                .selector      =3D DEFAULT_SELECTOR,
                .pgpolicy      =3D GROUP_BY_PRIO,
                .pgfailback    =3D -FAILBACK_IMMEDIATE,
                .rr_weight     =3D RR_WEIGHT_NONE,
                .no_path_retry =3D NO_PATH_RETRY_UNDEF,
                .minio         =3D DEFAULT_MINIO,
                .checker_name  =3D TUR,
                .prio_name     =3D PRIO_ALUA,
        },




The patch would be attached patch.txt file.


Best Regards
Srini

-----Original Message-----
From: Xose Vazquez Perez [mailto:xose.vazquez@gmail.com]=20
Sent: Saturday, July 30, 2016 5:03 PM
To: Srinivas Ramani
Cc: Christophe Varoqui; device-mapper development
Subject: Re: [PATCH] multipath-tools: Pillar/Axiom supports failback=3Dimme=
diate

On 07/31/2016 01:18 AM, Srinivas Ramani wrote:

Pillar/Axiom and "Oracle FS" configs look the same.

>                 .vendor        =3D "^Pillar(  )?$",
>                 .product       =3D "^Axiom"
>                 .getuid        =3D DEFAULT_GETUID,
>                 .features      =3D DEFAULT_FEATURES,
>                 .hwhandler     =3D DEFAULT_HWHANDLER,
>                 .selector      =3D DEFAULT_SELECTOR,
>                 .pgpolicy      =3D GROUP_BY_PRIO,
>                 .pgfailback    =3D FAILBACK_UNDEF, <<<<<-----------

Why pgfailback is FAILBACK_UNDEF(manual)?, when in your /etc/multipath.conf=
 template it's "immediate".

> Auto-generated template from Oracle FS Path Manager 4.0:
>         vendor                "^Pillar(  )?$"
>         product               "^Axiom"
>         path_grouping_policy  group_by_prio
>         prio                  oraclefspm
>         path_checker          oraclefspm
>         failback              immediate          <<<<<-----------
>         path_selector         "round-robin 0"
>=20
> Template from Axiom Path Manager 3.1 for RHEL-6.1:
>         vendor               "Pillar"
>         product              "*"
>         path_grouping_policy group_by_prio
>         prio                 pillarapm
>         path_checker         pillarapm
>         failback             immediate          <<<<<-----------
>         no_path_retry        60
>         dev_loss_tmo         60
>         fast_io_fail_tmo     30

Thank you.

--__14700029538762339abhmp0001.oracle.com
Content-Type: text/plain; charset=Windows-1252; name="patch.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="patch.txt"

--- 1/hwtable.c 2016-07-31 15:03:56.614527157 -0700
+++ 2/hwtable.c 2016-07-31 15:04:02.599057789 -0700
@@ -764,17 +764,38 @@
         * Pillar Data controller family
         *
         * Maintainer : Srinivasan Ramani
-        * Mail : sramani@pillardata.com
+        * Mail : srinivas.ramani@oracle.com
         */
        {
-               .vendor        =3D "Pillar",
-               .product       =3D "Axiom.*",
+               .vendor        =3D "^Pillar(  )?$",
+               .product       =3D "^Axiom"
                .getuid        =3D DEFAULT_GETUID,
                .features      =3D DEFAULT_FEATURES,
                .hwhandler     =3D DEFAULT_HWHANDLER,
                .selector      =3D DEFAULT_SELECTOR,
                .pgpolicy      =3D GROUP_BY_PRIO,
-               .pgfailback    =3D FAILBACK_UNDEF,
+               .pgfailback    =3D -FAILBACK_IMMEDIATE,
+               .rr_weight     =3D RR_WEIGHT_NONE,
+               .no_path_retry =3D NO_PATH_RETRY_UNDEF,
+               .minio         =3D DEFAULT_MINIO,
+               .checker_name  =3D TUR,
+               .prio_name     =3D PRIO_ALUA,
+       },
+       /*
+        * Oracle FS controller family
+        *
+        * Maintainer : Srinivasan Ramani
+        * Mail : srinivas.ramani@oracle.com
+        */
+       {
+               .vendor        =3D "^Oracle(  )?$",
+               .product       =3D "^Oracle FS",
+               .getuid        =3D DEFAULT_GETUID,
+               .features      =3D DEFAULT_FEATURES,
+               .hwhandler     =3D DEFAULT_HWHANDLER,
+               .selector      =3D DEFAULT_SELECTOR,
+               .pgpolicy      =3D GROUP_BY_PRIO,
+               .pgfailback    =3D -FAILBACK_IMMEDIATE,
+               .rr_weight     =3D RR_WEIGHT_NONE,
+               .no_path_retry =3D NO_PATH_RETRY_UNDEF,
+               .minio         =3D DEFAULT_MINIO,
+               .checker_name  =3D TUR,
+               .prio_name     =3D PRIO_ALUA,
+       },
       
--__14700029538762339abhmp0001.oracle.com
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--__14700029538762339abhmp0001.oracle.com--
