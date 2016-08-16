From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: replace LDFLAGS with
 LIBDEPS for groups of libraries in Makefiles
Date: Tue, 16 Aug 2016 17:18:20 +0200
Message-ID: <CABr-GnfYxkosOtTpJ1G9xBhnAkHPOQS3KvD57ofCgLMV-BR6AA@mail.gmail.com>
References: <1471024973-15047-1-git-send-email-xose.vazquez@gmail.com>
	<3184b48f-d8eb-e73b-795f-6622b6fbf5fa@sandisk.com>
	<fa5e4e49-80ff-e84f-1505-988aad64526f@gmail.com>
	<c5623b8f-3f8b-7ff2-f484-bd23a57f7cca@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0239426685679259945=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <c5623b8f-3f8b-7ff2-f484-bd23a57f7cca@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

--===============0239426685679259945==
Content-Type: multipart/alternative; boundary=001a113fc3a0ec5cf8053a31db02

--001a113fc3a0ec5cf8053a31db02
Content-Type: text/plain; charset=UTF-8

Applied then.
Thanks.

On Tue, Aug 16, 2016 at 5:02 PM, Bart Van Assche <bart.vanassche@sandisk.com
> wrote:

> On 08/12/2016 11:33 AM, Xose Vazquez Perez wrote:
>
>> On 08/12/2016 08:10 PM, Bart Van Assche wrote:
>>
>>> It seems like a patch description that motivates why this change is
>>>
>> >> considered useful is missing completely? Anyway, have you considered
> >> to use a name that is consistent by what is expected by automake,
> >> namely LDADD (see also https://www.gnu.org/software/a
> utomake/manual/html_node/Linking.html#Linking)?
>
>>
>> I followed just same rule as in the rest of multipath-tools'
>> Makefiles. Where it's called "LIBDEPS":
>>
>> libmpathpersist/Makefile:LIBDEPS +=  -lpthread -ldevmapper -ldl
>> -L$(multipathdir) -lmultipath \
>> libmultipath/Makefile:          LIBDEPS += -lsystemd
>> libmultipath/Makefile:          LIBDEPS += -lsystemd-daemon
>>
>
> Hello Xose,
>
> Thanks for the clarification. Since LIBDEPS is already used elsewhere in
> multipath-tools makefiles I'm fine with using that name. I don't think it's
> worth to rename all uses of LIBDEPS in other Makefiles.
>
> Bart.
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a113fc3a0ec5cf8053a31db02
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied then.<div>Thanks.</div></div><div class=3D"gmail_e=
xtra"><br><div class=3D"gmail_quote">On Tue, Aug 16, 2016 at 5:02 PM, Bart =
Van Assche <span dir=3D"ltr">&lt;<a href=3D"mailto:bart.vanassche@sandisk.c=
om" target=3D"_blank">bart.vanassche@sandisk.com</a>&gt;</span> wrote:<br><=
blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px=
 #ccc solid;padding-left:1ex"><span class=3D"">On 08/12/2016 11:33 AM, Xose=
 Vazquez Perez wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
On 08/12/2016 08:10 PM, Bart Van Assche wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
It seems like a patch description that motivates why this change is<br>
</blockquote></blockquote>
&gt;&gt; considered useful is missing completely? Anyway, have you consider=
ed<br>
&gt;&gt; to use a name that is consistent by what is expected by automake,<=
br>
&gt;&gt; namely LDADD (see also <a href=3D"https://www.gnu.org/software/aut=
omake/manual/html_node/Linking.html#Linking" rel=3D"noreferrer" target=3D"_=
blank">https://www.gnu.org/software/a<wbr>utomake/manual/html_node/Linki<wb=
r>ng.html#Linking</a>)?<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<br>
I followed just same rule as in the rest of multipath-tools&#39;<br>
Makefiles. Where it&#39;s called &quot;LIBDEPS&quot;:<br>
<br>
libmpathpersist/Makefile:LIBDE<wbr>PS +=3D=C2=A0 -lpthread -ldevmapper -ldl=
 -L$(multipathdir) -lmultipath \<br>
libmultipath/Makefile:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 LIBDEPS +=3D -lsys=
temd<br>
libmultipath/Makefile:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 LIBDEPS +=3D -lsys=
temd-daemon<br>
</blockquote>
<br></span>
Hello Xose,<br>
<br>
Thanks for the clarification. Since LIBDEPS is already used elsewhere in mu=
ltipath-tools makefiles I&#39;m fine with using that name. I don&#39;t thin=
k it&#39;s worth to rename all uses of LIBDEPS in other Makefiles.<span cla=
ss=3D"HOEnZb"><font color=3D"#888888"><br>
<br>
Bart.</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman<wbr>/listinfo/dm-deve=
l</a><br>
</div></div></blockquote></div><br></div>

--001a113fc3a0ec5cf8053a31db02--


--===============0239426685679259945==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0239426685679259945==--
