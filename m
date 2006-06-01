From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Hitachi storage and Multipath-Tools
Date: Thu, 01 Jun 2006 20:37:12 +0200
Message-ID: <1149187033.8452.77.camel@localhost.localdomain>
References: <C67364BD62907640A033D1F4094CA7B7043CECBC@UKSPKEVS101.corp.hds.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C67364BD62907640A033D1F4094CA7B7043CECBC@UKSPKEVS101.corp.hds.com>
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
Cc: Matthias.Rudolph@hds.com
List-Id: dm-devel.ids

Le lundi 29 mai 2006 =C3=A0 15:56 +0100, Matthias Rudolph a =C3=A9crit :
> Hi Christopher,
>=20
> I have checked the latest file hwtable.c on /pub/mirrors/kernel.org/pub=
/scm/linux/storage/multipath-tools and I do not understand the entries fo=
r vendor HP and Hitachi. I hope you can help.
>=20
> Here are some background information:
>=20
> Vendor Hitachi build two different storage classes with fibre channel c=
onnectivity: Enterprise class and Modular class.
> The SCSI product inquiry for Enterprise classe always begins with "OPEN=
-" and the rest of the string depends on the LUN type (for example "OPEN-=
V*10" for a MetaLUN/LUSE build from 10 different internal LUNs). The LUNs=
 of the Enterprise Class can be accessed active/active (multibus). There =
are different versions of the Enterprise class and all with nearly the sa=
me internal crossbar/switch architecture (no bus): 9910, 9960, 9970V, 998=
0V, USP100, USP600 and USP1100.
> The other storage class made by Hitachi is the Modular class. The SCSI =
product inquiry for Modular class always begins with "DF". The LUNs of th=
e Modular class can be accessed active/passive (group_by_prio) and for sp=
reading the load you need a prioritizer (pp_hds_modular). There are also =
a lot of different versions of the Hitachi Modular class and all with a t=
wo-controller-architecture: 9200, 9520V, 9530V, 9570V, 9580V, 9585V, WMS,=
 AMS500, AMS1000 and so on. The Hitachi internal naming for 9200 is DF500=
x, for 95xxV is DF600x and for AMS/WMS is DF700x. The SCSI product inquir=
y changes depending on the Hitachi internal name and the LUN type (for ex=
ample "DF600F-CM" for a 9580V LUN with Command Device functionality.
>=20
> I am an employee of HDS - Hitachi Data Systems. It is a 100% doughter o=
f Hitachi Limited in Japan and we are the responsible for selling and for=
 service of the Storage products from Hitachi worldwide.
>=20
> Hawlett Packard (HP) does also sell the Hitachi Enterprise class. The o=
nly difference is the different SCSI inquiry for vendor (HP) and the name=
s. The SCSI inquiry for product "OPEN-" is the same. HP sells the Hitachi=
 Enterprise class under the name XPxxxxx.
> The product A6189A is HPs own developed Modular storage class and is se=
lled under the name EVA. It is not compatible to Hitachi products.
>=20
> SUN Microsystems is also selling the Hitachi Enterprise class but they =
do not change the SCSI vendor inquiry. They use "HITACHI" as vendor strin=
g.
>=20
I tried to apply your suggestions.

Please check out the lastest git tree and confirm I did the job right,
this time.

I also declared you as maintainer of the Hitachi defaults.
I hope it's ok with you. Let me know if not.

Thanks,
cvaroqui
