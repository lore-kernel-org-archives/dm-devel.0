From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: patches for clariion inactive snapshot built atop
	most recent global path checker context patch
Date: Fri, 24 Nov 2006 00:15:48 +0100
Message-ID: <1164323748.25061.60.camel@localhost.localdomain>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D157B@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D157B@CORPUSMX40A.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: egoggin@emc.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Le mercredi 22 novembre 2006 =C3=A0 14:45 -0500, Edward Goggin a =C3=A9cr=
it :
>  <<readsector0.h.diff>>  <<readsector0.c.diff>>  <<emc_clariion.c.diff>=
>
>=20
Champagne !
Merged with minor arrangements.

1) move sg_read() out of readsector0.c to share it cleanly
2) improve the MSG() macro to avoid to 2-steps process (sprinf(str, fmt,
args) && MSG(c, str))
3) remove condlogs to avoid linking to libmultipath
4) remove vector.h include, remnant of an old iteration of the patch

Thank you for your patient recrafting this patchset,
cvaroqui
