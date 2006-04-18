From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Problems with multipathing
Date: Tue, 18 Apr 2006 15:38:44 -0400
Message-ID: <44454044.7010902@emulex.com>
References: <443BF12E.50900@ludd.luth.se>	<443BF87A.10804@free.fr>	<443C19E6.8000607@ludd.luth.se>	<443E870E.1070902@ludd.luth.se>	<443EB907.1070600@free.fr>	<4442E2ED.7020405@ludd.luth.se>	<4443635F.5000401@free.fr>	<4443A390.5010005@ludd.luth.se>
	<44446F7E.2060502@free.fr>
Reply-To: James.Smart@Emulex.Com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <44446F7E.2060502@free.fr>
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


> Roger H=E5kansson a =E9crit :
>> Also, I've noticed that it's not only when a controller fails that thi=
s
>> happens, when a failed controller is "revived" the same thing might=20
>> happen.
>>
>> As far as I've been able to tell, the more I/O-transactions at the tim=
e
>> of the failure, the more likely that the (SCSI) device will be marked =
as
>> "dead".

Hmmm.. I'm wondering if he's hitting the scenario in which the midlayer
marks the sdev in an offline state - which could be the "dead" state.
This occurs if an i/o hits the LLDD when the device is disconnected, and
error recovery fails. If so, at a later time when the LLDD has connectivi=
ty
and can access the device, the scsi layer would still likely bounce i/o.
It requires a manual interaction to change it back to a running state,
any i/o requests by dm would be failed back by the midlayer.

What doesn't jive is the rescan re-enabling the device. As I stated, this
is usually a manual action to restore things. If the rescans are just
prior to the transition to the offline state, they may be making dm chang=
e
it's path mappings to avoid i/o to the failed path, thus deflecting the
sdev transition.  Can you report the contents of
/sys/class/scsi_device/1:0:*/device/state  at the following states in bot=
h
the works and does not work cases :
   working, right after failover but before dm fails it; after failure/su=
ccess

-- james
