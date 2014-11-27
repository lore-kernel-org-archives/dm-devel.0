From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Re: Unable to deactivate lv,
	pehaps due to semaphore problem...
Date: Thu, 27 Nov 2014 16:36:52 +0100
Message-ID: <CAG2kNCz7hmtcMQBeVQRbryVTzsE_DKr9y8Pg8rfKmSf8UDVDRQ@mail.gmail.com>
References: <CAG2kNCxiZhRpfnifa58bDODfcyhaArLmP4kbgPfPs=2Lq_tYWw@mail.gmail.com>
	<54773621.5090301@redhat.com>
	<CAG2kNCyDcgCdCpUAzZ51mAyqS8LF9i9Tau3Lke5E2ZJy352_ig@mail.gmail.com>
	<54774220.7080709@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7544468026061180683=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54774220.7080709@redhat.com>
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

--===============7544468026061180683==
Content-Type: multipart/alternative; boundary=047d7b5d6194d3ae4e0508d8e962

--047d7b5d6194d3ae4e0508d8e962
Content-Type: text/plain; charset=UTF-8

On Thu, Nov 27, 2014 at 4:24 PM, Zdenek Kabelac <zkabelac@redhat.com> wrote:

>
>>
> Ahh - I'd too strict  adblock filter - however passed info is not that
> useful.
> Prefered output is   'lvchange -vvvv -an'


Thanks!
here it is:
https://drive.google.com/file/d/0BwoPbcrMv8mvellaS1FtVXpqU2c/view?usp=sharing



>
>
>
>
>>     But anyway - if you have problem with  'semaphore' resouces - you
>> could
>>     'recycle' old ones -
>>
>>     'dmsetup  udevcomplete_all'
>>
>>
>> This is actually a production server with many other LVs... Is there any
>> drawback in the command above?
>>
>
> You could 'complete' all cookies older then i.e. 1 minute.
> Nothing should be holding cookie for that long time.
>
>
So the command would be

dmsetup udevcomplete_all 1
correct?



>  Nov 26 17:35:34 orapr2 rgmanager[5908]: [lvm] lv_activate_resilient stop
>> failed on VG_AAA_TEMP/LV_AAA_TEMP
>> Nov 26 17:35:34 orapr2 rgmanager[5928]: [lvm] Unable to deactivate
>> VG_AAA_TEMP/LV_AAA_TEMP
>>
>
> Well - here we need to know the reason why it has failed -
>
> Is there some user of  VG_AAA_TEMP/LV_AAA_TEMP ?
>
> Mounted, opened, used as a device for something else ?


It seems not so.


>
>
>
>          [root@orapr2 ~]# lvs VG_AAA_TEMP/LV_AAA_TEMP
>>             LV          VG          Attr       LSize    Pool Origin Data%
>>         Move Log
>>         Cpy%Sync Convert
>>             LV_AAA_TEMP VG_AAA_TEMP -wi-ao---- 1020.00m
>>
>>         How can I see the responsible for the reference that apparently
>> keeps
>>         it open?
>>
>>         Open count:        1
>>         so I can check and eventually fix??
>>
>
> lsof  - look for user of 253,49


[root@orapr2 ~]# lsof | grep 253,49
[root@orapr2 ~]#

While for example for another LV (with major,minor=253,68) that is part of
a running service I have at this moment:
[root@orapr2 ~]# lsof | grep 253,68
oracle    25298  oracle11se  273uW     REG             253,68   988811264
      12 /PABX/temp/tempPABX.dbf
oracle    25298  oracle11se  274uW     REG             253,68  1319112704
      13 /PABX/temp/tempnewPABX.dbf
oracle    25300  oracle11se  269u      REG             253,68   988811264
      12 /PABX/temp/tempPABX.dbf
oracle    25302  oracle11se  266u      REG             253,68  1319112704
      13 /PABX/temp/tempnewPABX.dbf
oracle    25302  oracle11se  270u      REG             253,68   988811264
      12 /PABX/temp/tempPABX.dbf
oracle    25304  oracle11se  266u      REG             253,68  1319112704
      13 /PABX/temp/tempnewPABX.dbf
oracle    25304  oracle11se  269u      REG             253,68   988811264
      12 /PABX/temp/tempPABX.dbf
oracle    25306  oracle11se  283u      REG             253,68   988811264
      12 /PABX/temp/tempPABX.dbf
oracle    25306  oracle11se  284u      REG             253,68  1319112704
      13 /PABX/temp/tempnewPABX.dbf
oracle    25310  oracle11se  270u      REG             253,68   988811264
      12 /PABX/temp/tempPABX.dbf
oracle    25310  oracle11se  271u      REG             253,68  1319112704
      13 /PABX/temp/tempnewPABX.dbf

Gianluca

--047d7b5d6194d3ae4e0508d8e962
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On T=
hu, Nov 27, 2014 at 4:24 PM, Zdenek Kabelac <span dir=3D"ltr">&lt;<a href=
=3D"mailto:zkabelac@redhat.com" target=3D"_blank">zkabelac@redhat.com</a>&g=
t;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0=
px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);borde=
r-left-style:solid;padding-left:1ex"><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(2=
04,204,204);border-left-style:solid;padding-left:1ex"><span class=3D""><br>
</span></blockquote>
<br>
Ahh - I&#39;d too strict=C2=A0 adblock filter - however passed info is not =
that useful.<br>
Prefered output is=C2=A0 =C2=A0&#39;lvchange -vvvv -an&#39;</blockquote><di=
v><br></div><div>Thanks!</div><div>here it is:</div><div><a href=3D"https:/=
/drive.google.com/file/d/0BwoPbcrMv8mvellaS1FtVXpqU2c/view?usp=3Dsharing">h=
ttps://drive.google.com/file/d/0BwoPbcrMv8mvellaS1FtVXpqU2c/view?usp=3Dshar=
ing</a><br></div><div><br></div><div>=C2=A0</div><blockquote class=3D"gmail=
_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left=
-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex"><span cla=
ss=3D""><br>
<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex">
<br>
=C2=A0 =C2=A0 But anyway - if you have problem with=C2=A0 &#39;semaphore&#3=
9; resouces - you could<br>
=C2=A0 =C2=A0 &#39;recycle&#39; old ones -<br>
<br>
=C2=A0 =C2=A0 &#39;dmsetup=C2=A0 udevcomplete_all&#39;<br>
<br>
<br>
This is actually a production server with many other LVs... Is there any<br=
>
drawback in the command above?<br>
</blockquote>
<br></span>
You could &#39;complete&#39; all cookies older then i.e. 1 minute.<br>
Nothing should be holding cookie for that long time.<span class=3D""><br>
<br></span></blockquote><div><br></div><div>So the command would be</div><d=
iv><br></div><div>dmsetup udevcomplete_all 1<br></div><div>correct?</div><d=
iv><br></div><div><br></div><blockquote class=3D"gmail_quote" style=3D"marg=
in:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,20=
4);border-left-style:solid;padding-left:1ex"><span class=3D"">
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex">
Nov 26 17:35:34 orapr2 rgmanager[5908]: [lvm] lv_activate_resilient stop<br=
>
failed on VG_AAA_TEMP/LV_AAA_TEMP<br>
Nov 26 17:35:34 orapr2 rgmanager[5928]: [lvm] Unable to deactivate<br>
VG_AAA_TEMP/LV_AAA_TEMP<br>
</blockquote>
<br></span>
Well - here we need to know the reason why it has failed -<br>
<br>
Is there some user of=C2=A0 VG_AAA_TEMP/LV_AAA_TEMP ?<br>
<br>
Mounted, opened, used as a device for something else ?</blockquote><div><br=
></div><div>It seems not so.</div><div>=C2=A0</div><blockquote class=3D"gma=
il_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-le=
ft-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex"><span c=
lass=3D""><br>
<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 [root@orapr2 ~]# lvs VG_AAA_TEMP/LV_AAA_TEMP<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 LV=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 VG=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Attr=C2=A0 =C2=A0 =C2=A0 =C2=A0LSi=
ze=C2=A0 =C2=A0 Pool Origin Data%<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Move Log<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Cpy%Sync Convert<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 LV_AAA_TEMP VG_AAA_TEMP -wi-ao---=
- 1020.00m<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 How can I see the responsible for the reference=
 that apparently keeps<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 it open?<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Open count:=C2=A0 =C2=A0 =C2=A0 =C2=A0 1<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 so I can check and eventually fix??<br>
</blockquote>
<br></span>
lsof=C2=A0 - look for user of 253,49</blockquote><div><br></div><div>[root@=
orapr2 ~]# lsof | grep 253,49</div><div>[root@orapr2 ~]#=C2=A0</div><div><b=
r></div><div>While for example for another LV (with major,minor=3D253,68) t=
hat is part of a running service I have at this moment:</div><div><div>[roo=
t@orapr2 ~]# lsof | grep 253,68</div><div>oracle =C2=A0 =C2=A025298 =C2=A0o=
racle11se =C2=A0273uW =C2=A0 =C2=A0 REG =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 253,68 =C2=A0 988811264 =C2=A0 =C2=A0 =C2=A0 =C2=A0 12 /PABX/temp/te=
mpPABX.dbf</div><div>oracle =C2=A0 =C2=A025298 =C2=A0oracle11se =C2=A0274uW=
 =C2=A0 =C2=A0 REG =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 253,68 =C2=A01=
319112704 =C2=A0 =C2=A0 =C2=A0 =C2=A0 13 /PABX/temp/tempnewPABX.dbf</div><d=
iv>oracle =C2=A0 =C2=A025300 =C2=A0oracle11se =C2=A0269u =C2=A0 =C2=A0 =C2=
=A0REG =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 253,68 =C2=A0 988811264 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 12 /PABX/temp/tempPABX.dbf</div><div>oracle =C2=
=A0 =C2=A025302 =C2=A0oracle11se =C2=A0266u =C2=A0 =C2=A0 =C2=A0REG =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 253,68 =C2=A01319112704 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 13 /PABX/temp/tempnewPABX.dbf</div><div>oracle =C2=A0 =C2=A02=
5302 =C2=A0oracle11se =C2=A0270u =C2=A0 =C2=A0 =C2=A0REG =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 253,68 =C2=A0 988811264 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 12 /PABX/temp/tempPABX.dbf</div><div>oracle =C2=A0 =C2=A025304 =C2=A0or=
acle11se =C2=A0266u =C2=A0 =C2=A0 =C2=A0REG =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 253,68 =C2=A01319112704 =C2=A0 =C2=A0 =C2=A0 =C2=A0 13 /PABX/tem=
p/tempnewPABX.dbf</div><div>oracle =C2=A0 =C2=A025304 =C2=A0oracle11se =C2=
=A0269u =C2=A0 =C2=A0 =C2=A0REG =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 2=
53,68 =C2=A0 988811264 =C2=A0 =C2=A0 =C2=A0 =C2=A0 12 /PABX/temp/tempPABX.d=
bf</div><div>oracle =C2=A0 =C2=A025306 =C2=A0oracle11se =C2=A0283u =C2=A0 =
=C2=A0 =C2=A0REG =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 253,68 =C2=A0 98=
8811264 =C2=A0 =C2=A0 =C2=A0 =C2=A0 12 /PABX/temp/tempPABX.dbf</div><div>or=
acle =C2=A0 =C2=A025306 =C2=A0oracle11se =C2=A0284u =C2=A0 =C2=A0 =C2=A0REG=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 253,68 =C2=A01319112704 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 13 /PABX/temp/tempnewPABX.dbf</div><div>oracle =C2=A0 =
=C2=A025310 =C2=A0oracle11se =C2=A0270u =C2=A0 =C2=A0 =C2=A0REG =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 253,68 =C2=A0 988811264 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 12 /PABX/temp/tempPABX.dbf</div><div>oracle =C2=A0 =C2=A025310 =
=C2=A0oracle11se =C2=A0271u =C2=A0 =C2=A0 =C2=A0REG =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 253,68 =C2=A01319112704 =C2=A0 =C2=A0 =C2=A0 =C2=A0 13=
 /PABX/temp/tempnewPABX.dbf</div></div><div><br></div><div>Gianluca</div></=
div></div></div>

--047d7b5d6194d3ae4e0508d8e962--


--===============7544468026061180683==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7544468026061180683==--
