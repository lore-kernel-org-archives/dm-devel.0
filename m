From: Fil <lists@internyc.net>
Subject: Re: [PATCH 0/3][RESEND]multipath-tools: mpathpersist
 utility for managing persistent reservation on dm multipath device.
Date: Wed, 25 Jan 2012 15:55:16 -0500
Message-ID: <4F206C34.4030401@internyc.net>
References: <EE2129A8E578DC4E94D643D6C1C1C67D07D9B409@BTCMVEXC2-PRD.hq.netapp.com>
	<4F197EEB.3050805@internyc.net>
	<F200AD42A082BC4088B232D13A916A89E24A@SACEXCMBX02-PRD.hq.netapp.com>
	<4F1E4785.7010806@internyc.net>
	<F200AD42A082BC4088B232D13A916A89EA01@SACEXCMBX02-PRD.hq.netapp.com>
	<4F2022D3.2070609@internyc.net>
	<F200AD42A082BC4088B232D13A916A89EC06@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <F200AD42A082BC4088B232D13A916A89EC06@SACEXCMBX02-PRD.hq.netapp.com>
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

Vijay,

I guess you are not understanding what I am saying.

1. mpathpersist does not work as expected

here is an output of mpathpersist vs sg_persist

[root@rhc-node3 ~]# mpathpersist -d /dev/mapper/blah --in --read-full-status
Persistent Reserve IN command failed
[root@rhc-node3 ~]# sg_persist -d /dev/mapper/blah --in --read-full-status
  QNAP      iSCSI Storage     3.1
  Peripheral device type: disk
  PR generation=3D0xc
    Key=3D0x123abc
      All target ports bit clear
      Relative port address: 0x1
      not reservation holder
      Transport Id of initiator:
        iSCSI name and session id: iqn.2009-11.com.adriaticsolutions:blah
    Key=3D0x123abc
      All target ports bit clear
      Relative port address: 0x1
      << Reservation holder >>
      scope: LU_SCOPE,  type: Exclusive Access, all registrants
      Transport Id of initiator:
        iSCSI name and session id: iqn.2009-11.com.adriaticsolutions:blah


 2. DID_BAD_TARGET host status is because I have reserved my multipathed
lun and now one of the paths is in a failed state, so mpathpersist is
failing on that path. read 4 examples below....

mpathpersist -d /dev/mapper/blah --in --read-reservation
Persistent Reserve IN command failed

sg_persist -d /dev/mapper/blah --in --read-reservation
  QNAP      iSCSI Storage     3.1
  Peripheral device type: disk
  PR generation=3D0xd, Reservation follows:
    Key=3D0x0
    scope: LU_SCOPE,  type: Exclusive Access, all registrants

sg_persist -d /dev/sda --in --read-reservation
  QNAP      iSCSI Storage     3.1
  Peripheral device type: disk
  PR generation=3D0xd, Reservation follows:
    Key=3D0x0
    scope: LU_SCOPE,  type: Exclusive Access, all registrants

sg_persist -d /dev/sdb --in --read-reservation
  QNAP      iSCSI Storage     3.1
  Peripheral device type: disk
persistent reservation in: transport: Host_status=3D0x11 is invalid
Driver_status=3D0x00 [DRIVER_OK, SUGGEST_OK]

PR in: command failed







On 01/25/2012 02:28 PM, Chauhan, Vijay wrote:
> On Wednesday, January 25, 2012 9:12 PM, Fil Wrote:
>> Here is the info you requested.
> =

> Fil, Thanks for the logs.
> =

>> On 01/25/2012 02:45 AM, Chauhan, Vijay wrote:
>>> On January 24, 2012, Fil Wrote:
>>>>
>>>> 1. Patches apply against the 63704387009443bdb37d9deaaafa9ab121d45bfb
>>>> without any problems. Everything builds correctly (tested it on
>> centos
>>>> 6.2 and fedora 16).
>>>>
>>>> 2. multipathd runs correctly.
>>>>
>>>
>>> Fil, Thanks for the update. Good to know.
>>>
>>>> 3. mpathpersist is missing --no-inquiry option. It would be nice to
>> be
>>>> compatible with  sg_persist. (breaks most of my test scripts.)
>>>>
>>>> 4. mpathpersist -d /dev/mapper/blah --in --read-status
>>>> mpathpersist: unrecognized option '--read-status'
>>>> unrecognised switch code 0x3f ??
>>>>
>>>
>>> There is a typo in usage output. Please use --read-full-status
>> instead. I will correct it.
>>
>> still no go...
>>
> =

> It seems issue 4 is resolved with option '--read-full-status'
> =

>> mpathpersist -d /dev/mapper/blah --in --read-full-status
>> Persistent Reserve IN command failed
>> mpathpersist -d /dev/mapper/blah --in --read-full-status -v3
> =

>> Jan 25 10:32:37 | alias =3D blah
>> Jan 25 10:32:37 | 36001405c55fc03cd8193d491eda0d4d7: sending pr in
>> command to sda
>> Jan 25 10:32:37 | sda: duration =3D 2 (ms)
>> Jan 25 10:32:37 | sda: status driver:00 host:04 scsi:00
> =

> PRIN command returned with DID_BAD_TARGET host status. iscsi layer return=
s this when we get some bad output from =

> target. This does not look like issue related to this feature. =

> =

>>>
>>>> 5. registration works
>>>>
>>>> 6. reservation, reserves only a single path. (is this by design?)
>>>
>>> Yes, this is as per design. Reservation is sent to one of the active
>>> path and reservation is applicable to registered I_T nexus with
>> respect to pr type.
>>>
>>> I was expecting your device server to  apply reservation to all the
>>> registered I_T nexus for pr type "Exclusive Access, all registrants".
>> Can you verify the below output again?
>>>
>>> Please see below in SPC4
>>> "For a persistent reservation of the type Write Exclusive =96 All
>> Registrants or Exclusive Access =96 All Registrants,
>>> the persistent reservation holder is any registered I_T nexus;"
>>>
>>>> mpathpersist --out --reserve --param-rk=3D123abc --prout-type=3D8 -d
>>>> /dev/mapper/blah
>>>>
>>>> sg_persist -i -s /dev/mapper/blah
>>>>  QNAP      iSCSI Storage     3.1
>>>>  Peripheral device type: disk
>>>>  PR generation=3D0x8
>>>>    Key=3D0x123abc
>>>>      All target ports bit clear
>>>>      Relative port address: 0x1
>>>>      not reservation holder
>>>>      Transport Id of initiator:
>>>>        iSCSI name and session id: iqn.2009-
>>>> 11.com.adriaticsolutions:blah
>>>>    Key=3D0x123abc
>>>>      All target ports bit clear
>>>>      Relative port address: 0x1
>>>>      << Reservation holder >>
>>>>      scope: LU_SCOPE,  type: Exclusive Access, all registrants
>>>>      Transport Id of initiator:
>>>>        iSCSI name and session id: iqn.2009-
>>>> 11.com.adriaticsolutions:blah
>>>>
>>>> multipath -ll
>>>> blah (36001405c55fc03cd8193d491eda0d4d7) dm-4 QNAP,iSCSI Storage
>>>> size=3D10G features=3D'0' hwhandler=3D'0' wp=3Drw
>>>> `-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
>>>>  |- 16:0:0:0 sda 8:0  active ready  running
>>>>  `- 17:0:0:0 sdb 8:16 failed faulty running
>>>>
>>>> 7. mpathpersist -d /dev/mapper/blah --in --read-reservation
>>>> Persistent Reserve IN command failed
>>>>
>>> Can you please share the output with verbose 3. Append '-v3'.
>>
>>
>> mpathpersist -d /dev/mapper/blah --in --read-reservation
>> Persistent Reserve IN command failed
>> mpathpersist -d /dev/mapper/blah --in --read-reservation -v3
>> Jan 25 10:34:07 | alias =3D blah
> =

>> Jan 25 10:34:07 | 36001405c55fc03cd8193d491eda0d4d7: sending pr in
>> command to sda
>> Jan 25 10:34:07 | sda: duration =3D 1 (ms)
>> Jan 25 10:34:07 | sda: status driver:00 host:04 scsi:00
> =

> Same is with issue 7. PRIN command returned with DID_BAD_TARGET host stat=
us.
> =

>> Jan 25 10:34:07 | directio checker refcount 2
>> Jan 25 10:34:07 | directio checker refcount 1
>> Persistent Reserve IN command failed
>> Jan 25 10:34:07 | unloading const prioritizer
>> Jan 25 10:34:07 | unloading directio checker
>>
>>>
>>>> 8. release 'fails' because reservation registered only a single path
>> and
>>>> the other one is in a failed state.
>>>>
>>>> mpathpersist -d /dev/mapper/blah --out --release --param-rk=3D123abc
>>>> --prout-type=3D8
>>>> Jan 24 00:43:53 | 36001405c55fc03cd8193d491eda0d4d7: pr in read
>>>> reservation command failed.
>>>> PR out: command failed
>>>>
>>> As per design, release service action performs following steps:
>>> Step 1) PROUT 'release' SA is sent on the all paths of the multipath
>> device as it is not clear which data path is reservation holder.
>>> STEP 2) PRIN read reservation SA is sent to one of the active path to
>> verify the reservation.
>>> STEP 3) If the Read Reservation parameter data indicates that the
>> logical unit is still reserved then this indicates that the reservation
>> holder belongs to a data path in failed state or removed data path of
>> the multipath device, continue else goto step 7
>>> STEP 4) PRIN Report Full Status  service action is issued to any
>> active data path. Full status descriptors are saved.
>>> STEP 5) PROUT clear reservation service action is sent via any active
>> data path to clear the reservation and
>>> Registrants
>>> STEP 6) all registrants are restored by issuing PROUT register service
>> action with transport IDs from the full status
>>> descriptors saved in the step 4
>>> STEP 7) exit with status
>>>
>>> It looks like you are getting into some other issue. Can you please
>> share the output with verbose with '-v3'.
>>
>>
>> mpathpersist -d /dev/mapper/blah --out --release --param-rk=3D123abc
>> --prout-type=3D8 -v3
>> Jan 25 10:35:41 | alias =3D blah
> =

>> Jan 25 10:35:41 | 36001405c55fc03cd8193d491eda0d4d7: sending pr out
>> command to sda
>> Jan 25 10:35:41 | 36001405c55fc03cd8193d491eda0d4d7: sdb path not up.
>> Jan 25 10:35:41 | sda: rq_servact =3D 2
>> Jan 25 10:35:41 | sda: rq_scope =3D 0
>> Jan 25 10:35:41 | sda: rq_type =3D 8
>> Jan 25 10:35:41 | sda: paramlen =3D 24
>> Jan 25 10:35:41 | sda: Persistent Reservation OUT parameter:
>> Jan 25 10:35:41 |         00 00 00 00 00 12 3a bc  00 00 00 00 00 00 00
>> 00
>> Jan 25 10:35:41 |         00 00 00 00 00 00 00 00
>> Jan 25 10:35:41 | sda: Duration=3D1 (ms)
>> Jan 25 10:35:41 | sda: status driver:00 host:00 scsi:00
>> Jan 25 10:35:41 | sda: status =3D 0
>> Jan 25 10:35:41 | 36001405c55fc03cd8193d491eda0d4d7: sending pr in
>> command to sda
>> Jan 25 10:35:41 | sda: duration =3D 1 (ms)
>> Jan 25 10:35:41 | sda: status driver:08 host:00 scsi:02
>> Jan 25 10:35:41 | sda: Sense_Key=3D06, ASC=3D00 ASCQ=3D00
>> Jan 25 10:35:41 | sda: retrying for Unit Attention. Remaining retries =
=3D
>> 4
>> Jan 25 10:35:41 | sda: duration =3D 0 (ms)
>> Jan 25 10:35:41 | sda: status driver:00 host:04 scsi:00
> =

> Same with issue 8. PRIN command returned with DID_BAD_TARGET host status.
> =

> All the three failures reported above are due to DID_BAD_TARGET host stat=
us returned for =

> the PRIN command. It does not look like anywhere this feature is related =
to the above reported errors.
> =

>>>> 9. de-registration works....
>>>>
> =

> Thanks,
> Vijay
> =
