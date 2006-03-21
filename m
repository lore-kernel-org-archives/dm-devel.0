From: egoggin@emc.com
Subject: RE: multipath -l displays nothing (Solved)
Date: Tue, 21 Mar 2006 14:40:42 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321B13C@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

By the way, you shouldn't have to setup ANY multipath parameters in
/etc/multipath.conf for the dm-multipath software to work well with
all CLARiiON models except FC series.

> -----Original Message-----
> From: dm-devel-bounces@redhat.com=20
> [mailto:dm-devel-bounces@redhat.com]=20
> Sent: Tuesday, March 21, 2006 2:37 PM
> To: device-mapper development
> Subject: RE: [dm-devel] multipath -l displays nothing (Solved)
>=20
> On Tue, 21 Mar 2006, Jussi Hamalainen wrote:
>=20
> > Tried that. It didn't help with my current situation.
>=20
> After a lot of trial and error I decided to compile device mapper and
> multipathing statically into the kernel. Things seem a lot better
> after rebooting.
>=20
> --=20
> Jussi H=E4m=E4l=E4inen         +358 3 3551 8086   University of Tampere
> System administrator     +358 50  5900641   Computer Centre
> ccjuha@uta.fi            TietoPinni  4166  =20
> http://www.uta.fi/laitokset/tkk
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
