From: "Xyber Blue" <xyberblue@gmail.com>
Subject: Re: Compiling libdevmapper based application using C++
Date: Thu, 24 May 2007 08:35:52 +0800
Message-ID: <45ea3f390705231735r4a7aab0dj831f5cd19bbc552@mail.gmail.com>
References: <45ea3f390705222030s65989947ta35b136a90451b57@mail.gmail.com>
	<465488F5.4030405@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <465488F5.4030405@redhat.com>
Content-Disposition: inline
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

Bryn,

Thanks man, it really works. Now I know that's the use of extern C.

Thanks again,
Ervin

On 5/24/07, Bryn M. Reeves <breeves@redhat.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Xyber Blue wrote:
> > Hello people,
> >
> > I hope someone have had done this one. I am developing application
> > that uses libdevmapper for accesing kernel based device mapper. Im
> > having problem compiling my program which is coded using C++ and it
> > seems that it can't link to libdevmapper libraries.
> >
> > Did someone experienced this one? It would be very much help if
> > someone here can give me some tips on compiling my libdevmapper based
> > application using C++.
> >
> > Thanks,
> > xyber
>
> You'll need to wrap the libdevmapper.h include in the usual extern "C"
> block like this:
>
> extern "C" {
>         #include "libdevmapper.h"
> }
>
> But beyond that I don't know of any specific problems and you didn't
> describe what actually goes wrong so it's hard to make a more definite
> suggestion.
>
> Kind regards,
> Bryn.
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.7 (GNU/Linux)
> Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org
>
> iD8DBQFGVIj16YSQoMYUY94RAimxAJ9v51hfQ7xh4+NTQTp30sAXu+MvvQCg1U8W
> u+qfat5tIIto+/jwP8cAaWQ=
> =8nrT
> -----END PGP SIGNATURE-----
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>


-- 
If you want to become somebody
Display your best ability
