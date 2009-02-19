From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: Question on DM reload ioctl failure
Date: Thu, 19 Feb 2009 08:19:44 -0800
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF46663841E@cosmail01.lsi.com>
References: <D00AA2C108EC0346B503219C7565A66F038D99@ausx3mpc138.aus.amer.dell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <D00AA2C108EC0346B503219C7565A66F038D99@ausx3mpc138.aus.amer.dell.com>
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


We have not seen this problem. I suggest you to open a bugzilla with Nove=
ll and work with them.

Thanks
Babu Moger=20

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On=
 Behalf Of Yanqing_Liu@Dell.com
Sent: Wednesday, February 18, 2009 11:40 AM
To: dm-devel@redhat.com
Subject: [dm-devel] Question on DM reload ioctl failure


In testing with rdac device handler on SLES11 RC4, there is an issue of r=
eload ioctl failure when trying to reload device map for rdac device.
Because of this, no multipathing device is created. The multipath tool pa=
ckage version is the built-in version (0.4.8-37.1).

The error message is as follows:

Feb 18 09:52:33 | mpathc: verified path sdf dev_t 8:80 Feb 18 09:52:33 | =
mpathc: pgfailback =3D -2 (controller setting) Feb 18 09:52:33 | mpathc: =
pgpolicy =3D group_by_prio (controller setting) Feb 18 09:52:33 | mpathc:=
 selector =3D round-robin 0 (internal default) Feb 18 09:52:33 | mpathc: =
features =3D 0 (internal default) Feb 18 09:52:33 | mpathc: hwhandler =3D=
 1 rdac (controller setting) Feb 18 09:52:33 | mpathc: rr_weight =3D 1 (i=
nternal default) Feb 18 09:52:33 | mpathc: minio =3D 1000 (config file de=
fault) Feb 18 09:52:33 | mpathc: no_path_retry =3D NONE (internal default=
) Feb 18 09:52:33 | mpathc: pg_timeout =3D NONE (internal default) Feb 18=
 09:52:33 | mpathc: assembled map [0 1 rdac 1 1 round-robin 0 2 1
8:32 1000 8:80 1000]

Feb 18 09:52:33 | mpathc: set ACT_CREATE (map does not exist) Feb 18 09:5=
2:33 | libdevmapper: ioctl/libdm-iface.c(1674): dm info
mpathc  NF   [16384]
Feb 18 09:52:33 | mpathc: addmap [0 20971520 multipath 0 1 rdac 1 1 round=
-robin 0 2 1 8:32 1000 8:80 1000]

Feb 18 09:52:33 | libdevmapper: ioctl/libdm-iface.c(1674): dm create
mpathc mpath-360019b9000d456c0000029b74979b0da OF   [16384]
Feb 18 09:52:33 | libdevmapper: libdm-common.c(599): mpathc: Stacking NOD=
E_ADD (253,0) 0:6 0640 Feb 18 09:52:33 | libdevmapper: ioctl/libdm-iface.=
c(1674): dm reload
mpathc  OF   [16384]
Feb 18 09:52:33 | libdevmapper: ioctl/libdm-iface.c(1691):
device-mapper: reload ioctl failed: Invalid argument Feb 18 09:52:33 | li=
bdevmapper: ioctl/libdm-iface.c(1674): dm remove
mpathc  NF   [16384]

Any suggestion?

Thanks,
Yanqing

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
