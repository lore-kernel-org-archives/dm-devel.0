From: "Roland Mieslinger" <roland.mieslinger@interoute.com>
Subject: RE: online disk resizing
Date: Thu, 5 Jul 2007 16:15:07 +0200
Message-ID: <7531FC6D348A2F4A9670BBC9BCB3250802B3E2EC@cm050024.europede.psinet.dc>
References: <E43E8EC1853DF64D8DF70C7FDC14E92A027093C5@dewdfe26.wdf.sap.corp>	<468CE787.6040500@sigmatrans.ru><7531FC6D348A2F4A9670BBC9BCB3250802B3E2E8@cm050024.europede.psinet.dc>
	<468CFB57.4050508@sigmatrans.ru>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <468CFB57.4050508@sigmatrans.ru>
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

> -----Original Message-----
> From: dm-devel-bounces@redhat.com=20
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of Alexander Benaguev
> Sent: Donnerstag, 5. Juli 2007 16:08
> To: device-mapper development
> Subject: Re: [dm-devel] online disk resizing
>=20
> Roland Mieslinger wrote:
> > try:=20
> > blockdevice --rereadpt <blockdevice>
> >=20
> > Roland
> just tried. no effect;(

Did you get a error from blockdev command?
Did you stop all I/O to the device?=20

This command worked for me in the past several times.=20

Roland
