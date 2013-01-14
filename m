From: Stefan Weinhuber <WEIN@de.ibm.com>
Subject: Re: multipath-tool: gcc warnings
Date: Mon, 14 Jan 2013 09:46:51 +0100
Message-ID: <OF50C364B6.D8557717-ONC1257AF3.002FF264-C1257AF3.00303FAB@de.ibm.com>
References: <50F196C2.4050104@gmail.com>
	<1358018522.4263.23.camel@lapoo.opensvc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358018522.4263.23.camel@lapoo.opensvc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Christophe Varoqui <christophe.varoqui@gmail.com> wrote on 2013-01-12 =

20:22:02:

> On sam., 2013-01-12 at 18:00 +0100, Xose Vazquez Perez wrote:
> > hi,
> > =

> > I built multipath-tool with -Wextra and gcc shows a lot
> > of warnings. But I believe two of them are relevant:
> ...
> > dasd.c:233:4: warning: comparison is always false due to limited =

> range of data type [-Wtype-limits]
> > - wrong type
> =

> Stephan,
> =

> would you approve this patch to the kpartx dasd parser you contributed
> back in 2009 ?
> =

> diff --git a/kpartx/dasd.h b/kpartx/dasd.h
> index 0ed7c80..42f94db 100644
> --- a/kpartx/dasd.h
> +++ b/kpartx/dasd.h
> @@ -68,7 +68,7 @@ typedef struct volume_label
>         char res2[4];           /* reserved   */
>         char lvtoc[14];         /* owner code for LVTOC   */
>         char res3[28];          /* reserved   */
> -       char ldl_version;       /* version number, valid for ldl =

> format      */
> +       uint8_t ldl_version;    /* version number, valid for ldl =

> format      */
>         uint64_t formatted_blocks; /* valid when ldl_version >=3D f2   */
>  } __attribute__ ((packed)) volume_label_t;
> =

> =

> Best regards,
> Christophe Varoqui
> =


Hi Christophe,

yes,the change looks fine to me, thanks! =


Mit freundlichen Gr=FC=DFen / Kind regards
 =

Stefan Weinhuber

-- =

Linux for zSeries kernel development
IBM Systems &Technology Group, Systems Software Development / SW Linux f=FC=
r =

zSeries Entwicklung

IBM Deutschland
Schoenaicher Str. 220
71032 Boeblingen
Phone: +49-7031-16-4018
E-Mail: wein@de.ibm.com

IBM Deutschland Research & Development GmbH / Vorsitzender des =

Aufsichtsrats: Martina Koederitz
Gesch=E4ftsf=FChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=F6blingen / Registergericht: Amtsgericht Stuttgart=
, =

HRB 243294
