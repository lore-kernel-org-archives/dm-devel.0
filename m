From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: [PATCH] pp_aula/spc.h
Date: Thu, 4 May 2006 17:20:40 +0200
Message-ID: <OF8A814999.803FEBB5-ONC1257164.0053CCEC-C1257164.00541B23@de.ibm.com>
References: <20060504145645.GA2379@pundit>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060504145645.GA2379@pundit>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

The draft is good. This was/is a bug.

Mit freundlichem Gru=DF,
Stefan Bader

SW Linux on zSeries Development & Services
Stefan.Bader@de.ibm.com
-------------------------------------------------------------------------=
---------
  When all other means of communication fail, try words.

dm-devel-bounces@redhat.com wrote on 04.05.2006 16:56:45:

> On Tue, May 02, 2006 at 03:32:02PM -0700, Tom Kalus wrote:
> > path_priority/pp_aula/spc.h
> >=20
> > Isn't the inquiry_data.product_identifier 16 bytes long? or do I need=
=20
a=20
> > later draft of SPC3... 21d - Feb 2005
> > Bug doesn't effect existing code, but it's still a bug.
> > Rest looks ok, so far as I can tell.
> >=20
> > See attached patch.
> >=20
> >=20
>=20
> > diff --git a/path_priority/pp_alua/spc3.h=20
b/path_priority/pp_alua/spc3.h
> > index 11f5dbd..bddbbdd 100644
> > --- a/path_priority/pp_alua/spc3.h
> > +++ b/path_priority/pp_alua/spc3.h
> > @@ -148,10 +148,10 @@ struct inquiry_data {
> >                 /* ......x. =3D command queue support  */
> >                 /* .......x =3D vs2                    */
> >     unsigned char   vendor_identification[8];
> > -   unsigned char   product_identification[8];
> > +   unsigned char   product_identification[16];
> >     unsigned char   product_revision[4];
> >     unsigned char   vendor_specific[20];
> > -   unsigned char   b48;      /* xxxx.... =3D reserved               =
*/
> > +   unsigned char   b56;      /* xxxx.... =3D reserved               =
*/
> >                 /* ....xx.. =3D clocking               */
> >                 /* ......x. =3D qas                    */
> >                 /* .......x =3D ius                    */
>=20
> Stefan,
>=20
> Can you you ack this one ?
>=20
> Regards,
> cvaroqui
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
