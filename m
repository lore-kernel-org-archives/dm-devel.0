From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: RE: Clariion CX600 automatic failback support
Date: Fri, 04 Nov 2005 21:55:20 +0100
Message-ID: <1131137721.7463.12.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321ADAC@SRMANNING.eng.emc.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321ADAC@SRMANNING.eng.emc.com>
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


> > Yes, the test to determine if a switch is needed is sub-optimal :
> > The no activated PG case (all Enabled for example=C3=83) keeps=20
> > triggering a switch.
> > I checked-in a patch to solve that issue.
>=20
> I've dealt with this problem by patching the device mapper
> multipath driver in the kernel.
>=20
> The patch below patches drivers/md/dm-mpath.c:multipath_status()
> to return an active state for a path group which is either the
> current path group or setup to be the next path group instead
> of just returning an active state for a path group which is
> currently active.
>=20
Right, it deserved to be done.

I'm inclined to keep the tools patch anyway : it wastes an "int" per
multipath but is brain-friendlier (as it avoids using mpp->nextpg to
represent the current setting *and* the best-rated setting).

Are interested parties ok with that ?

Regards,
cvaroqui
