From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: RE: patch to get_refwwid()
	inmultipath-tools/libmultipath/configure.c
Date: Tue, 14 Nov 2006 22:27:59 +0100
Message-ID: <1163539679.10466.132.camel@localhost.localdomain>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1545@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D1545@CORPUSMX40A.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Edward Goggin <egoggin@emc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Le lundi 13 novembre 2006 =C3=A0 21:40 -0500, Edward Goggin a =C3=A9crit =
:
> I messed up the patch a bit.  Apparently dm_get_uuid() can
> return a zero without actually having found a dm name which
> matches the name parameter.
>=20
> Also, I changed dm_get_uuid() so it either returns 1 or a null
> string in the uuid return parameter -- in 2 different cases=20
> it was doing neither.
>=20
> The <dm_device_name> qualifier for the command line
> "multipath -ll <dm device name>" can now accept up
> to 3 different names for the same dm mapped device,
> that is, a user friendly name, an alias in
> /etc/multipath.conf, and the current name as
> reported by "dmsetup ls".  Is this OK or should
> we enforce that only the current name as reported
> by "dmsetup ls" is acceptable if the mapped device
> already exists?=20
>=20
Friendlyness is ok :)
Merged.
