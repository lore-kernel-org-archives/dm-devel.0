From: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Subject: Re: [PATCH 0/3][RESEND]multipath-tools: mpathpersist
 utility for managing persistent reservation on dm multipath device.
Date: Wed, 25 Jan 2012 07:45:26 +0000
Message-ID: <F200AD42A082BC4088B232D13A916A89EA01@SACEXCMBX02-PRD.hq.netapp.com>
References: <EE2129A8E578DC4E94D643D6C1C1C67D07D9B409@BTCMVEXC2-PRD.hq.netapp.com>
	<4F197EEB.3050805@internyc.net>
	<F200AD42A082BC4088B232D13A916A89E24A@SACEXCMBX02-PRD.hq.netapp.com>
	<4F1E4785.7010806@internyc.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4F1E4785.7010806@internyc.net>
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
	Babu" <Babu.Moger@netapp.com>, "Stankey,
	Robert" <Robert.Stankey@netapp.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On January 24, 2012, Fil Wrote:
>
>1. Patches apply against the 63704387009443bdb37d9deaaafa9ab121d45bfb
>without any problems. Everything builds correctly (tested it on centos
>6.2 and fedora 16).
>
>2. multipathd runs correctly.
>

Fil, Thanks for the update. Good to know.

>3. mpathpersist is missing --no-inquiry option. It would be nice to be
>compatible with  sg_persist. (breaks most of my test scripts.)
>
>4. mpathpersist -d /dev/mapper/blah --in --read-status
>mpathpersist: unrecognized option '--read-status'
>unrecognised switch code 0x3f ??
>

There is a typo in usage output. Please use --read-full-status instead. I w=
ill correct it. =


>5. registration works
>
>6. reservation, reserves only a single path. (is this by design?)

Yes, this is as per design. Reservation is sent to one of the active =

path and reservation is applicable to registered I_T nexus with respect to =
pr type.

I was expecting your device server to  apply reservation to all the =

registered I_T nexus for pr type "Exclusive Access, all registrants". Can y=
ou verify the below output again?

Please see below in SPC4
"For a persistent reservation of the type Write Exclusive =96 All Registran=
ts or Exclusive Access =96 All Registrants,
the persistent reservation holder is any registered I_T nexus;" =


>mpathpersist --out --reserve --param-rk=3D123abc --prout-type=3D8 -d
>/dev/mapper/blah
>
>sg_persist -i -s /dev/mapper/blah
>  QNAP      iSCSI Storage     3.1
>  Peripheral device type: disk
>  PR generation=3D0x8
>    Key=3D0x123abc
>      All target ports bit clear
>      Relative port address: 0x1
>      not reservation holder
>      Transport Id of initiator:
>        iSCSI name and session id: iqn.2009-
>11.com.adriaticsolutions:blah
>    Key=3D0x123abc
>      All target ports bit clear
>      Relative port address: 0x1
>      << Reservation holder >>
>      scope: LU_SCOPE,  type: Exclusive Access, all registrants
>      Transport Id of initiator:
>        iSCSI name and session id: iqn.2009-
>11.com.adriaticsolutions:blah
>
>multipath -ll
>blah (36001405c55fc03cd8193d491eda0d4d7) dm-4 QNAP,iSCSI Storage
>size=3D10G features=3D'0' hwhandler=3D'0' wp=3Drw
>`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
>  |- 16:0:0:0 sda 8:0  active ready  running
>  `- 17:0:0:0 sdb 8:16 failed faulty running
>
>7. mpathpersist -d /dev/mapper/blah --in --read-reservation
>Persistent Reserve IN command failed
>
Can you please share the output with verbose 3. Append '-v3'.

>8. release 'fails' because reservation registered only a single path and
>the other one is in a failed state.
>
>mpathpersist -d /dev/mapper/blah --out --release --param-rk=3D123abc
>--prout-type=3D8
>Jan 24 00:43:53 | 36001405c55fc03cd8193d491eda0d4d7: pr in read
>reservation command failed.
>PR out: command failed
>
As per design, release service action performs following steps: =

Step 1) PROUT 'release' SA is sent on the all paths of the multipath device=
 as it is not clear which data path is reservation holder.
STEP 2) PRIN read reservation SA is sent to one of the active path to verif=
y the reservation.
STEP 3) If the Read Reservation parameter data indicates that the logical u=
nit is still reserved then this indicates that the reservation holder belon=
gs to a data path in failed state or removed data path of the multipath dev=
ice, continue else goto step 7
STEP 4) PRIN Report Full Status  service action is issued to any active dat=
a path. Full status descriptors are saved.
STEP 5) PROUT clear reservation service action is sent via any active data =
path to clear the reservation and
Registrants
STEP 6) all registrants are restored by issuing PROUT register service acti=
on with transport IDs from the full status
descriptors saved in the step 4
STEP 7) exit with status

It looks like you are getting into some other issue. Can you please share t=
he output with verbose with '-v3'.

>9. de-registration works....
>
>I haven't had time to test path fail over and weird cases when multiple
>nodes try to do destructive things to the shared luns...
>
>thanks
>fil
>
>On 01/23/2012 11:09 PM, Chauhan, Vijay wrote:
>> Thanks for these info Fil.  Can you please also share your feedback on
>your in-depth testing.
>>
>> I appreciate your effort.
>>
>> On January 20, 2012, Fil wrote:
>>> Thanks for the patches Vijay,
>>>
>>> I tested the new set of patches against the git repo, and it applied
>>> cleanly compiled and is running as expected. I will do more indepth
>>> testing over the weekend.

Thanks for your detailed testing.

Thanks and regards,
Vijay
