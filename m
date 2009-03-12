From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Re: configure MD3000
Date: Thu, 12 Mar 2009 12:18:13 -0700
Message-ID: <1236885493.12841.15.camel@chandra-ubuntu>
References: <d1392840903120953me7d9acdyee6ead49d880be0@mail.gmail.com>
	<d1392840903121207n6b3b0ca8lb22134dd064dbc45@mail.gmail.com>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d1392840903121207n6b3b0ca8lb22134dd064dbc45@mail.gmail.com>
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

No, you don't have to change the distro.

Do you see the disks ? (the #:#:#:# makes me think that the underlying
block devices are not configured properly). IOW, do you the sd devices
under /sys/block ? Are you able to read/write from/to the devices ?

chandra 

On Thu, 2009-03-12 at 15:07 -0400, Thomas Witzel wrote:
> Thanks Chandra,
> 
> sorry for the out of order reply, still had the digest mode on. I
> setup the config similar to what you said
> 
> devices {
>         device {
>                 vendor                  "DELL"
>                 product                 "MD3000"
>                 hardware_handler        "1 rdac"
>                 path_checker            rdac
>                 path_grouping_policy    group_by_prio
>                 prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
>                 failback                immediate
>                 getuid_callout          "/sbin/scsi_id -g -u /block/%n"
>         }
> }
> 
> 
> and I'm still getting:
> sdh: checker msg is "directio checker reports path is down"
> create: 360022190009773680000214749504780 ,
> [size=2.0T][features=0][hwhandler=0]
> \_ round-robin 0 [prio=1][undef]
>  \_ #:#:#:# sdb 8:16  [undef][ready]
> \_ round-robin 0 [prio=0][undef]
>  \_ #:#:#:# sdh 8:112 [undef][faulty]
> sdc: checker msg is "directio checker reports path is down"
> create: 3600221900096f27d00000ab3495047fd ,
> [size=2.0T][features=0][hwhandler=0]
> \_ round-robin 0 [prio=0][undef]
>  \_ #:#:#:# sdc 8:32  [undef][faulty]
> \_ round-robin 0 [prio=1][undef]
>  \_ #:#:#:# sdi 8:128 [undef][ready]
> sdj: checker msg is "directio checker reports path is down"
> create: 360022190009773680000214a495047ce ,
> [size=2.0T][features=0][hwhandler=0]
> \_ round-robin 0 [prio=1][undef]
>  \_ #:#:#:# sdd 8:48  [undef][ready]
> \_ round-robin 0 [prio=0][undef]
>  \_ #:#:#:# sdj 8:144 [undef][faulty]
> sde: checker msg is "directio checker reports path is down"
> create: 3600221900096f27d00000ab449504839 ,
> [size=2.0T][features=0][hwhandler=0]
> \_ round-robin 0 [prio=0][undef]
>  \_ #:#:#:# sde 8:64  [undef][faulty]
> \_ round-robin 0 [prio=1][undef]
>  \_ #:#:#:# sdk 8:160 [undef][ready]
> sdl: checker msg is "directio checker reports path is down"
> create: 360022190009773680000214c49504806 ,
> [size=1.1T][features=0][hwhandler=0]
> \_ round-robin 0 [prio=1][undef]
>  \_ #:#:#:# sdf 8:80  [undef][ready]
> \_ round-robin 0 [prio=0][undef]
>  \_ #:#:#:# sdl 8:176 [undef][faulty]
> create: 360022190009773680000000000000000 ,
> [size=20M][features=0][hwhandler=0]
> \_ round-robin 0 [prio=1][undef]
>  \_ #:#:#:# sdg 8:96  [undef][ready]
> create: 3600221900096f27d0000000000000000 ,
> [size=20M][features=0][hwhandler=0]
> \_ round-robin 0 [prio=1][undef]
>  \_ #:#:#:# sdm 8:192 [undef][ready]
> libdevmapper: libdm-common.c(312): Created
> /dev/mapper/360022190009773680000000000000000
> libdevmapper: libdm-common.c(312): Created
> /dev/mapper/3600221900096f27d0000000000000000
> 
> Now this is not on RH or SLES, its an ubuntu 8.4 system. If absolutely
> necessary I would  consider switching the distribution, but right now
> I'd prefer to stick with what all the other machines have.
> 
> Thanks, Thomas
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
