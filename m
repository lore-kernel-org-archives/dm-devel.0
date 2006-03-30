From: lbt <transter@gmail.com>
Subject: Re: IO error on DM device
Date: Thu, 30 Mar 2006 10:17:58 -0800
Message-ID: <ac71172a0603301017o33fa324cl58c19bf4ae33bff@mail.gmail.com>
References: <3456F611E9329441B12FBB24447B3FA003BB5226@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: transter@gmail.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1147622103=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3456F611E9329441B12FBB24447B3FA003BB5226@bgeexc01.asiapacific.cpqcorp.net>
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
Cc: Securelinux <securelinux@hp.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

--===============1147622103==
Content-Type: multipart/alternative;
	boundary="----=_Part_12519_30191507.1143742678650"

------=_Part_12519_30191507.1143742678650
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 3/29/06, Murthy, Narasimha Doraswamy (STSD) <narasimha.murthy@hp.com>
wrote:
>
> Hi Alasdair,
>
> We are seeing an IO error problem on a DM device, when the HBA ports of
> another host, seen through the same switch are disabled/enable. We are no=
t
> understanding on why the paths are failed when ports on other hosts are
> disabled. Please explain.
>
> Below is the problem description and steps to reproduce.
>
> *Problem     : * I/O Error on DM device**** on one host when HBA ports of
> another host are disabled.
>
> *OS distros :*  RHEL4.0 U2/U3.
>
> *HOW-TO**** reproduce the problem****:*****
>
> 1. Configure 2 storage arrays (A1, A2) and two host (H1, H2) in the same
> zone, so that both the hosts can see**** both the arrays. Create and pres=
ent
> LUNs (L1, L2) from array (A1) to host (H1)
>
> 2. Stop the multipathd daemon (for testing purpose on why the IO error
> when ports of other hosts are failed). Not stopping it may take long time
> to reproduce the problem.
>
> 3. Start I/O on DM device representing luns L1 and L2 on host H1. We used=
*
> ** dt tool* for IO exercising.
>
> 4. Disable host ports of host H2 or any port of array A2 one after the
> other (few times) OR disable and enable the same port of the other host =
=96few times (may be 4-5 times).
>
> 5. Application (dt tool) aborts with IO error on host H1.
>
> =3D=3D=3D=3D=3D
>
>  Snippet of*** s****ys log output* (while doing I/O on /dev/dm-0)
>
> Feb  1 11:47:14 apwtest52 kernel: SCSI error : <2 0 0 1> return code =3D
> 0x20000
>
Feb  1 11:47:14 apwtest52 kernel: end_request: I/O error, dev sda, sector
> 1584600
>
> Feb  1 11:47:14 apwtest52 kernel: device-mapper: dm-multipath: Failing
> path 8:0.     <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dpath fa=
iled, after disabling/enabling the H2
> host port 1
>
> Feb  1 11:47:14 apwtest52 kernel: end_request: I/O error, dev sda, sector
> 1584608
>
> Feb  1 11:47:45 apwtest52 kernel: SCSI error : <3 0 1 1> return code =3D
> 0x20000
>
> Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sdg, sector
> 861400
>
> Feb  1 11:47:45 apwtest52 kernel: device-mapper: dm-multipath: Failing
> path 8:96.   <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dpath fai=
led, after disabling/enabling  the H2
> host port 2
>
> Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sdg, sector
> 861408
>
> Feb  1 11:47:45 apwtest52 kernel: SCSI error : <3 0 0 1> return code =3D
> 0x20000
>
> Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde, sector
> 452760
>
> Feb  1 11:47:45 apwtest52 kernel: device-mapper: dm-multipath: Failing
> path 8:64.  <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dpath fail=
ed after disabling/enabling the H2
> host port 1
>
> Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde, sector
> 452768
>
> Feb  1 11:47:45 apwtest52 kernel: SCSI error : <3 0 0 1> return code =3D
> 0x20000
>
> Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde, sector
> 453784
>
> Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde, sector
> 453792
>
> Feb  1 11:47:45 apwtest52 kernel: SCSI error : <3 0 0 1> return code =3D
> 0x20000
>
> Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde, sector
> 454808
>
> Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde, sector
> 454816
>
> Feb  1 11:47:45 apwtest52 kernel: SCSI error : <3 0 0 1> return code =3D
> 0x20000
>
> Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde, sector
> 863960
>
> Feb  1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde, sector
> 863968
>
> Feb  1 11:48:40 apwtest52 kernel: SCSI error : <2 0 1 1> return code =3D
> 0x20000
>
> Feb  1 11:48:40 apwtest52 kernel: end_request: I/O error, dev sdc, sector
> 935384
>
> Feb  1 11:48:40 apwtest52 kernel: device-mapper: dm-multipath: Failing
> path 8:32.  <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D after di=
sabling/enabling  the H2 host port 2
>
> Feb  1 11:48:40 apwtest52 kernel: end_request: I/O error, dev sdc, sector
> 935392
>
> Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logica=
l
> block 116924    <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3DAll path to the devi=
ce /dev/dm-0 failed
>
> Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logica=
l
> block 116925
>
> Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logica=
l
> block 116926
>
> Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logica=
l
> block 116927
>
> Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logica=
l
> block 116928
>
> Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logica=
l
> block 116929
>
> Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logica=
l
> block 116930
>
> Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logica=
l
> block 116931
>
> Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logica=
l
> block 116932
>
> Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logica=
l
> block 116933
>
> Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logica=
l
> block 116934
>
> Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logica=
l
> block 116935
>
> Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logica=
l
> block 116936
>
> Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logica=
l
> block 116937
>
> Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logica=
l
> block 116938
>
> Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logica=
l
> block 116939
>
> Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logica=
l
> block 116940
>
>
>
> *Observations :*
>
>       As we do the port failure on the other host, paths of the dm device
> is failed and the subsequent port (i.e A2 or H2 ports) disabling/enabling
> results into more numbers of path failure and that leads into all path
> failure condition, which in turn results into IO error on RHEL4.0 U2/U3.
>
>      Through the device-mapper debug driver we are finding that the there
> is no valid path in*** __choose_pgpath()* and *** m->current_pgpath* (m i=
s
> pointer to struct multipath) is null when it comes to map_io() in
> dm-mpath.c.
>
> Another observation is that we are not seeing any IO errors when the same=
test is executed on SLES9 SP3/SP4.
>

Are you using the Qlogic or Emulex driver with your RHEL4 and SLES9 systems=
?


The 0x20000 errors you are seeing corresponds to DID_BUS_BUSY error. This i=
s
considered one of the 'retryable' errors by the SCSI layer. As far as I
know, Qlogic driver uses the DID_BUS_BUSY error return code to force a retr=
y
of I/O for various fabric events. (I think they are planning on, or maybe
already have, cleaned this up in their driver to remove this hack and use
block/unblock interface. This could be double-checked by looking at qlogic
source code for the driver version you're using). Since dm I/O uses a
failfast flag, these retryable errors won't get retried by the SCSI layer
and get immediately propagated up to dm, which is probably why you're
getting errors even on paths that should be okay. If this is the case, I
would expect this same problem to occur on your SLES9 systems too if you're
using QLogic driver.

I assume you're not using queue_if_no_path? From a dm and user perspective,
this is the only thing I can think of to work around this issue until the
patch to propagate error codes up the stack is included and/or Qlogic stops
using DID_BUS_BUSY to force retries.

Thanks,
lan

> Please provide some pointers on why we are seeing this behavior or is thi=
s a
> known thing at this point in time?
>
> Thanks and regards
>
> -Murthy
>
>
>
>
>
>
>
>
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
>

------=_Part_12519_30191507.1143742678650
Content-Type: text/html; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<br><br><div><span class=3D"gmail_quote">On 3/29/06, <b class=3D"gmail_send=
ername">Murthy, Narasimha Doraswamy (STSD)</b> &lt;<a href=3D"mailto:narasi=
mha.murthy@hp.com">narasimha.murthy@hp.com</a>&gt; wrote:</span><blockquote=
 class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); =
margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div style=3D"direction: ltr;">









<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Hi A=
lasdair,</font></span><span lang=3D"en-us"></span><span lang=3D"en-us"></sp=
an></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">We a=
re seeing</font></span><span lang=3D"en-us"></span><span lang=3D"en-us"> <f=
ont face=3D"Arial" size=3D"2">an IO error problem on a DM device, when the<=
/font></span>
<span lang=3D"en-us"></span><span lang=3D"en-us"> <font face=3D"Arial" size=
=3D"2">HBA</font></span><span lang=3D"en-us"></span><span lang=3D"en-us"> <=
font face=3D"Arial" size=3D"2">ports of another host</font></span><span lan=
g=3D"en-us"></span>
<span lang=3D"en-us"><font face=3D"Arial" size=3D"2">,</font></span><span l=
ang=3D"en-us"></span><span lang=3D"en-us"><font face=3D"Arial" size=3D"2"> =
seen through the same switch</font></span><span lang=3D"en-us"></span><span=
 lang=3D"en-us">
 <font face=3D"Arial" size=3D"2">are</font></span><span lang=3D"en-us"></sp=
an><span lang=3D"en-us"><font face=3D"Arial" size=3D"2"> disabled/enable</f=
ont></span><span lang=3D"en-us"></span><span lang=3D"en-us"><font face=3D"A=
rial" size=3D"2">
. We are n</font></span><span lang=3D"en-us"></span><span lang=3D"en-us"><f=
ont face=3D"Arial" size=3D"2">ot understanding on why the paths are failed =
when ports on other hosts are disabled. Please explain. </font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Belo=
w is the problem description and steps to reproduce.</font></span><span lan=
g=3D"en-us"></span><span lang=3D"en-us"></span></p>

<p align=3D"left"><span lang=3D"en-us"><b><font face=3D"Arial" size=3D"2">P=
roblem&nbsp;&nbsp;&nbsp;&nbsp; :&nbsp;</font></b></span><span lang=3D"en-us=
"></span><span lang=3D"en-us"> <font face=3D"Arial" size=3D"2">I/O Error on=
 DM device</font></span><span lang=3D"en-us">
<b><i></i></b></span><span lang=3D"en-us"><b><i><font color=3D"#000080" fac=
e=3D"Arial" size=3D"2"></font></i></b></span><span lang=3D"en-us"></span><s=
pan lang=3D"en-us"> <font face=3D"Arial" size=3D"2">on one host when</font>=
</span><span lang=3D"en-us">
</span><span lang=3D"en-us"><font face=3D"Arial" size=3D"2"> HBA ports of</=
font></span><span lang=3D"en-us"></span><span lang=3D"en-us"> <font face=3D=
"Arial" size=3D"2">another</font></span><span lang=3D"en-us"></span><span l=
ang=3D"en-us">
<font face=3D"Arial" size=3D"2"> host</font></span><span lang=3D"en-us"></s=
pan><span lang=3D"en-us"><font face=3D"Arial" size=3D"2"> are disabled.</fo=
nt></span><span lang=3D"en-us"></span><span lang=3D"en-us"></span></p>

<p align=3D"left"><span lang=3D"en-us"><b><font face=3D"Arial" size=3D"2">O=
S distros :</font></b></span><span lang=3D"en-us"></span><span lang=3D"en-u=
s"><font face=3D"Arial" size=3D"2">&nbsp; RHEL4.0 U2/U3.</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><b><font face=3D"Arial" size=3D"2">H=
OW-TO</font></b></span><span lang=3D"en-us"><b></b></span><span lang=3D"en-=
us"><b><font face=3D"Arial" size=3D"2"> reproduce the problem</font></b></s=
pan><span lang=3D"en-us">
<b></b></span><span lang=3D"en-us"><b><font color=3D"#000080" face=3D"Arial=
" size=3D"2">:</font></b></span><span lang=3D"en-us"><b></b></span><span la=
ng=3D"en-us"><b></b></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">1. C=
onfigure</font></span><span lang=3D"en-us"></span><span lang=3D"en-us"><fon=
t face=3D"Arial" size=3D"2"> 2 storage</font></span><span lang=3D"en-us"></=
span><span lang=3D"en-us">
 <font face=3D"Arial" size=3D"2">arrays</font></span><span lang=3D"en-us"><=
/span><span lang=3D"en-us"><font face=3D"Arial" size=3D"2"> (</font></span>=
<span lang=3D"en-us"></span><span lang=3D"en-us"><font face=3D"Arial" size=
=3D"2">A1</font></span>
<span lang=3D"en-us"></span><span lang=3D"en-us"><font face=3D"Arial" size=
=3D"2">, A2</font></span><span lang=3D"en-us"></span><span lang=3D"en-us"><=
font face=3D"Arial" size=3D"2">) and two</font></span><span lang=3D"en-us">=
</span><span lang=3D"en-us">
 <font face=3D"Arial" size=3D"2">host (</font></span><span lang=3D"en-us"><=
/span><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">H1</font></span>=
<span lang=3D"en-us"></span><span lang=3D"en-us"><font face=3D"Arial" size=
=3D"2">, H2) in</font>
</span><span lang=3D"en-us"></span><span lang=3D"en-us"><font face=3D"Arial=
" size=3D"2"> the same zone, so that both the hosts can see</font></span><s=
pan lang=3D"en-us"><b><i></i></b></span><span lang=3D"en-us"><b><i><font co=
lor=3D"#000080" face=3D"Arial" size=3D"2">
</font></i></b></span><span lang=3D"en-us"></span><span lang=3D"en-us"> <fo=
nt color=3D"#000080" face=3D"Arial" size=3D"2">both</font></span><span lang=
=3D"en-us"></span><span lang=3D"en-us"><font face=3D"Arial" size=3D"2"> the=
 arrays.</font>
</span><span lang=3D"en-us"></span><span lang=3D"en-us"><font color=3D"#000=
080" face=3D"Arial" size=3D"2"></font></span><span lang=3D"en-us"></span><s=
pan lang=3D"en-us"> <font face=3D"Arial" size=3D"2">Create and p</font></sp=
an><span lang=3D"en-us">
</span><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">resent LUNs</fo=
nt></span><span lang=3D"en-us"></span><span lang=3D"en-us"><font face=3D"Ar=
ial" size=3D"2"></font></span><span lang=3D"en-us"></span><span lang=3D"en-=
us"> <font face=3D"Arial" size=3D"2">
(L1,</font></span><span lang=3D"en-us"></span><span lang=3D"en-us"><font fa=
ce=3D"Arial" size=3D"2"></font></span><span lang=3D"en-us"></span><span lan=
g=3D"en-us"> <font face=3D"Arial" size=3D"2">L2) from array</font></span><s=
pan lang=3D"en-us">
</span><span lang=3D"en-us"><font face=3D"Arial" size=3D"2"></font></span><=
span lang=3D"en-us"></span><span lang=3D"en-us"> <font face=3D"Arial" size=
=3D"2">(A1) to host</font></span><span lang=3D"en-us"></span><span lang=3D"=
en-us"><font face=3D"Arial" size=3D"2">
</font></span><span lang=3D"en-us"></span><span lang=3D"en-us"> <font face=
=3D"Arial" size=3D"2">(H1)</font></span><span lang=3D"en-us"></span><span l=
ang=3D"en-us"></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">2. S=
top the multipathd daemon</font></span><span lang=3D"en-us"></span><span la=
ng=3D"en-us"><font face=3D"Arial" size=3D"2"></font></span><span lang=3D"en=
-us"></span><span lang=3D"en-us">
 <font face=3D"Arial" size=3D"2">(for testing purpose on why the</font></sp=
an><span lang=3D"en-us"></span><span lang=3D"en-us"> <font face=3D"Arial" s=
ize=3D"2">IO error when ports of other hosts are failed)</font></span><span=
 lang=3D"en-us">
</span><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">.</font></span>=
<span lang=3D"en-us"></span><span lang=3D"en-us"><font color=3D"#000080" fa=
ce=3D"Arial" size=3D"2"></font></span><span lang=3D"en-us"></span><span lan=
g=3D"en-us"> <font face=3D"Arial" size=3D"2">
Not stopping it may take long time to reproduce the problem.</font></span><=
span lang=3D"en-us"></span><span lang=3D"en-us"></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">3. S=
tart I/O on</font></span><span lang=3D"en-us"></span><span lang=3D"en-us"> =
<font face=3D"Arial" size=3D"2">DM device representing</font></span><span l=
ang=3D"en-us">
</span><span lang=3D"en-us"><font color=3D"#000080" face=3D"Arial" size=3D"=
2"></font></span><span lang=3D"en-us"></span><span lang=3D"en-us"> <font fa=
ce=3D"Arial" size=3D"2">luns L1 and L2</font></span><span lang=3D"en-us"></=
span><span lang=3D"en-us">
 <font face=3D"Arial" size=3D"2">on host H1</font></span><span lang=3D"en-u=
s"></span><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">. We used</f=
ont></span><span lang=3D"en-us"><b></b></span><span lang=3D"en-us"><b> <fon=
t face=3D"Arial" size=3D"2">
dt tool</font></b></span><span lang=3D"en-us"></span><span lang=3D"en-us"><=
font face=3D"Arial" size=3D"2"> for IO exercising.</font></span><span lang=
=3D"en-us"></span><span lang=3D"en-us"></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">4.</=
font></span><span lang=3D"en-us"></span><span lang=3D"en-us"> <font face=3D=
"Arial" size=3D"2">Disable</font></span><span lang=3D"en-us"></span><span l=
ang=3D"en-us"><font face=3D"Arial" size=3D"2">
 host ports of host H2 or any port of array A2</font></span><span lang=3D"e=
n-us"></span><span lang=3D"en-us"><font face=3D"Arial" size=3D"2"> one afte=
r the other</font></span><span lang=3D"en-us"></span><span lang=3D"en-us"><=
font face=3D"Arial" size=3D"2">
 (few times)</font></span><span lang=3D"en-us"></span><span lang=3D"en-us">=
<font face=3D"Arial" size=3D"2"> OR disable and enable</font></span><span l=
ang=3D"en-us"></span><span lang=3D"en-us"> <font face=3D"Arial" size=3D"2">=
the same</font>
</span><span lang=3D"en-us"></span><span lang=3D"en-us"><font face=3D"Arial=
" size=3D"2"> port of the other host</font></span><span lang=3D"en-us"></sp=
an><span lang=3D"en-us"> <font face=3D"Arial" size=3D"2">=96</font></span><=
span lang=3D"en-us">
</span><span lang=3D"en-us"><font face=3D"Arial" size=3D"2"> few times (may=
 be 4-5 times).</font></span><span lang=3D"en-us"></span><span lang=3D"en-u=
s"></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">5. A=
pplicatio</font></span><span lang=3D"en-us"></span><span lang=3D"en-us"><fo=
nt face=3D"Arial" size=3D"2">n (dt tool)</font></span><span lang=3D"en-us">=
</span><span lang=3D"en-us">
<font face=3D"Arial" size=3D"2"> aborts with IO error on host H1.</font></s=
pan></p>
<br>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">=3D=
=3D=3D=3D=3D</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2"></fo=
nt></span><span lang=3D"en-us"></span><span lang=3D"en-us">&nbsp;<font face=
=3D"Arial" size=3D"2">Snippet of</font></span><span lang=3D"en-us"><b></b><=
/span><span lang=3D"en-us">
<b><font color=3D"#000080" face=3D"Arial" size=3D"2"> s</font></b></span><s=
pan lang=3D"en-us"><b></b></span><span lang=3D"en-us"><b><font face=3D"Aria=
l" size=3D"2">ys log output</font></b></span><span lang=3D"en-us"></span><s=
pan lang=3D"en-us">
<font face=3D"Arial" size=3D"2"> (while</font></span><span lang=3D"en-us"><=
/span><span lang=3D"en-us"> <font face=3D"Arial" size=3D"2">d</font></span>=
<span lang=3D"en-us"></span><span lang=3D"en-us"><font face=3D"Arial" size=
=3D"2">o</font></span>
<span lang=3D"en-us"></span><span lang=3D"en-us"><font face=3D"Arial" size=
=3D"2">ing</font></span><span lang=3D"en-us"></span><span lang=3D"en-us"><f=
ont face=3D"Arial" size=3D"2"> I/O on /dev/dm-0</font></span><span lang=3D"=
en-us"></span><span lang=3D"en-us">
<font face=3D"Arial" size=3D"2">)</font></span><span lang=3D"en-us"></span>=
<span lang=3D"en-us"></span></p>
<br>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:47:14 apwtest52 kernel: SCSI error : &lt;2 0 0 1&gt; return code=
 =3D 0x20000&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; </font></span></p></div></blockquote><blockquote class=3D"gmail_quote" =
style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8=
ex; padding-left: 1ex;">
<div style=3D"direction: ltr;"><p align=3D"left"><span lang=3D"en-us"><font=
 face=3D"Arial" size=3D"2">Feb&nbsp; 1 11:47:14 apwtest52 kernel: end_reque=
st: I/O error, dev sda, sector 1584600</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:47:14 apwtest52 kernel: device-mapper: dm-multipath: Failing pat=
h 8:0.&nbsp;&nbsp;&nbsp;&nbsp; &lt;=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3Dpath failed, after disabling/enabling the H2 host port 1=20
</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:47:14 apwtest52 kernel: end_request: I/O error, dev sda, sector =
1584608</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:47:45 apwtest52 kernel: SCSI error : &lt;3 0 1 1&gt; return code=
 =3D 0x20000&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sdg, sector =
861400 </font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:47:45 apwtest52 kernel: device-mapper: dm-multipath: Failing pat=
h 8:96.&nbsp;&nbsp; &lt;=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
path failed, after disabling/enabling&nbsp; the H2 host port 2
</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sdg, sector =
861408 </font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:47:45 apwtest52 kernel: SCSI error : &lt;3 0 0 1&gt; return code=
 =3D 0x20000</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde, sector =
452760 </font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:47:45 apwtest52 kernel: device-mapper: dm-multipath: Failing pat=
h 8:64.&nbsp; &lt;=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3Dpath f=
ailed after disabling/enabling the H2 host port 1
</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde, sector =
452768 </font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:47:45 apwtest52 kernel: SCSI error : &lt;3 0 0 1&gt; return code=
 =3D 0x20000</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde, sector =
453784 </font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde, sector =
453792 </font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:47:45 apwtest52 kernel: SCSI error : &lt;3 0 0 1&gt; return code=
 =3D 0x20000</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde, sector =
454808 </font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde, sector =
454816</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:47:45 apwtest52 kernel: SCSI error : &lt;3 0 0 1&gt; return code=
 =3D 0x20000</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde, sector =
863960</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:47:45 apwtest52 kernel: end_request: I/O error, dev sde, sector =
863968 </font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: SCSI error : &lt;2 0 1 1&gt; return code=
 =3D 0x20000</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: end_request: I/O error, dev sdc, sector =
935384 </font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: device-mapper: dm-multipath: Failing pat=
h 8:32.&nbsp; &lt;=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D after=
 disabling/enabling&nbsp; the H2 host port 2</font></span>
</p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: end_request: I/O error, dev sdc, sector =
935392 </font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logical=
 block 116924&nbsp;&nbsp;&nbsp; &lt;=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3DAll=
 path to the device /dev/dm-0 failed</font></span>
</p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logical=
 block 116925</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logical=
 block 116926</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logical=
 block 116927</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logical=
 block 116928</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logical=
 block 116929</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logical=
 block 116930</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logical=
 block 116931</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logical=
 block 116932</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logical=
 block 116933</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logical=
 block 116934</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logical=
 block 116935</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logical=
 block 116936</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logical=
 block 116937</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logical=
 block 116938</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logical=
 block 116939</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Feb&=
nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0, logical=
 block 116940</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </font></=
span></p>

<p align=3D"left"><span lang=3D"en-us"><b><font face=3D"Arial" size=3D"2">O=
bservations :</font></b></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; As we do the port failur</font></span><span lang=
=3D"en-us"></span><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">e</f=
ont></span><span lang=3D"en-us"></span>
<span lang=3D"en-us"> <font face=3D"Arial" size=3D"2">on the other host</fo=
nt></span><span lang=3D"en-us"></span><span lang=3D"en-us"><font face=3D"Ar=
ial" size=3D"2">, paths of the dm device is failed and the subsequent por</=
font></span>
<span lang=3D"en-us"></span><span lang=3D"en-us"><font face=3D"Arial" size=
=3D"2">t</font></span><span lang=3D"en-us"></span><span lang=3D"en-us"> <fo=
nt face=3D"Arial" size=3D"2">(i.e A2 or H2 ports) disabling/enabling result=
s into more numbers of path failure and that leads into all path failure co=
ndition
</font></span><span lang=3D"en-us"></span><span lang=3D"en-us"><font face=
=3D"Arial" size=3D"2">, w</font></span><span lang=3D"en-us"></span><span la=
ng=3D"en-us"><font face=3D"Arial" size=3D"2">hich in turn results into IO e=
rror on RHEL4.0
 U2/U3.</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">&nbs=
p;&nbsp;&nbsp;&nbsp; Through the device-mapper debug</font></span><span lan=
g=3D"en-us"></span><span lang=3D"en-us"> <font face=3D"Arial" size=3D"2">dr=
iver we</font></span><span lang=3D"en-us">
</span><span lang=3D"en-us"><font face=3D"Arial" size=3D"2"> are finding th=
at the there is no valid path in</font></span><span lang=3D"en-us"><b><i></=
i></b></span><span lang=3D"en-us"><b><i> <font face=3D"Arial" size=3D"2">__=
choose_pgpath()
</font></i></b></span><span lang=3D"en-us"></span><span lang=3D"en-us"><fon=
t face=3D"Arial" size=3D"2"> and&nbsp;</font></span><span lang=3D"en-us"><b=
><i></i></b></span><span lang=3D"en-us"><b><i> <font face=3D"Arial" size=3D=
"2">m-&gt;current_pgpath
</font></i></b></span><span lang=3D"en-us"></span><span lang=3D"en-us"><fon=
t face=3D"Arial" size=3D"2"></font></span><span lang=3D"en-us"></span><span=
 lang=3D"en-us"> <font face=3D"Arial" size=3D"2">(m is pointer to struct mu=
ltipath)</font>
</span><span lang=3D"en-us"></span><span lang=3D"en-us"> <font face=3D"Aria=
l" size=3D"2">is null when it comes to map_io() in dm-mpath.c.</font></span=
><span lang=3D"en-us"></span><span lang=3D"en-us"></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Anot=
her observation</font></span><span lang=3D"en-us"></span><span lang=3D"en-u=
s"> <font face=3D"Arial" size=3D"2">is that we are not seeing any IO errors=
 when the</font>
</span><span lang=3D"en-us"></span><span lang=3D"en-us"> <font face=3D"Aria=
l" size=3D"2">same</font></span><span lang=3D"en-us"></span><span lang=3D"e=
n-us"><font face=3D"Arial" size=3D"2"> test is executed on SLES9 SP3/SP4.</=
font></span>
</p></div></blockquote><div><br><div>Are you using the Qlogic or Emulex dri=
ver with your RHEL4 and SLES9 systems? <br>
<br>The 0x20000 errors you are seeing corresponds to DID_BUS_BUSY error. Th=
is is considered one of the 'retryable' errors by the SCSI layer. As far as=
 I know, Qlogic driver uses the DID_BUS_BUSY error return code to force a r=
etry of I/O for various fabric events. (I think they are planning on, or ma=
ybe already have, cleaned this up in their driver to remove this hack and u=
se block/unblock interface. This could be double-checked by looking at qlog=
ic source code for the driver version you're using). Since dm I/O uses a fa=
ilfast flag, these retryable errors won't get retried by the SCSI layer and=
 get immediately propagated up to dm, which is probably why you're getting =
errors even on paths that should be okay. If this is the case, I would expe=
ct this same problem to occur on your SLES9 systems too if you're using QLo=
gic driver.=20
<br>=20
<br>
I assume you're not using queue_if_no_path? From a dm and user perspective,=
 this is the only thing I can think of to work around this issue until the =
patch to propagate error codes up the stack is included and/or Qlogic stops=
 using DID_BUS_BUSY to force retries.=20
<br>
<br>Thanks,<br>lan<br></div></div><blockquote class=3D"gmail_quote" style=
=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; p=
adding-left: 1ex;"><div style=3D"direction: ltr;"><p align=3D"left"><span l=
ang=3D"en-us">
<font face=3D"Arial" size=3D"2">Please provide some pointers on why we are =
seeing this</font></span><span lang=3D"en-us"></span><span lang=3D"en-us"> =
<font face=3D"Arial" size=3D"2">behavior</font></span><span lang=3D"en-us">=
</span><span lang=3D"en-us">
<font face=3D"Arial" size=3D"2"></font></span><span lang=3D"en-us"></span><=
span lang=3D"en-us"> <font face=3D"Arial" size=3D"2">or</font></span><span =
lang=3D"en-us"></span><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">=
 is this</font></span>
<span lang=3D"en-us"></span><span lang=3D"en-us"> <font face=3D"Arial" size=
=3D"2">a know</font></span><span lang=3D"en-us"></span><span lang=3D"en-us"=
><font face=3D"Arial" size=3D"2">n</font></span><span lang=3D"en-us"></span=
><span lang=3D"en-us">
<font face=3D"Arial" size=3D"2"> thing at this point in time</font></span><=
span lang=3D"en-us"></span><span lang=3D"en-us"><font face=3D"Arial" size=
=3D"2">?</font></span><span lang=3D"en-us"></span><span lang=3D"en-us"></sp=
an></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">Than=
ks and regards</font></span></p></div><div style=3D"direction: ltr;"><span =
class=3D"sg">

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">-Mur=
thy</font></span></p>
<br>
<br>
<br>
<br>
<br>
<br>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">&nbs=
p;</font></span></p>

<p align=3D"left"><span lang=3D"en-us"><font face=3D"Arial" size=3D"2">&nbs=
p; </font></span></p>
<br>



</span></div><br>--<br>dm-devel mailing list<br><a onclick=3D"return top.js=
.OpenExtLink(window,event,this)" href=3D"mailto:dm-devel@redhat.com">dm-dev=
el@redhat.com</a><br><a onclick=3D"return top.js.OpenExtLink(window,event,t=
his)" href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_=
blank">
https://www.redhat.com/mailman/listinfo/dm-devel</a><br><br></blockquote></=
div><br>

------=_Part_12519_30191507.1143742678650--


--===============1147622103==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1147622103==--
