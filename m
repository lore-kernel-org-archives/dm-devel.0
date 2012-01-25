From: Fil <lists@internyc.net>
Subject: Re: [PATCH 0/3][RESEND]multipath-tools: mpathpersist
 utility for managing persistent reservation on dm multipath device.
Date: Wed, 25 Jan 2012 10:42:11 -0500
Message-ID: <4F2022D3.2070609@internyc.net>
References: <EE2129A8E578DC4E94D643D6C1C1C67D07D9B409@BTCMVEXC2-PRD.hq.netapp.com>
	<4F197EEB.3050805@internyc.net>
	<F200AD42A082BC4088B232D13A916A89E24A@SACEXCMBX02-PRD.hq.netapp.com>
	<4F1E4785.7010806@internyc.net>
	<F200AD42A082BC4088B232D13A916A89EA01@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <F200AD42A082BC4088B232D13A916A89EA01@SACEXCMBX02-PRD.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@netapp.com>, "Moger,
	Babu" <Babu.Moger@netapp.com>, "Stankey,
	Robert" <Robert.Stankey@netapp.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Here is the info you requested.

thanks
fil

On 01/25/2012 02:45 AM, Chauhan, Vijay wrote:
> On January 24, 2012, Fil Wrote:
>>
>> 1. Patches apply against the 63704387009443bdb37d9deaaafa9ab121d45bfb
>> without any problems. Everything builds correctly (tested it on centos
>> 6.2 and fedora 16).
>>
>> 2. multipathd runs correctly.
>>
> =

> Fil, Thanks for the update. Good to know.
> =

>> 3. mpathpersist is missing --no-inquiry option. It would be nice to be
>> compatible with  sg_persist. (breaks most of my test scripts.)
>>
>> 4. mpathpersist -d /dev/mapper/blah --in --read-status
>> mpathpersist: unrecognized option '--read-status'
>> unrecognised switch code 0x3f ??
>>
> =

> There is a typo in usage output. Please use --read-full-status instead. I=
 will correct it. =


still no go...

mpathpersist -d /dev/mapper/blah --in --read-full-status
Persistent Reserve IN command failed
mpathpersist -d /dev/mapper/blah --in --read-full-status -v3
Jan 25 10:32:37 | alias =3D blah
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
Jan 25 10:32:37 | sda: mask =3D 0x5
Jan 25 10:32:37 | sda: dev_t =3D 8:0
Jan 25 10:32:37 | sda: size =3D 20971520
Jan 25 10:32:37 | sda: vendor =3D QNAP
Jan 25 10:32:37 | sda: product =3D iSCSI Storage
Jan 25 10:32:37 | sda: rev =3D 3.1
Jan 25 10:32:37 | sda: h:b:t:l =3D 16:0:0:0
Jan 25 10:32:37 | sda: tgt_node_name =3D
iqn.2004-04.com.qnap:ts-459proii:iscsi.blah.cb4d16
Jan 25 10:32:37 | sda: path state =3D running
Jan 25 10:32:37 | sda: get_state
Jan 25 10:32:37 | loading /lib64/multipath/libcheckdirectio.so checker
Jan 25 10:32:37 | sda: path checker =3D directio (controller setting)
Jan 25 10:32:37 | sda: checker timeout =3D 30000 ms (sysfs setting)
Jan 25 10:32:37 | directio: starting new request
Jan 25 10:32:37 | directio: io finished 4096/0
Jan 25 10:32:37 | sda: state =3D up
Jan 25 10:32:37 | dm-4: device node name blacklisted
Jan 25 10:32:37 | sdb: not found in pathvec
Jan 25 10:32:37 | sdb: mask =3D 0x5
Jan 25 10:32:37 | sdb: dev_t =3D 8:16
Jan 25 10:32:37 | sdb: size =3D 20971520
Jan 25 10:32:37 | sdb: vendor =3D QNAP
Jan 25 10:32:37 | sdb: product =3D iSCSI Storage
Jan 25 10:32:37 | sdb: rev =3D 3.1
Jan 25 10:32:37 | sdb: h:b:t:l =3D 17:0:0:0
Jan 25 10:32:37 | sdb: tgt_node_name =3D
iqn.2004-04.com.qnap:ts-459proii:iscsi.blah.cb4d16
Jan 25 10:32:37 | sdb: path state =3D running
Jan 25 10:32:37 | sdb: get_state
Jan 25 10:32:37 | sdb: path checker =3D directio (controller setting)
Jan 25 10:32:37 | sdb: checker timeout =3D 30000 ms (sysfs setting)
Jan 25 10:32:37 | directio: starting new request
Jan 25 10:32:37 | directio: io finished 18446744073709551611/0
Jan 25 10:32:37 | sdb: state =3D down
Jan 25 10:32:37 | sdb: checker msg is "directio checker reports path is
down"
Jan 25 10:32:37 | params =3D 0 0 1 1 round-robin 0 2 1 8:0 1 8:16 1
Jan 25 10:32:37 | status =3D 2 0 0 0 1 1 A 0 2 0 8:0 A 0 8:16 F 2
Jan 25 10:32:37 | blah: disassemble map [0 0 1 1 round-robin 0 2 1 8:0 1
8:16 1 ]
Jan 25 10:32:37 | sda: mask =3D 0x8
Jan 25 10:32:37 | sda: path state =3D running
Jan 25 10:32:37 | loading /lib64/multipath/libprioconst.so prioritizer
Jan 25 10:32:37 | sda: prio =3D const (internal default)
Jan 25 10:32:37 | sda: prio =3D  (internal default)
Jan 25 10:32:37 | sda: const prio =3D 1
Jan 25 10:32:37 | sdb: mask =3D 0x8
Jan 25 10:32:37 | sdb: path state =3D running
Jan 25 10:32:37 | sdb: prio =3D const (internal default)
Jan 25 10:32:37 | sdb: prio =3D  (internal default)
Jan 25 10:32:37 | sdb: const prio =3D 1
Jan 25 10:32:37 | blah: disassemble status [2 0 0 0 1 1 A 0 2 0 8:0 A 0
8:16 F 2 ]
Jan 25 10:32:37 | 36001405c55fc03cd8193d491eda0d4d7: sending pr in
command to sda
Jan 25 10:32:37 | sda: duration =3D 2 (ms)
Jan 25 10:32:37 | sda: status driver:00 host:04 scsi:00
Jan 25 10:32:37 | directio checker refcount 2
Jan 25 10:32:37 | directio checker refcount 1
Persistent Reserve IN command failed
Jan 25 10:32:37 | unloading const prioritizer
Jan 25 10:32:37 | unloading directio checker

> =

>> 5. registration works
>>
>> 6. reservation, reserves only a single path. (is this by design?)
> =

> Yes, this is as per design. Reservation is sent to one of the active =

> path and reservation is applicable to registered I_T nexus with respect t=
o pr type.
> =

> I was expecting your device server to  apply reservation to all the =

> registered I_T nexus for pr type "Exclusive Access, all registrants". Can=
 you verify the below output again?
> =

> Please see below in SPC4
> "For a persistent reservation of the type Write Exclusive =96 All Registr=
ants or Exclusive Access =96 All Registrants,
> the persistent reservation holder is any registered I_T nexus;" =

> =

>> mpathpersist --out --reserve --param-rk=3D123abc --prout-type=3D8 -d
>> /dev/mapper/blah
>>
>> sg_persist -i -s /dev/mapper/blah
>>  QNAP      iSCSI Storage     3.1
>>  Peripheral device type: disk
>>  PR generation=3D0x8
>>    Key=3D0x123abc
>>      All target ports bit clear
>>      Relative port address: 0x1
>>      not reservation holder
>>      Transport Id of initiator:
>>        iSCSI name and session id: iqn.2009-
>> 11.com.adriaticsolutions:blah
>>    Key=3D0x123abc
>>      All target ports bit clear
>>      Relative port address: 0x1
>>      << Reservation holder >>
>>      scope: LU_SCOPE,  type: Exclusive Access, all registrants
>>      Transport Id of initiator:
>>        iSCSI name and session id: iqn.2009-
>> 11.com.adriaticsolutions:blah
>>
>> multipath -ll
>> blah (36001405c55fc03cd8193d491eda0d4d7) dm-4 QNAP,iSCSI Storage
>> size=3D10G features=3D'0' hwhandler=3D'0' wp=3Drw
>> `-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
>>  |- 16:0:0:0 sda 8:0  active ready  running
>>  `- 17:0:0:0 sdb 8:16 failed faulty running
>>
>> 7. mpathpersist -d /dev/mapper/blah --in --read-reservation
>> Persistent Reserve IN command failed
>>
> Can you please share the output with verbose 3. Append '-v3'.


mpathpersist -d /dev/mapper/blah --in --read-reservation
Persistent Reserve IN command failed
mpathpersist -d /dev/mapper/blah --in --read-reservation -v3
Jan 25 10:34:07 | alias =3D blah
Jan 25 10:34:07 | ram0: device node name blacklisted
Jan 25 10:34:07 | ram1: device node name blacklisted
Jan 25 10:34:07 | ram2: device node name blacklisted
Jan 25 10:34:07 | ram3: device node name blacklisted
Jan 25 10:34:07 | ram4: device node name blacklisted
Jan 25 10:34:07 | ram5: device node name blacklisted
Jan 25 10:34:07 | ram6: device node name blacklisted
Jan 25 10:34:07 | ram7: device node name blacklisted
Jan 25 10:34:07 | ram8: device node name blacklisted
Jan 25 10:34:07 | ram9: device node name blacklisted
Jan 25 10:34:07 | ram10: device node name blacklisted
Jan 25 10:34:07 | ram11: device node name blacklisted
Jan 25 10:34:07 | ram12: device node name blacklisted
Jan 25 10:34:07 | ram13: device node name blacklisted
Jan 25 10:34:07 | ram14: device node name blacklisted
Jan 25 10:34:07 | ram15: device node name blacklisted
Jan 25 10:34:07 | loop0: device node name blacklisted
Jan 25 10:34:07 | loop1: device node name blacklisted
Jan 25 10:34:07 | loop2: device node name blacklisted
Jan 25 10:34:07 | loop3: device node name blacklisted
Jan 25 10:34:07 | loop4: device node name blacklisted
Jan 25 10:34:07 | loop5: device node name blacklisted
Jan 25 10:34:07 | loop6: device node name blacklisted
Jan 25 10:34:07 | loop7: device node name blacklisted
Jan 25 10:34:07 | vda: device node name blacklisted
Jan 25 10:34:07 | dm-0: device node name blacklisted
Jan 25 10:34:07 | dm-1: device node name blacklisted
Jan 25 10:34:07 | dm-2: device node name blacklisted
Jan 25 10:34:07 | dm-3: device node name blacklisted
Jan 25 10:34:07 | sda: not found in pathvec
Jan 25 10:34:07 | sda: mask =3D 0x5
Jan 25 10:34:07 | sda: dev_t =3D 8:0
Jan 25 10:34:07 | sda: size =3D 20971520
Jan 25 10:34:07 | sda: vendor =3D QNAP
Jan 25 10:34:07 | sda: product =3D iSCSI Storage
Jan 25 10:34:07 | sda: rev =3D 3.1
Jan 25 10:34:07 | sda: h:b:t:l =3D 16:0:0:0
Jan 25 10:34:07 | sda: tgt_node_name =3D
iqn.2004-04.com.qnap:ts-459proii:iscsi.blah.cb4d16
Jan 25 10:34:07 | sda: path state =3D running
Jan 25 10:34:07 | sda: get_state
Jan 25 10:34:07 | loading /lib64/multipath/libcheckdirectio.so checker
Jan 25 10:34:07 | sda: path checker =3D directio (controller setting)
Jan 25 10:34:07 | sda: checker timeout =3D 30000 ms (sysfs setting)
Jan 25 10:34:07 | directio: starting new request
Jan 25 10:34:07 | directio: io finished 4096/0
Jan 25 10:34:07 | sda: state =3D up
Jan 25 10:34:07 | dm-4: device node name blacklisted
Jan 25 10:34:07 | sdb: not found in pathvec
Jan 25 10:34:07 | sdb: mask =3D 0x5
Jan 25 10:34:07 | sdb: dev_t =3D 8:16
Jan 25 10:34:07 | sdb: size =3D 20971520
Jan 25 10:34:07 | sdb: vendor =3D QNAP
Jan 25 10:34:07 | sdb: product =3D iSCSI Storage
Jan 25 10:34:07 | sdb: rev =3D 3.1
Jan 25 10:34:07 | sdb: h:b:t:l =3D 17:0:0:0
Jan 25 10:34:07 | sdb: tgt_node_name =3D
iqn.2004-04.com.qnap:ts-459proii:iscsi.blah.cb4d16
Jan 25 10:34:07 | sdb: path state =3D running
Jan 25 10:34:07 | sdb: get_state
Jan 25 10:34:07 | sdb: path checker =3D directio (controller setting)
Jan 25 10:34:07 | sdb: checker timeout =3D 30000 ms (sysfs setting)
Jan 25 10:34:07 | directio: starting new request
Jan 25 10:34:07 | directio: io finished 18446744073709551611/0
Jan 25 10:34:07 | sdb: state =3D down
Jan 25 10:34:07 | sdb: checker msg is "directio checker reports path is
down"
Jan 25 10:34:07 | params =3D 0 0 1 1 round-robin 0 2 1 8:0 1 8:16 1
Jan 25 10:34:07 | status =3D 2 0 0 0 1 1 A 0 2 0 8:0 A 0 8:16 F 2
Jan 25 10:34:07 | blah: disassemble map [0 0 1 1 round-robin 0 2 1 8:0 1
8:16 1 ]
Jan 25 10:34:07 | sda: mask =3D 0x8
Jan 25 10:34:07 | sda: path state =3D running
Jan 25 10:34:07 | loading /lib64/multipath/libprioconst.so prioritizer
Jan 25 10:34:07 | sda: prio =3D const (internal default)
Jan 25 10:34:07 | sda: prio =3D  (internal default)
Jan 25 10:34:07 | sda: const prio =3D 1
Jan 25 10:34:07 | sdb: mask =3D 0x8
Jan 25 10:34:07 | sdb: path state =3D running
Jan 25 10:34:07 | sdb: prio =3D const (internal default)
Jan 25 10:34:07 | sdb: prio =3D  (internal default)
Jan 25 10:34:07 | sdb: const prio =3D 1
Jan 25 10:34:07 | blah: disassemble status [2 0 0 0 1 1 A 0 2 0 8:0 A 0
8:16 F 2 ]
Jan 25 10:34:07 | 36001405c55fc03cd8193d491eda0d4d7: sending pr in
command to sda
Jan 25 10:34:07 | sda: duration =3D 1 (ms)
Jan 25 10:34:07 | sda: status driver:00 host:04 scsi:00
Jan 25 10:34:07 | directio checker refcount 2
Jan 25 10:34:07 | directio checker refcount 1
Persistent Reserve IN command failed
Jan 25 10:34:07 | unloading const prioritizer
Jan 25 10:34:07 | unloading directio checker

> =

>> 8. release 'fails' because reservation registered only a single path and
>> the other one is in a failed state.
>>
>> mpathpersist -d /dev/mapper/blah --out --release --param-rk=3D123abc
>> --prout-type=3D8
>> Jan 24 00:43:53 | 36001405c55fc03cd8193d491eda0d4d7: pr in read
>> reservation command failed.
>> PR out: command failed
>>
> As per design, release service action performs following steps: =

> Step 1) PROUT 'release' SA is sent on the all paths of the multipath devi=
ce as it is not clear which data path is reservation holder.
> STEP 2) PRIN read reservation SA is sent to one of the active path to ver=
ify the reservation.
> STEP 3) If the Read Reservation parameter data indicates that the logical=
 unit is still reserved then this indicates that the reservation holder bel=
ongs to a data path in failed state or removed data path of the multipath d=
evice, continue else goto step 7
> STEP 4) PRIN Report Full Status  service action is issued to any active d=
ata path. Full status descriptors are saved.
> STEP 5) PROUT clear reservation service action is sent via any active dat=
a path to clear the reservation and
> Registrants
> STEP 6) all registrants are restored by issuing PROUT register service ac=
tion with transport IDs from the full status
> descriptors saved in the step 4
> STEP 7) exit with status
> =

> It looks like you are getting into some other issue. Can you please share=
 the output with verbose with '-v3'.


mpathpersist -d /dev/mapper/blah --out --release --param-rk=3D123abc
--prout-type=3D8 -v3
Jan 25 10:35:41 | alias =3D blah
Jan 25 10:35:41 | ram0: device node name blacklisted
Jan 25 10:35:41 | ram1: device node name blacklisted
Jan 25 10:35:41 | ram2: device node name blacklisted
Jan 25 10:35:41 | ram3: device node name blacklisted
Jan 25 10:35:41 | ram4: device node name blacklisted
Jan 25 10:35:41 | ram5: device node name blacklisted
Jan 25 10:35:41 | ram6: device node name blacklisted
Jan 25 10:35:41 | ram7: device node name blacklisted
Jan 25 10:35:41 | ram8: device node name blacklisted
Jan 25 10:35:41 | ram9: device node name blacklisted
Jan 25 10:35:41 | ram10: device node name blacklisted
Jan 25 10:35:41 | ram11: device node name blacklisted
Jan 25 10:35:41 | ram12: device node name blacklisted
Jan 25 10:35:41 | ram13: device node name blacklisted
Jan 25 10:35:41 | ram14: device node name blacklisted
Jan 25 10:35:41 | ram15: device node name blacklisted
Jan 25 10:35:41 | loop0: device node name blacklisted
Jan 25 10:35:41 | loop1: device node name blacklisted
Jan 25 10:35:41 | loop2: device node name blacklisted
Jan 25 10:35:41 | loop3: device node name blacklisted
Jan 25 10:35:41 | loop4: device node name blacklisted
Jan 25 10:35:41 | loop5: device node name blacklisted
Jan 25 10:35:41 | loop6: device node name blacklisted
Jan 25 10:35:41 | loop7: device node name blacklisted
Jan 25 10:35:41 | vda: device node name blacklisted
Jan 25 10:35:41 | dm-0: device node name blacklisted
Jan 25 10:35:41 | dm-1: device node name blacklisted
Jan 25 10:35:41 | dm-2: device node name blacklisted
Jan 25 10:35:41 | dm-3: device node name blacklisted
Jan 25 10:35:41 | sda: not found in pathvec
Jan 25 10:35:41 | sda: mask =3D 0x5
Jan 25 10:35:41 | sda: dev_t =3D 8:0
Jan 25 10:35:41 | sda: size =3D 20971520
Jan 25 10:35:41 | sda: vendor =3D QNAP
Jan 25 10:35:41 | sda: product =3D iSCSI Storage
Jan 25 10:35:41 | sda: rev =3D 3.1
Jan 25 10:35:41 | sda: h:b:t:l =3D 16:0:0:0
Jan 25 10:35:41 | sda: tgt_node_name =3D
iqn.2004-04.com.qnap:ts-459proii:iscsi.blah.cb4d16
Jan 25 10:35:41 | sda: path state =3D running
Jan 25 10:35:41 | sda: get_state
Jan 25 10:35:41 | loading /lib64/multipath/libcheckdirectio.so checker
Jan 25 10:35:41 | sda: path checker =3D directio (controller setting)
Jan 25 10:35:41 | sda: checker timeout =3D 30000 ms (sysfs setting)
Jan 25 10:35:41 | directio: starting new request
Jan 25 10:35:41 | directio: io finished 4096/0
Jan 25 10:35:41 | sda: state =3D up
Jan 25 10:35:41 | dm-4: device node name blacklisted
Jan 25 10:35:41 | sdb: not found in pathvec
Jan 25 10:35:41 | sdb: mask =3D 0x5
Jan 25 10:35:41 | sdb: dev_t =3D 8:16
Jan 25 10:35:41 | sdb: size =3D 20971520
Jan 25 10:35:41 | sdb: vendor =3D QNAP
Jan 25 10:35:41 | sdb: product =3D iSCSI Storage
Jan 25 10:35:41 | sdb: rev =3D 3.1
Jan 25 10:35:41 | sdb: h:b:t:l =3D 17:0:0:0
Jan 25 10:35:41 | sdb: tgt_node_name =3D
iqn.2004-04.com.qnap:ts-459proii:iscsi.blah.cb4d16
Jan 25 10:35:41 | sdb: path state =3D running
Jan 25 10:35:41 | sdb: get_state
Jan 25 10:35:41 | sdb: path checker =3D directio (controller setting)
Jan 25 10:35:41 | sdb: checker timeout =3D 30000 ms (sysfs setting)
Jan 25 10:35:41 | directio: starting new request
Jan 25 10:35:41 | directio: io finished 18446744073709551611/0
Jan 25 10:35:41 | sdb: state =3D down
Jan 25 10:35:41 | sdb: checker msg is "directio checker reports path is
down"
Jan 25 10:35:41 | params =3D 0 0 1 1 round-robin 0 2 1 8:0 1 8:16 1
Jan 25 10:35:41 | status =3D 2 0 0 0 1 1 A 0 2 0 8:0 A 0 8:16 F 2
Jan 25 10:35:41 | blah: disassemble map [0 0 1 1 round-robin 0 2 1 8:0 1
8:16 1 ]
Jan 25 10:35:41 | sda: mask =3D 0x8
Jan 25 10:35:41 | sda: path state =3D running
Jan 25 10:35:41 | loading /lib64/multipath/libprioconst.so prioritizer
Jan 25 10:35:41 | sda: prio =3D const (internal default)
Jan 25 10:35:41 | sda: prio =3D  (internal default)
Jan 25 10:35:41 | sda: const prio =3D 1
Jan 25 10:35:41 | sdb: mask =3D 0x8
Jan 25 10:35:41 | sdb: path state =3D running
Jan 25 10:35:41 | sdb: prio =3D const (internal default)
Jan 25 10:35:41 | sdb: prio =3D  (internal default)
Jan 25 10:35:41 | sdb: const prio =3D 1
Jan 25 10:35:41 | blah: disassemble status [2 0 0 0 1 1 A 0 2 0 8:0 A 0
8:16 F 2 ]
Jan 25 10:35:41 | blah: reservation_key  =3D 0x123abc (config file default)
Jan 25 10:35:41 |  path count =3D 0
Jan 25 10:35:41 | rq_servact=3D2
Jan 25 10:35:41 | rq_scope=3D0
Jan 25 10:35:41 | rq_type=3D8
Jan 25 10:35:41 | noisy=3D1
Jan 25 10:35:41 | status=3D-1
Jan 25 10:35:41 | 36001405c55fc03cd8193d491eda0d4d7: sending pr out
command to sda
Jan 25 10:35:41 | 36001405c55fc03cd8193d491eda0d4d7: sdb path not up.
Jan 25 10:35:41 | sda: rq_servact =3D 2
Jan 25 10:35:41 | sda: rq_scope =3D 0
Jan 25 10:35:41 | sda: rq_type =3D 8
Jan 25 10:35:41 | sda: paramlen =3D 24
Jan 25 10:35:41 | sda: Persistent Reservation OUT parameter:
Jan 25 10:35:41 |         00 00 00 00 00 12 3a bc  00 00 00 00 00 00 00
00
Jan 25 10:35:41 |         00 00 00 00 00 00 00 00
Jan 25 10:35:41 | sda: Duration=3D1 (ms)
Jan 25 10:35:41 | sda: status driver:00 host:00 scsi:00
Jan 25 10:35:41 | sda: status =3D 0
Jan 25 10:35:41 | 36001405c55fc03cd8193d491eda0d4d7: sending pr in
command to sda
Jan 25 10:35:41 | sda: duration =3D 1 (ms)
Jan 25 10:35:41 | sda: status driver:08 host:00 scsi:02
Jan 25 10:35:41 | sda: Sense_Key=3D06, ASC=3D00 ASCQ=3D00
Jan 25 10:35:41 | sda: retrying for Unit Attention. Remaining retries =3D 4
Jan 25 10:35:41 | sda: duration =3D 0 (ms)
Jan 25 10:35:41 | sda: status driver:00 host:04 scsi:00
Jan 25 10:35:41 | 36001405c55fc03cd8193d491eda0d4d7: pr in read
reservation command failed.
Jan 25 10:35:41 | directio checker refcount 2
Jan 25 10:35:41 | directio checker refcount 1
PR out: command failed
Jan 25 10:35:41 | unloading const prioritizer
Jan 25 10:35:41 | unloading directio checker

> =

>> 9. de-registration works....
>>
>> I haven't had time to test path fail over and weird cases when multiple
>> nodes try to do destructive things to the shared luns...
>>
>> thanks
>> fil
>>
>> On 01/23/2012 11:09 PM, Chauhan, Vijay wrote:
>>> Thanks for these info Fil.  Can you please also share your feedback on
>> your in-depth testing.
>>>
>>> I appreciate your effort.
>>>
>>> On January 20, 2012, Fil wrote:
>>>> Thanks for the patches Vijay,
>>>>
>>>> I tested the new set of patches against the git repo, and it applied
>>>> cleanly compiled and is running as expected. I will do more indepth
>>>> testing over the weekend.
> =

> Thanks for your detailed testing.
> =

> Thanks and regards,
> Vijay
> =
