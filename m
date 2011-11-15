From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: Re: info on enabling only one path with rdac and DS4700
Date: Tue, 15 Nov 2011 11:01:03 -0500
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD910809F39@RTPMVEXC1-PRD.hq.netapp.com>
References: <CAG2kNCx2FSBFcKQQ5qRNNdY8c8OZ6iR+WY4XPUy21mttYn-wuw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <CAG2kNCx2FSBFcKQQ5qRNNdY8c8OZ6iR+WY4XPUy21mttYn-wuw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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
> From: Gianluca Cecchi [mailto:gianluca.cecchi@gmail.com]
> Sent: Tuesday, November 15, 2011 9:34 AM
> To: device-mapper development
> Subject: [dm-devel] info on enabling only one path with rdac and DS4700
> =

> Hello,
> with RH EL 5.7 x86_64 and updates:
> # uname -r
> 2.6.18-274.7.1.el5
> # rpm -q device-mapper-multipath
> device-mapper-multipath-0.4.7-46.el5_7.1
> =

> I'm on a IBM HS21 blade connected to a DS4700 storage array.
> Without doing nothing in multipath.conf but blacklisting the internal
> disk, I get this kind of configuration:
> # multipath -l
> mpath1 (3600a0b80005012440000093e4a55cf33) dm-6 IBM,1814      FAStT
> [size=3D3.4T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac][rw]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 3:0:0:1 sdb 8:16  [active][undef]
>  \_ 4:0:0:1 sdc 8:32  [active][undef]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 3:0:1:1 sdd 8:48  [active][undef]
>  \_ 4:0:1:1 sde 8:64  [active][undef]

This output looks good to me. I don=92t see any problem..

> =

> Is there any config option I can force to use only one path at a time
> in the active controller, instead of two (sdb and sdc in my case) in
> round robin as I see in iostat?

Not sure about the purpose of this. Either you have to blacklist by device =
node(sdb or sdc) or change your config to see only one path to the controll=
er.

> =

> Also, I noticed that output with "-ll" shows "200" as priority of
> paths for the active controller, while "-l" shows 0 for both (see
> above)...
> Is this a bug or expected difference due to command different
> switch/verbosity?

It is not a bug. It will not run all the commands if you run with "-l"

> (I see similar behaviour also with another server connected to a
> DS6800 storage array)
> # multipath -ll
> mpath1 (3600a0b80005012440000093e4a55cf33) dm-6 IBM,1814      FAStT
> [size=3D3.4T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac][rw]
> \_ round-robin 0 [prio=3D200][active]
>  \_ 3:0:0:1 sdb 8:16  [active][ready]
>  \_ 4:0:0:1 sdc 8:32  [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 3:0:1:1 sdd 8:48  [active][ghost]
>  \_ 4:0:1:1 sde 8:64  [active][ghost]
> =

> I would like to use default multipath instead of LSI provided rdac,
> found at
> http://www.lsi.com/sep/Pages/rdac/ds4000.aspx
> version 09.03.0C05.0504 ,  dated	7/18/2011 with:
> New linux kernel versions supported with this release:
>              - SLES 10-SP3: 2.6.16.60-0.54.5
>              - SLES 10-SP4: 2.6.16.60-0.85.1
>              - SLES 11.1  : 2.6.32.12-0.7
>              - RHEL5-u5   : 2.6.18-194
>              - RHEL5-u6   : 2.6.18-238
>              - RHEL6      : 2.6.32-71
> =

> In fact I'm using  2.6.18-274.7.1.el5 that is not listed...
> Any known cons in using device-mapper-multipath with IBM,1814?
> =

> Thanks in advance,
> Gianluca
> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
