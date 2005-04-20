From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: release 0.4.4 ?
Date: Wed, 20 Apr 2005 22:59:05 +0200
Message-ID: <1114030745.24817.142.camel@zezette>
References: <1113731446.24817.4.camel@zezette>
	<1113953571.24817.97.camel@zezette>
	<20050420133116.GW29071@marowsky-bree.de>
	<1114006824.24817.108.camel@zezette>
	<20050420142637.GA29071@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050420142637.GA29071@marowsky-bree.de>
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

Indeed, store_hwe was completely brain dead.
Corrected in pre17, online.

Also merged the sense buffer zeroing in EMC checker.

Regards,
cvaroqui

On mer, 2005-04-20 at 16:26 +0200, Lars Marowsky-Bree wrote:
> On 2005-04-20T16:20:23, christophe varoqui <christophe.varoqui@free.fr>=
 wrote:
>=20
> > > -pre16 /sbin/multipath doesn't create _any_ mapping for me.
> > Not funny.
>=20
> Not very ;-)
>=20
> > I guess I'll setup the OSDL environment now, for testing and debuggin=
g.
> > Hope to be able to diagnose in a few hours.
>=20
> Well, I forgot to attach a patch last time. Here we go. Also initialize=
s
> pp_emc so that the sense buffer doesn't contain crap.
>=20
>=20
> Sincerely,
>     Lars Marowsky-Br=C3=A9e <lmb@suse.de>
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
--=20
christophe varoqui <christophe.varoqui@free.fr>
