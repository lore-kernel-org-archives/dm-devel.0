From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Re: Unable to deactivate lv,
	pehaps due to semaphore problem...
Date: Thu, 27 Nov 2014 16:01:53 +0100
Message-ID: <CAG2kNCyDcgCdCpUAzZ51mAyqS8LF9i9Tau3Lke5E2ZJy352_ig@mail.gmail.com>
References: <CAG2kNCxiZhRpfnifa58bDODfcyhaArLmP4kbgPfPs=2Lq_tYWw@mail.gmail.com>
	<54773621.5090301@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6771325335251837348=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54773621.5090301@redhat.com>
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

--===============6771325335251837348==
Content-Type: multipart/alternative; boundary=f46d043c7ef8b1fcbf0508d86cb8

--f46d043c7ef8b1fcbf0508d86cb8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 27, 2014 at 3:33 PM, Zdenek Kabelac <zkabelac@redhat.com> wrote=
:

> Dne 27.11.2014 v 15:26 Gianluca Cecchi napsal(a):
>
>> Hello,
>> I'm unable to deactivate an lvm.
>>
>> My system is RHEL 6.5 with lvm2-2.02.100-8.el6.x86_64 and kernel
>> 2.6.32-431.29.2.el6.x86_64
>>
>> I get error code 5 with message
>>    Logical volume VG_AAA_TEMP/LV_AAA_TEMP in use.
>>
>> You can find output of
>> lvchange -d -d -d -d -d -d -an VG_AAA_TEMP/LV_AAA_TEMP
>> here:
>> https://drive.google.com/file/d/0BwoPbcrMv8mvTjlBMkRUbG9nczA/
>> view?usp=3Dsharing
>>
>>
> Not really accessible.
>

strange, do you mean the google docs link?
I tried with a browser without access to any gmail account and I'm able to
download it....


>
> But anyway - if you have problem with  'semaphore' resouces - you could
> 'recycle' old ones -
>
> 'dmsetup  udevcomplete_all'
>

This is actually a production server with many other LVs... Is there any
drawback in the command above?


>
> Of course it's hard to guess what experiments are you doing and would
> could lead to uncompleted cockies (stuck udev scans)
>

Actually no experiment at all.
The node is part of a rhel 2-nodes production cluster with HA_LVM based
services.
We need to relocate many services to the other node for a planned
maintenance, but it seems that this one is able to stop the lvm resources,
but not cleanly deactivate the LVs. We get messages like

Nov 26 17:35:29 orapr2 rgmanager[5765]: [lvm] Deactivating
VG_AAA_TEMP/LV_AAA_TEMP
Nov 26 17:35:29 orapr2 rgmanager[5786]: [lvm] Making resilient : lvchange
-an VG_AAA_TEMP/LV_AAA_TEMP
Nov 26 17:35:29 orapr2 rgmanager[5809]: [lvm] Resilient command: lvchange
-an VG_AAA_TEMP/LV_AAA_TEMP --config devices{filter=3D["a|/dev/ma
pper/360a9800037543544465d424
Nov 26 17:35:34 orapr2 rgmanager[5883]: [lvm] lv_exec_resilient failed
Nov 26 17:35:34 orapr2 rgmanager[5908]: [lvm] lv_activate_resilient stop
failed on VG_AAA_TEMP/LV_AAA_TEMP
Nov 26 17:35:34 orapr2 rgmanager[5928]: [lvm] Unable to deactivate
VG_AAA_TEMP/LV_AAA_TEMP
Nov 26 17:35:34 orapr2 rgmanager[5948]: [lvm] Failed to stop
VG_AAA_TEMP/LV_AAA_TEMP
Nov 26 17:35:34 orapr2 rgmanager[5968]: [lvm] Attempting cleanup of
VG_AAA_TEMP
Nov 26 17:35:34 orapr2 rgmanager[5989]: [lvm] VG_AAA_TEMP now consistent
Nov 26 17:35:34 orapr2 rgmanager[6013]: [lvm] Deactivating
VG_AAA_TEMP/LV_AAA_TEMP
Nov 26 17:35:34 orapr2 rgmanager[6033]: [lvm] Making resilient : lvchange
-an VG_AAA_TEMP/LV_AAA_TEMP
Nov 26 17:35:35 orapr2 rgmanager[6056]: [lvm] Resilient command: lvchange
-an VG_AAA_TEMP/LV_AAA_TEMP --config devices{filter=3D["a|/dev/ma
pper/360a9800037543544465d424
Nov 26 17:35:39 orapr2 rgmanager[6648]: [lvm] lv_exec_resilient failed
Nov 26 17:35:40 orapr2 rgmanager[6670]: [lvm] lv_activate_resilient stop
failed on VG_AAA_TEMP/LV_AAA_TEMP
Nov 26 17:35:40 orapr2 rgmanager[6690]: [lvm] Unable to deactivate
VG_AAA_TEMP/LV_AAA_TEMP
Nov 26 17:35:40 orapr2 rgmanager[6710]: [lvm] Failed second attempt to stop
VG_AAA_TEMP/LV_AAA_TEMP
Nov 26 17:35:40 orapr2 rgmanager[20260]: stop on lvm "LV_AAA_TEMP" returned
1 (generic error)
Nov 26 17:35:40 orapr2 rgmanager[20260]: Marking service:AAA as 'disabled',
but some resources may still be allocated!
Nov 26 17:35:40 orapr2 rgmanager[20260]: Service service:AAA is disabled

And of course the other node then is unable to activate the service due to
LV maintained open from the first one:

Nov 26 17:35:40 orapr1 rgmanager[18596]: Starting disabled service
service:AAA
Nov 26 17:35:41 orapr1 rgmanager[31420]: [lvm] Someone else owns this
logical volume
Nov 26 17:35:41 orapr1 rgmanager[18596]: start on lvm "LV_AAA_TEMP"
returned 1 (generic error)
Nov 26 17:35:41 orapr1 rgmanager[18596]: #68: Failed to start service:AAA;
return value: 1

So I'm trying to reproduce the cluster command to see how to clean the
situation, using this particular service (named AAA) that is not critical
as the other ones running on the node


> Do you happen to have some suspend devices in your table ?
> (dmsetup info -c    should show them)


It seems not so. Only (L)ive states...

[root@orapr2 ~]# dmsetup info -c | awk '{print $4}' | sort | uniq -c
     77 L--w
      1 Stat



>
>
>  [root@orapr2 ~]# lvs VG_AAA_TEMP/LV_AAA_TEMP
>>    LV          VG          Attr       LSize    Pool Origin Data%  Move L=
og
>> Cpy%Sync Convert
>>    LV_AAA_TEMP VG_AAA_TEMP -wi-ao---- 1020.00m
>>
>> How can I see the responsible for the reference that apparently keeps it
>> open?
>>
>> Open count:        1
>> so I can check and eventually fix??
>>
>>
> dmsetup ls --tree
>
> is usually good in shows deps between devs (i.e.  target A holds target B=
)
>
> Regards
>
> Zdenek
>
>
>
it returns no particular output related
...
 VG_AAA_TEMP-LV_AAA_TEMP (253:49)
 =E2=94=94=E2=94=80360a9800037543544465d424130533177 (253:4)
    =E2=94=9C=E2=94=80 (130:128)
    =E2=94=9C=E2=94=80 (129:32)
    =E2=94=9C=E2=94=80 (68:48)
    =E2=94=9C=E2=94=80 (8:96)
    =E2=94=9C=E2=94=80 (8:288)
    =E2=94=9C=E2=94=80 (133:224)
    =E2=94=9C=E2=94=80 (69:192)
    =E2=94=94=E2=94=80 (66:160)
...

BTW: I'm testing this one but it seems that the problem is general, in the
sense that each LV gets this kind of behaviour trying to deactivating it...

Thanks in advance for any other insight and let me know if I can send it
the debug log of lvchange command in case you are not yet able to access
it...

Gianluca

--f46d043c7ef8b1fcbf0508d86cb8
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On T=
hu, Nov 27, 2014 at 3:33 PM, Zdenek Kabelac <span dir=3D"ltr">&lt;<a href=
=3D"mailto:zkabelac@redhat.com" target=3D"_blank">zkabelac@redhat.com</a>&g=
t;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0=
px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);borde=
r-left-style:solid;padding-left:1ex">Dne 27.11.2014 v 15:26 Gianluca Cecchi=
 napsal(a):<span class=3D""><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex">
Hello,<br>
I&#39;m unable to deactivate an lvm.<br>
<br>
My system is RHEL 6.5 with lvm2-2.02.100-8.el6.x86_64 and kernel<br>
2.6.32-431.29.2.el6.x86_64<br>
<br>
I get error code 5 with message<br>
=C2=A0 =C2=A0Logical volume VG_AAA_TEMP/LV_AAA_TEMP in use.<br>
<br>
You can find output of<br>
lvchange -d -d -d -d -d -d -an VG_AAA_TEMP/LV_AAA_TEMP<br>
here:<br>
<a href=3D"https://drive.google.com/file/d/0BwoPbcrMv8mvTjlBMkRUbG9nczA/vie=
w?usp=3Dsharing" target=3D"_blank">https://drive.google.com/file/<u></u>d/<=
u></u>0BwoPbcrMv8mvTjlBMkRUbG9nczA/<u></u>view?usp=3Dsharing</a><br>
<br>
</blockquote>
<br></span>
Not really accessible.<br></blockquote><div><br></div><div>strange, do you =
mean the google docs link?</div><div>I tried with a browser without access =
to any gmail account and I&#39;m able to download it....</div><div>=C2=A0=
=C2=A0=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px=
 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-=
left-style:solid;padding-left:1ex">
<br>
But anyway - if you have problem with=C2=A0 &#39;semaphore&#39; resouces - =
you could &#39;recycle&#39; old ones -<br>
<br>
&#39;dmsetup=C2=A0 udevcomplete_all&#39;<br></blockquote><div><br></div><di=
v>This is actually a production server with many other LVs... Is there any =
drawback in the command above?</div><div>=C2=A0</div><blockquote class=3D"g=
mail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-=
left-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex">
<br>
Of course it&#39;s hard to guess what experiments are you doing and would c=
ould lead to uncompleted cockies (stuck udev scans)<br></blockquote><div><b=
r></div><div>Actually no experiment at all.</div><div>The node is part of a=
 rhel 2-nodes production cluster with HA_LVM based services.</div><div>We n=
eed to relocate many services to the other node for a planned maintenance, =
but it seems that this one is able to stop the lvm resources, but not clean=
ly deactivate the LVs. We get messages like</div><div><br></div><div><div>N=
ov 26 17:35:29 orapr2 rgmanager[5765]: [lvm] Deactivating VG_AAA_TEMP/LV_AA=
A_TEMP</div><div>Nov 26 17:35:29 orapr2 rgmanager[5786]: [lvm] Making resil=
ient : lvchange -an VG_AAA_TEMP/LV_AAA_TEMP</div><div>Nov 26 17:35:29 orapr=
2 rgmanager[5809]: [lvm] Resilient command: lvchange -an VG_AAA_TEMP/LV_AAA=
_TEMP --config devices{filter=3D[&quot;a|/dev/ma</div><div>pper/360a9800037=
543544465d424</div><div>Nov 26 17:35:34 orapr2 rgmanager[5883]: [lvm] lv_ex=
ec_resilient failed</div><div>Nov 26 17:35:34 orapr2 rgmanager[5908]: [lvm]=
 lv_activate_resilient stop failed on VG_AAA_TEMP/LV_AAA_TEMP</div><div>Nov=
 26 17:35:34 orapr2 rgmanager[5928]: [lvm] Unable to deactivate VG_AAA_TEMP=
/LV_AAA_TEMP</div><div>Nov 26 17:35:34 orapr2 rgmanager[5948]: [lvm] Failed=
 to stop VG_AAA_TEMP/LV_AAA_TEMP</div><div>Nov 26 17:35:34 orapr2 rgmanager=
[5968]: [lvm] Attempting cleanup of VG_AAA_TEMP</div><div>Nov 26 17:35:34 o=
rapr2 rgmanager[5989]: [lvm] VG_AAA_TEMP now consistent</div><div>Nov 26 17=
:35:34 orapr2 rgmanager[6013]: [lvm] Deactivating VG_AAA_TEMP/LV_AAA_TEMP</=
div><div>Nov 26 17:35:34 orapr2 rgmanager[6033]: [lvm] Making resilient : l=
vchange -an VG_AAA_TEMP/LV_AAA_TEMP</div><div>Nov 26 17:35:35 orapr2 rgmana=
ger[6056]: [lvm] Resilient command: lvchange -an VG_AAA_TEMP/LV_AAA_TEMP --=
config devices{filter=3D[&quot;a|/dev/ma</div><div>pper/360a980003754354446=
5d424</div><div>Nov 26 17:35:39 orapr2 rgmanager[6648]: [lvm] lv_exec_resil=
ient failed</div><div>Nov 26 17:35:40 orapr2 rgmanager[6670]: [lvm] lv_acti=
vate_resilient stop failed on VG_AAA_TEMP/LV_AAA_TEMP</div><div>Nov 26 17:3=
5:40 orapr2 rgmanager[6690]: [lvm] Unable to deactivate VG_AAA_TEMP/LV_AAA_=
TEMP</div><div>Nov 26 17:35:40 orapr2 rgmanager[6710]: [lvm] Failed second =
attempt to stop VG_AAA_TEMP/LV_AAA_TEMP</div><div>Nov 26 17:35:40 orapr2 rg=
manager[20260]: stop on lvm &quot;LV_AAA_TEMP&quot; returned 1 (generic err=
or)</div><div>Nov 26 17:35:40 orapr2 rgmanager[20260]: Marking service:AAA =
as &#39;disabled&#39;, but some resources may still be allocated!</div><div=
>Nov 26 17:35:40 orapr2 rgmanager[20260]: Service service:AAA is disabled</=
div></div><div><br></div><div>And of course the other node then is unable t=
o activate the service due to LV maintained open from the first one:<br></d=
iv><div><br></div><div><div>Nov 26 17:35:40 orapr1 rgmanager[18596]: Starti=
ng disabled service service:AAA</div><div>Nov 26 17:35:41 orapr1 rgmanager[=
31420]: [lvm] Someone else owns this logical volume</div><div>Nov 26 17:35:=
41 orapr1 rgmanager[18596]: start on lvm &quot;LV_AAA_TEMP&quot; returned 1=
 (generic error)</div><div>Nov 26 17:35:41 orapr1 rgmanager[18596]: #68: Fa=
iled to start service:AAA; return value: 1</div></div><div><br></div><div>S=
o I&#39;m trying to reproduce the cluster command to see how to clean the s=
ituation, using this particular service (named AAA) that is not critical as=
 the other ones running on the node =C2=A0=C2=A0</div><div><br></div><block=
quote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-w=
idth:1px;border-left-color:rgb(204,204,204);border-left-style:solid;padding=
-left:1ex">
<br>
Do you happen to have some suspend devices in your table ?<br>
(dmsetup info -c=C2=A0 =C2=A0 should show them)</blockquote><div><br></div>=
<div>It seems not so. Only (L)ive states...</div><div><br></div><div><div>[=
root@orapr2 ~]# dmsetup info -c | awk &#39;{print $4}&#39; | sort | uniq -c=
</div><div>=C2=A0 =C2=A0 =C2=A077 L--w</div><div>=C2=A0 =C2=A0 =C2=A0 1 Sta=
t</div></div><div><br></div><div>=C2=A0</div><blockquote class=3D"gmail_quo=
te" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-col=
or:rgb(204,204,204);border-left-style:solid;padding-left:1ex"><span class=
=3D""><br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex">
[root@orapr2 ~]# lvs VG_AAA_TEMP/LV_AAA_TEMP<br>
=C2=A0 =C2=A0LV=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 VG=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 Attr=C2=A0 =C2=A0 =C2=A0 =C2=A0LSize=C2=A0 =C2=A0 Pool Origin=
 Data%=C2=A0 Move Log<br>
Cpy%Sync Convert<br>
=C2=A0 =C2=A0LV_AAA_TEMP VG_AAA_TEMP -wi-ao---- 1020.00m<br>
<br>
How can I see the responsible for the reference that apparently keeps it op=
en?<br>
<br>
Open count:=C2=A0 =C2=A0 =C2=A0 =C2=A0 1<br>
so I can check and eventually fix??<br>
<br>
</blockquote>
<br></span>
dmsetup ls --tree<br>
<br>
is usually good in shows deps between devs (i.e.=C2=A0 target A holds targe=
t B)<br>
<br>
Regards<br>
<br>
Zdenek<br>
<br>
<br></blockquote><div><br></div><div>it returns no particular output relate=
d</div><div>...</div><div>=C2=A0VG_AAA_TEMP-LV_AAA_TEMP (253:49)</div><div>=
=C2=A0=E2=94=94=E2=94=80360a9800037543544465d424130533177 (253:4)</div><div=
>=C2=A0 =C2=A0 =E2=94=9C=E2=94=80 (130:128)</div><div>=C2=A0 =C2=A0 =E2=94=
=9C=E2=94=80 (129:32)</div><div>=C2=A0 =C2=A0 =E2=94=9C=E2=94=80 (68:48)</d=
iv><div>=C2=A0 =C2=A0 =E2=94=9C=E2=94=80 (8:96)</div><div>=C2=A0 =C2=A0 =E2=
=94=9C=E2=94=80 (8:288)</div><div>=C2=A0 =C2=A0 =E2=94=9C=E2=94=80 (133:224=
)</div><div>=C2=A0 =C2=A0 =E2=94=9C=E2=94=80 (69:192)</div><div>=C2=A0 =C2=
=A0 =E2=94=94=E2=94=80 (66:160)</div><div>...</div><div><br></div><div>BTW:=
 I&#39;m testing this one but it seems that the problem is general, in the =
sense that each LV gets this kind of behaviour trying to deactivating it...=
</div><div><br></div><div>Thanks in advance for any other insight and let m=
e know if I can send it the debug log of lvchange command in case you are n=
ot yet able to access it...</div><div><br></div><div>Gianluca</div></div></=
div></div>

--f46d043c7ef8b1fcbf0508d86cb8--


--===============6771325335251837348==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6771325335251837348==--
