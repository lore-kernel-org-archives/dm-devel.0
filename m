From: Fil <lists@internyc.net>
Subject: Re: [PATCH 0/3][RESEND]multipath-tools: mpathpersist
 utility for managing persistent reservation on dm multipath device.
Date: Tue, 24 Jan 2012 00:54:13 -0500
Message-ID: <4F1E4785.7010806@internyc.net>
References: <EE2129A8E578DC4E94D643D6C1C1C67D07D9B409@BTCMVEXC2-PRD.hq.netapp.com>
	<4F197EEB.3050805@internyc.net>
	<F200AD42A082BC4088B232D13A916A89E24A@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <F200AD42A082BC4088B232D13A916A89E24A@SACEXCMBX02-PRD.hq.netapp.com>
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

Hi Vijay,

Sorry for a late report, but I was busy with other stuff and didn't test
as much as I wanted, but anyway here is what I have by now.

1. Patches apply against the 63704387009443bdb37d9deaaafa9ab121d45bfb
without any problems. Everything builds correctly (tested it on centos
6.2 and fedora 16).

2. multipathd runs correctly.

3. mpathpersist is missing --no-inquiry option. It would be nice to be
compatible with  sg_persist. (breaks most of my test scripts.)

4. mpathpersist -d /dev/mapper/blah --in --read-status
mpathpersist: unrecognized option '--read-status'
unrecognised switch code 0x3f ??

5. registration works

6. reservation, reserves only a single path. (is this by design?)
mpathpersist --out --reserve --param-rk=123abc --prout-type=8 -d
/dev/mapper/blah

sg_persist -i -s /dev/mapper/blah
  QNAP      iSCSI Storage     3.1
  Peripheral device type: disk
  PR generation=0x8
    Key=0x123abc
      All target ports bit clear
      Relative port address: 0x1
      not reservation holder
      Transport Id of initiator:
        iSCSI name and session id: iqn.2009-11.com.adriaticsolutions:blah
    Key=0x123abc
      All target ports bit clear
      Relative port address: 0x1
      << Reservation holder >>
      scope: LU_SCOPE,  type: Exclusive Access, all registrants
      Transport Id of initiator:
        iSCSI name and session id: iqn.2009-11.com.adriaticsolutions:blah

multipath -ll
blah (36001405c55fc03cd8193d491eda0d4d7) dm-4 QNAP,iSCSI Storage
size=10G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  |- 16:0:0:0 sda 8:0  active ready  running
  `- 17:0:0:0 sdb 8:16 failed faulty running

7. mpathpersist -d /dev/mapper/blah --in --read-reservation
Persistent Reserve IN command failed

8. release 'fails' because reservation registered only a single path and
the other one is in a failed state.

mpathpersist -d /dev/mapper/blah --out --release --param-rk=123abc
--prout-type=8
Jan 24 00:43:53 | 36001405c55fc03cd8193d491eda0d4d7: pr in read
reservation command failed.
PR out: command failed

9. de-registration works....

I haven't had time to test path fail over and weird cases when multiple
nodes try to do destructive things to the shared luns...

thanks
fil

On 01/23/2012 11:09 PM, Chauhan, Vijay wrote:
> Thanks for these info Fil.  Can you please also share your feedback on your in-depth testing.
> 
> I appreciate your effort.
>  
> On January 20, 2012, Fil wrote:
>> Thanks for the patches Vijay,
>>
>> I tested the new set of patches against the git repo, and it applied
>> cleanly compiled and is running as expected. I will do more indepth
>> testing over the weekend.
>>
>> thanks
>> fil
>>
>> On 01/19/2012 02:20 PM, Chauhan, Vijay wrote:
>>> Resending this patch with the fix mentioned by Mike
>> Snitzer<snitzer@redhat.com> and Fil<lists@internyc.net>.
>>> Thanks to all for sending me your review comments. Fil, Thanks for
>> trying out mpathpersist and providing your
>>> feedback. Also thanking Yanling Qi<Yanling.Qi@netapp.com> for
>> proposing this design for pr management feature.
>>> These series of patch is made on commit
>> 864162b08067d3e55d52996846d10a046956c6d6.
> 
> 
> Regards,
> Vijay
> 
