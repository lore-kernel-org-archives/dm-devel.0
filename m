From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/4] Various small multipath-tools
	improvements
Date: Sat, 18 Apr 2009 13:53:05 -0400
Message-ID: <20090418175304.GA3582@redhat.com>
References: <1240006080-27892-1-git-send-email-snitzer@redhat.com>
	<1728817154.2681491240076467124.JavaMail.root@zimbra16-e3.priv.proxad.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1728817154.2681491240076467124.JavaMail.root@zimbra16-e3.priv.proxad.net>
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

Hi Christophe,

I don't have a public git tree at the moment but I can look to get one
setup for future patches.  The patches that I posted should apply
cleanly to the current HEAD (49944a3d5).

BTW, agk pointed out that moving the bindings file may require that some
logic be added to migrate the old bindings to the new location.  I
haven't looked into it yet but will do so shortly.  But for now it is
probably safest to not apply the change to the bindings file location
(patch 4).

Mike


On Sat, Apr 18 2009 at  1:41pm -0400,
christophe.varoqui@free.fr <christophe.varoqui@free.fr> wrote:

> Hi Mike,
> thank you for these patches.
> Do you happen to have a fetchable git clone to ease integration ?
>=20
> ----- Mail Original -----
> De: "Mike Snitzer" <snitzer@redhat.com>
> =C0: dm-devel@redhat.com
> Envoy=E9: Samedi 18 Avril 2009 00h07:56 GMT +01:00 Amsterdam / Berlin /=
 Berne / Rome / Stockholm / Vienne
> Objet: [dm-devel] [PATCH 0/4] Various small multipath-tools improvement=
s
>=20
> Just a few cleanup patches.
>=20
> Mike Snitzer (4):
>   multipath-tools: update scsi_id arguments
>   multipath-tools: install libmultipath.so in $syslibdir
>   multipath-tools: update multipathd.init.redhat
>   multipath-tools: change default location for bindings file
>=20
>  Makefile.inc                      |    1 +
>  libmultipath/Makefile             |    6 +-
>  libmultipath/defaults.h           |    4 +-
>  libmultipath/hwtable.c            |    6 +-
>  multipath.conf.annotated          |    6 +-
>  multipath.conf.defaults           |   78 ++++++++++++++++++-----------=
-------
>  multipath.conf.synthetic          |    4 +-
>  multipath/Makefile                |    1 +
>  multipath/multipath.conf.5        |    2 +-
>  multipathd/multipathd.init.redhat |   30 +++++++--------
>  10 files changed, 69 insertions(+), 69 deletions(-)
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
