From: Edward Goggin <egoggin@emc.com>
Subject: RE: patches for clariion inactive snapshot built atopmost
	recent global path checker context patch
Date: Mon, 27 Nov 2006 13:00:58 -0500
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1586@CORPUSMX40A.corp.emc.com>
References: <1164323748.25061.60.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C7124D.FDA5AC3D"
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1164323748.25061.60.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7124D.FDA5AC3D
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thursday, November 23, 2006 6:16 PM, Christophe Varoqui wrote:

> To: goggin, edward
> Cc: device-mapper development
> Subject: Re: [dm-devel] patches for clariion inactive=20
> snapshot built atopmost recent global path checker context patch
>=20
> Le mercredi 22 novembre 2006 =E0 14:45 -0500, Edward Goggin a =E9crit =
:
> >  <<readsector0.h.diff>>  <<readsector0.c.diff>> =20
> <<emc_clariion.c.diff>>
> >=20
> Champagne !
> Merged with minor arrangements.
>

Looks good, except that this very small change which I
submitted last Wednesday might have gotten lost.

.. just a simple change to multipath/main.c:update_paths()
to set the mpp field of each path so that the immediately
following call to pathinfo() will call get_state() on a
path with its  mpp field set.  This enables "multipath -ll"
to utilize the shared context field of the multipath struct.=20

------_=_NextPart_001_01C7124D.FDA5AC3D
Content-Type: application/octet-stream;
	name="patch"
Content-Transfer-Encoding: base64
Content-Description: patch
Content-Disposition: attachment;
	filename="patch"

ZGlmZiAtclU1IG11bHRpcGF0aC10b29scy4xMTIyMjAwNi9tdWx0aXBhdGgvbWFpbi5jIG11bHRp
cGF0aC10b29scy9tdWx0aXBhdGgvbWFpbi5jCi0tLSBtdWx0aXBhdGgtdG9vbHMuMTEyMjIwMDYv
bXVsdGlwYXRoL21haW4uYwkyMDA2LTExLTIwIDIwOjI3OjAyLjAwMDAwMDAwMCAtMDYwMAorKysg
bXVsdGlwYXRoLXRvb2xzL211bHRpcGF0aC9tYWluLmMJMjAwNi0xMS0yMCAyMzoxNTozMi4wMDAw
MDAwMDAgLTA2MDAKQEAgLTEyOSwxMCArMTI5LDEzIEBACiAJCQkJCWNvbnRpbnVlOwogCQkJCX0K
IAkJCQlwYXRoaW5mbyhwcCwgY29uZi0+aHd0YWJsZSwgRElfQUxMKTsKIAkJCQljb250aW51ZTsK
IAkJCX0KKworCQkJcHAtPm1wcCA9IG1wcDsKKwogCQkJaWYgKHBwLT5zdGF0ZSA9PSBQQVRIX1VO
Q0hFQ0tFRCkKIAkJCQlwYXRoaW5mbyhwcCwgY29uZi0+aHd0YWJsZSwgRElfQ0hFQ0tFUik7CiAK
IAkJCWlmIChwcC0+cHJpb3JpdHkgPT0gUFJJT19VTkRFRikKIAkJCQlwYXRoaW5mbyhwcCwgY29u
Zi0+aHd0YWJsZSwgRElfUFJJTyk7Cg==

------_=_NextPart_001_01C7124D.FDA5AC3D
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_001_01C7124D.FDA5AC3D--
