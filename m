From: Edward Goggin <egoggin@emc.com>
Subject: RE: I/O error during path failover
Date: Mon, 27 Nov 2006 11:10:36 -0500
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D157F@CORPUSMX40A.corp.emc.com>
References: <27284436.1305071164547629015.JavaMail.petteri.j.heinonen@kolumbus.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <27284436.1305071164547629015.JavaMail.petteri.j.heinonen@kolumbus.fi>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: petteri.j.heinonen@kolumbus.fi
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sunday, November 26, 2006 8:27 AM, Petteri Heinonen wrote

> I have a system with Qlogic QLA2312 HBAs. System is running RHEL 4u4:
>=20
> [root@cpn-0 etc]# uname -a
> Linux cpn-0.chas1A.ucs2.net 2.6.9-42.ELsmp #1 SMP Wed Jul 12=20
> 23:27:17 EDT 2006 i686 i686 i386 GNU/Linux
> [root@cpn-0 etc]# rpm -qa | grep device
> device-mapper-1.02.07-4.0.RHEL4
> device-mapper-multipath-0.4.5-18.1.RHEL4
> [root@cpn-0 etc]#
>=20
> Storage is EMC Cx500. Multipath.conf is at the end of the=20
> mail. I have tested the system by running I/O directly to=20
> multipath device file, e.g. like this:
>=20
> dd if=3D/dev/mpath/dm-0 of=3D/dev/null count=3D10000000
>=20
> Now, when I pull the cable to cause path change, dd usually=20
> stops in the middle, and gives error message indicating I/O=20
> error. Any suggestions?
>

The CLARiiON should only be configured with a dm-multipath path
grouping policy of "group_by_prio".

Using a no_path_retry value of "fail" may prevent a CLARiiON ucode
from being updated in an application transparent manner.  Should set
CLARiiON features to "1 queue_if_no_path".
