From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: multipath rdac - recover from both paths lost
Date: Mon, 20 Oct 2008 11:04:11 -0700
Message-ID: <1224525851.14830.805.camel@chandra-ubuntu>
References: <bd4583d00810200329x652c28b8xbfa1aa23c22912e@mail.gmail.com>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <bd4583d00810200329x652c28b8xbfa1aa23c22912e@mail.gmail.com>
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


Can you try with "no_path_retry queue" in multipath.conf file for the
device.

On Mon, 2008-10-20 at 21:29 +1100, Greg Cockburn wrote:
> Hi,
> 
> I am trying to get back from a strage situation.
> 
> I have had both paths in a RDAC setup fail and then come back.
> 
> I want to know if there is a way to recover from this without a
> reboot.
> 
> (OS = CentOS 5.1)
> 
> multipath -ll
> mpath2 (3600a0b800035ebc8000001a94652ae50) dm-4 IBM,1726-4xx  FAStT
> [size=1.4T][features=0][hwhandler=1 rdac]
> \_ round-robin 0 [prio=0][enabled]
>  \_ 2:0:0:1 sde 8:80  [failed][ghost]
> \_ round-robin 0 [prio=100][active]
>  \_ 1:0:0:1 sdf 8:96  [failed][ready]
> 
> dmsetup info mpath2
> Name:              mpath2
> State:             ACTIVE
> Tables present:    LIVE
> Open count:        20
> Event number:      3
> Major, minor:      253, 4
> Number of targets: 1
> UUID: mpath-3600a0b800035ebc8000001a94652ae50
> 
> vgscan
>   Reading all physical volumes.  This may take a while...
>   /dev/mapper/mpath2: read failed after 0 of 4096 at 1497314033664:
> Input/output error
>   /dev/mapper/mpath2: read failed after 0 of 4096 at 0: Input/output
> error
> 
> dmsetup remove --force mpath2
> 
> 
> 
> device-mapper: remove ioctl failed: Device or resource busy
> Command failed
> 
> multipath -f mpath2 (just exits with return code 1)
> 
> 
> dmesg
> 
>     <<vendor>> ASC=0xe0 ASCQ=0x6ASC=0xe0 ASCQ=0x6
> 
> sde: Current: sense key: Recovered Error
>     <<vendor>> ASC=0xe0 ASCQ=0x6ASC=0xe0 ASCQ=0x6
> 
> sdf: Current: sense key: Recovered Error
>     <<vendor>> ASC=0xe0 ASCQ=0x6ASC=0xe0 ASCQ=0x6
> 
> end_request: I/O error, dev sdf, sector 61118720
> device-mapper: multipath: Failing path 8:80.
> end_request: I/O error, dev sdf, sector 599510512
> 
> device-mapper: ioctl: unable to remove open device mpath2
> device-mapper: ioctl: unable to remove open device mpath2
> 
> Any advice would be greatly appreciated.
> 
> Thanks,
> Greg.
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
