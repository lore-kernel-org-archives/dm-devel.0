From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC PATCH v2 2/2] init: boot to device-mapper targets without
 an  initr*
Date: Mon, 17 May 2010 11:21:51 -0700
Message-ID: <20100517112151.b1a56a4f.randy.dunlap@oracle.com>
References: <20100514035347.GA20636@redhat.com>
	<1273887701-2152-2-git-send-email-wad@chromium.org>
	<20100517094724.48632380.randy.dunlap@oracle.com>
	<AANLkTimRJAOO6frxyr3M-cL8UCxYZfU4FN1TBJn3sd4c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTimRJAOO6frxyr3M-cL8UCxYZfU4FN1TBJn3sd4c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Drewry <wad@chromium.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On Mon, 17 May 2010 13:13:48 -0500 Will Drewry wrote:

> On Mon, May 17, 2010 at 11:47 AM, Randy Dunlap <randy.dunlap@oracle.c=
om> wrote:
> > On Fri, 14 May 2010 20:41:41 -0500 Will Drewry wrote:
> >
> >> Add a dm=3D kernel parameter modeled after the md=3D parameter fro=
m
> >> do_mounts_md. =A0It allows for device-mapper targets to be configu=
red at
> >> boot time for use early in the boot process (as the root device or
> >> otherwise).
> >
> > dm=3D<blah>
> > documentation needs to be added to Documentation/kernel-parameters.=
txt and/or
> > Documentation/md.txt.
>=20
> Absolutely -- I've appended a proposed version below which I'll inclu=
de in the
> next round.  I'm not a lkml veteran, so if it makes sense to resend
> the full patchset
> again with it, I can.  Otherwise, I'll wait for comments on the code =
too.

OK, thanks for the doc update.  One typo noted below.


> >> The format is dm=3D"name uuid ro,table line 1,table line 2,...". =A0=
The
> >> parser expects the comma to be safe to use as a newline substitute=
 but,
> >> otherwise, uses the normal separator of space. =A0Some attempt has=
 been
> >> made to make it forgiving of additional spaces (using skip_spaces(=
)).
> >
> > This "space in the arg string" has been tested, right?
>=20
> Works for me so far.  I've tested this on a user mode linux instance =
and
> a real x86 machine with the dm-linear target and a custom dm target
> (which I'll be
> mailing to dm-devel@ for feedback later this week).
>=20
> > It seems a bit odd to me. =A0Most kernel parameter strings that I a=
m familiar with
> > use punctuation for separating parameter parts.
>=20
> Yup - I agree. My first cut I used commas with an empty ,, delimiter =
as a new
> line.  Then I ran across this in the source:
>=20
> kernel/params.c
> 76 /* You can use " around spaces, but can't escape ". */
> 77 /* Hyphens and underscores equivalent in parameter names. */
> 78 static char *next_arg(char *args, char **param, char **val)
>=20
> I will need to cross-check all the known dm targets to make sure that
> they don't expect quoted internal strings.  In my first look, I didn'=
t see any.
>=20
> However, I'm perfectly content with either approach so if there's a p=
reference,
> I'll rework it to make it happen.  This approach just maps more clean=
ly to the
> existing experience of configuring a mapped device.
>=20
> thanks!
> will
>=20
>=20
> documentation: dm=3D parameter documentation
>=20
> Add documentation for early mapped device creation without an initial=
 rd.
>=20
> Signed-off-by: Will Drewry <wad@chromium.org>
> ---
>  Documentation/device-mapper/boot.txt |   36 ++++++++++++++++++++++++=
++++++++++
>  Documentation/kernel-parameters.txt  |    4 +++
>  2 files changed, 40 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/device-mapper/boot.txt
>=20
> diff --git a/Documentation/device-mapper/boot.txt
> b/Documentation/device-mapper/boot.txt
> new file mode 100644
> index 0000000..00fb557
> --- /dev/null
> +++ b/Documentation/device-mapper/boot.txt
> @@ -0,0 +1,36 @@
> +Boot time creation of mapped devices
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +You can boot directly to a dm device using the following kernel comm=
and
> +line:
> +
> +dm=3D"<name> <uuid> <ro>,table line 1,...,table line n"
> +
> +name =3D the name to associated with the device

                      associate

> +	 after boot, udev, if used, will use that name to label
> +	 the device node.
> +uuid =3D may be 'none' or the UUID desired for the device.
> +ro =3D may be 0 or 1.  If non-zero, the device and device table will=
 be
> +	marked read-only.
> +
> +Each table line may be as normal when using the dmsetup tool except =
for
> +two variations:
> +1. Any use of commas will be interpreted as a newline
> +2. Quotation marks cannot be escaped and cannot be used without
> +   terminating the dm=3D argument.
> +
> +Unless renamed by udev, the device node created will be dm-0 as the
> +first minor number for the device-mapper is used during early creati=
on.
> +
> +Example
> +=3D=3D=3D=3D=3D=3D=3D
> +
> +- Booting to a linear array made up of user-mode linux block devices=
:
> +
> +  dm=3D"lroot none 0, 0 4096 linear 98:16 0, 4096 4096 linear 98:32 =
0" \
> +  root=3D/dev/dm-0
> +
> +Will boot to a rw dm-linear target of 8192 sectors split across two
> +block devices identified by their major:minor numbers.  After boot, =
udev
> +will rename this target to /dev/mapper/lroot (depending on the rules=
).
> +No uuid was assigned.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***
