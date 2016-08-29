From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipathd: Suppress uninteresting data race
	reports
Date: Mon, 29 Aug 2016 18:14:33 +0200
Message-ID: <CABr-GnetkeF8=-PRrO7JfKU9UhnzDziqwL5x4DyDkadFZC+oKg@mail.gmail.com>
References: <01747bb5-c10e-a3b6-e440-d9443837a6f7@sandisk.com>
	<CABr-Gnc6OQRhUeXtkHn-_CVYcSvYco78i1euggauTcjVNSrv5A@mail.gmail.com>
	<72cf1f62-3727-1ca0-4400-b6e352a98a08@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7103211940731218997=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <72cf1f62-3727-1ca0-4400-b6e352a98a08@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============7103211940731218997==
Content-Type: multipart/alternative; boundary=001a113fc3a0e29e3a053b3828f4

--001a113fc3a0e29e3a053b3828f4
Content-Type: text/plain; charset=UTF-8

I would merge that too, sure.

On Mon, Aug 29, 2016 at 5:51 PM, Bart Van Assche <bart.vanassche@sandisk.com
> wrote:

> On 08/29/2016 12:19 AM, Christophe Varoqui wrote:
>
>> I think it would be fair to detect the valgrind headers presence in the
>> Makefile and ifdef the include (else define dummy ANNOTATE_* macros).
>>
>> Would you care to prepare that ?
>>
>
> Hello Christophe,
>
> How about adding a copy of the valgrind.h and helgrind.h header files to
> the multipath-tools source tree? This is the approach that is followed by
> several other projects, e.g. chromium. See also
> https://chromium.googlesource.com/chromium/src/base/+/master
> /third_party/valgrind/valgrind.h.
>
> Thanks,
>
> Bart.
>

--001a113fc3a0e29e3a053b3828f4
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I would merge that too, sure.</div><div class=3D"gmail_ext=
ra"><br><div class=3D"gmail_quote">On Mon, Aug 29, 2016 at 5:51 PM, Bart Va=
n Assche <span dir=3D"ltr">&lt;<a href=3D"mailto:bart.vanassche@sandisk.com=
" target=3D"_blank">bart.vanassche@sandisk.com</a>&gt;</span> wrote:<br><bl=
ockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #=
ccc solid;padding-left:1ex"><span class=3D"">On 08/29/2016 12:19 AM, Christ=
ophe Varoqui wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
I think it would be fair to detect the valgrind headers presence in the<br>
Makefile and ifdef the include (else define dummy ANNOTATE_* macros).<br>
<br>
Would you care to prepare that ?<br>
</blockquote>
<br></span>
Hello Christophe,<br>
<br>
How about adding a copy of the valgrind.h and helgrind.h header files to th=
e multipath-tools source tree? This is the approach that is followed by sev=
eral other projects, e.g. chromium. See also <a href=3D"https://chromium.go=
oglesource.com/chromium/src/base/+/master/third_party/valgrind/valgrind.h" =
rel=3D"noreferrer" target=3D"_blank">https://chromium.googlesource.<wbr>com=
/chromium/src/base/+/master<wbr>/third_party/valgrind/valgrind<wbr>.h</a>.<=
br>
<br>
Thanks,<br>
<br>
Bart.<br>
</blockquote></div><br></div>

--001a113fc3a0e29e3a053b3828f4--


--===============7103211940731218997==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7103211940731218997==--
