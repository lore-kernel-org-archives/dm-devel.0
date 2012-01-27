From: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Subject: Re: [PATCH 0/3][RESEND]multipath-tools: mpathpersist
 utility for managing persistent reservation on dm multipath device.
Date: Fri, 27 Jan 2012 13:06:13 +0000
Message-ID: <F200AD42A082BC4088B232D13A916A89FF8E@SACEXCMBX02-PRD.hq.netapp.com>
References: <EE2129A8E578DC4E94D643D6C1C1C67D07D9B409@BTCMVEXC2-PRD.hq.netapp.com>
	<4F197EEB.3050805@internyc.net>
	<F200AD42A082BC4088B232D13A916A89E24A@SACEXCMBX02-PRD.hq.netapp.com>
	<4F1E4785.7010806@internyc.net>
	<F200AD42A082BC4088B232D13A916A89EA01@SACEXCMBX02-PRD.hq.netapp.com>
	<4F2022D3.2070609@internyc.net>
	<F200AD42A082BC4088B232D13A916A89EC06@SACEXCMBX02-PRD.hq.netapp.com>
	<4F206C34.4030401@internyc.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4F206C34.4030401@internyc.net>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Fil <lists@internyc.net>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@netapp.com>, "Moger,
	Babu" <Babu.Moger@netapp.com>, "christophe.varoqui@free.fr" <christophe.varoqui@free.fr>, "Stankey, Robert" <Robert.Stankey@netapp.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thursday, January 26, 2012 2:25 AM; Fil Wrote:
>here is an output of mpathpersist vs sg_persist
>
>[root@rhc-node3 ~]# mpathpersist -d /dev/mapper/blah --in --read-full-
>status
>Persistent Reserve IN command failed
>[root@rhc-node3 ~]# sg_persist -d /dev/mapper/blah --in --read-full-
>status
>  QNAP      iSCSI Storage     3.1
>  Peripheral device type: disk
>  PR generation=0xc
>    Key=0x123abc
>      All target ports bit clear
>      Relative port address: 0x1
>      not reservation holder
>      Transport Id of initiator:
>        iSCSI name and session id: iqn.2009-
>11.com.adriaticsolutions:blah
>    Key=0x123abc
>      All target ports bit clear
>      Relative port address: 0x1
>      << Reservation holder >>
>      scope: LU_SCOPE,  type: Exclusive Access, all registrants
>      Transport Id of initiator:
>        iSCSI name and session id: iqn.2009-
>11.com.adriaticsolutions:blah

Can you share the output with verbose:
* mpathpersist -d /dev/mapper/blah --in --read-full-status -v3

> 2. DID_BAD_TARGET host status is because I have reserved my multipathed
>lun and now one of the paths is in a failed state, so mpathpersist is
>failing on that path. read 4 examples below....
>
Again, your assumption is not correct here. DID_BAD_TARGET(hostbyte=0x04)
status is not something dm multipath driver or mpathpersist utility 
sets in hostbyte for sense. It is set by lower layer driver.

Output log's recital - 'blah' mpath device had two paths sda and sdb. 
sda was in active state where as sdb was in failed state. 
mpathpersist selected sda (active path) for sending pr in command.  
PR in command failed with hostbyte=DID_BAD_TARGET in lower layer. 
mpathpersist reported the command as failed.

Let me know where I missed anything in understanding your log? 

Also see same details step by step in the output log provided by you:
mpathpersist -d /dev/mapper/blah --in --read-full-status
Persistent Reserve IN command failed
mpathpersist -d /dev/mapper/blah --in --read-full-status -v3
Jan 25 10:32:37 | alias = blah
Jan 25 10:32:37 | ram0: device node name blacklisted
Jan 25 10:32:37 | ram1: device node name blacklisted
Jan 25 10:32:37 | ram2: device node name blacklisted
Jan 25 10:32:37 | ram3: device node name blacklisted
Jan 25 10:32:37 | ram4: device node name blacklisted
Jan 25 10:32:37 | ram5: device node name blacklisted
Jan 25 10:32:37 | ram6: device node name blacklisted
Jan 25 10:32:37 | ram7: device node name blacklisted
Jan 25 10:32:37 | ram8: device node name blacklisted
Jan 25 10:32:37 | ram9: device node name blacklisted
Jan 25 10:32:37 | ram10: device node name blacklisted
Jan 25 10:32:37 | ram11: device node name blacklisted
Jan 25 10:32:37 | ram12: device node name blacklisted
Jan 25 10:32:37 | ram13: device node name blacklisted
Jan 25 10:32:37 | ram14: device node name blacklisted
Jan 25 10:32:37 | ram15: device node name blacklisted
Jan 25 10:32:37 | loop0: device node name blacklisted
Jan 25 10:32:37 | loop1: device node name blacklisted
Jan 25 10:32:37 | loop2: device node name blacklisted
Jan 25 10:32:37 | loop3: device node name blacklisted
Jan 25 10:32:37 | loop4: device node name blacklisted
Jan 25 10:32:37 | loop5: device node name blacklisted
Jan 25 10:32:37 | loop6: device node name blacklisted
Jan 25 10:32:37 | loop7: device node name blacklisted
Jan 25 10:32:37 | vda: device node name blacklisted
Jan 25 10:32:37 | dm-0: device node name blacklisted
Jan 25 10:32:37 | dm-1: device node name blacklisted
Jan 25 10:32:37 | dm-2: device node name blacklisted
Jan 25 10:32:37 | dm-3: device node name blacklisted
Jan 25 10:32:37 | sda: not found in pathvec
Jan 25 10:32:37 | sda: mask = 0x5
Jan 25 10:32:37 | sda: dev_t = 8:0
Jan 25 10:32:37 | sda: size = 20971520
Jan 25 10:32:37 | sda: vendor = QNAP
Jan 25 10:32:37 | sda: product = iSCSI Storage
Jan 25 10:32:37 | sda: rev = 3.1
Jan 25 10:32:37 | sda: h:b:t:l = 16:0:0:0
Jan 25 10:32:37 | sda: tgt_node_name =
iqn.2004-04.com.qnap:ts-459proii:iscsi.blah.cb4d16
Jan 25 10:32:37 | sda: path state = running
Jan 25 10:32:37 | sda: get_state
Jan 25 10:32:37 | loading /lib64/multipath/libcheckdirectio.so checker
Jan 25 10:32:37 | sda: path checker = directio (controller setting)
Jan 25 10:32:37 | sda: checker timeout = 30000 ms (sysfs setting)
Jan 25 10:32:37 | directio: starting new request
Jan 25 10:32:37 | directio: io finished 4096/0
Jan 25 10:32:37 | sda: state = up

--> You have two physical paths for blah, i.e sda and sdb.
--> sda path is currently in active state.

Jan 25 10:32:37 | dm-4: device node name blacklisted
Jan 25 10:32:37 | sdb: not found in pathvec
Jan 25 10:32:37 | sdb: mask = 0x5
Jan 25 10:32:37 | sdb: dev_t = 8:16
Jan 25 10:32:37 | sdb: size = 20971520
Jan 25 10:32:37 | sdb: vendor = QNAP
Jan 25 10:32:37 | sdb: product = iSCSI Storage
Jan 25 10:32:37 | sdb: rev = 3.1
Jan 25 10:32:37 | sdb: h:b:t:l = 17:0:0:0
Jan 25 10:32:37 | sdb: tgt_node_name =
iqn.2004-04.com.qnap:ts-459proii:iscsi.blah.cb4d16
Jan 25 10:32:37 | sdb: path state = running
Jan 25 10:32:37 | sdb: get_state
Jan 25 10:32:37 | sdb: path checker = directio (controller setting)
Jan 25 10:32:37 | sdb: checker timeout = 30000 ms (sysfs setting)
Jan 25 10:32:37 | directio: starting new request
Jan 25 10:32:37 | directio: io finished 18446744073709551611/0
Jan 25 10:32:37 | sdb: state = down
Jan 25 10:32:37 | sdb: checker msg is "directio checker reports path is
down"

--> sdb is currently in failed state.

Jan 25 10:32:37 | params = 0 0 1 1 round-robin 0 2 1 8:0 1 8:16 1
Jan 25 10:32:37 | status = 2 0 0 0 1 1 A 0 2 0 8:0 A 0 8:16 F 2
Jan 25 10:32:37 | blah: disassemble map [0 0 1 1 round-robin 0 2 1 8:0 1
8:16 1 ]
Jan 25 10:32:37 | sda: mask = 0x8
Jan 25 10:32:37 | sda: path state = running
Jan 25 10:32:37 | loading /lib64/multipath/libprioconst.so prioritizer
Jan 25 10:32:37 | sda: prio = const (internal default)
Jan 25 10:32:37 | sda: prio =  (internal default)
Jan 25 10:32:37 | sda: const prio = 1
Jan 25 10:32:37 | sdb: mask = 0x8
Jan 25 10:32:37 | sdb: path state = running
Jan 25 10:32:37 | sdb: prio = const (internal default)
Jan 25 10:32:37 | sdb: prio =  (internal default)
Jan 25 10:32:37 | sdb: const prio = 1
Jan 25 10:32:37 | blah: disassemble status [2 0 0 0 1 1 A 0 2 0 8:0 A 0
8:16 F 2 ]
Jan 25 10:32:37 | 36001405c55fc03cd8193d491eda0d4d7: sending pr in
command to sda

--> Among sda and sdb, mpathpersist finds sda as active path and sends pr in command through it.

Jan 25 10:32:37 | sda: duration = 2 (ms)
Jan 25 10:32:37 | sda: status driver:00 host:04 scsi:00

--> Command returned after 2 ms with hostbyte=0x04. 

Persistent Reserve IN command failed
--> mpathpersist reports error.

>mpathpersist -d /dev/mapper/blah --in --read-reservation
>Persistent Reserve IN command failed
>
>sg_persist -d /dev/mapper/blah --in --read-reservation
>  QNAP      iSCSI Storage     3.1
>  Peripheral device type: disk
>  PR generation=0xd, Reservation follows:
>    Key=0x0
>    scope: LU_SCOPE,  type: Exclusive Access, all registrants
>
>sg_persist -d /dev/sda --in --read-reservation
>  QNAP      iSCSI Storage     3.1
>  Peripheral device type: disk
>  PR generation=0xd, Reservation follows:
>    Key=0x0
>    scope: LU_SCOPE,  type: Exclusive Access, all registrants
>
>sg_persist -d /dev/sdb --in --read-reservation
>  QNAP      iSCSI Storage     3.1
>  Peripheral device type: disk
>persistent reservation in: transport: Host_status=0x11 is invalid
>Driver_status=0x00 [DRIVER_OK, SUGGEST_OK]
>

This is a new issue. One of your path reports "DID_NEXUS_FAILURE". 
For more insight, please share output with verbose:
* mpathpersist -d /dev/mapper/blah --in --read-reservation -v3

Fil, I appreciate your testing effort. I verified all the basic functionality 
before posting it and in your opinion if it still needs to handle 
few special cases and improving error handling then we can always do it. 
I am more interested to know if basic functionality works fine 
and does not break any existing dm feature. And also if it is useful to get it upstream.

Note: Currently, PR command is retried only for unit attention and 02/04/07 in mpathpersist error handler.

Thanks,
Vijay
