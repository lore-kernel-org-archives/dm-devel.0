From: "Bahadir Kiziltan" <b_kiziltan@hotmail.com>
Subject: Re: SOLVED: Partition(s) on boot time
Date: Fri, 10 Mar 2006 14:54:57 +0000
Message-ID: <BAY106-F24FC7997D6398EA578E000F4ED0@phx.gbl>
References: <20060307135721.GC29080@dogpound.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060307135721.GC29080@dogpound.rdu.redhat.com>
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


Hi,

I've just applied the workaround you suggested and I see that it works.

Thank you.

>From: Josef Whiter <jwhiter@redhat.com>
>Reply-To: device-mapper development <dm-devel@redhat.com>
>To: device-mapper development <dm-devel@redhat.com>
>Subject: Re: [dm-devel] Partition(s) on boot time
>Date: Tue, 7 Mar 2006 08:57:21 -0500
>
>Hello,
>
>This is a problem with our init scripts that will be fixed in U3.  The 
>change is
>to make kpartx run for every multipathed device like so
>
>/sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a"
>
>this is put in /etc/rc.d/rc.sysinit right after we load the dm-multipath 
>module.
>Thank you,
>
>Josef
>
>On Tue, Mar 07, 2006 at 07:57:06AM +0000, Bahadir Kiziltan wrote:
> >
> > Have a Dell PowerEdge 6850 server with 2 x Emulex LP1050 HBAs with the
> > latest firmware and BIOS connected to EMC CX300 storage system via 2 x 
>SAN
> > switches. It's a fully redundant SAN fabric. A LUN sized and named 112GB 
>is
> > dedicated to such server running RHEL4 U2. Here are some more details...
> >
> > [root@devapp2 ~]# multipath -ll
> > 112GB (36006016064e116004a8cdf7cd8a9da11)
> > [size=112 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
> > \_ round-robin 0 [active]
> >  \_ 1:0:0:0 sdb  8:16    [ready ][active]
> > \_ round-robin 0 [enabled]
> >  \_ 1:0:1:0 sdc  8:32    [ready ][active]
> > \_ round-robin 0 [enabled]
> >  \_ 2:0:0:0 sdd  8:48    [ready ][active]
> > \_ round-robin 0 [enabled]
> >  \_ 2:0:1:0 sde  8:64    [ready ][active]
> >
> > Such LUN is presented under "/dev" as "dm-0". Also "/dev/mapper/112GB"
> > device file is available. However I can't see partitions created on such
> > LUN without executing "kpartx" command manually.
> >
> > [root@devapp2 ~]# kpartx -va /dev/dm-0
> > add map dm-0p1 : 0 9783522 linear /dev/dm-0 63
> >
> > I tried to modify script files under /etc/udev/rules directory but no 
>luck.
> >
> > How is it possible to make partition(s) available on boot time?
> >
> > BTW, fail-over and fail-back operations are working flawless.
> >
> > Thanks.
> >
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel
