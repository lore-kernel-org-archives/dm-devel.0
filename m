From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Re: dm-multipath: del/add map problem
Date: Sat, 25 Feb 2006 15:09:14 +0100
Message-ID: <1140876554.19829.1.camel@localhost.localdomain>
References: <20060221213805.GA5670@ether.msp.redhat.com>
	<20060221223906.GC5670@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060221223906.GC5670@ether.msp.redhat.com>
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

Le mardi 21 f=C3=A9vrier 2006 =C3=A0 16:39 -0600, Benjamin Marzinski a =C3=
=A9crit :
> On Tue, Feb 21, 2006 at 03:38:05PM -0600, Benjamin Marzinski wrote:
> > When you delete a multipath map, orphaning the path clears out some m=
embers
> > of the path structure.  Adding that map again doesn't bring them back=
.
> > Specifically, you loose your checker file descriptor.
> >=20
> > The attached patch restores most of the members. It doesn't reset get=
uid.
> >=20
...
> oops. Forgot to attach the patch. Here it is.
> --
Applied, thanks.

Regards,
cvaroqui
