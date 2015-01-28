From: Suresh Babu Kandukuru <suresh.babu.kandukuru@oracle.com>
Subject: Re: dm_mirror/dm_raid1 limitations ?.
Date: Tue, 27 Jan 2015 20:03:18 -0800 (PST)
Message-ID: <2d1d9a04-d3f4-4714-a588-e2852ec8dcb8@default>
References: <4d982ea8-3769-46d2-ba73-2d1525faa63b@default>
	<54C64C4F.6090601@redhat.com>
	<E0704006-CC32-460A-AC22-149FD2B76583@oracle.com>
	<54C68F22.5080004@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4039023385302257191=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54C68F22.5080004@redhat.com>
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

--===============4039023385302257191==
Content-Type: multipart/alternative;
	boundary="__1422417801796114040abhmp0013.oracle.com"

--__1422417801796114040abhmp0013.oracle.com
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable

What is difference of  creating mirror with=20

1 ) mdadm (    mdadm --create --verbose /dev/md0 --level=3Dmirror --raid-de=
vices=3D2 /dev/sdb1 /dev/sdc1 --spare-devices=3D1 /dev/sdd1 )=20
and=20
2)  dmsetup ( dmsetp create mirror )

Which one is better ?. and Pros and cons ?. Google is not helping much=20
=20
/Suresh


-----Original Message-----
From: Marian Csontos [mailto:mcsontos@redhat.com]=20
Sent: Tuesday, January 27, 2015 12:32 AM
To: dm-devel@redhat.com
Subject: Re: [dm-devel] dm_mirror/dm_raid1 limitations ?.

On 01/26/2015 04:34 PM,  HYPERLINK "mailto:suresh.babu.kandukuru@oracle.com=
" suresh.babu.kandukuru@oracle.com wrote:
> Heinzm,thanks for the quick reply.. We are using dmestup create mirror=20
> ..as we want to do that on physical San lun (block devices) ... Not=20
> the one ( lv create ) you mentioned below.. Is there any advantage=20
> going with logical volume approach lvcreate -type

One of LVM features is monitoring of mirror/raid LVs and removing/replacing=
 any missing legs.

Using dmsetup directly, you have to do this manually.

>
> /Suresh
>
> Sent from my iPhone
>
>> On Jan 26, 2015, at 7:46 PM, Heinz Mauelshagen < HYPERLINK "mailto:heinz=
m@redhat.com" heinzm@redhat.com>
>> wrote:
>>
>>
>>> On 01/26/2015 02:51 PM, Suresh Babu Kandukuru wrote: Use case is
>>> : Two luns are mapped from storage array to linux host which are in=20
>>> same SAN fabric . we want to create a mirror on the linux host with=20
>>> these two luns and let  host use that mirror lun .  basic tests=20
>>> suggest that dm_mirror working fine . when we have any intermittent=20
>>> path issues with between host and san array , host i/o just freeze ,=20
>>> never returns back even after the path is online.
>>
>> Hard to tell what's happening without any kernel log.
>>
>>>
>>> Is dm_mirror viable solution here  ?. Can you point me any link=20
>>> which gives the limitations of dm_mirror ? . another alternate=20
>>> solutions you propose here ?. Thanks in advance .
>>
>> We've switched the default away from "mirror" to "raid1" in order to=20
>> take advantage of th MD runtime. Have you tested  "lvcreate --type=20
>> raid1 ..." yet? Please do.
>>
>> Regards, Heinz
>>
>>>
>>> Thanks /Suresh
>>>
>>>
>>> -- dm-devel mailing list  HYPERLINK "mailto:dm-devel@redhat.com" dm-dev=
el@redhat.com=20
>>> https://www.redhat.com/mailman/listinfo/dm-devel
>>
>> <Untitled.txt>
>
>
>
> -- dm-devel mailing list  HYPERLINK "mailto:dm-devel@redhat.com" dm-devel=
@redhat.com=20
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--
dm-devel mailing list
 HYPERLINK "mailto:dm-devel@redhat.com" dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

--__1422417801796114040abhmp0013.oracle.com
Content-Type: text/html; charset=us-ascii
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; charset=3Dus-ascii"=
>
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version 14.02.5004.0=
00">
<TITLE>RE: [dm-devel] dm_mirror/dm_raid1 limitations ?.</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">What is difference=
 of&nbsp; creating mirror with</FONT></SPAN><SPAN LANG=3D"en-us"> </SPAN></=
P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">1 )</FONT></SPAN><=
SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri"></FONT></SPAN><SPAN LANG=3D"en-u=
s"> <FONT FACE=3D"Calibri">mdadm (</FONT></SPAN><SPAN LANG=3D"en-us"><FONT =
FACE=3D"Calibri">&nbsp;&nbsp;&nbsp;</FONT></SPAN><SPAN LANG=3D"en-us"><B> <=
FONT FACE=3D"Calibri">mdadm --create --verbose /dev/md0 --level=3Dmirror --=
raid-devices=3D2 /dev/sdb1 /dev/sdc1 --spare-devices=3D1 /dev/sdd1</FONT></=
B></SPAN><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri"> )</FONT></SPAN><SPAN =
LANG=3D"en-us"> </SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">and</FONT></SPAN><=
SPAN LANG=3D"en-us"> </SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">2)</FONT></SPAN><S=
PAN LANG=3D"en-us">&nbsp;<FONT FACE=3D"Calibri"></FONT></SPAN><SPAN LANG=3D=
"en-us"> <FONT FACE=3D"Calibri">dmsetup (</FONT></SPAN><SPAN LANG=3D"en-us"=
><FONT FACE=3D"Calibri"></FONT></SPAN><SPAN LANG=3D"en-us"><B> <FONT FACE=
=3D"Calibri">dmsetp create mirror</FONT></B></SPAN><SPAN LANG=3D"en-us"><FO=
NT FACE=3D"Calibri"></FONT></SPAN><SPAN LANG=3D"en-us"> <FONT FACE=3D"Calib=
ri">)</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">Which one is bette=
r ?. and Pros and cons ?. Google is not helping much</FONT></SPAN><SPAN LAN=
G=3D"en-us"> </SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri"></FONT></SPAN><SPA=
N LANG=3D"en-us">&nbsp;</SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"></SPAN><SPAN LANG=3D"en-us"><FONT FACE=3D=
"Calibri">/Suresh</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">-----Original Mess=
age-----<BR>
From: Marian Csontos [<A HREF=3D"mailto:mcsontos@redhat.com">mailto:mcsonto=
s@redhat.com</A>]<BR>
Sent: Tuesday, January 27, 2015 12:32 AM<BR>
To: dm-devel@redhat.com<BR>
Subject: Re: [dm-devel] dm_mirror/dm_raid1 limitations ?.</FONT></SPAN><SPA=
N LANG=3D"en-us"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">On 01/26/2015 04:3=
4 PM,</FONT></SPAN><SPAN LANG=3D"en-us"> </SPAN><A HREF=3D"mailto:suresh.ba=
bu.kandukuru@oracle.com"><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">suresh=
.babu.kandukuru@oracle.com</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN></A><SP=
AN LANG=3D"en-us"><FONT FACE=3D"Calibri"> wrote:</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt; Heinzm,thanks=
 for the quick reply.. We are using dmestup create mirror </FONT></SPAN></P=
>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt; ..as we want =
to do that on physical San lun (block devices) ... Not </FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt; the one ( lv =
create ) you mentioned below.. Is there any advantage </FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt; going with lo=
gical volume approach lvcreate -type</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">One of LVM feature=
s is monitoring of mirror/raid LVs and removing/replacing any missing legs.=
</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">Using dmsetup dire=
ctly, you have to do this manually.</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;</FONT></SPAN>=
</P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt; /Suresh</FONT=
></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;</FONT></SPAN>=
</P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt; Sent from my =
iPhone</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;</FONT></SPAN>=
</P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt; On Jan 26=
, 2015, at 7:46 PM, Heinz Mauelshagen &lt;</FONT></SPAN><SPAN LANG=3D"en-us=
"></SPAN><A HREF=3D"mailto:heinzm@redhat.com"><SPAN LANG=3D"en-us"><FONT FA=
CE=3D"Calibri">heinzm@redhat.com</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><=
/A><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt; wrote:</F=
ONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;</FONT></S=
PAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;</FONT></S=
PAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;&gt; On 01=
/26/2015 02:51 PM, Suresh Babu Kandukuru wrote: Use case is</FONT></SPAN></=
P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;&gt; : Two=
 luns are mapped from storage array to linux host which are in </FONT></SPA=
N></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;&gt; same =
SAN fabric . we want to create a mirror on the linux host with </FONT></SPA=
N></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;&gt; these=
 two luns and let&nbsp; host use that mirror lun .&nbsp; basic tests </FONT=
></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;&gt; sugge=
st that dm_mirror working fine . when we have any intermittent </FONT></SPA=
N></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;&gt; path =
issues with between host and san array , host i/o just freeze , </FONT></SP=
AN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;&gt; never=
 returns back even after the path is online.</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;</FONT></S=
PAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt; Hard to t=
ell what's happening without any kernel log.</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;</FONT></S=
PAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;&gt;</FONT=
></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;&gt; Is dm=
_mirror viable solution here&nbsp; ?. Can you point me any link </FONT></SP=
AN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;&gt; which=
 gives the limitations of dm_mirror ? . another alternate </FONT></SPAN></P=
>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;&gt; solut=
ions you propose here ?. Thanks in advance .</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;</FONT></S=
PAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt; We've swi=
tched the default away from &quot;mirror&quot; to &quot;raid1&quot; in orde=
r to </FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt; take adva=
ntage of th MD runtime. Have you tested&nbsp; &quot;lvcreate --type </FONT>=
</SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt; raid1 ...=
&quot; yet? Please do.</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;</FONT></S=
PAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt; Regards, =
Heinz</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;</FONT></S=
PAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;&gt;</FONT=
></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;&gt; Thank=
s /Suresh</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;&gt;</FONT=
></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;&gt;</FONT=
></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;&gt; -- dm=
-devel mailing list</FONT></SPAN><SPAN LANG=3D"en-us"> </SPAN><A HREF=3D"ma=
ilto:dm-devel@redhat.com"><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">dm-de=
vel@redhat.com</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN></A><SPAN LANG=3D"e=
n-us"><FONT FACE=3D"Calibri"> </FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;&gt;</FONT=
></SPAN><SPAN LANG=3D"en-us"> </SPAN><A HREF=3D"https://www.redhat.com/mail=
man/listinfo/dm-devel"><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">https://=
www.redhat.com/mailman/listinfo/dm-devel</FONT></SPAN><SPAN LANG=3D"en-us">=
</SPAN></A><SPAN LANG=3D"en-us"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt;</FONT></S=
PAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;&gt; &lt;Untit=
led.txt&gt;</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;</FONT></SPAN>=
</P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;</FONT></SPAN>=
</P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;</FONT></SPAN>=
</P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt; -- dm-devel m=
ailing list</FONT></SPAN><SPAN LANG=3D"en-us"> </SPAN><A HREF=3D"mailto:dm-=
devel@redhat.com"><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">dm-devel@redh=
at.com</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN></A><SPAN LANG=3D"en-us"><F=
ONT FACE=3D"Calibri"> </FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;</FONT></SPAN>=
<SPAN LANG=3D"en-us"> </SPAN><A HREF=3D"https://www.redhat.com/mailman/list=
info/dm-devel"><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">https://www.redh=
at.com/mailman/listinfo/dm-devel</FONT></SPAN><SPAN LANG=3D"en-us"></SPAN><=
/A><SPAN LANG=3D"en-us"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">&gt;</FONT></SPAN>=
</P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">--</FONT></SPAN></=
P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">dm-devel mailing l=
ist</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"></SPAN><A HREF=3D"mailto:dm-devel@redhat.=
com"><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">dm-devel@redhat.com</FONT>=
</SPAN><SPAN LANG=3D"en-us"></SPAN></A><SPAN LANG=3D"en-us"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-us"></SPAN><A HREF=3D"https://www.redhat.com/=
mailman/listinfo/dm-devel"><SPAN LANG=3D"en-us"><FONT FACE=3D"Calibri">http=
s://www.redhat.com/mailman/listinfo/dm-devel</FONT></SPAN><SPAN LANG=3D"en-=
us"></SPAN></A><SPAN LANG=3D"en-us"></SPAN></P>

</BODY>
</HTML>
--__1422417801796114040abhmp0013.oracle.com--


--===============4039023385302257191==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4039023385302257191==--
