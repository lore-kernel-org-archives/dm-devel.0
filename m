From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: map in use - by what?
Date: Wed, 17 Mar 2010 12:53:50 +0100
Message-ID: <1268826830.31272.170.camel@o>
References: <db9fa2351003150252md9d7e6ak1d7625d98914283f@mail.gmail.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <db9fa2351003150252md9d7e6ak1d7625d98914283f@mail.gmail.com>
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

Kevin,

analyzing "dmsetup ls --tree" for mapped device
dependencies should help you.

Heinz

On Mon, 2010-03-15 at 10:52 +0100, Kevin Maguire wrote:
> Hi
> 
> I wish to remove some mpath devices (which are in fact SAN storage)
> from my server.
> 
> Previously LVM objects was built on top of these devices, but these
> have been removed via lvremove + vgremove + pvremove. lvs/vgs/pvs list
> nothing related to the underlying mpath devices.
> 
> I then commented out the relevant entries in /etc/multipath.conf and
> tried:
> 
> $ multipath -F
> sossan4: map in use
> ecfs1: map in use
> sossan5: map in use
> 
> (sossan4/5 should now be removable, ecfs1 is still in use)
> 
> Also
> 
> # multipath -ll
> sossan4 (3600a0b800048ead00000070c4b2a66ee) dm-2 SUN,CSM200_R
> [size=6.4T][features=1 queue_if_no_path][hwhandler=1 rdac][rw]
> \_ round-robin 0 [prio=3][active]
>  \_ 1:0:0:0 sdb 8:16  [active][ready]
> \_ round-robin 0 [prio=0][enabled]
>  \_ 2:0:0:0 sde 8:64  [active][ghost]
> ecfs1 (3600d0230ffffffff02bd6d4c3b1a8900) dm-3 IFT,A16F-R2431
> [size=6.4T][features=1 queue_if_no_path][hwhandler=0][rw]
> \_ round-robin 0 [prio=1][active]
>  \_ 1:0:1:0 sdc 8:32  [active][ready]
> \_ round-robin 0 [prio=1][enabled]
>  \_ 2:0:1:0 sdf 8:80  [active][ready]
> sossan5 (3600a0b800048eac2000008c34b2a6961) dm-4 SUN,CSM200_R
> [size=6.4T][features=1 queue_if_no_path][hwhandler=1 rdac][rw]
> \_ round-robin 0 [prio=3][active]
>  \_ 1:0:2:0 sdd 8:48  [active][ready]
> \_ round-robin 0 [prio=0][enabled]
>  \_ 2:0:2:0 sdg 8:96  [active][ghost]
> # dmsetup remove sossan4
> device-mapper: remove ioctl failed: Device or resource busy
> Command failed
> # dmsetup remove sossan5
> device-mapper: remove ioctl failed: Device or resource busy
> Command failed
> # dmsetup info sossan4
> Name:              sossan4
> State:             ACTIVE
> Read Ahead:        256
> Tables present:    LIVE
> Open count:        8
> Event number:      5
> Major, minor:      253, 2
> Number of targets: 1
> UUID: mpath-3600a0b800048ead00000070c4b2a66ee
> # dmsetup info sossan5
> Name:              sossan5
> State:             ACTIVE
> Read Ahead:        256
> Tables present:    LIVE
> Open count:        8
> Event number:      3
> Major, minor:      253, 4
> Number of targets: 1
> UUID: mpath-3600a0b800048eac2000008c34b2a6961
> 
> Note the "Open Count" is 8 and not 0 !? How do i find out what is
> keeping these resources busy?
> 
> I am pretty sure a reboot would fix this, maybe even a brute force
> removal of the underlying sdX devices, but as this is a production
> system I would rather find the "right way"?
> 
> Versions:
> 
> # uname -a
> Linux otsvm02 2.6.18-164.el5xen #1 SMP Tue Aug 18 15:59:52 EDT 2009
> x86_64 x86_64 x86_64 GNU/Linux
> # cat /etc/redhat-release 
> Red Hat Enterprise Linux Server release 5.4 (Tikanga)
> # rpm -q device-mapper
> device-mapper-1.02.32-1.el5
> # dmsetup version
> Library version:   1.02.32 (2009-05-21)
> Driver version:    4.11.5
> 
> Ideas?
> 
> Thanks,
> Kevin
> 
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
