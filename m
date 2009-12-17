From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Thu, 17 Dec 2009 17:31:51 +0800
Message-ID: <2375c9f90912170131g3144ca2eydfa067c85f6ced44@mail.gmail.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	 <200912152326.34728.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764219AbZLQJb4@vger.kernel.org>
In-Reply-To: <200912152326.34728.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Dec 16, 2009 at 6:26 AM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> On Tuesday 15 December 2009 10:57:49 pm Mikulas Patocka wrote:
>
>> But some maintainers take output of the script checkpatch.pl dogmati=
cally,
>> requiring that every new work must pass the script without a warning=
=2E This is
>> counterproductive --- if I write a driver and I will be doing most m=
aintenance
>> work on it in the future, it is viable that the driver is formatted =
in such
>> a way that is best editable for me, not for anyone else. And as show=
n in example
>> (1), this 80-column requirement makes even simple changes much harde=
r.
>
> It has been agreed in the past that 80-column warnings shouldn't resu=
lt
> automatically in the rejection of the new hardware support so the abo=
ve
> argumentation is a bit weak.
>
>> So: I am submitting this patch for the checkpatch.pl script.
>>
>>
>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
> Having this limitation makes people at least think about designing th=
eir
> code properly and making it more compact.
>
> If you don't want to see such warnings just apply the following patch=
 that
> I've been keeping locally (it helped me to work on staging drivers):
>
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] checkpatch.pl: add option to disable 80 column limit=
 check
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>


I like this patch, this is actually what I wanted to do.

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!

> ---
> =C2=A0scripts/checkpatch.pl | =C2=A0 =C2=A05 ++++-
> =C2=A01 file changed, 4 insertions(+), 1 deletion(-)
>
> Index: b/scripts/checkpatch.pl
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -17,6 +17,7 @@ use Getopt::Long qw(:config no_auto_abbr
> =C2=A0my $quiet =3D 0;
> =C2=A0my $tree =3D 1;
> =C2=A0my $chk_signoff =3D 1;
> +my $chk_cl =3D 1;
> =C2=A0my $chk_patch =3D 1;
> =C2=A0my $tst_only;
> =C2=A0my $emacs =3D 0;
> @@ -41,6 +42,7 @@ Options:
> =C2=A0 -q, --quiet =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0quiet
> =C2=A0 --no-tree =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0run without a kernel tree
> =C2=A0 --no-signoff =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
do not check for 'Signed-off-by' line
> + =C2=A0--no-cl =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0do not apply 80 column limit
> =C2=A0 --patch =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0treat FILE as patchfile (default)
> =C2=A0 --emacs =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0emacs compile window format
> =C2=A0 --terse =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0one line per report
> @@ -67,6 +69,7 @@ GetOptions(
> =C2=A0 =C2=A0 =C2=A0 =C2=A0'q|quiet+' =C2=A0 =C2=A0 =C2=A0=3D> \$quie=
t,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0'tree!' =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D> \=
$tree,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0'signoff!' =C2=A0 =C2=A0 =C2=A0=3D> \$chk_=
signoff,
> + =C2=A0 =C2=A0 =C2=A0 'cl!' =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D> =
\$chk_cl,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0'patch!' =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D> \=
$chk_patch,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0'emacs!' =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D> \=
$emacs,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0'terse!' =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D> \=
$terse,
> @@ -1365,7 +1368,7 @@ sub process {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0next if ($real=
file !~ /\.(h|c|s|S|pl|sh)$/);
>
> =C2=A0#80 column limit
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ($line =3D~ /^\=
+/ && $prevrawline !~ /\/\*\*/ &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ($chk_cl && $li=
ne =3D~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
$rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
$line !~ /^\+\s*printk\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s=
*$/ &&
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
$length > 80)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>
