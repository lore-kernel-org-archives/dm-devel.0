From: "Bryn M. Reeves" <breeves@redhat.com>
Subject: Re: Compiling libdevmapper based application using C++
Date: Wed, 23 May 2007 19:33:25 +0100
Message-ID: <465488F5.4030405@redhat.com>
References: <45ea3f390705222030s65989947ta35b136a90451b57@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <45ea3f390705222030s65989947ta35b136a90451b57@mail.gmail.com>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Xyber Blue wrote:
> Hello people,
> 
> I hope someone have had done this one. I am developing application
> that uses libdevmapper for accesing kernel based device mapper. Im
> having problem compiling my program which is coded using C++ and it
> seems that it can't link to libdevmapper libraries.
> 
> Did someone experienced this one? It would be very much help if
> someone here can give me some tips on compiling my libdevmapper based
> application using C++.
> 
> Thanks,
> xyber

You'll need to wrap the libdevmapper.h include in the usual extern "C"
block like this:

extern "C" {
	#include "libdevmapper.h"
}

But beyond that I don't know of any specific problems and you didn't
describe what actually goes wrong so it's hard to make a more definite
suggestion.

Kind regards,
Bryn.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGVIj16YSQoMYUY94RAimxAJ9v51hfQ7xh4+NTQTp30sAXu+MvvQCg1U8W
u+qfat5tIIto+/jwP8cAaWQ=
=8nrT
-----END PGP SIGNATURE-----
