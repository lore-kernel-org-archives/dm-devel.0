From: Yonathan Cohen <yonic@voltaire.com>
Subject: Re: AW: AW: multipathd failback
Date: Wed, 25 Oct 2006 10:37:19 +0200
Message-ID: <453F223F.3050704@Voltaire.COM>
References: <C514D40EFDB5C84083DAEB84A1186A8F94CCE2@msc-ex02.msc-ge.mscnet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C514D40EFDB5C84083DAEB84A1186A8F94CCE2@msc-ex02.msc-ge.mscnet>
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

I also have no probelm with failover only with failback
but ill try upgrading to multipath-tools-0.4.5-0.20
thanks.
Herr, Manuel wrote:
>
> I have no Problem with the failover also with SLES 9 2.6.5-7.244-smp.
> But i'm not working with the isci initiator.
>
> My Config:
> defaults
> {
>         multipath_tool  "/sbin/multipath -v0"
>         udev_dir        /dev
>         polling_interval 5
>         default_selector        "round-robin 0"
>         default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
>         default_prio_callout    "/bin/true"
>         failback        immediate
> }
> There are newer Multipath tools available:
> Im working with: multipath-tools-0.4.5-0.20
> (Device Mapper is same)
> I recommend to update them first. :)
>
> This one is talking about the same Problem you have.
> http://www.querzone.de/wiki/Wiki.jsp?page=3DEMCClariion
> I don't know if this error is clariion specific.
>
> Regards,
> Manuel
>
> > -----Urspr=FCngliche Nachricht-----
> > Von: dm-devel-bounces@redhat.com
> > [mailto:dm-devel-bounces@redhat.com] Im Auftrag von Yonathan Cohen
> > Gesendet: Mittwoch, 25. Oktober 2006 09:22
> > An: device-mapper development
> > Betreff: Re: AW: [dm-devel] multipathd failback
> >
> > sorry but I am not sure what you mean.
> > I am using an iscsi initiator (linux-iscsi rev 4.2) and this
> > is what the multipathd daemon sees pepper:~ # multipath -l
> > dm names   N
> > dm table 3600c0ff00000000007c1d167985b4b06  N dm table
> > 3600c0ff00000000007c1d167985b4b06  N dm status
> > 3600c0ff00000000007c1d167985b4b06  N dm info
> > 3600c0ff00000000007c1d167985b4b06  O
> > 3600c0ff00000000007c1d167985b4b06
> > [size=3D20 GB][features=3D"0"][hwhandler=3D"0"] \_ round-robin 0
> > [enabled]  \_ 14:0:0:0 sda 8:0  [failed]  \_ round-robin 0 [active]
> >   \_ 14:1:0:0 sdb 8:16 [active]
> >
> > sda and sdb are actually the same device discovered by iscsi
> > via 2 different paths.
> > when sda failed multipathd identified the problem and
> > diverted traffic to sdb but after correcting the sda problem,
> > multipathd did not become aware of this and of course when i
> > failed sdb it did not failback to sda.
> > i know that multipathd is suppose to poll for failed paths
> > and reinstate them when they become valid.
> > but for some reason it does not.
> >
> >
> > Herr, Manuel wrote:
> > >
> > > On which Hardware? (HBAs, SAN)?
> > >
> > > > -----Urspr=FCngliche Nachricht-----
> > > > Von: dm-devel-bounces@redhat.com
> > > > [mailto:dm-devel-bounces@redhat.com] Im Auftrag von Yonathan Cohe=
n
> > > > Gesendet: Mittwoch, 25. Oktober 2006 08:50
> > > > An: dm-devel@redhat.com
> > > > Betreff: [dm-devel] multipathd failback
> > > >
> > > > Hello.
> > > > My "multipathd" daemon does not FailBack It does not check the
> > > > availability of a failed path and of course does not
> > reinstate it My
> > > > configuration is as follows:
> > > > cat /etc/multipath.conf
> > > >
> > > > defaults {
> > > >
> > > >         failback        immediate
> > > > }
> > > > I am using the following packages:
> > > > multipath-tools-0.4.5-0.11
> > > > device-mapper-1.01.01-1.6
> > > > I have them installed on a SUSE LINUX Enterprise Server 9
> > > > (x86_64) sp-3 With kernel version: 2.6.5-7.244-smp Please help.
> > > > Thanks.
> > > >
> > > > ____________________________________________________________
> > > >
> > > > Cohen Yonatan   |  +972-9-9718607 (o)
> > > >
> > > > Software. Eng,  Storage group
> > > >
> > > > Voltaire - _The Grid Backbone_
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
>
> --=20
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
