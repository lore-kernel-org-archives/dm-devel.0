From: Thomas Witzel <witzel.thomas@gmail.com>
Subject: Re: Re: configure MD3000
Date: Thu, 12 Mar 2009 15:38:17 -0400
Message-ID: <d1392840903121238o643eea89p6e5d5b99aacbafbd@mail.gmail.com>
References: <d1392840903120953me7d9acdyee6ead49d880be0@mail.gmail.com>
	<d1392840903121207n6b3b0ca8lb22134dd064dbc45@mail.gmail.com>
	<1236885493.12841.15.camel@chandra-ubuntu>
	<d1392840903121225y7c46dbfbs366de71ab82c8b8d@mail.gmail.com>
	<1236886304.12841.17.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1236886304.12841.17.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

How do you want me to test whether I can read/write ? I can no longer
mount the /dev/sd*1 partitions because now they are busy (thats since
I started multipath). Yes, I did execute multipath -F and multipath
repeatedly, the daemon is running.

On Thu, Mar 12, 2009 at 3:31 PM, Chandra Seetharaman
<sekharan@us.ibm.com> wrote:
> Are you able to read/write from/to the scsi device ?
>
> If yes, Did you do "multipath -F" followed by "multipath".
>
> Is the multipathd running ?
>
> chandra
> On Thu, 2009-03-12 at 15:25 -0400, Thomas Witzel wrote:
>> My /sys/block looks like this:
>> ls /sys/block/
>> dm-0  dm-3  dm-6   loop2  loop5  ram0   ram11  ram14  ram3  ram6  ram9
>>  sdc  sdf  sdi  sdl
>> dm-1  dm-4  loop0  loop3  loop6  ram1   ram12  ram15  ram4  ram7  sda
>>  sdd  sdg  sdj  sdm
>> dm-2  dm-5  loop1  loop4  loop7  ram10  ram13  ram2   ram5  ram8  sdb
>>  sde  sdh  sdk  sr0
>>
>> My /proc/partitions looks like this:
>>
>> major minor  #blocks  name
>>
>>    8     0   71041024 sda
>>    8     1   68099503 sda1
>>    8     2          1 sda2
>>    8     5    2939863 sda5
>>    8    16 2134896640 sdb
>>    8    17 2134893883 sdb1
>>    8    32 2134896640 sdc
>>    8    48 2134896640 sdd
>>    8    49 2134893883 sdd1
>>    8    64 2134896640 sde
>>    8    80 1222794240 sdf
>>    8    96      20480 sdg
>>    8   112 2134896640 sdh
>>    8   128 2134896640 sdi
>>    8   129 2134893883 sdi1
>>    8   144 2134896640 sdj
>>    8   160 2134896640 sdk
>>    8   161 2134893883 sdk1
>>    8   176 1222794240 sdl
>>    8   192      20480 sdm
>>  254     0 2134896640 dm-0
>>  254     1 2134896640 dm-1
>>  254     2 2134896640 dm-2
>>  254     3 2134896640 dm-3
>>  254     4 1222794240 dm-4
>>  254     5      20480 dm-5
>>  254     6      20480 dm-6
>>
>> All the sd's with a partition are working fine, I even created a test
>> file system at some point. I did load scsi_dh_rdac for testing at some
>> point, and that put the following into the syslog:
>> [10170.087743] sd 1:0:0:0: rdac: LUN 0 (owned)
>> [10170.089151] sd 1:0:0:1: rdac: LUN 1 (unowned)
>> [10170.089941] sd 1:0:0:2: rdac: LUN 2 (owned)
>> [10170.090719] sd 1:0:0:3: rdac: LUN 3 (unowned)
>> [10170.092112] sd 1:0:0:4: rdac: LUN 4 (owned)
>> [10170.092964] sd 1:0:1:0: rdac: LUN 0 (unowned)
>> [10170.093733] sd 1:0:1:1: rdac: LUN 1 (owned)
>> [10170.094507] sd 1:0:1:2: rdac: LUN 2 (unowned)
>> [10170.095261] sd 1:0:1:3: rdac: LUN 3 (owned)
>> [10170.096081] sd 1:0:1:4: rdac: LUN 4 (unowned)
>> [10170.096088] rdac: device handler registered
>>
>> Also loading the scsi_dh_rdac module seems to stop the [ 8996.087508]
>> Buffer I/O error on device dm-5, logical block 5
>> [ 8996.087539] Buffer I/O error on device dm-5, logical block 6
>> [ 8996.087548] Buffer I/O error on device dm-5, logical block 5112
>> [ 8996.087553] Buffer I/O error on device dm-5, logical block 5112
>> [ 8996.087601] Buffer I/O error on device dm-5, logical block 12
>> [ 8996.087606] Buffer I/O error on device dm-5, logical block 13
>> [ 8996.087609] Buffer I/O error on device dm-5, logical block 14
>> [ 8996.087612] Buffer I/O error on device dm-5, logical block 15
>> [ 8996.087615] Buffer I/O error on device dm-5, logical block 16
>> [ 8996.087618] Buffer I/O error on device dm-5, logical block 17
>>
>> type messages.
>>
>> On Thu, Mar 12, 2009 at 3:18 PM, Chandra Seetharaman
>> <sekharan@us.ibm.com> wrote:
>> > No, you don't have to change the distro.
>> >
>> > Do you see the disks ? (the #:#:#:# makes me think that the underlying
>> > block devices are not configured properly). IOW, do you the sd devices
>> > under /sys/block ? Are you able to read/write from/to the devices ?
>> >
>> > chandra
>> >
>> > On Thu, 2009-03-12 at 15:07 -0400, Thomas Witzel wrote:
>> >> Thanks Chandra,
>> >>
>> >> sorry for the out of order reply, still had the digest mode on. I
>> >> setup the config similar to what you said
>> >>
>> >> devices {
>> >>         device {
>> >>                 vendor                  "DELL"
>> >>                 product                 "MD3000"
>> >>                 hardware_handler        "1 rdac"
>> >>                 path_checker            rdac
>> >>                 path_grouping_policy    group_by_prio
>> >>                 prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
>> >>                 failback                immediate
>> >>                 getuid_callout          "/sbin/scsi_id -g -u /block/%n"
>> >>         }
>> >> }
>> >>
>> >>
>> >> and I'm still getting:
>> >> sdh: checker msg is "directio checker reports path is down"
>> >> create: 360022190009773680000214749504780 ,
>> >> [size=2.0T][features=0][hwhandler=0]
>> >> \_ round-robin 0 [prio=1][undef]
>> >>  \_ #:#:#:# sdb 8:16  [undef][ready]
>> >> \_ round-robin 0 [prio=0][undef]
>> >>  \_ #:#:#:# sdh 8:112 [undef][faulty]
>> >> sdc: checker msg is "directio checker reports path is down"
>> >> create: 3600221900096f27d00000ab3495047fd ,
>> >> [size=2.0T][features=0][hwhandler=0]
>> >> \_ round-robin 0 [prio=0][undef]
>> >>  \_ #:#:#:# sdc 8:32  [undef][faulty]
>> >> \_ round-robin 0 [prio=1][undef]
>> >>  \_ #:#:#:# sdi 8:128 [undef][ready]
>> >> sdj: checker msg is "directio checker reports path is down"
>> >> create: 360022190009773680000214a495047ce ,
>> >> [size=2.0T][features=0][hwhandler=0]
>> >> \_ round-robin 0 [prio=1][undef]
>> >>  \_ #:#:#:# sdd 8:48  [undef][ready]
>> >> \_ round-robin 0 [prio=0][undef]
>> >>  \_ #:#:#:# sdj 8:144 [undef][faulty]
>> >> sde: checker msg is "directio checker reports path is down"
>> >> create: 3600221900096f27d00000ab449504839 ,
>> >> [size=2.0T][features=0][hwhandler=0]
>> >> \_ round-robin 0 [prio=0][undef]
>> >>  \_ #:#:#:# sde 8:64  [undef][faulty]
>> >> \_ round-robin 0 [prio=1][undef]
>> >>  \_ #:#:#:# sdk 8:160 [undef][ready]
>> >> sdl: checker msg is "directio checker reports path is down"
>> >> create: 360022190009773680000214c49504806 ,
>> >> [size=1.1T][features=0][hwhandler=0]
>> >> \_ round-robin 0 [prio=1][undef]
>> >>  \_ #:#:#:# sdf 8:80  [undef][ready]
>> >> \_ round-robin 0 [prio=0][undef]
>> >>  \_ #:#:#:# sdl 8:176 [undef][faulty]
>> >> create: 360022190009773680000000000000000 ,
>> >> [size=20M][features=0][hwhandler=0]
>> >> \_ round-robin 0 [prio=1][undef]
>> >>  \_ #:#:#:# sdg 8:96  [undef][ready]
>> >> create: 3600221900096f27d0000000000000000 ,
>> >> [size=20M][features=0][hwhandler=0]
>> >> \_ round-robin 0 [prio=1][undef]
>> >>  \_ #:#:#:# sdm 8:192 [undef][ready]
>> >> libdevmapper: libdm-common.c(312): Created
>> >> /dev/mapper/360022190009773680000000000000000
>> >> libdevmapper: libdm-common.c(312): Created
>> >> /dev/mapper/3600221900096f27d0000000000000000
>> >>
>> >> Now this is not on RH or SLES, its an ubuntu 8.4 system. If absolutely
>> >> necessary I would  consider switching the distribution, but right now
>> >> I'd prefer to stick with what all the other machines have.
>> >>
>> >> Thanks, Thomas
>> >>
>> >> --
>> >> dm-devel mailing list
>> >> dm-devel@redhat.com
>> >> https://www.redhat.com/mailman/listinfo/dm-devel
>> >
>> > --
>> > dm-devel mailing list
>> > dm-devel@redhat.com
>> > https://www.redhat.com/mailman/listinfo/dm-devel
>> >
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
