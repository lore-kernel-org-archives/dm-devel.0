From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 1/1] multipath: fix memory leak and segfault
	in reconfigure
Date: Mon, 18 Apr 2016 13:12:24 +0200
Message-ID: <CABr-Gnf6b7i59bEEReNYxZUWZ0yjWDiVbLBFZwOvPdECPcMcBg@mail.gmail.com>
References: <1455219054-13122-1-git-send-email-germano.percossi@citrix.com>
	<5714B9FA.9060002@citrix.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5571511745376133756=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5714B9FA.9060002@citrix.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Germano Percossi <germano.percossi@citrix.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5571511745376133756==
Content-Type: multipart/alternative; boundary=001a1141893a6a12a10530c06f99

--001a1141893a6a12a10530c06f99
Content-Type: text/plain; charset=UTF-8

Hi Germano,

no reason at all ... it just missed my attention, twice. Sorry.

This patch is now merged.
Thanks,
Christophe Varoqui
www.opensvc.com

On Mon, Apr 18, 2016 at 12:42 PM, Germano Percossi <
germano.percossi@citrix.com> wrote:

> Hi Christophe,
>
> Is there a specific reason this silly patch is not getting
> through?
>
> It seems a no-brainer to me but probably I am missing something.
>
> Thanks,
> Germano
>
> On 02/11/2016 07:30 PM, Germano Percossi wrote:
>
>> Within the reconfigure function, the global pointer conf is
>> stored in a local variable and then assigned NULL.
>> If load_config should fail, for any reason, we end up with
>> a memory leak, as soon as we leave the function, and with
>> the global pointer conf set to NULL, leading to a segfault
>> as soon as it is dereferenced.
>>
>> I tested it by calling a reconfigure and making the first
>> allocation in load_config fail but any failure in load_config
>> would do.
>>
>>> From a user perspective the CLI reports "fail".
>>>
>>
>> If something like this should happen there are at least 2 possible
>> scenarios:
>>
>> 1) If a second immediate reconfigure succeeds, the conf now is fine but
>>     the leak stays
>> 2) If the previous point does not happen, any command trying to access
>>     "conf" would fail. On my test box a "show conf" segfaulted.
>>
>> The fix is simple but in case of failure at least the previous
>> conf is kept in memory without leaks or segfaluts
>>
>> Signed-off-by: Germano Percossi <germano.percossi@citrix.com>
>> ---
>>   multipathd/main.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/multipathd/main.c b/multipathd/main.c
>> index 04f6d02..f83c849 100644
>> --- a/multipathd/main.c
>> +++ b/multipathd/main.c
>> @@ -1551,6 +1551,8 @@ reconfigure (struct vectors * vecs)
>>                 configure(vecs, 1);
>>                 free_config(old);
>>                 retval = 0;
>> +       } else {
>> +               conf = old;
>>         }
>>
>>         running_state = DAEMON_RUNNING;
>>
>>

--001a1141893a6a12a10530c06f99
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Germano,<div><br></div><div>no reason at all ... it jus=
t missed my attention, twice. Sorry.</div><div><br></div><div>This patch is=
 now merged.</div><div>Thanks,</div><div>Christophe Varoqui</div><div><a hr=
ef=3D"http://www.opensvc.com">www.opensvc.com</a></div></div><div class=3D"=
gmail_extra"><br><div class=3D"gmail_quote">On Mon, Apr 18, 2016 at 12:42 P=
M, Germano Percossi <span dir=3D"ltr">&lt;<a href=3D"mailto:germano.percoss=
i@citrix.com" target=3D"_blank">germano.percossi@citrix.com</a>&gt;</span> =
wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bord=
er-left:1px #ccc solid;padding-left:1ex">Hi Christophe,<br>
<br>
Is there a specific reason this silly patch is not getting<br>
through?<br>
<br>
It seems a no-brainer to me but probably I am missing something.<br>
<br>
Thanks,<br>
Germano<span class=3D"im HOEnZb"><br>
<br>
On 02/11/2016 07:30 PM, Germano Percossi wrote:<br>
</span><div class=3D"HOEnZb"><div class=3D"h5"><blockquote class=3D"gmail_q=
uote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1e=
x">
Within the reconfigure function, the global pointer conf is<br>
stored in a local variable and then assigned NULL.<br>
If load_config should fail, for any reason, we end up with<br>
a memory leak, as soon as we leave the function, and with<br>
the global pointer conf set to NULL, leading to a segfault<br>
as soon as it is dereferenced.<br>
<br>
I tested it by calling a reconfigure and making the first<br>
allocation in load_config fail but any failure in load_config<br>
would do.<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
From a user perspective the CLI reports &quot;fail&quot;.<br>
</blockquote>
<br>
If something like this should happen there are at least 2 possible<br>
scenarios:<br>
<br>
1) If a second immediate reconfigure succeeds, the conf now is fine but<br>
=C2=A0 =C2=A0 the leak stays<br>
2) If the previous point does not happen, any command trying to access<br>
=C2=A0 =C2=A0 &quot;conf&quot; would fail. On my test box a &quot;show conf=
&quot; segfaulted.<br>
<br>
The fix is simple but in case of failure at least the previous<br>
conf is kept in memory without leaks or segfaluts<br>
<br>
Signed-off-by: Germano Percossi &lt;<a href=3D"mailto:germano.percossi@citr=
ix.com" target=3D"_blank">germano.percossi@citrix.com</a>&gt;<br>
---<br>
=C2=A0 multipathd/main.c | 2 ++<br>
=C2=A0 1 file changed, 2 insertions(+)<br>
<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index 04f6d02..f83c849 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -1551,6 +1551,8 @@ reconfigure (struct vectors * vecs)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 configure(vecs, 1);=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free_config(old);<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 retval =3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0conf =3D old;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 running_state =3D DAEMON_RUNNING;<br>
<br>
</blockquote>
</div></div></blockquote></div><br></div>

--001a1141893a6a12a10530c06f99--


--===============5571511745376133756==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5571511745376133756==--
