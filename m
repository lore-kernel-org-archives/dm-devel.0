From: "Herr, Manuel" <mher@msc-ge.com>
Subject: AW: AW: AW: multipathd failback
Date: Mon, 30 Oct 2006 08:26:19 +0100
Message-ID: <C514D40EFDB5C84083DAEB84A1186A8F94CCF1@msc-ex02.msc-ge.mscnet>
References: <4544D616.7060509@Voltaire.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <4544D616.7060509@Voltaire.COM>
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

Multipath-tools are supported by Novell. So try to update
them with YOU (Yast online update).


> -----Urspr=FCngliche Nachricht-----
> Von: dm-devel-bounces@redhat.com=20
> [mailto:dm-devel-bounces@redhat.com] Im Auftrag von Yonathan Cohen
> Gesendet: Sonntag, 29. Oktober 2006 17:26
> An: device-mapper development
> Betreff: Re: AW: AW: [dm-devel] multipathd failback
>=20
> Hello again.
> can you please tell me how to upgrade to=20
> multipath-tools-0.4.5-0.20 i found multipath-0.4.5.tar.bz2 on=20
> the site (http://christophe.varoqui.free.fr/multipath-tools/=20
> ) but i guess that multipath-tools-0.4.5-0.20 is after=20
> applying some patches if so can you tell me which ones ?
> thanks.
>=20
> Herr, Manuel wrote:
> >
> > I have no Problem with the failover also with SLES 9=20
> 2.6.5-7.244-smp.
> > But i'm not working with the isci initiator.
> >
> > My Config:
> > defaults
> > {
> >         multipath_tool  "/sbin/multipath -v0"
> >         udev_dir        /dev
> >         polling_interval 5
> >         default_selector        "round-robin 0"
> >         default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
> >         default_prio_callout    "/bin/true"
> >         failback        immediate
> > }
> > There are newer Multipath tools available:
> > Im working with: multipath-tools-0.4.5-0.20 (Device Mapper=20
> is same) I=20
> > recommend to update them first. :)
> >
> > This one is talking about the same Problem you have.
> > http://www.querzone.de/wiki/Wiki.jsp?page=3DEMCClariion
> > I don't know if this error is clariion specific.
> >
> > Regards,
> > Manuel
> >
> > > -----Urspr=FCngliche Nachricht-----
> > > Von: dm-devel-bounces@redhat.com
> > > [mailto:dm-devel-bounces@redhat.com] Im Auftrag von Yonathan Cohen
> > > Gesendet: Mittwoch, 25. Oktober 2006 09:22
> > > An: device-mapper development
> > > Betreff: Re: AW: [dm-devel] multipathd failback
> > >
> > > sorry but I am not sure what you mean.
> > > I am using an iscsi initiator (linux-iscsi rev 4.2) and=20
> this is what=20
> > > the multipathd daemon sees pepper:~ # multipath -l
> > > dm names   N
> > > dm table 3600c0ff00000000007c1d167985b4b06  N dm table
> > > 3600c0ff00000000007c1d167985b4b06  N dm status
> > > 3600c0ff00000000007c1d167985b4b06  N dm info
> > > 3600c0ff00000000007c1d167985b4b06  O
> > > 3600c0ff00000000007c1d167985b4b06
> > > [size=3D20 GB][features=3D"0"][hwhandler=3D"0"] \_ round-robin=20
> 0 [enabled] =20
> > > \_ 14:0:0:0 sda 8:0  [failed]  \_ round-robin 0 [active]
> > >   \_ 14:1:0:0 sdb 8:16 [active]
> > >
> > > sda and sdb are actually the same device discovered by=20
> iscsi via 2=20
> > > different paths.
> > > when sda failed multipathd identified the problem and diverted=20
> > > traffic to sdb but after correcting the sda problem,=20
> multipathd did=20
> > > not become aware of this and of course when i failed sdb=20
> it did not=20
> > > failback to sda.
> > > i know that multipathd is suppose to poll for failed paths and=20
> > > reinstate them when they become valid.
> > > but for some reason it does not.
> > >
> > >
> > > Herr, Manuel wrote:
> > > >
> > > > On which Hardware? (HBAs, SAN)?
> > > >
> > > > > -----Urspr=FCngliche Nachricht-----
> > > > > Von: dm-devel-bounces@redhat.com=20
> > > > > [mailto:dm-devel-bounces@redhat.com] Im Auftrag von Yonathan=20
> > > > > Cohen
> > > > > Gesendet: Mittwoch, 25. Oktober 2006 08:50
> > > > > An: dm-devel@redhat.com
> > > > > Betreff: [dm-devel] multipathd failback
> > > > >
> > > > > Hello.
> > > > > My "multipathd" daemon does not FailBack It does not=20
> check the=20
> > > > > availability of a failed path and of course does not
> > > reinstate it My
> > > > > configuration is as follows:
> > > > > cat /etc/multipath.conf
> > > > >
> > > > > defaults {
> > > > >
> > > > >         failback        immediate
> > > > > }
> > > > > I am using the following packages:
> > > > > multipath-tools-0.4.5-0.11
> > > > > device-mapper-1.01.01-1.6
> > > > > I have them installed on a SUSE LINUX Enterprise Server 9
> > > > > (x86_64) sp-3 With kernel version: 2.6.5-7.244-smp=20
> Please help.
> > > > > Thanks.
> > > > >
> > > > > ____________________________________________________________
> > > > >
> > > > > Cohen Yonatan   |  +972-9-9718607 (o)
> > > > >
> > > > > Software. Eng,  Storage group
> > > > >
> > > > > Voltaire - _The Grid Backbone_
> > > > >
> > > > > --
> > > > > dm-devel mailing list
> > > > > dm-devel@redhat.com
> > > > > https://www.redhat.com/mailman/listinfo/dm-devel
> > > > >
> > > >
> > > > --
> > > > dm-devel mailing list
> > > > dm-devel@redhat.com
> > > > https://www.redhat.com/mailman/listinfo/dm-devel
> > > >
> > >
> > > --
> > > dm-devel mailing list
> > > dm-devel@redhat.com
> > > https://www.redhat.com/mailman/listinfo/dm-devel
> > >
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
