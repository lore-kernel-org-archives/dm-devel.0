From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 10/15] multipath: blacklist virtio-blk devices
Date: Mon, 9 Mar 2015 15:19:39 -0500
Message-ID: <20150309201939.GB29132@octiron.msp.redhat.com>
References: <54FC235D.2060500@gmail.com>
	<CABr-GncMe=qP=6MiDfLt6KAe0AQEByHZzEqfZ-W2i3crgEEDAQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CABr-GncMe=qP=6MiDfLt6KAe0AQEByHZzEqfZ-W2i3crgEEDAQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

On Sun, Mar 08, 2015 at 11:33:38AM +0100, Christophe Varoqui wrote:
>    Hi Xose,
>    it sure wouldn't hurt, be as there is no trailing "$" I guess the patt=
ern
>    does its job as-is.
>    Please let me know if I'm reading this wrong.

You're reading it right. What's there will blacklist devices like "vdbx"
just fine. We could add a "$" and fully specify the pattern to make sure
we don't catch any devices by accident, but I don't really see that
happening with device names, and I've never seen any complaints about
the existing devnode balcklists that don't have them.

-Ben

>    Best regards,
>    Christophe Varoqui
>    OpenSVC
>    On Sun, Mar 8, 2015 at 11:24 AM, Xose Vazquez Perez
>    <[1]xose.vazquez@gmail.com> wrote:
> =

>      Benjamin Marzinski wrote:
> =

>      > virtio-blk devices don't report anything to use as a WWID, so
>      > multipath shouldn't waste it's time checking them.
>      >
>      > Signed-off-by: Benjamin Marzinski <[2]bmarzins@redhat.com>
>      > ---
>      >=A0 libmultipath/blacklist.c | 2 +-
>      >=A0 multipath.conf.defaults=A0 | 2 +-
>      >=A0 2 files changed, 2 insertions(+), 2 deletions(-)
>      >
>      > diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
>      > index 05f1697..cea128c 100644
>      > --- a/libmultipath/blacklist.c
>      > +++ b/libmultipath/blacklist.c
>      > @@ -178,7 +178,7 @@ setup_default_blist (struct config * conf)
>      >=A0 =A0 =A0 =A0if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAU=
LT))
>      >=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
>      >
>      > -=A0 =A0 =A0str =3D STRDUP("^(td|hd)[a-z]");
>      > +=A0 =A0 =A0str =3D STRDUP("^(td|hd|vd)[a-z]");
>      =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 ^
>      =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 Missing "*" ?
> =

> References
> =

>    Visible links
>    1. mailto:xose.vazquez@gmail.com
>    2. mailto:bmarzins@redhat.com
