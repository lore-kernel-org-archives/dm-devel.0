From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Add human-readable units modifier to vsnprintf()
Date: Wed, 23 May 2012 01:22:36 -0400
Message-ID: <20120523052236.GA14312@dhcp-172-18-216-138.mtv.corp.google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
 <20120522211706.GH14339@google.com>
 <20120523031214.GA607@dhcp-172-18-216-138.mtv.corp.google.com>
 <1337744190.13111.33.camel@joe2Laptop>
 <20120523045023.GE607@dhcp-172-18-216-138.mtv.corp.google.com>
 <1337749848.13111.40.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1337749848.13111.40.camel@joe2Laptop>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Tejun Heo <tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Tue, May 22, 2012 at 10:10:48PM -0700, Joe Perches wrote:
> On Wed, 2012-05-23 at 00:50 -0400, Kent Overstreet wrote:
> > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> []
> > @@ -1002,6 +1023,7 @@ int format_decode(const char *fmt, struct pri=
ntf_spec *spec)
> >  		case ' ': spec->flags |=3D SPACE;   break;
> >  		case '#': spec->flags |=3D SPECIAL; break;
> >  		case '0': spec->flags |=3D ZEROPAD; break;
> > +		case 'h': spec->flags |=3D HUNITS;  break;
> >  		default:  found =3D false;
> >  		}
> > =20
>=20
> I think that doesn't work well because
> gcc __attribute__((format(printf, x, y)))
> verification fails.

Yeah, I already ran into that. I was looking through the gcc docs to se=
e
if there was a way to add modifiers (how is it done for the other kerne=
l
specific format strings?) but I haven't found anything yet

> It's also possible
> to confuse it with printf's own 'h' /=20
> integer precision use.

Well, that's annoying. Any suggestions?

>=20
> $ cat h.c
> #include <stdio.h>
> #include <stdlib.h>
>=20
> int main(int argc, char** argv)
> {
>   printf("%h02u\n", 1);
>   return 0;
> }
>=20
> $ gcc h.c
> h.c: In function =E2=80=98main=E2=80=99:
> h.c:6:3: warning: unknown conversion type character =E2=80=980=E2=80=99=
 in format [-Wformat]
>=20
>=20
