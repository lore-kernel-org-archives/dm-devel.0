From: Javier Barroso <javibarroso@gmail.com>
Subject: Re: Clariion EMC RX300 and "long trespass command will be
	send" message
Date: Tue, 10 Mar 2009 16:27:45 +0100
Message-ID: <81c921f30903100827o11edb182id7e1c90e4809eedc@mail.gmail.com>
References: <81c921f30903100341h59740b3dtedb61960b5e5daf7@mail.gmail.com>
	<20090310143512.GE22889@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1761222094=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090310143512.GE22889@mars.virtualiron.com>
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

--===============1761222094==
Content-Type: multipart/alternative; boundary=000e0cd30508ae6d050464c56427

--000e0cd30508ae6d050464c56427
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Tue, Mar 10, 2009 at 3:35 PM, Konrad Rzeszutek <konrad@virtualiron.com>wrote:

> > [5078349.903410] scsi 6:0:0:0: rejecting I/O to dead device
> ... snip ..
> > scsi 6:0:0:0 not exist at lsscsi:
>
> How did it disappear?

Ok. It dissapear when I upgraded my system.

As I have lvm in iscsi volume, I had to patch lvm init.d stop script (see my
no-answered question athttp://
www.redhat.com/archives/linux-lvm/2009-February/msg00003.html and
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=498616) (else, my reboot
hangs).

But this change (add vgchange --available=n $vg || RETVAL=1 at stop function
in /etc/init.d/open-iscsi ) made my upgrade hang (I had to manually kill the
proccess, umount my partitions on iscsi and follow with the installation)

So in my logs:

First ISCSI start (and tells connection 5-8 are operationals):
Mar  5 15:46:50 sprdom kernel: [4608617.246584] scsi4 : iSCSI Initiator over
TCP/IP
Mar  5 15:46:50 sprdom kernel: [4608617.246832] scsi5 : iSCSI Initiator over
TCP/IP
Mar  5 15:46:50 sprdom kernel: [4608617.250835] scsi6 : iSCSI Initiator over
TCP/IP
Mar  5 15:46:50 sprdom kernel: [4608617.250835] scsi7 : iSCSI Initiator over
TCP/IP
....
Mar  5 15:46:50 sprdom kernel: [4608617.552350]  sdg:<6>sd 6:0:0:0: [sdg]
Device not ready: Sense Key : Not Ready [current]
Mar  5 15:46:50 sprdom kernel: [4608617.552657] sd 6:0:0:0: [sdg] Device not
ready: Add. Sense: Logical unit not ready, manual intervention required
Mar  5 15:46:50 sprdom kernel: [4608617.552721] end_request: I/O error, dev
sdg, sector 0
Mar  5 15:46:50 sprdom kernel: [4608617.552752] __ratelimit: 28 messages
suppressed
....
Mar  5 15:46:51 sprdom kernel: [4608617.808252] sd 7:0:0:0: [sdh] Device not
ready: Sense Key : Not Ready [current]
Mar  5 15:46:51 sprdom kernel: [4608617.808318] sd 7:0:0:0: [sdh] Device not
ready: Add. Sense: Logical unit not ready, manual intervention
 required
Mar  5 15:46:51 sprdom kernel: [4608617.808861] end_request: I/O error, dev
sdh, sector 0
Mar  5 15:46:51 sprdom multipathd: mpath0: load table [0 1073741824
multipath 0 0 1 1 round-robin 0 1 1 8:96 1000]
Mar  5 15:46:51 sprdom multipathd: sdh: add path (uevent)
Mar  5 15:46:51 sprdom kernel: [4608617.817256] device-mapper: multipath
emc: long trespass command will be send
Mar  5 15:46:51 sprdom kernel: [4608617.817256] device-mapper: multipath
emc: honor reservation bit will not be set (default)
Mar  5 15:46:51 sprdom kernel: [4608617.819512] sd 6:0:0:0: [sdg] Device not
ready: Sense Key : Not Ready [current]
Mar  5 15:46:51 sprdom kernel: [4608617.819587] sd 6:0:0:0: [sdg] Device not
ready: Add. Sense: Logical unit not ready, manual intervention
 required
Mar  5 15:46:51 sprdom kernel: [4608617.819653] end_request: I/O error, dev
sdg, sector 0
Mar  5 15:46:51 sprdom kernel: [4608617.819685] device-mapper: multipath:
Failing path 8:96.
Mar  5 15:46:51 sprdom kernel: [4608617.819826] sd 6:0:0:0: [sdg] Device not
ready: Sense Key : Not Ready [current]
Mar  5 15:46:51 sprdom kernel: [4608617.819887] sd 6:0:0:0: [sdg] Device not
ready: Add. Sense: Logical unit not ready, manual intervention required
Mar  5 15:46:51 sprdom kernel: [4608617.819949] end_request: I/O error, dev
sdg, sector 0
Mar  5 15:46:51 sprdom kernel: [4608617.829248] device-mapper: multipath
emc: long trespass command will be send
Mar  5 15:46:51 sprdom kernel: [4608617.829270] device-mapper: multipath
emc: honor reservation bit will not be set (default)
Mar  5 15:46:51 sprdom kernel: [4608617.830657] device-mapper: multipath
emc: emc_pg_init: sending switch-over command
Mar  5 15:46:51 sprdom multipathd: mpath0: failed in domap for addition of
new path sdh
Mar  5 15:46:51 sprdom multipathd: mpath0: uev_add_path sleep
Mar  5 15:46:51 sprdom kernel: [4608617.861246] device-mapper: table: 254:6:
multipath: unknown path selector type
Mar  5 15:46:51 sprdom kernel: [4608617.861246] device-mapper: ioctl: error
adding target to table
Mar  5 15:46:51 sprdom iscsid: transport class version 2.0-869. iscsid
version 2.0-870
Mar  5 15:46:51 sprdom iscsid: iSCSI daemon with pid=25592 started!
Mar  5 15:46:51 sprdom iscsid: connection5:0 is operational now
Mar  5 15:46:51 sprdom iscsid: connection6:0 is operational now
Mar  5 15:46:51 sprdom iscsid: connection7:0 is operational now
Mar  5 15:46:51 sprdom iscsid: connection8:0 is operational now
Mar  5 15:46:51 sprdom kernel: [4608618.331096] device-mapper: multipath
emc: emc_pg_init: sending switch-over command
....

Later (the second upgrade try?) it works, but 6 and 7 are dead:
Mar  5 15:48:53 sprdom kernel: [4608750.038111] scsi8 : iSCSI Initiator over
TCP/IP
Mar  5 15:48:53 sprdom kernel: [4608750.038362] scsi9 : iSCSI Initiator over
TCP/IP
Mar  5 15:48:53 sprdom kernel: [4608750.047191] scsi10 : iSCSI Initiator
over TCP/IP
Mar  5 15:48:53 sprdom kernel: [4608750.049000] scsi11 : iSCSI Initiator
over TCP/IP
Mar  5 15:48:53 sprdom multipathd: sdg: checker msg is
"emc_clariion_checker: query command indicates error"
Mar  5 15:48:53 sprdom kernel: [4608750.195239] scsi 6:0:0:0: rejecting I/O
to dead device
Mar  5 15:48:53 sprdom kernel: [4608750.195239] scsi 7:0:0:0: rejecting I/O
to dead device
Mar  5 15:48:53 sprdom kernel: [4608750.195239] device-mapper: multipath
emc: long trespass command will be send
Mar  5 15:48:53 sprdom kernel: [4608750.195239] device-mapper: multipath
emc: honor reservation bit will not be set (default)
Mar  5 15:48:53 sprdom kernel: [4608750.229003] device-mapper: table: 254:6:
multipath: unknown path selector type
Mar  5 15:48:53 sprdom kernel: [4608750.229559] device-mapper: ioctl: error
adding target to table
Mar  5 15:48:53 sprdom multipathd: sdh: checker msg is
"emc_clariion_checker: query command indicates error"
Mar  5 15:48:53 sprdom multipathd: mpath0: failed in domap for addition of
new path sdh
Mar  5 15:48:53 sprdom multipathd: mpath0: uev_add_path sleep
...
Mar  5 15:48:53 sprdom iscsid: connection9:0 is operational now
Mar  5 15:48:53 sprdom iscsid: connection10:0 is operational now
Mar  5 15:48:53 sprdom iscsid: connection11:0 is operational now
Mar  5 15:48:53 sprdom iscsid: connection12:0 is operational now

> How could can I stop scsi system / multipath from this messages ?
>
> Try: multipathd -k'reconfigure'

I tried,
# multipathd -k'reconfigure'
OK

But syslog is growing like before

Should I ask to iscsi list then ?

Thank you very much

--000e0cd30508ae6d050464c56427
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">On Tue, Mar 10, 2009 at 3:35 PM, Konrad Rzeszute=
k <span dir=3D"ltr">&lt;<a href=3D"mailto:konrad@virtualiron.com">konrad@vi=
rtualiron.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" st=
yle=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex=
; padding-left: 1ex;">
<div class=3D"im">&gt; [5078349.903410] scsi 6:0:0:0: rejecting I/O to dead=
 device<br>
</div>... snip ..<br>
<div class=3D"im">&gt; scsi 6:0:0:0 not exist at lsscsi:<br>
<br>
</div>How did it disappear?</blockquote><div>Ok. It dissapear when I upgrad=
ed my system.<br><br>As I have lvm in iscsi volume, I had to patch lvm init=
.d stop script (see my no-answered question athttp://<a href=3D"http://www.=
redhat.com/archives/linux-lvm/2009-February/msg00003.html">www.redhat.com/a=
rchives/linux-lvm/2009-February/msg00003.html</a> and <a href=3D"http://bug=
s.debian.org/cgi-bin/bugreport.cgi?bug=3D498616">http://bugs.debian.org/cgi=
-bin/bugreport.cgi?bug=3D498616</a>) (else, my reboot hangs).<br>
<br>But this change (add vgchange --available=3Dn $vg || RETVAL=3D1 at stop=
 function in /etc/init.d/open-iscsi ) made my upgrade hang (I had to manual=
ly kill the proccess, umount my partitions on iscsi and follow with the ins=
tallation)<br>
<br>So in my logs:<br><br>First ISCSI start (and tells connection 5-8 are o=
perationals):<br>Mar=A0 5 15:46:50 sprdom kernel: [4608617.246584] scsi4 : =
iSCSI Initiator over TCP/IP<br>Mar=A0 5 15:46:50 sprdom kernel: [4608617.24=
6832] scsi5 : iSCSI Initiator over TCP/IP<br>
Mar=A0 5 15:46:50 sprdom kernel: [4608617.250835] scsi6 : iSCSI Initiator o=
ver TCP/IP<br>Mar=A0 5 15:46:50 sprdom kernel: [4608617.250835] scsi7 : iSC=
SI Initiator over TCP/IP<br>....<br>Mar=A0 5 15:46:50 sprdom kernel: [46086=
17.552350]=A0 sdg:&lt;6&gt;sd 6:0:0:0: [sdg] Device not ready: Sense Key : =
Not Ready [current] <br>
Mar=A0 5 15:46:50 sprdom kernel: [4608617.552657] sd 6:0:0:0: [sdg] Device =
not ready: Add. Sense: Logical unit not ready, manual intervention required=
<br>Mar=A0 5 15:46:50 sprdom kernel: [4608617.552721] end_request: I/O erro=
r, dev sdg, sector 0<br>
Mar=A0 5 15:46:50 sprdom kernel: [4608617.552752] __ratelimit: 28 messages =
suppressed<br>....<br>Mar=A0 5 15:46:51 sprdom kernel: [4608617.808252] sd =
7:0:0:0: [sdh] Device not ready: Sense Key : Not Ready [current] <br>Mar=A0=
 5 15:46:51 sprdom kernel: [4608617.808318] sd 7:0:0:0: [sdh] Device not re=
ady: Add. Sense: Logical unit not ready, manual intervention<br>
=A0required<br>Mar=A0 5 15:46:51 sprdom kernel: [4608617.808861] end_reques=
t: I/O error, dev sdh, sector 0<br>Mar=A0 5 15:46:51 sprdom multipathd: mpa=
th0: load table [0 1073741824 multipath 0 0 1 1 round-robin 0 1 1 8:96 1000=
]<br>
Mar=A0 5 15:46:51 sprdom multipathd: sdh: add path (uevent)<br>Mar=A0 5 15:=
46:51 sprdom kernel: [4608617.817256] device-mapper: multipath emc: long tr=
espass command will be send<br>Mar=A0 5 15:46:51 sprdom kernel: [4608617.81=
7256] device-mapper: multipath emc: honor reservation bit will not be set (=
default)<br>
Mar=A0 5 15:46:51 sprdom kernel: [4608617.819512] sd 6:0:0:0: [sdg] Device =
not ready: Sense Key : Not Ready [current] <br>Mar=A0 5 15:46:51 sprdom ker=
nel: [4608617.819587] sd 6:0:0:0: [sdg] Device not ready: Add. Sense: Logic=
al unit not ready, manual intervention<br>
=A0required<br>Mar=A0 5 15:46:51 sprdom kernel: [4608617.819653] end_reques=
t: I/O error, dev sdg, sector 0<br>Mar=A0 5 15:46:51 sprdom kernel: [460861=
7.819685] device-mapper: multipath: Failing path 8:96.<br>Mar=A0 5 15:46:51=
 sprdom kernel: [4608617.819826] sd 6:0:0:0: [sdg] Device not ready: Sense =
Key : Not Ready [current] <br>
Mar=A0 5 15:46:51 sprdom kernel: [4608617.819887] sd 6:0:0:0: [sdg] Device =
not ready: Add. Sense: Logical unit not ready, manual intervention required=
<br>Mar=A0 5 15:46:51 sprdom kernel: [4608617.819949] end_request: I/O erro=
r, dev sdg, sector 0<br>
Mar=A0 5 15:46:51 sprdom kernel: [4608617.829248] device-mapper: multipath =
emc: long trespass command will be send<br>Mar=A0 5 15:46:51 sprdom kernel:=
 [4608617.829270] device-mapper: multipath emc: honor reservation bit will =
not be set (default)<br>
Mar=A0 5 15:46:51 sprdom kernel: [4608617.830657] device-mapper: multipath =
emc: emc_pg_init: sending switch-over command<br>Mar=A0 5 15:46:51 sprdom m=
ultipathd: mpath0: failed in domap for addition of new path sdh<br>Mar=A0 5=
 15:46:51 sprdom multipathd: mpath0: uev_add_path sleep<br>
Mar=A0 5 15:46:51 sprdom kernel: [4608617.861246] device-mapper: table: 254=
:6: multipath: unknown path selector type<br>Mar=A0 5 15:46:51 sprdom kerne=
l: [4608617.861246] device-mapper: ioctl: error adding target to table<br>M=
ar=A0 5 15:46:51 sprdom iscsid: transport class version 2.0-869. iscsid ver=
sion 2.0-870<br>
Mar=A0 5 15:46:51 sprdom iscsid: iSCSI daemon with pid=3D25592 started!<br>=
Mar=A0 5 15:46:51 sprdom iscsid: connection5:0 is operational now<br>Mar=A0=
 5 15:46:51 sprdom iscsid: connection6:0 is operational now<br>Mar=A0 5 15:=
46:51 sprdom iscsid: connection7:0 is operational now<br>
Mar=A0 5 15:46:51 sprdom iscsid: connection8:0 is operational now<br>Mar=A0=
 5 15:46:51 sprdom kernel: [4608618.331096] device-mapper: multipath emc: e=
mc_pg_init: sending switch-over command<br>.... <br><br>Later (the second u=
pgrade try?) it works, but 6 and 7 are dead:<br>
Mar=A0 5 15:48:53 sprdom kernel: [4608750.038111] scsi8 : iSCSI Initiator o=
ver TCP/IP<br>Mar=A0 5 15:48:53 sprdom kernel: [4608750.038362] scsi9 : iSC=
SI Initiator over TCP/IP<br>Mar=A0 5 15:48:53 sprdom kernel: [4608750.04719=
1] scsi10 : iSCSI Initiator over TCP/IP<br>
Mar=A0 5 15:48:53 sprdom kernel: [4608750.049000] scsi11 : iSCSI Initiator =
over TCP/IP<br>Mar=A0 5 15:48:53 sprdom multipathd: sdg: checker msg is &qu=
ot;emc_clariion_checker: query command indicates error&quot;<br>Mar=A0 5 15=
:48:53 sprdom kernel: [4608750.195239] scsi 6:0:0:0: rejecting I/O to dead =
device<br>
Mar=A0 5 15:48:53 sprdom kernel: [4608750.195239] scsi 7:0:0:0: rejecting I=
/O to dead device<br>Mar=A0 5 15:48:53 sprdom kernel: [4608750.195239] devi=
ce-mapper: multipath emc: long trespass command will be send<br>Mar=A0 5 15=
:48:53 sprdom kernel: [4608750.195239] device-mapper: multipath emc: honor =
reservation bit will not be set (default)<br>
Mar=A0 5 15:48:53 sprdom kernel: [4608750.229003] device-mapper: table: 254=
:6: multipath: unknown path selector type<br>Mar=A0 5 15:48:53 sprdom kerne=
l: [4608750.229559] device-mapper: ioctl: error adding target to table<br>M=
ar=A0 5 15:48:53 sprdom multipathd: sdh: checker msg is &quot;emc_clariion_=
checker: query command indicates error&quot;<br>
Mar=A0 5 15:48:53 sprdom multipathd: mpath0: failed in domap for addition o=
f new path sdh<br>Mar=A0 5 15:48:53 sprdom multipathd: mpath0: uev_add_path=
 sleep<br>...<br>Mar=A0 5 15:48:53 sprdom iscsid: connection9:0 is operatio=
nal now<br>
Mar=A0 5 15:48:53 sprdom iscsid: connection10:0 is operational now<br>Mar=
=A0 5 15:48:53 sprdom iscsid: connection11:0 is operational now<br>Mar=A0 5=
 15:48:53 sprdom iscsid: connection12:0 is operational now<br><br></div><bl=
ockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 204=
, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div class=3D"im">&gt; How could can I stop scsi system / multipath from th=
is messages ?<br>
<br>
</div>Try: multipathd -k&#39;reconfigure&#39;</blockquote><div>I tried, <br=
></div><div># multipathd -k&#39;reconfigure&#39;<br>OK<br><br>But syslog is=
 growing like before<br><br>Should I ask to iscsi list then ?<br><br>Thank =
you very much <br>
</div></div>

--000e0cd30508ae6d050464c56427--


--===============1761222094==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1761222094==--
