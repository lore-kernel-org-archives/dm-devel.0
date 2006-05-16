From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: patch to allow multipath(8) and multipathd(8) to
	pick up existing alias (if any) from dm device-name
Date: Tue, 16 May 2006 23:28:40 +0200
Message-ID: <1147814920.4854.30.camel@localhost.localdomain>
References: <6CCEAEDF4D06984A83F427424F47D6E4149049@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4149049@CORPUSMX40A.corp.emc.com>
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

Le mardi 16 mai 2006 =C3=A0 15:32 -0400, egoggin@emc.com a =C3=A9crit :
> Christophe,
>=20
> This small patch should allow multipath(8) and multipathd(8) to acquire=
 its
> internal alias name from the device-mapper's device-name for the device=
 if a
> multipath specific alias (user friendly one or not) has __not__ been se=
t.
> Otherwise, assuming that a multipath device has been renamed beforehand=
 by
> someone invoking "dm_setup rename", simply invoking "multipath" changes=
 the
> device-mapper's device-name for the device back to the multipath assign=
ed
> UID name.
>=20
Sure. Good point.

Applied and pushed, thanks,
cvaroqui
