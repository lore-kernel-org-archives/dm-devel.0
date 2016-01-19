From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: Question about multipath device compiled defaults
Date: Tue, 19 Jan 2016 17:48:42 +0100
Message-ID: <CABr-GneOyHJNiQRywzdKq5rr5S7Ljz4up3W=V_HgHoUtfY=C3g@mail.gmail.com>
References: <201511050700.tA570XNA029270@d06av02.portsmouth.uk.ibm.com>
	<569E65D4.4020002@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5888926943117853677=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <569E65D4.4020002@linux.vnet.ibm.com>
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
Cc: DORONTAL@il.ibm.com
List-Id: dm-devel.ids

--===============5888926943117853677==
Content-Type: multipart/alternative; boundary=047d7b3a7f5c6487830529b2a4b0

--047d7b3a7f5c6487830529b2a4b0
Content-Type: text/plain; charset=UTF-8

Hi,

and when you are ready, you can post the patch here so I can merge it
upstream.

Thanks,
Christophe Varoqui
OpenSVC

On Tue, Jan 19, 2016 at 5:35 PM, Mauricio Faria de Oliveira <
mauricfo@linux.vnet.ibm.com> wrote:

> On 11/05/2015 04:59 AM, Doron Tal1 wrote:
>
>> I would like to know how and what procedure i should follow if i want to
>> modify or add new settings to the device mapper defaults.
>>
>
> The defaults are in hwtable.c [1].
>
> So for example how can i modify existing compiled settings for the
>> 2810XIV device? in case i want to add a new device and it settings, how
>> can it be done?
>>
>
> To modify the compiled settings, you have to modify it and recompile.
>
> To modify the runtime settings (based on the defaults), you can modify
> /etc/multipath.conf (see its manpage [2] with 'man multipath.conf').
>
> You can verify the the setting values used during multipath discovery
> with 'multipath -v3' for example, or "multipathd -k'show config'".
>
> Hope this might still help at this time,
>
> [1]
> http://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=blob;f=libmultipath/hwtable.c
> [2]
> http://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=blob;f=multipath/multipath.conf.5
>
> --
> Mauricio Faria de Oliveira
> IBM Linux Technology Center
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--047d7b3a7f5c6487830529b2a4b0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi,</div><div><br></div>and when you are ready, you c=
an post the patch here so I can merge it upstream.<div><br></div><div>Thank=
s,</div><div>Christophe Varoqui</div><div>OpenSVC</div></div><div class=3D"=
gmail_extra"><br><div class=3D"gmail_quote">On Tue, Jan 19, 2016 at 5:35 PM=
, Mauricio Faria de Oliveira <span dir=3D"ltr">&lt;<a href=3D"mailto:mauric=
fo@linux.vnet.ibm.com" target=3D"_blank">mauricfo@linux.vnet.ibm.com</a>&gt=
;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On 11/05=
/2015 04:59 AM, Doron Tal1 wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
I would like to know how and what procedure i should follow if i want to<br=
>
modify or add new settings to the device mapper defaults.<br>
</blockquote>
<br></span>
The defaults are in hwtable.c [1].<span class=3D""><br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
So for example how can i modify existing compiled settings for the<br>
2810XIV device? in case i want to add a new device and it settings, how<br>
can it be done?<br>
</blockquote>
<br></span>
To modify the compiled settings, you have to modify it and recompile.<br>
<br>
To modify the runtime settings (based on the defaults), you can modify<br>
/etc/multipath.conf (see its manpage [2] with &#39;man multipath.conf&#39;)=
.<br>
<br>
You can verify the the setting values used during multipath discovery<br>
with &#39;multipath -v3&#39; for example, or &quot;multipathd -k&#39;show c=
onfig&#39;&quot;.<br>
<br>
Hope this might still help at this time,<br>
<br>
[1] <a href=3D"http://git.opensvc.com/gitweb.cgi?p=3Dmultipath-tools/.git;a=
=3Dblob;f=3Dlibmultipath/hwtable.c" rel=3D"noreferrer" target=3D"_blank">ht=
tp://git.opensvc.com/gitweb.cgi?p=3Dmultipath-tools/.git;a=3Dblob;f=3Dlibmu=
ltipath/hwtable.c</a><br>
[2] <a href=3D"http://git.opensvc.com/gitweb.cgi?p=3Dmultipath-tools/.git;a=
=3Dblob;f=3Dmultipath/multipath.conf.5" rel=3D"noreferrer" target=3D"_blank=
">http://git.opensvc.com/gitweb.cgi?p=3Dmultipath-tools/.git;a=3Dblob;f=3Dm=
ultipath/multipath.conf.5</a><span class=3D"HOEnZb"><font color=3D"#888888"=
><br>
<br>
-- <br>
Mauricio Faria de Oliveira<br>
IBM Linux Technology Center<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
</font></span></blockquote></div><br></div>

--047d7b3a7f5c6487830529b2a4b0--


--===============5888926943117853677==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5888926943117853677==--
