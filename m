From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: The request about integrating the configuration of
 HUAWEI storage into the device-mapper-multipath software
Date: Thu, 25 Aug 2016 11:47:14 +0200
Message-ID: <CABr-Gnee_BzJNAhh7c1Ao9HcG2abwL6kEYQ3Mi2jVw_vXOjEqw@mail.gmail.com>
References: <CEDA639684A7E541B5AC87E4A13134824C79962C@SZXEMA504-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3315836390481600483=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CEDA639684A7E541B5AC87E4A13134824C79962C@SZXEMA504-MBS.china.huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tongrenyuan <tongrenyuan@huawei.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "Zhouweigang (Jack)" <zhouweigang09@huawei.com>, fuyucheng <fuyucheng@huawei.com>
List-Id: dm-devel.ids

--===============3315836390481600483==
Content-Type: multipart/alternative; boundary=001a113fc3a0641ec3053ae248ae

--001a113fc3a0641ec3053ae248ae
Content-Type: text/plain; charset=UTF-8

Hi,

The homepage now encourages users to fetch tarballs directly from git :
either HEAD or tagged versions.

The upstream git repo has HUAWEI devices since:

commit b9c1926846fac72a4d702f307721b11033f04e00
Author: Benjamin Marzinski <bmarzins@redhat.com>
Date:   Tue May 31 18:16:49 2016 -0500

    libmultipath: add Huawei Storage default config

    Add a default device config for the Huawei XSG1 arrary. This config
    comes from Huawei.

    Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>


For future work on the HUAWEI devices settings, just contribute to the
upstream projet directly or via a distributor. You can also propose a patch
to designate a maintainer for these device settings.

Best regards,
Christophe Varoqui

On Thu, Aug 25, 2016 at 11:36 AM, Tongrenyuan <tongrenyuan@huawei.com>
wrote:

> Dear:
>
>        I am a storage system integration engineer of HUAWEI.
>
>        Our work is to make sure HUAWEI storage can work well with other IT
> hardware & Software.
>
>
>
> We have verified the compatibility between storage system and many Linux
> OS.
>
> When we communicate with the engineers from these Linxu OS vendor, we find
> many of them get the multipath software from  http://christophe.varoqui.
> free.fr/.
>
>
>
>      We check the latest multipath software released by this website, and
> find HUAWEI Storage system is not included in its default configuration.
>
>     We have communicated with REDHAT before, and they have agreed to add
> HUAWEI storage system information in REDHAT default configuration. You can
> find the detail information in the following address:
> https://bugzilla.redhat.com/show_bug.cgi?id=1333331
>
> We hope the information of HUAWEI Storage system can also be included in
> the default configuration of multipath software from
> http://christophe.varoqui.free.fr/..
>
>      Could you please tell me how to do it?
>
>
>
>      Looking forward to your reply.
>
>      Thanks very much.
>
>
>
>
>
> BR
>
> Tong Renyuan
>

--001a113fc3a0641ec3053ae248ae
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>The homepage now encourages users t=
o fetch tarballs directly from git : either HEAD or tagged versions.</div><=
div><br></div><div>The upstream git repo has HUAWEI devices since:</div><di=
v><br></div><div><div>commit b9c1926846fac72a4d702f307721b11033f04e00</div>=
<div>Author: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com">=
bmarzins@redhat.com</a>&gt;</div><div>Date: =C2=A0 Tue May 31 18:16:49 2016=
 -0500</div><div><br></div><div>=C2=A0 =C2=A0 libmultipath: add Huawei Stor=
age default config</div><div>=C2=A0 =C2=A0=C2=A0</div><div>=C2=A0 =C2=A0 Ad=
d a default device config for the Huawei XSG1 arrary. This config</div><div=
>=C2=A0 =C2=A0 comes from Huawei.</div><div>=C2=A0 =C2=A0=C2=A0</div><div>=
=C2=A0 =C2=A0 Signed-off-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarz=
ins@redhat.com">bmarzins@redhat.com</a>&gt;</div></div><div><br></div><div>=
<br></div><div>For future work on the HUAWEI devices settings, just contrib=
ute to the upstream projet directly or via a distributor. You can also prop=
ose a patch to designate a maintainer for these device settings.</div><div>=
<br></div><div>Best regards,</div><div>Christophe Varoqui</div></div><div c=
lass=3D"gmail_extra"><br><div class=3D"gmail_quote">On Thu, Aug 25, 2016 at=
 11:36 AM, Tongrenyuan <span dir=3D"ltr">&lt;<a href=3D"mailto:tongrenyuan@=
huawei.com" target=3D"_blank">tongrenyuan@huawei.com</a>&gt;</span> wrote:<=
br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left=
:1px #ccc solid;padding-left:1ex">





<div lang=3D"ZH-CN" link=3D"blue" vlink=3D"purple">
<div>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-family:&quot;Cour=
ier New&quot;">Dear:<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-family:&quot;Cour=
ier New&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 I am a storage system i=
ntegration engineer of HUAWEI.
<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-family:&quot;Cour=
ier New&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Our work is to mak=
e sure HUAWEI storage can work well with other IT hardware &amp; Software.<=
u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-family:&quot;Cour=
ier New&quot;"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal" style=3D"margin-left:31.5pt"><span lang=3D"EN-US" st=
yle=3D"font-family:&quot;Courier New&quot;">We have verified the compatibil=
ity between storage system and many Linux OS.<u></u><u></u></span></p>
<p class=3D"MsoNormal" style=3D"margin-left:31.5pt"><span lang=3D"EN-US" st=
yle=3D"font-family:&quot;Courier New&quot;">When we communicate with the en=
gineers from these Linxu OS vendor, we find many of them get the multipath =
software from =C2=A0</span><span lang=3D"EN-US" style=3D"color:#1f497d"><a =
href=3D"http://christophe.varoqui.free.fr/" target=3D"_blank">http://christ=
ophe.varoqui.<wbr>free.fr/</a>.</span><span lang=3D"EN-US" style=3D"font-fa=
mily:&quot;Courier New&quot;"><u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-family:&quot;Cour=
ier New&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <u></u>
<u></u></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:5.25pt"><span lang=3D"EN-US" st=
yle=3D"font-family:&quot;Courier New&quot;">=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0W=
e check the latest multipath software released by this website, and find HU=
AWEI Storage system is not included in its default configuration.<u></u><u>=
</u></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:5.25pt"><span lang=3D"EN-US" st=
yle=3D"font-family:&quot;Courier New&quot;">=C2=A0=C2=A0=C2=A0=C2=A0We have=
 communicated with REDHAT before, and they have agreed to add HUAWEI storag=
e system information in REDHAT default configuration. You can find the
 detail information in the following address: </span><span><span lang=3D"EN=
-US" style=3D"font-size:9.5pt;font-family:&quot;\005fae\008f6f\0096c5\009ed=
1&quot;,&quot;sans-serif&quot;;color:black"><a href=3D"https://bugzilla.red=
hat.com/show_bug.cgi?id=3D1333331" target=3D"_blank">https://bugzilla.redha=
t.com/<wbr>show_bug.cgi?id=3D1333331</a></span></span><span lang=3D"EN-US" =
style=3D"font-size:9.5pt;font-family:&quot;\005fae\008f6f\0096c5\009ed1&quo=
t;,&quot;sans-serif&quot;;color:black"><br>
<br>
</span><span lang=3D"EN-US" style=3D"font-family:&quot;Courier New&quot;"><=
u></u><u></u></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:31.5pt"><span lang=3D"EN-US" st=
yle=3D"font-family:&quot;Courier New&quot;">We hope the information of HUAW=
EI Storage system can also be included in the default configuration of mult=
ipath software from =C2=A0</span><span lang=3D"EN-US" style=3D"color:#1f497=
d"><a href=3D"http://christophe.varoqui.free.fr/" target=3D"_blank">http://=
christophe.varoqui.<wbr>free.fr/</a>.</span><span lang=3D"EN-US" style=3D"f=
ont-family:&quot;Courier New&quot;">.<u></u><u></u></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:5.25pt"><span lang=3D"EN-US" st=
yle=3D"font-family:&quot;Courier New&quot;">=C2=A0=C2=A0=C2=A0=C2=A0 Could =
you please tell me how to do it?<u></u><u></u></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:5.25pt"><span lang=3D"EN-US" st=
yle=3D"font-family:&quot;Courier New&quot;"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:5.25pt"><span lang=3D"EN-US" st=
yle=3D"font-family:&quot;Courier New&quot;">=C2=A0=C2=A0=C2=A0=C2=A0 Lookin=
g forward to your reply.<u></u><u></u></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:5.25pt"><span lang=3D"EN-US" st=
yle=3D"font-family:&quot;Courier New&quot;">=C2=A0=C2=A0=C2=A0=C2=A0 Thanks=
 very much.<u></u><u></u></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:5.25pt"><span lang=3D"EN-US" st=
yle=3D"font-family:&quot;Courier New&quot;">=C2=A0=C2=A0=C2=A0=C2=A0
<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-family:&quot;Cour=
ier New&quot;"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-family:&quot;Cour=
ier New&quot;">BR<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-family:&quot;Cour=
ier New&quot;">Tong Renyuan<u></u><u></u></span></p>
</div>
</div>

</blockquote></div><br></div>

--001a113fc3a0641ec3053ae248ae--


--===============3315836390481600483==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3315836390481600483==--
