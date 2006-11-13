From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: patch to get_refwwid() in
	multipath-tools/libmultipath/configure.c
Date: Tue, 14 Nov 2006 00:00:04 +0100
Message-ID: <1163458804.10466.120.camel@localhost.localdomain>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1542@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D1542@CORPUSMX40A.corp.emc.com>
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
Cc: dm-devel@redhat.com, dave.wysochanski@redhat.com
List-Id: dm-devel.ids

Le lundi 13 novembre 2006 =C3=A0 17:32 -0500, Edward Goggin a =C3=A9crit =
:
> Christophe,
>=20
> This patch enables "multipath -l <dm device name>"
> to work if the current dm_alias has been changed by
> "dmsetup rename" or other means.
>=20
Nice to have. Merged localy.=20

My dev tree also has the "calc prio for down path" patch, so I'll push
it to korg once David W. has further commented the change.

Regards,
cvaroqui
