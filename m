From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Problems with multipathing
Date: Tue, 18 Apr 2006 06:47:58 +0200
Message-ID: <44446F7E.2060502@free.fr>
References: <443BF12E.50900@ludd.luth.se>	<443BF87A.10804@free.fr>	<443C19E6.8000607@ludd.luth.se>	<443E870E.1070902@ludd.luth.se>	<443EB907.1070600@free.fr>	<4442E2ED.7020405@ludd.luth.se>	<4443635F.5000401@free.fr>
	<4443A390.5010005@ludd.luth.se>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4443A390.5010005@ludd.luth.se>
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

Roger H=E5kansson a =E9crit :
> Christophe Varoqui wrote:
>  =20
>> Do failover device nodes get reassigned during the rescan ?
>> Like, for example, a configured path sda gets removed and a new path s=
db
>> appears ?
>>    =20
>
> No, since I don't do a rescan on the bus but just on the target itself.
> When I had the controller in non-hubbed mode and did (when a controller
> has failed) "echo 1> /sys/class/scsi_host/host[1-2]/scan" I got two new
> devices, sde and sdf (I normally havesda,sdb,sdc and sdd)
> But if I instead did "echo 1 >
> /sys/class/scsi_device/[1-2]:0:0:0/device/rescan", I didn't get any new
> devices but the old ones start working again.
> Now, when I have the box in hubbed-mode, I can't seem to get new device=
s
>  even when I do a scsi-host-scan, but just as before, a
> scsi-target-rescan will get my devices back to order again.
>
>  =20
ok.
have you tried sending a START_STOP scsi command (wit sg_start from=20
sg3_utils) to the affect'ed LUN instead of target-rescaning ?
> Also, I've noticed that it's not only when a controller fails that this
> happens, when a failed controller is "revived" the same thing might hap=
pen.
>
> As far as I've been able to tell, the more I/O-transactions at the time
> of the failure, the more likely that the (SCSI) device will be marked a=
s
> "dead".
> If I do "while /bin/true ;do dd if=3D/dev/zero of=3D/mnt/test count=3D2=
0000;
> sleep 1" and fail (or revive) a controller it seems to work in 50% of
> the cases, with 2 sec sleep there is rarely any problem but with no
> sleep at all it fails nearly 100% of the times
> And in all types of tests, if I do a SCSI-target(path) rescan before
> multipath decides both paths are dead, both paths will work again and
> the multipath-device will never fail.
>
>  =20
I see your features still don't include "queue_if_no_path". You seem to=20
really need it.
>> If so, the FC transport class is in charge of the timeout triggering t=
he
>> dead devices removal.
>> A hardware handler wouldn't help here.
>>
>> Can you paste a before/after scsi rescan "multipath -l" output ?
>>
>>    =20
>
> They are identical
>
> [root@asl005 ~]# multipath -l
> mpath1 (3600d0230000000000b01910b4d313400)
> [size=3D97 GB][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 1:0:0:0 sdb 8:16  [active][undef]
>  \_ 2:0:0:0 sdc 8:32  [active][undef]
> [root@asl005 ~]# dmesg |tail -20
> SCSI error : <1 0 0 0> return code =3D 0x20008
> end_request: I/O error, dev sdb, sector 21247352
> end_request: I/O error, dev sdb, sector 21247360
> SCSI error : <1 0 0 0> return code =3D 0x20008
> end_request: I/O error, dev sdb, sector 21036576
> end_request: I/O error, dev sdb, sector 21036584
> Aborting journal on device dm-5.
> ext3_abort called.
> EXT3-fs error (device dm-5): ext3_journal_start_sb: Detected aborted jo=
urnal
> Remounting filesystem read-only
> EXT3-fs error (device dm-5) in start_transaction: Journal has aborted
> __journal_remove_journal_head: freeing b_committed_data
> printk: 254766 messages suppressed.
> Buffer I/O error on device dm-5, logical block 2092209
> lost page write due to I/O error on dm-5
> Buffer I/O error on device dm-5, logical block 2093234
> lost page write due to I/O error on dm-5
> printk: 485 messages suppressed.
> Buffer I/O error on device dm-5, logical block 1
> lost page write due to I/O error on dm-5
> [root@asl005 ~]# multipath -l
> mpath1 (3600d0230000000000b01910b4d313400)
> [size=3D97 GB][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 1:0:0:0 sdb 8:16  [failed][undef]
>  \_ 2:0:0:0 sdc 8:32  [failed][undef]
> [root@asl005 ~]# echo 1 >
> /sys/class/fc_transport/target1\:0\:0/device/1\:0\:0\:0/rescan
> [root@asl005 ~]# multipath -l
> mpath1 (3600d0230000000000b01910b4d313400)
> [size=3D97 GB][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 1:0:0:0 sdb 8:16  [failed][undef]
>  \_ 2:0:0:0 sdc 8:32  [failed][undef]
> [root@asl005 ~]# multipath
> [root@asl005 ~]# multipath -ll
> mpath1 (3600d0230000000000b01910b4d313400)
> [size=3D97 GB][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 1:0:0:0 sdb 8:16  [active][undef]
>  \_ 2:0:0:0 sdc 8:32  [active][undef]
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
>  =20
