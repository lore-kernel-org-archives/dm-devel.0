From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: path_grouping_policy group_by_serial prio question
Date: Tue, 8 Mar 2016 13:48:46 +0100
Message-ID: <CABr-Gne6uk8=SbOM8bHccnXLYHVZFGCRKbkRGNBF7SwJ39fhnA@mail.gmail.com>
References: <de2a545fcd595b05011ba8cd715d484a@broermann.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7056174156046503359=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <de2a545fcd595b05011ba8cd715d484a@broermann.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bernd Broermann <bernd@broermann.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============7056174156046503359==
Content-Type: multipart/alternative; boundary=001a11401a84920b59052d890052

--001a11401a84920b59052d890052
Content-Type: text/plain; charset=UTF-8

Hi,

the path_grouping_policy is only responsible for the path grouping.
The "emc" prioritizer here, attributes a prio to each path.
Priorities of paths in the same group are aggregated into a pathgroup
priority.
The pathgroup with the highest priority is activated.

Best regards,
Christophe Varoqui
www.opensvc.com


On Tue, Mar 8, 2016 at 1:03 PM, Bernd Broermann <bernd@broermann.com> wrote:

> Hello,
>
>
> Does "group_by_serial" activate the "low latency"  path ?
>
> There are two servers which have a separate path to a EMC VPLEX box in
> different Data centers ( DC1 , DC2 ) .
>
> Because of latency the paths are grouped by the serial number of the VPLEX
> box.
>
>
>
>
>        DC1                DC2
>
>    +------------+    +------------+
>    | Server 1   |    | Server 2   |
>    +------------+    +------------+
>       |   \              /  |
>       |     \          /    |
>       |       \      /      |
>       |         \  /        |
>       |          X          |
>       |        /   \        |
>       |      /       \      |
>       |    /           \    |
>       |  /              \   |
>    +------------+    +------------+
>    |disk VPLEX A|    |disk VPLEX B|
>    +------------+    +------------+
>
>
> As I expected the paths are grouped and the path to the "nearest" disk(
> VPLEX) is active.
>
> Is this an coincidence or does it work as designed ?
>
> I didn't find something enlightening in the dm documentation.
>
> Thank you for your help.
>
> Bernd
>
>
>
> partitial output of  "multipathd show config"
> ....
> device {
>     vendor "EMC"
>     product "Invista"
>     product_blacklist "LUNZ"
>     path_grouping_policy group_by_serial
>     getuid_callout "/lib/udev/scsi_id --whitelisted --device=/dev/%n"
>     path_selector "round-robin 0"
>     path_checker tur
>     features "0"
>     hardware_handler "1 emc"
>     prio emc
>     rr_weight uniform
>     no_path_retry fail
>     rr_min_io 1000
>     rr_min_io_rq 1
>     detect_prio yes
> }
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a11401a84920b59052d890052
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>the=C2=A0<span style=3D"font-size:1=
9.2px">path_grouping_policy is only responsible for the path grouping.</spa=
n></div><div><span style=3D"font-size:19.2px">The &quot;emc&quot; prioritiz=
er here, attributes a prio to each path.</span></div><div><span style=3D"fo=
nt-size:19.2px">Priorities of paths in the same group are aggregated into a=
 pathgroup priority.</span></div><div><span style=3D"font-size:19.2px">The =
pathgroup with the highest priority is activated.</span></div><div><span st=
yle=3D"font-size:19.2px"><br></span></div><div><span style=3D"font-size:19.=
2px">Best regards,</span></div><div><span style=3D"font-size:19.2px">Christ=
ophe Varoqui</span></div><div><span style=3D"font-size:19.2px"><a href=3D"h=
ttp://www.opensvc.com">www.opensvc.com</a></span></div><div><span style=3D"=
font-size:19.2px"><br></span></div></div><div class=3D"gmail_extra"><br><di=
v class=3D"gmail_quote">On Tue, Mar 8, 2016 at 1:03 PM, Bernd Broermann <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:bernd@broermann.com" target=3D"_blank"=
>bernd@broermann.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">Hello,<br>
<br>
<br>
Does &quot;group_by_serial&quot; activate the &quot;low latency&quot;=C2=A0=
 path ?<br>
<br>
There are two servers which have a separate path to a EMC VPLEX box in diff=
erent Data centers ( DC1 , DC2 ) .<br>
<br>
Because of latency the paths are grouped by the serial number of the VPLEX =
box.<br>
<br>
<br>
<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0DC1=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 DC2<br>
<br>
=C2=A0 =C2=A0+------------+=C2=A0 =C2=A0 +------------+<br>
=C2=A0 =C2=A0| Server 1=C2=A0 =C2=A0|=C2=A0 =C2=A0 | Server 2=C2=A0 =C2=A0|=
<br>
=C2=A0 =C2=A0+------------+=C2=A0 =C2=A0 +------------+<br>
=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A0\=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 /=C2=A0 |<br>
=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A0 =C2=A0\=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /=C2=A0 =C2=A0 |<br>
=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A0 =C2=A0 =C2=A0\=C2=A0 =C2=A0 =C2=A0 /=C2=
=A0 =C2=A0 =C2=A0 |<br>
=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\=C2=A0 /=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 |<br>
=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 X=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 |<br>
=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A0 =C2=A0 =C2=A0 /=C2=A0 =C2=A0\=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 |<br>
=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A0 =C2=A0 /=C2=A0 =C2=A0 =C2=A0 =C2=A0\=C2=
=A0 =C2=A0 =C2=A0 |<br>
=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A0 /=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0\=C2=A0 =C2=A0 |<br>
=C2=A0 =C2=A0 =C2=A0 |=C2=A0 /=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 \=C2=A0 =C2=A0|<br>
=C2=A0 =C2=A0+------------+=C2=A0 =C2=A0 +------------+<br>
=C2=A0 =C2=A0|disk VPLEX A|=C2=A0 =C2=A0 |disk VPLEX B|<br>
=C2=A0 =C2=A0+------------+=C2=A0 =C2=A0 +------------+<br>
<br>
<br>
As I expected the paths are grouped and the path to the &quot;nearest&quot;=
 disk( VPLEX) is active.<br>
<br>
Is this an coincidence or does it work as designed ?<br>
<br>
I didn&#39;t find something enlightening in the dm documentation.<br>
<br>
Thank you for your help.<br>
<br>
Bernd<br>
<br>
<br>
<br>
partitial output of=C2=A0 &quot;multipathd show config&quot;<br>
....<br>
device {<br>
=C2=A0 =C2=A0 vendor &quot;EMC&quot;<br>
=C2=A0 =C2=A0 product &quot;Invista&quot;<br>
=C2=A0 =C2=A0 product_blacklist &quot;LUNZ&quot;<br>
=C2=A0 =C2=A0 path_grouping_policy group_by_serial<br>
=C2=A0 =C2=A0 getuid_callout &quot;/lib/udev/scsi_id --whitelisted --device=
=3D/dev/%n&quot;<br>
=C2=A0 =C2=A0 path_selector &quot;round-robin 0&quot;<br>
=C2=A0 =C2=A0 path_checker tur<br>
=C2=A0 =C2=A0 features &quot;0&quot;<br>
=C2=A0 =C2=A0 hardware_handler &quot;1 emc&quot;<br>
=C2=A0 =C2=A0 prio emc<br>
=C2=A0 =C2=A0 rr_weight uniform<br>
=C2=A0 =C2=A0 no_path_retry fail<br>
=C2=A0 =C2=A0 rr_min_io 1000<br>
=C2=A0 =C2=A0 rr_min_io_rq 1<br>
=C2=A0 =C2=A0 detect_prio yes<br>
}<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
</blockquote></div><br></div>

--001a11401a84920b59052d890052--


--===============7056174156046503359==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7056174156046503359==--
