From: Dragan Stancevic <dragan.stancevic@canonical.com>
Subject: Re: [PATCH 6/6] multipathd: Remove a busy-waiting loop
Date: Wed, 17 Aug 2016 14:42:54 -0500
Message-ID: <CAAZtj80UaRfO_iKOVp8MP4xkXwRwfT5d_hggZmCW4P6ZN2Kjag@mail.gmail.com>
References: <31d43b64-36c8-1a24-a849-230b5cf6323c@sandisk.com>
	<14804b8b-51a7-e860-91d7-9b594aeed63c@sandisk.com>
	<2a584b4c-88b7-288b-3f89-62c565774cf1@suse.de>
	<7b1ac503-6f17-68b5-7510-547bd5f11731@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8530424907899861047=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7b1ac503-6f17-68b5-7510-547bd5f11731@sandisk.com>
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

--===============8530424907899861047==
Content-Type: multipart/alternative; boundary=94eb2c19e2c8e9b3d6053a49ab64

--94eb2c19e2c8e9b3d6053a49ab64
Content-Type: text/plain; charset=UTF-8

Hi Bart-

are the semantics below really safe, the don't appear to? Any caller of
checker_thread_running is relaying on stale information. The
c->thread_running could have changed as soon as you unlock.

+static unsigned checker_thread_running(struct tur_checker_context *ct)
+{
+ unsigned thread_running;
+
+ pthread_spin_lock(&ct->hldr_lock);
+ thread_running = ct->thread_running;
+ pthread_spin_unlock(&ct->hldr_lock);
+
+ return thread_running;
+}


On Tue, Aug 16, 2016 at 3:11 PM, Bart Van Assche <bart.vanassche@sandisk.com
> wrote:

> On 08/15/2016 11:31 PM, Hannes Reinecke wrote:
>
>> Makes one wonder: what happens to the waitevent threads?
>> We won't be waiting for them after applying this patch, right?
>> So why did we ever had this busy loop here?
>> Ben?
>>
>> (And while we're at the subject: can't we drop the waitevent threads
>> altogether? We're listening to uevents nowadays, so we should be
>> notified if something happened to the device-mapper tables. Which should
>> make the waitevent threads unnecessary, right?)
>>
>
> Hello Hannes,
>
> Maybe this is not what you had in mind, but would you agree with the
> attached two patches?
>
> Thanks,
>
> Bart.
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--94eb2c19e2c8e9b3d6053a49ab64
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Bart-</div><div><br></div><div>are the semantics b=
elow really safe, the don&#39;t appear to? Any caller of checker_thread_run=
ning is relaying on stale information. The c-&gt;thread_running could have =
changed as soon as you unlock.=C2=A0</div><div><br></div><div>+static unsig=
ned checker_thread_running(struct tur_checker_context *ct)</div><div>+{</di=
v><div>+<span class=3D"" style=3D"white-space:pre">	</span>unsigned thread_=
running;</div><div>+</div><div>+<span class=3D"" style=3D"white-space:pre">=
	</span>pthread_spin_lock(&amp;ct-&gt;hldr_lock);</div><div>+<span class=3D=
"" style=3D"white-space:pre">	</span>thread_running =3D ct-&gt;thread_runni=
ng;</div><div>+<span class=3D"" style=3D"white-space:pre">	</span>pthread_s=
pin_unlock(&amp;ct-&gt;hldr_lock);</div><div>+</div><div>+<span class=3D"" =
style=3D"white-space:pre">	</span>return thread_running;</div><div>+}</div>=
<div><br></div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Tue, Aug 16, 2016 at 3:11 PM, Bart Van Assche <span dir=3D"ltr">&lt;=
<a href=3D"mailto:bart.vanassche@sandisk.com" target=3D"_blank">bart.vanass=
che@sandisk.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" =
style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><sp=
an class=3D"">On 08/15/2016 11:31 PM, Hannes Reinecke wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Makes one wonder: what happens to the waitevent threads?<br>
We won&#39;t be waiting for them after applying this patch, right?<br>
So why did we ever had this busy loop here?<br>
Ben?<br>
<br>
(And while we&#39;re at the subject: can&#39;t we drop the waitevent thread=
s<br>
altogether? We&#39;re listening to uevents nowadays, so we should be<br>
notified if something happened to the device-mapper tables. Which should<br=
>
make the waitevent threads unnecessary, right?)<br>
</blockquote>
<br></span>
Hello Hannes,<br>
<br>
Maybe this is not what you had in mind, but would you agree with the attach=
ed two patches?<br>
<br>
Thanks,<br>
<br>
Bart.<br>
<br>
<br>
<br>--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm-deve=
l</a><br></blockquote></div><br></div>

--94eb2c19e2c8e9b3d6053a49ab64--


--===============8530424907899861047==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8530424907899861047==--
