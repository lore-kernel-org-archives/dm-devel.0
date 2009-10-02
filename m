From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: [PATCH 1/4] scsi_dh: Change the scsidh_activate interface to
	be asynchronous
Date: Fri, 02 Oct 2009 15:36:25 -0700
Message-ID: <1254522985.747.3.camel@chandra-ubuntu>
References: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>
	 <20090930020817.11455.52042.sendpatchset@chandra-ubuntu>
	 <E463DF2B2E584B4A82673F53D62C2EF474ED88E7@cosmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474ED88E7@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Benoit_Arthur@emc.com" <Benoit_Arthur@emc.com>, "Eddie.Williams@steeleye.com" <Eddie.Williams@steeleye.com>, "berthiaume_wayne@emc.com" <berthiaume_wayne@emc.com>
List-Id: dm-devel.ids


On Fri, 2009-10-02 at 16:04 -0600, Moger, Babu wrote:
> Chandra, I have one comment on this patch..=20
>=20
> >  static inline int scsi_dh_handler_exist(const char *name)
> > Index: linux-2.6.31/drivers/scsi/device_handler/scsi_dh.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.31.orig/drivers/scsi/device_handler/scsi_dh.c
> > +++ linux-2.6.31/drivers/scsi/device_handler/scsi_dh.c
> > @@ -214,7 +214,7 @@ store_dh_state(struct device *dev, struc
> >  			 * Activate a device handler
> >  			 */
> >  			if (scsi_dh->activate)
> > -				err =3D scsi_dh->activate(sdev);
> > +				err =3D scsi_dh->activate(sdev, NULL, NULL);
>=20
>=20
> This might cause problems in handlers.  We don=E2=80=99t do NULL chec=
k in attach routine.

I assume you meant activate(), when you mention "attach" above.

At every place where the callback function is called, we first check
that the callback function is not NULL.

Can you point me if I missed some place.

Thanks

chandra

>=20
>=20
> >  			else
> >  				err =3D 0;
> >  		}


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
