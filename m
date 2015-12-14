From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: linux-4.4-rc5 bug report ?
Date: Mon, 14 Dec 2015 09:36:48 -0500
Message-ID: <20151214143648.GA925@redhat.com>
References: <DUB128-W85E2287516BB8B636D5C119CED0@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <DUB128-W85E2287516BB8B636D5C119CED0@phx.gbl>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Binderman <dcb314@hotmail.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Dec 14 2015 at  7:22am -0500,
David Binderman <dcb314@hotmail.com> wrote:

> Hello there,
> =

> [linux-4.4-rc5/drivers/md/persistent-data/dm-space-map-metadata.c:160]: (=
style) Variable 'bop' is assigned a value that is never used.
> =

> =A0=A0=A0 bop =3D brb->bops + brb->begin;
> =A0=A0=A0 brb->begin =3D brb_next(brb, brb->begin);
> =

> =A0=A0=A0 return 0;
> =

> Suggest either use the variable in some way, or delete it.

Thanks for the report, I've staged a fix here:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/com=
mit/?h=3Ddm-4.5&id=3D512167788a6fe9481a33a3cce5f80b684631a1bb

Waiting for the 4.5 merge window sense this isn't a serious problem
(it'll make its way back to stable@ kernels once merged)
