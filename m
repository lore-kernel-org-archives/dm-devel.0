From: "T S, Veena (STSD)" <veena-s.t@hp.com>
Subject: RE: [patch] mpath_prio_pp
Date: Thu, 17 Jan 2008 16:14:49 +0530
Message-ID: <4640E676B7B93749BC82C75D50E500FB05C59CF7@BGEEXC07.asiapacific.cpqcorp.net>
References: <4640E676B7B93749BC82C75D50E500FB0570FBF4@BGEEXC07.asiapacific.cpqcorp.net><4640E676B7B93749BC82C75D50E500FB05B2EF5C@BGEEXC07.asiapacific.cpqcorp.net>
	<20080110.174824.08317843.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20080110.174824.08317843.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

=20

> -----Original Message-----
> From: Kiyoshi Ueda [mailto:k-ueda@ct.jp.nec.com]=20
> Sent: Friday, January 11, 2008 4:18 AM
> To: T S, Veena (STSD)
> Cc: dm-devel@redhat.com
> Subject: Re: [dm-devel] [patch] mpath_prio_pp
>=20
> Hi Veena,
>=20
> On Wed, 9 Jan 2008 15:15:38 +0530, "T S, Veena (STSD)" wrote:
> > Purpose of the patch-
> > -- To introduce the prio_callout attribute into the=20
> multipath section=20
> > of the configuration file.
>=20
> The prio_callout feature has been changed to the libprio.
> Please check the latest Christophe's git.
>=20

The changes made, to have the prio_callout attribute in the multipath
section  =20
can be ported to the latest Christophe's git.

>=20
> > -- To implement the preferred path feature in device mapper.
> >=20
> > Uses of the patch-
> > -- Prio_callout attribute in the multipath section allows users to=20
> > write callout routines,which can be specific to a LUN.
> > -- When it is known the performance of one of the path is=20
> better than=20
> > the other available paths for a particular LUN, the user=20
> can set it as=20
> > preferred path.
>=20
> How about opposite case such as the performance of some paths=20
> are better than the one backup path for a particular LUN?
> So if we can specify some preferred paths, that may be more useful.
>=20

The preferred path approach implemented here is only an example to show
how   =20
the selection of path(s) can be made for a particular LUN. Changes to
have=20
more than one preferred path can be made accordingly,if necessary.

>=20
> > +int main(int argc, char * argv[])
> > +{
> > +=20
> > +       char path[FILE_NAME_SIZE];
> > +      =20
> > +       if(argv[1] && argv[2])=20
> > +       {=20
> > +               if(!strncmp(argv[2],"/dev/",5))=20
> > +                       strcpy(path,argv[2]+5);
> > +=20
> > +               if(!strcmp(path,argv[1]) ||=20
> !strcmp(argv[1],argv[2]))=20
> > +               {=20
> > +                       printf("%u\n", HIGH);=20
> > +                       return 0;=20
> > +               }=20
> > +               else=20
> > +               {=20
> > +                       printf("%u\n", LOW);=20
> > +                       return 0;=20
> > +               }=20
> > +       }=20
> > +       return -1;
> > +}
>=20
> This prioritizer looks that we need to specify the preferred=20
> path by devnode or major/minor, right?
> If so, it doesn't work reliably.
> Both devnode and major/minor may vary for each system reboot.
> It's horrible to check and change the config file after every reboot.
> We should be able to use more persistent name to specify a=20
> path, though I don't have a good idea now...
>=20
> Thanks,
> Kiyoshi Ueda
>=20

Thanks,
Veena
