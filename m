From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/7] multipathd: Fix race conditions related
	to thread termination
Date: Tue, 16 Aug 2016 09:38:39 +0200
Message-ID: <CABr-GndbrabKXe=56PhevFdQ1=RYBRAHj6Ff4AUkvM_hCZ5jyQ@mail.gmail.com>
References: <31d43b64-36c8-1a24-a849-230b5cf6323c@sandisk.com>
	<d71738e7-4909-fb4d-8bc7-372035f7f161@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6002227308735918558=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d71738e7-4909-fb4d-8bc7-372035f7f161@sandisk.com>
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

--===============6002227308735918558==
Content-Type: multipart/alternative; boundary=001a114002f8f9b27a053a2b6f9a

--001a114002f8f9b27a053a2b6f9a
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.

On Mon, Aug 15, 2016 at 5:29 PM, Bart Van Assche <bart.vanassche@sandisk.com
> wrote:

> On 08/15/2016 08:24 AM, Bart Van Assche wrote:
>
>> As you may already have noticed the code in multipathd for terminating
>> worker threads triggers several race conditions. It would be appreciated
>> if you could review and/or apply the following seven patches that fix
>> these race conditions:
>>
>> 0001-multipathd-fix-memory-allocation-logic-error-for-pol.patch
>> 0002-libmultipath-Remove-a-data-structure-that-has-been-c.patch
>> 0003-libmultipath-Remove-debugging-code-from-lock.h.patch
>> 0004-libmultipath-Convert-lock-and-unlock-into-inline-fun.patch
>> 0005-libmultipath-Inline-mutex-in-struct-mutex_lock.patch
>> 0006-libmultipath-Introduce-timedlock.patch
>> 0007-multipathd-Remove-a-busy-waiting-loop.patch
>>
>
> (replying to my own e-mail)
>
> A correction: this series consists of 6 patches instead of 7.
>
> Bart.
>

--001a114002f8f9b27a053a2b6f9a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Mon, Aug 15, 2016 at 5:29 PM, Bart Van A=
ssche <span dir=3D"ltr">&lt;<a href=3D"mailto:bart.vanassche@sandisk.com" t=
arget=3D"_blank">bart.vanassche@sandisk.com</a>&gt;</span> wrote:<br><block=
quote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc=
 solid;padding-left:1ex"><span class=3D"">On 08/15/2016 08:24 AM, Bart Van =
Assche wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
As you may already have noticed the code in multipathd for terminating<br>
worker threads triggers several race conditions. It would be appreciated<br=
>
if you could review and/or apply the following seven patches that fix<br>
these race conditions:<br>
<br>
0001-multipathd-fix-memory-all<wbr>ocation-logic-error-for-pol.<wbr>patch<b=
r>
0002-libmultipath-Remove-a-dat<wbr>a-structure-that-has-been-c.<wbr>patch<b=
r>
0003-libmultipath-Remove-debug<wbr>ging-code-from-lock.h.patch<br>
0004-libmultipath-Convert-lock<wbr>-and-unlock-into-inline-fun.<wbr>patch<b=
r>
0005-libmultipath-Inline-mutex<wbr>-in-struct-mutex_lock.patch<br>
0006-libmultipath-Introduce-ti<wbr>medlock.patch<br>
0007-multipathd-Remove-a-busy-<wbr>waiting-loop.patch<br>
</blockquote>
<br></span>
(replying to my own e-mail)<br>
<br>
A correction: this series consists of 6 patches instead of 7.<span class=3D=
"HOEnZb"><font color=3D"#888888"><br>
<br>
Bart.<br>
</font></span></blockquote></div><br></div>

--001a114002f8f9b27a053a2b6f9a--


--===============6002227308735918558==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6002227308735918558==--
