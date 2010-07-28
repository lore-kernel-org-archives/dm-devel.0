From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: [OT] How to associate pci id with wwpn for an hba
Date: Wed, 28 Jul 2010 10:45:50 +0200
Message-ID: <AANLkTik17u5GBF_SBB25-qptP9cqjQFqgG4D+k-zc9a9@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0898598176509956979=="
Return-path: <dm-devel-bounces@redhat.com>
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

--===============0898598176509956979==
Content-Type: multipart/alternative; boundary=0016e6db2bef113c13048c6ea53d

--0016e6db2bef113c13048c6ea53d
Content-Type: text/plain; charset=UTF-8

Hello,
yesterday I had a problem where a server with 2 Qlogic HBA detected only 2
of the 4 paths it should see.
Each HBA is connected to a different fc switch.
Each FC switch is connected to the 2 controllers of an IBM DS6800 storage
array.
So that in general each disk is seen by 4 paths.
System is rh el 5.5 x86_64
Something like this for each mpath device normally:

mpath1 (3600507630efe0b0c0000000000000601) dm-8 IBM,1750500
[size=15G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
 \_ 1:0:3:2  sdao 66:128 [active][undef]
 \_ 2:0:3:2  sdaq 66:160 [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:2:2  sdd  8:48   [active][undef]
 \_ 2:0:2:2  sdp  8:240  [active][undef]

Yesterday one server was able to see only 2 paths for each mpath device.
I had something like this:
mpath1 (3600507630efe0b0c0000000000000601) dm-8 IBM,1750500
[size=15G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=0][active]
 \_ 1:0:3:2  sdao 66:128 [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:2:2  sdd  8:48   [active][undef]

I had some problems to identify PCI ID <--> WWPN <--> disk devices
associations so that I could give the correct wwpn involved in the problem
to the SAN guys for analysis and resolution.

I took these steps. Could anyone confirm they are ok or provide other
analysys information?

a) From above output of "multipath -l", and also from output of "lsscsi"
command
..
[1:0:2:2]    disk    IBM      1750500          .508  /dev/sdd
[1:0:2:3]    disk    IBM      1750500          .508  /dev/sde
..
[1:0:3:0]    disk    IBM      1750500          .508  /dev/sdal
[1:0:3:1]    disk    IBM      1750500          .508  /dev/sdan
[1:0:3:2]    disk    IBM      1750500          .508  /dev/sdao

with only lines of kind "1:0:x:x" I concluded that I had one adapter
correctly seeing its 2 paths and the other one seeing nothing.

b) In /var/log/messages I had this, only for one adapter
Jul 27 17:54:58 orastud1 kernel: qla2xxx 0000:06:00.0: SNS scan failed --
assuming zero-entry result...

that confirmed somehow a) conclusion

Now I had to give wwpn of hba with pci id 0000:06:00.0
I found that this was not so obvious (at least for me)

c) to see my two wwpn:
# for i in 1 2 ; do echo "host$i $(cat
/sys/class/fc_host/host$i/port_name)"; done
host1 0x21000024ff288e04
host2 0x21000024ff288e05

ok: how to directly connect hostx with pci 0000:06:00.0 ?
lspci  gives:
06:00.0 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel to PCI
Express HBA (rev 02)
06:00.1 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel to PCI
Express HBA (rev 02)

but no "-vv" switch gives the wwpn for them
Can I surely say that host1 <--> 06:00.0 and host2 <--> 06:00.1 ?
What if the first number in general is not the same (for example first hba
05:00.0 and second 06:00.0)?

d) Basically I went through something like:
# ls -d /sys/class/fc_transport/target*/device/*/block* | grep sdao
/sys/class/fc_transport/target1:0:3/device/1:0:3:2/block:sdao
# ls -d /sys/class/fc_transport/target*/device/*/block* | grep sdd
/sys/class/fc_transport/target1:0:2/device/1:0:2:2/block:sdd

Can I say that host1 <--> target1 ?
And so that in my case the adapter not seeing the LUNs was host2 ----> wpn
0x21000024ff288e05 ?

Could I directly say from point a) that the hostx involved is host2 as
"multipath -l" only shows 1:x:y:z devices?
And so that problematic wpn was 0x21000024ff288e05?
Anyway, how to associate hostx with pci id?

Thanks in advance,
Gianluca

--0016e6db2bef113c13048c6ea53d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,<br>yesterday I had a problem where a server with 2 Qlogic HBA detect=
ed only 2 of the 4 paths it should see.<br>Each HBA is connected to a diffe=
rent fc switch.<br>Each FC switch is connected to the 2 controllers of an I=
BM DS6800 storage array.<br>
So that in general each disk is seen by 4 paths.<br>System is rh el 5.5 x86=
_64<br>Something like this for each mpath device normally:<br><br>mpath1 (3=
600507630efe0b0c0000000000000601) dm-8 IBM,1750500<br>[size=3D15G][features=
=3D1 queue_if_no_path][hwhandler=3D0][rw]<br>
\_ round-robin 0 [prio=3D0][active]<br>=C2=A0\_ 1:0:3:2=C2=A0 sdao 66:128 [=
active][undef]<br>=C2=A0\_ 2:0:3:2=C2=A0 sdaq 66:160 [active][undef]<br>\_ =
round-robin 0 [prio=3D0][enabled]<br>=C2=A0\_ 1:0:2:2=C2=A0 sdd=C2=A0 8:48=
=C2=A0=C2=A0 [active][undef]<br>=C2=A0\_ 2:0:2:2=C2=A0 sdp=C2=A0 8:240=C2=
=A0 [active][undef]<br>
<br>Yesterday one server was able to see only 2 paths for each mpath device=
.<br>I had something like this:<br>mpath1 (3600507630efe0b0c000000000000060=
1) dm-8 IBM,1750500<br>
[size=3D15G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]<br>
\_ round-robin 0 [prio=3D0][active]<br>
=C2=A0\_ 1:0:3:2=C2=A0 sdao 66:128 [active][undef]<br>

\_ round-robin 0 [prio=3D0][enabled]<br>
=C2=A0\_ 1:0:2:2=C2=A0 sdd=C2=A0 8:48=C2=A0=C2=A0 [active][undef]<br>
<br>I had some problems to identify PCI ID &lt;--&gt; WWPN &lt;--&gt; disk =
devices associations so that I could give the correct wwpn involved in the =
problem to the SAN guys for analysis and resolution.<br><br>I took these st=
eps. Could anyone confirm they are ok or provide other analysys information=
?<br>
<br>a) From above output of &quot;multipath -l&quot;, and also from output =
of &quot;lsscsi&quot; command<br>..<br>[1:0:2:2]=C2=A0=C2=A0=C2=A0 disk=C2=
=A0=C2=A0=C2=A0 IBM=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1750500=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .508=C2=A0 /dev/sdd<br>[1:0:2:3]=C2=A0=
=C2=A0=C2=A0 disk=C2=A0=C2=A0=C2=A0 IBM=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 17505=
00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .508=C2=A0 /dev/sd=
e<br>
..<br>[1:0:3:0]=C2=A0=C2=A0=C2=A0 disk=C2=A0=C2=A0=C2=A0 IBM=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 1750500=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 .508=C2=A0 /dev/sdal<br>[1:0:3:1]=C2=A0=C2=A0=C2=A0 disk=C2=A0=C2=A0=C2=
=A0 IBM=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1750500=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 .508=C2=A0 /dev/sdan<br>[1:0:3:2]=C2=A0=C2=A0=C2=
=A0 disk=C2=A0=C2=A0=C2=A0 IBM=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1750500=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .508=C2=A0 /dev/sdao<br><b=
r>with only lines of kind &quot;1:0:x:x&quot; I concluded that I had one ad=
apter correctly seeing its 2 paths and the other one seeing nothing.<br>
<br>b) In /var/log/messages I had this, only for one adapter<br>Jul 27 17:5=
4:58 orastud1 kernel: qla2xxx 0000:06:00.0: SNS scan failed -- assuming zer=
o-entry result...<br><br>that confirmed somehow a) conclusion<br><br>Now I =
had to give wwpn of hba with pci id 0000:06:00.0<br>
I found that this was not so obvious (at least for me)<br><br>c) to see my =
two wwpn:<br># for i in 1 2 ; do echo &quot;host$i $(cat /sys/class/fc_host=
/host$i/port_name)&quot;; done<br>host1 0x21000024ff288e04<br>host2 0x21000=
024ff288e05<br>
<br>ok: how to directly connect hostx with pci 0000:06:00.0 ?<br>lspci=C2=
=A0 gives:<br>06:00.0 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre C=
hannel to PCI Express HBA (rev 02)<br>06:00.1 Fibre Channel: QLogic Corp. I=
SP2532-based 8Gb Fibre Channel to PCI Express HBA (rev 02)<br>
<br>but no &quot;-vv&quot; switch gives the wwpn for them<br>Can I surely s=
ay that host1 &lt;--&gt; 06:00.0 and host2 &lt;--&gt; 06:00.1 ?<br>What if =
the first number in general is not the same (for example first hba 05:00.0 =
and second 06:00.0)?<br>
<br>d) Basically I went through something like:<br># ls -d /sys/class/fc_tr=
ansport/target*/device/*/block* | grep sdao<br>/sys/class/fc_transport/targ=
et1:0:3/device/1:0:3:2/block:sdao<br># ls -d /sys/class/fc_transport/target=
*/device/*/block* | grep sdd<br>
/sys/class/fc_transport/target1:0:2/device/1:0:2:2/block:sdd<br><br>Can I s=
ay that host1 &lt;--&gt; target1 ? <br>And so that in my case the adapter n=
ot seeing the LUNs was host2 ----&gt; wpn 0x21000024ff288e05 ?<br><br>Could=
 I directly say from point a) that the hostx involved is host2 as &quot;mul=
tipath -l&quot; only shows 1:x:y:z devices?<br>
And so that  problematic wpn was 0x21000024ff288e05?<br>Anyway, how to asso=
ciate hostx with pci id? <br><br>Thanks in advance,<br>Gianluca<br><br>

--0016e6db2bef113c13048c6ea53d--


--===============0898598176509956979==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0898598176509956979==--
