From: Eli Klein <elijah@aclue.com>
Subject: Re: Question regarding failback option in multipath.conf
Date: Wed, 30 Sep 2009 13:36:53 -0600
Message-ID: <B38A0B62-A47C-4400-B113-5D46D13453D6@aclue.com>
References: <5A70833B-9208-470E-88B7-7C351EED2122@aclue.com>	<4AC3AC88.9020404@redhat.com>
	<06F122DE-B7E5-4721-BA08-D0453D10581C@aclue.com>
	<4AC3B084.4060700@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: multipart/mixed; boundary="===============0925423619=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AC3B084.4060700@redhat.com>
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


--===============0925423619==
Content-Type: multipart/alternative; boundary=Apple-Mail-9--993176692


--Apple-Mail-9--993176692
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes

On Sep 30, 2009, at 1:24 PM, John Brier wrote:

> On 09/30/2009 03:16 PM, Eli Klein wrote:
>>
>> Here's the abbreviated output from multipath -v3:
>>
>> mpath1: pgfailback = 120 (config file default)
>> mpath1: pgpolicy = multibus (config file default)
>> mpath1: selector = round-robin 0 (internal default)
>> mpath1: features = 1 queue_if_no_path (internal default)
>> mpath1: hwhandler = 0 (internal default)
>> mpath1: rr_weight = 2 (config file default)
>> mpath1: minio = 10 (config file default)
>> mpath1: no_path_retry = 1 (config file default)
>> pg_timeout = NONE (internal default)
>> mpath1: set ACT_NOTHING (map unchanged)
>>
>> It's definitely picking up the settings correctly from  
>> multipath.conf,
>> but the paths are still reinstated immediately once they're  
>> reconnected
>> (even if it's just for a split second).
>>
>
> What does /var/log/messages look like when this happens? Since you  
> changed failback to 120 did you restart multipathd or restart the box?
>
> John Brier
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

I've tried rebooting, restarting multipath (and iscsid), flushing  
multipath (-F), removing all the iscsi targets completely and then  
reinitializing the targets.  Nothing changes the behavior.  Here's  
output from /var/log/messages.. note the time between when the link  
becomes active (13:31:08) to when the path is reinstated (13:31:15):

Sep 30 13:30:28 testbox kernel:  connection7:0: ping timeout of 5 secs  
expired, recv timeout 5, last rx 4470061909, last ping 4470066909, now  
4470071909
Sep 30 13:30:28 testbox kernel:  connection7:0: detected conn error  
(1011)
Sep 30 13:30:28 testbox multipathd: sdf: readsector0 checker reports  
path is down
Sep 30 13:30:28 testbox multipathd: checker failed path 8:80 in map  
mpath0
Sep 30 13:30:28 testbox multipathd: mpath0: remaining active paths: 1
Sep 30 13:30:28 testbox kernel: device-mapper: multipath: Failing path  
8:80.
Sep 30 13:30:28 testbox iscsid: Kernel reported iSCSI connection 7:0  
error (1011) state (3)
Sep 30 13:30:29 testbox kernel:  connection9:0: ping timeout of 5 secs  
expired, recv timeout 5, last rx 4470063232, last ping 4470068232, now  
4470073232
Sep 30 13:30:29 testbox kernel:  connection9:0: detected conn error  
(1011)
Sep 30 13:30:29 testbox multipathd: sdg: readsector0 checker reports  
path is down
Sep 30 13:30:29 testbox multipathd: checker failed path 8:96 in map  
mpath1
Sep 30 13:30:29 testbox multipathd: mpath1: remaining active paths: 1
Sep 30 13:30:29 testbox kernel: device-mapper: multipath: Failing path  
8:96.
Sep 30 13:30:30 testbox kernel:  connection11:0: ping timeout of 5  
secs expired, recv timeout 5, last rx 4470064373, last ping  
4470069373, now 4470074373
Sep 30 13:30:30 testbox kernel:  connection11:0: detected conn error  
(1011)
Sep 30 13:30:30 testbox iscsid: Kernel reported iSCSI connection 9:0  
error (1011) state (3)
Sep 30 13:30:30 testbox multipathd: sdh: readsector0 checker reports  
path is down
Sep 30 13:30:30 testbox multipathd: checker failed path 8:112 in map  
mpath2
Sep 30 13:30:30 testbox kernel: device-mapper: multipath: Failing path  
8:112.
Sep 30 13:30:30 testbox multipathd: mpath2: remaining active paths: 1
Sep 30 13:30:30 testbox multipathd: dm-4: add map (uevent)
Sep 30 13:30:30 testbox multipathd: dm-4: devmap already registered
Sep 30 13:30:30 testbox multipathd: dm-2: add map (uevent)
Sep 30 13:30:30 testbox multipathd: dm-2: devmap already registered
Sep 30 13:30:30 testbox multipathd: dm-3: add map (uevent)
Sep 30 13:30:30 testbox multipathd: dm-3: devmap already registered
Sep 30 13:30:31 testbox iscsid: Kernel reported iSCSI connection 11:0  
error (1011) state (3)
Sep 30 13:30:43 testbox kernel:  session7: session recovery timed out  
after 15 secs
Sep 30 13:30:43 testbox multipathd: sdf: readsector0 checker reports  
path is down
Sep 30 13:30:44 testbox kernel:  session9: session recovery timed out  
after 15 secs
Sep 30 13:30:44 testbox multipathd: sdg: readsector0 checker reports  
path is down
Sep 30 13:30:45 testbox kernel:  session11: session recovery timed out  
after 15 secs
Sep 30 13:30:45 testbox kernel: sd 13:0:0:0: SCSI error: return code =  
0x000f0000
Sep 30 13:30:45 testbox kernel: end_request: I/O error, dev sdh,  
sector 407978223
Sep 30 13:30:45 testbox multipathd: sdh: readsector0 checker reports  
path is down
Sep 30 13:30:55 testbox multipathd: sdf: readsector0 checker reports  
path is down
Sep 30 13:31:05 testbox multipathd: sdg: readsector0 checker reports  
path is down
Sep 30 13:31:05 testbox multipathd: sdh: readsector0 checker reports  
path is down
Sep 30 13:31:05 testbox multipathd: sdf: readsector0 checker reports  
path is down
Sep 30 13:31:05 testbox multipathd: sdg: readsector0 checker reports  
path is down
Sep 30 13:31:05 testbox multipathd: sdh: readsector0 checker reports  
path is down
Sep 30 13:31:08 testbox iscsid: connection9:0 is operational after  
recovery (3 attempts)
Sep 30 13:31:08 testbox iscsid: connection11:0 is operational after  
recovery (3 attempts)
Sep 30 13:31:11 testbox iscsid: connection7:0 is operational after  
recovery (3 attempts)
Sep 30 13:31:15 testbox multipathd: sdf: readsector0 checker reports  
path is up
Sep 30 13:31:15 testbox multipathd: 8:80: reinstated
Sep 30 13:31:15 testbox multipathd: mpath0: remaining active paths: 2
Sep 30 13:31:15 testbox multipathd: sdg: readsector0 checker reports  
path is up
Sep 30 13:31:15 testbox multipathd: 8:96: reinstated
Sep 30 13:31:15 testbox multipathd: mpath1: remaining active paths: 2
Sep 30 13:31:15 testbox multipathd: sdh: readsector0 checker reports  
path is up
Sep 30 13:31:15 testbox multipathd: 8:112: reinstated
Sep 30 13:31:15 testbox multipathd: mpath2: remaining active paths: 2
Sep 30 13:31:15 testbox multipathd: dm-4: add map (uevent)
Sep 30 13:31:15 testbox multipathd: dm-4: devmap already registered
Sep 30 13:31:15 testbox multipathd: dm-2: add map (uevent)
Sep 30 13:31:15 testbox multipathd: dm-2: devmap already registered
Sep 30 13:31:15 testbox multipathd: dm-3: add map (uevent)
Sep 30 13:31:15 testbox multipathd: dm-3: devmap already registered


--Apple-Mail-9--993176692
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; =
"><div><div>On Sep 30, 2009, at 1:24 PM, John Brier wrote:</div><br =
class=3D"Apple-interchange-newline"><blockquote type=3D"cite"><div>On =
09/30/2009 03:16 PM, Eli Klein wrote:<br><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">Here's the =
abbreviated output from multipath -v3:<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">mpath1: =
pgfailback =3D 120 (config file default)<br></blockquote><blockquote =
type=3D"cite">mpath1: pgpolicy =3D multibus (config file =
default)<br></blockquote><blockquote type=3D"cite">mpath1: selector =3D =
round-robin 0 (internal default)<br></blockquote><blockquote =
type=3D"cite">mpath1: features =3D 1 queue_if_no_path (internal =
default)<br></blockquote><blockquote type=3D"cite">mpath1: hwhandler =3D =
0 (internal default)<br></blockquote><blockquote type=3D"cite">mpath1: =
rr_weight =3D 2 (config file default)<br></blockquote><blockquote =
type=3D"cite">mpath1: minio =3D 10 (config file =
default)<br></blockquote><blockquote type=3D"cite">mpath1: no_path_retry =
=3D 1 (config file default)<br></blockquote><blockquote =
type=3D"cite">pg_timeout =3D NONE (internal =
default)<br></blockquote><blockquote type=3D"cite">mpath1: set =
ACT_NOTHING (map unchanged)<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">It's definitely =
picking up the settings correctly from =
multipath.conf,<br></blockquote><blockquote type=3D"cite">but the paths =
are still reinstated immediately once they're =
reconnected<br></blockquote><blockquote type=3D"cite">(even if it's just =
for a split second).<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><br>What does /var/log/messages look like =
when this happens? Since you changed failback to 120 did you restart =
multipathd or restart the box?<br><br>John Brier<br><br>--<br>dm-devel =
mailing list<br><a =
href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>https://www=
.redhat.com/mailman/listinfo/dm-devel<br></div></blockquote></div><br><div=
><span class=3D"Apple-style-span" style=3D"font-family: arial; =
font-size: small; "><div><font class=3D"Apple-style-span" size=3D"3"><span=
 class=3D"Apple-style-span" style=3D"font-size: 12px;">I've tried =
rebooting, restarting multipath (and iscsid), flushing multipath (-F), =
removing all the iscsi targets completely and then reinitializing the =
targets. &nbsp;Nothing changes the behavior. &nbsp;Here's output from =
/var/log/messages.. note the time between when the link becomes active =
(13:31:08) to when the path is reinstated =
(13:31:15):</span></font></div><div><br></div><div><div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:30:28 =
testbox kernel: &nbsp;connection7:0: ping timeout of 5 secs expired, =
recv timeout 5, last rx 4470061909, last ping 4470066909, now =
4470071909</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:28 testbox kernel: =
&nbsp;connection7:0: detected conn error =
(1011)</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:28 testbox multipathd: sdf: =
readsector0 checker reports path is down</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:30:28 =
testbox multipathd: checker failed path 8:80 in map =
mpath0</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:28 testbox multipathd: mpath0: =
remaining active paths: 1</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:30:28 =
testbox kernel: device-mapper: multipath: Failing path =
8:80.</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:28 testbox iscsid: Kernel =
reported iSCSI connection 7:0 error (1011) state =
(3)</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:29 testbox kernel: =
&nbsp;connection9:0: ping timeout of 5 secs expired, recv timeout 5, =
last rx 4470063232, last ping 4470068232, now =
4470073232</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:29 testbox kernel: =
&nbsp;connection9:0: detected conn error =
(1011)</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:29 testbox multipathd: sdg: =
readsector0 checker reports path is down</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:30:29 =
testbox multipathd: checker failed path 8:96 in map =
mpath1</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:29 testbox multipathd: mpath1: =
remaining active paths: 1</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:30:29 =
testbox kernel: device-mapper: multipath: Failing path =
8:96.</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:30 testbox kernel: =
&nbsp;connection11:0: ping timeout of 5 secs expired, recv timeout 5, =
last rx 4470064373, last ping 4470069373, now =
4470074373</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:30 testbox kernel: =
&nbsp;connection11:0: detected conn error =
(1011)</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:30 testbox iscsid: Kernel =
reported iSCSI connection 9:0 error (1011) state =
(3)</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:30 testbox multipathd: sdh: =
readsector0 checker reports path is down</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:30:30 =
testbox multipathd: checker failed path 8:112 in map =
mpath2</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:30 testbox kernel: =
device-mapper: multipath: Failing path =
8:112.</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:30 testbox multipathd: mpath2: =
remaining active paths: 1</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:30:30 =
testbox multipathd: dm-4: add map (uevent)</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:30:30 =
testbox multipathd: dm-4: devmap already =
registered</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:30 testbox multipathd: dm-2: add =
map (uevent)</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:30 testbox multipathd: dm-2: =
devmap already registered</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:30:30 =
testbox multipathd: dm-3: add map (uevent)</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:30:30 =
testbox multipathd: dm-3: devmap already =
registered</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:31 testbox iscsid: Kernel =
reported iSCSI connection 11:0 error (1011) state =
(3)</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:43 testbox kernel: =
&nbsp;session7: session recovery timed out after 15 =
secs</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:43 testbox multipathd: sdf: =
readsector0 checker reports path is down</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:30:44 =
testbox kernel: &nbsp;session9: session recovery timed out after 15 =
secs</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:44 testbox multipathd: sdg: =
readsector0 checker reports path is down</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:30:45 =
testbox kernel: &nbsp;session11: session recovery timed out after 15 =
secs</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:45 testbox kernel: sd 13:0:0:0: =
SCSI error: return code =3D 0x000f0000</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:30:45 =
testbox kernel: end_request: I/O error, dev sdh, sector =
407978223</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:30:45 testbox multipathd: sdh: =
readsector0 checker reports path is down</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:30:55 =
testbox multipathd: sdf: readsector0 checker reports path is =
down</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:31:05 testbox multipathd: sdg: =
readsector0 checker reports path is down</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:31:05 =
testbox multipathd: sdh: readsector0 checker reports path is =
down</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:31:05 testbox multipathd: sdf: =
readsector0 checker reports path is down</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:31:05 =
testbox multipathd: sdg: readsector0 checker reports path is =
down</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:31:05 testbox multipathd: sdh: =
readsector0 checker reports path is down</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:31:08 =
testbox iscsid: connection9:0 is operational after recovery (3 =
attempts)</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:31:08 testbox iscsid: =
connection11:0 is operational after recovery (3 =
attempts)</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:31:11 testbox iscsid: connection7:0 =
is operational after recovery (3 attempts)</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:31:15 =
testbox multipathd: sdf: readsector0 checker reports path is =
up</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:31:15 testbox multipathd: 8:80: =
reinstated</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:31:15 testbox multipathd: mpath0: =
remaining active paths: 2</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:31:15 =
testbox multipathd: sdg: readsector0 checker reports path is =
up</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:31:15 testbox multipathd: 8:96: =
reinstated</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:31:15 testbox multipathd: mpath1: =
remaining active paths: 2</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:31:15 =
testbox multipathd: sdh: readsector0 checker reports path is =
up</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:31:15 testbox multipathd: 8:112: =
reinstated</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:31:15 testbox multipathd: mpath2: =
remaining active paths: 2</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:31:15 =
testbox multipathd: dm-4: add map (uevent)</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:31:15 =
testbox multipathd: dm-4: devmap already =
registered</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:31:15 testbox multipathd: dm-2: add =
map (uevent)</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'Courier New'" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;">Sep 30 13:31:15 testbox multipathd: dm-2: =
devmap already registered</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:31:15 =
testbox multipathd: dm-3: add map (uevent)</span></font></div><div><font =
class=3D"Apple-style-span" face=3D"'Courier New'" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">Sep 30 13:31:15 =
testbox multipathd: dm-3: devmap already =
registered</span></font></div><div><font class=3D"Apple-style-span" =
face=3D"'courier new', =
monospace"><br></font></div></div></div></span></div></body></html>=

--Apple-Mail-9--993176692--


--===============0925423619==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0925423619==--
