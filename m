From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: multipath and StorageWorks HSG80
Date: Thu, 20 Apr 2006 22:07:50 +0200
Message-ID: <4447EA16.9070708@free.fr>
References: <20060420194321.GE29759@ingress.sbb.uvm.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060420194321.GE29759@ingress.sbb.uvm.edu>
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

Steve Feehan a =E9crit :
> Hello. I'm trying to figure out multipath on a StorageWorks HSG80
> contoller. I'm using Ubuntu "Dapper" with the following software
> versions:
>
>   kernel:           2.6.15-20-server
>   multipath-tools:  0.4.7-1ubuntu4
>
> >From what I've been reading[1], I gather that I need to use the
> dm-hp-sw kernel module. So I applied the patches[2,3,4,5] to
> the kernel and setup the /etc/multipath.conf as follows:
>
> devices {
>
>         device {
>                 vendor                  "DEC"
>                 product                 "HSG80"
>                 path_grouping_policy    group_by_serial
>                 path_checker            hp_sw
>                 features                "1 queue_if_no_path"
>                 hardware_handler        "1 hp_sw"
>         }
> }
>
> multipaths {
>         multipath {
>                 wwid    60001fe10015bf500009947159810015
>                 alias   red
>         }
> }
>
> >From what I can tell, it is basically working:
>
> sfeehan@dogwood:~$ sudo multipath -ll
> red (360001fe10015bf500009947159810015)
> [size=3D203 GB][features=3D1 queue_if_no_path][hwhandler=3D1 hp_sw]
> \_ round-robin 0 [prio=3D2][active]
>  \_ 0:0:0:1 sda 8:0   [active][ready]
>  \_ 0:0:1:1 sdb 8:16  [active][ready]
> \_ round-robin 0 [prio=3D2][enabled]
>  \_ 0:0:2:1 sdc 8:32  [active][ghost]
>  \_ 0:0:3:1 sdd 8:48  [active][ghost]
>
>
> And now the problem: I see quite a few errors in dmesg:
>
>
> [42949392.230000] sd 0:0:2:1: Device not ready.
> [42949392.230000] end_request: I/O error, dev sdc, sector 426583424
> [42949392.230000] printk: 515 messages suppressed.
> [42949392.230000] Buffer I/O error on device sdc, logical block
> 213291712
> [42949392.230000] sd 0:0:2:1: Device not ready.
> [42949392.230000] end_request: I/O error, dev sdc, sector 426583424
> [42949392.230000] sd 0:0:3:1: Device not ready.
> [42949392.230000] end_request: I/O error, dev sdd, sector 426583424
> [42949392.230000] sd 0:0:3:1: Device not ready.
> [42949392.230000] end_request: I/O error, dev sdd, sector 426583424
>
>
> And when I put LVM on top of the multipath device I get lots
> of errors:
>
> sfeehan@dogwood:~$ sudo pvcreate /dev/mapper/red
>   Physical volume "/dev/mapper/red" successfully created
> sfeehan@dogwood:~$ sudo vgcreate vg0 /dev/mapper/red
>   Found duplicate PV qDhK4gPTGtzXAm7jPQf0uf07a0FQs2qL: using /dev/sdb1
> not /dev/sda1
>   /dev/sdc: read failed after 0 of 2048 at 0: Input/output error
>   /dev/sdd: read failed after 0 of 2048 at 0: Input/output error
>   Found duplicate PV qDhK4gPTGtzXAm7jPQf0uf07a0FQs2qL: using /dev/sda1
> not /dev/sdb1
>   Found duplicate PV qDhK4gPTGtzXAm7jPQf0uf07a0FQs2qL: using /dev/sdb1
> not /dev/sda1
>   /dev/sdc: read failed after 0 of 1024 at 0: Input/output error
>   /dev/sdc: read failed after 0 of 2048 at 0: Input/output error
>   /dev/sdd: read failed after 0 of 1024 at 0: Input/output error
>   /dev/sdd: read failed after 0 of 2048 at 0: Input/output error
>   Volume group "vg0" successfully created
> sfeehan@dogwood:~$
> sfeehan@dogwood:~$
> sfeehan@dogwood:~$ sudo lvcreate -L 10G -n test vg0
>   Found duplicate PV qDhK4gPTGtzXAm7jPQf0uf07a0FQs2qL: using /dev/sdb1
> not /dev/sda1
>   /dev/sdc: read failed after 0 of 2048 at 0: Input/output error
>   /dev/sdd: read failed after 0 of 2048 at 0: Input/output error
>   Logical volume "test" created
> sfeehan@dogwood:~$
>
>
> So... what are the errors about? Are they significant? What
> if anything can I do to resolve them?
>
> Thanks.
>
> Steve
>
>
> [1] [dm-devel] StorageWorks multipath support
>     http://www.redhat.com/archives/dm-devel/2005-June/msg00105.html
>
> [2] [dm-devel] [PATCH RFT/RFC 1/4] export block layer helpers
>     http://www.redhat.com/archives/dm-devel/2005-September/msg00097.htm=
l
>
> [3] [dm-devel] [PATCH RFT/RFC 2/4] add dm_scsi helpers
>     http://www.redhat.com/archives/dm-devel/2005-September/msg00098.htm=
l
>
> [4] [dm-devel] [PATCH RFT/RFC 3/4] convert dm emc
>     http://www.redhat.com/archives/dm-devel/2005-September/msg00099.htm=
l
>
> [5] [dm-devel] [PATCH RFT/RFC 4/4] add dm-hp-sw hw handler
>     http://www.redhat.com/archives/dm-devel/2005-September/msg00100.htm=
l
>
>  =20
Overall, that's very good howto material, if you care to feed the wiki.

The IO errors are due to lvm tools trying to scan the individual paths,=20
including those not usable, where they should only care about the=20
multipath devices.

You should blacklist the individual path in the lvm config.


Regards,
cvaroqui
