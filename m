From: Arnon Yaari <arnony@infinidat.com>
Subject: Re: [PATCH] libmultipath: update INFINIDAT builtin config
Date: Tue, 29 Aug 2017 14:26:27 +0300
Message-ID: <7657E7E2-0D90-4FBF-8175-97CB7209DAAB@infinidat.com>
References: <392CDE41-4C36-41B1-8811-B7EC93F0864C@infinidat.com>
	<364c3650-ef7d-5a17-6e34-a32f34ab31e7@gmail.com>
	<FDDA478C-AA82-4C40-9E6E-981D53F79693@infinidat.com>
	<089058c5-18f7-f197-1ca5-00a8a0e12c39@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/mixed; boundary="===============2242366826128516987=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <089058c5-18f7-f197-1ca5-00a8a0e12c39@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============2242366826128516987==
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_4D6FEE69-E4CF-49B5-8409-6E3AEEEC47A0"


--Apple-Mail=_4D6FEE69-E4CF-49B5-8409-6E3AEEEC47A0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On 29 Aug 2017, at 2:02, Xose Vazquez Perez <xose.vazquez@gmail.com> =
wrote:
>=20
> On 08/28/2017 03:59 PM, Arnon Yaari wrote:
>=20
>>> On 25 Aug 2017, at 3:26, Xose Vazquez Perez <xose.vazquez@gmail.com> =
wrote:
>=20
>>> On 08/22/2017 03:37 PM, Arnon Yaari wrote:
>=20
>>>> -		.pgfailback    =3D -FAILBACK_IMMEDIATE,
>>>> +		.pgfailback    =3D 30,
>=20
>>> Why is it needed?
>=20
>> All the values suggested here are the values that the company=E2=80=99s=
 interoperability
>> team found work best for the product on Linux. The timeout values are =
there
>> because in some upgrade scenarios we don=E2=80=99t want to fail =
devices until the
>> upgrade finishes.
>=20
> Were they tested with a *current* kernel and multipath-tools?

Of course. We do extensive interoperability testing on RHEL, CentOS, =
Ubuntu, SLES, on old and all new versions.
The way our "hot upgrade" process works can cause device loss if these =
values are not in place.

>=20
>> I don=E2=80=99t think there is a reason to add in-line comments in =
the code to
>> explain the values (none of the other vendors are doing that).
>=20
> It should be documented in the body of the git patch(changelog).
>=20
> Anything other than default values must be documented.
> This is a standard request: https://marc.info/?t=3D149850399700003 =
<https://marc.info/?t=3D149850399700003>

All vendor config commits I see just link to the vendor support docs, =
which makes sense because the vendor config is the authority on what =
needs to be set, and the docs themselves are the explanation (perhaps we =
need to add the reasons to the docs...).
I will change the patch message anyway.

>=20
>>>> +		.selector      =3D "round-robin 0",
>>>=20
>>> round-robin is the dumbest, queue-length is smarter and
>>> service-time is the smartest and default selector.
>>=20
>> Regardless of which algorithm is =E2=80=9Cdumbest=E2=80=9D or =
=E2=80=9Csmartest=E2=80=9D, round-robin
>> is a legitimate path selection algorithm that the vendor decided =
works
>> best with its product. The vendor knows its product best :)
>> The product=E2=80=99s customers set the values suggested here =
(manually or
>> using tools provided by the vendor), whether they are upstream or =
not.
>=20
> In an *ideal environment* , "round-robin" "queue-length" and =
"service-time"
> work the same way, doing a round robin distribution.
>=20
> But when things get ugly, "round-robin" could lost data.
>=20
> "service-time" works much better in any environment, even =
asymmetrical.
> In highly congested links, with different link speeds, faulty paths, =
...
>=20
> path_selector is like TCP congestion control algorithm.

We may decide to change this behavior in the future. I will pass your =
input to our product team. I don=E2=80=99t expect it=E2=80=99s something =
we=E2=80=99ll change in a short time frame without more discussion and =
testing.
We don=E2=80=99t see how round-robin can lose data. Can you please =
elaborate?
In any case, this is our current configuration that is set in customer =
environments. For better or worse, not accepting this doesn=E2=80=99t =
change anything other than inconveniencing users.

>=20
>>>> +		.no_path_retry =3D NO_PATH_RETRY_FAIL,
>>>=20
>>> Default value.
>>=20
>> Isn=E2=80=99t the default NO_PATH_RETRY_UNDEF?
>=20
>=20
> Practically it's the same: =
https://marc.info/?l=3Ddm-devel&m=3D147854542623733 =
<https://marc.info/?l=3Ddm-devel&m=3D147854542623733>

I=E2=80=99m not convinced it=E2=80=99s the same. The message you linked =
says it takes what is in the =E2=80=9Cfeatures=E2=80=9D line, which can =
be changed.
Even if it=E2=80=99s implicitly the same, it=E2=80=99s not really the =
default. We prefer to specify this explicitly.

>=20
>=20
> Thank you.


--Apple-Mail=_4D6FEE69-E4CF-49B5-8409-6E3AEEEC47A0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dutf-8"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><br class=3D""><div><blockquote type=3D"cite" class=3D""><div =
class=3D"">On 29 Aug 2017, at 2:02, Xose Vazquez Perez &lt;<a =
href=3D"mailto:xose.vazquez@gmail.com" =
class=3D"">xose.vazquez@gmail.com</a>&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div class=3D""><div class=3D"">On =
08/28/2017 03:59 PM, Arnon Yaari wrote:<br class=3D""><br =
class=3D""><blockquote type=3D"cite" class=3D""><blockquote type=3D"cite" =
class=3D"">On 25 Aug 2017, at 3:26, Xose Vazquez Perez &lt;<a =
href=3D"mailto:xose.vazquez@gmail.com" =
class=3D"">xose.vazquez@gmail.com</a>&gt; wrote:<br =
class=3D""></blockquote></blockquote><br class=3D""><blockquote =
type=3D"cite" class=3D""><blockquote type=3D"cite" class=3D"">On =
08/22/2017 03:37 PM, Arnon Yaari wrote:<br =
class=3D""></blockquote></blockquote><br class=3D""><blockquote =
type=3D"cite" class=3D""><blockquote type=3D"cite" class=3D""><blockquote =
type=3D"cite" class=3D"">-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>.pgfailback &nbsp;&nbsp;&nbsp;=3D =
-FAILBACK_IMMEDIATE,<br class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>.pgfailback &nbsp;&nbsp;&nbsp;=3D =
30,<br class=3D""></blockquote></blockquote></blockquote><br =
class=3D""><blockquote type=3D"cite" class=3D""><blockquote type=3D"cite" =
class=3D"">Why is it needed?<br class=3D""></blockquote></blockquote><br =
class=3D""><blockquote type=3D"cite" class=3D"">All the values suggested =
here are the values that the company=E2=80=99s interoperability<br =
class=3D"">team found work best for the product on Linux. The timeout =
values are there<br class=3D"">because in some upgrade scenarios we =
don=E2=80=99t want to fail devices until the<br class=3D"">upgrade =
finishes.<br class=3D""></blockquote><br class=3D"">Were they tested =
with a *current* kernel and multipath-tools?<br =
class=3D""></div></div></blockquote><div><br class=3D""></div><div>Of =
course. We do extensive interoperability testing on RHEL, CentOS, =
Ubuntu, SLES, on old and all new versions.</div><div>The way our "hot =
upgrade" process works can cause device loss if these values are not in =
place.</div><br class=3D""><blockquote type=3D"cite" class=3D""><div =
class=3D""><div class=3D""><br class=3D""><blockquote type=3D"cite" =
class=3D"">I don=E2=80=99t think there is a reason to add in-line =
comments in the code to<br class=3D"">explain the values (none of the =
other vendors are doing that).<br class=3D""></blockquote><br =
class=3D"">It should be documented in the body of the git =
patch(changelog).<br class=3D""><br class=3D"">Anything other than =
default values must be documented.<br class=3D"">This is a standard =
request: <a href=3D"https://marc.info/?t=3D149850399700003" =
class=3D"">https://marc.info/?t=3D149850399700003</a><br =
class=3D""></div></div></blockquote><div><br class=3D""></div><div>All =
vendor config commits I see just link to the vendor support docs, which =
makes sense because the vendor config is the authority on what needs to =
be set, and the docs themselves are the explanation (perhaps we need to =
add the reasons to the docs...).</div><div>I will change the patch =
message anyway.</div><br class=3D""><blockquote type=3D"cite" =
class=3D""><div class=3D""><div class=3D""><br class=3D""><blockquote =
type=3D"cite" class=3D""><blockquote type=3D"cite" class=3D""><blockquote =
type=3D"cite" class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>.selector =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=3D "round-robin 0",<br =
class=3D""></blockquote><br class=3D"">round-robin is the dumbest, =
queue-length is smarter and<br class=3D"">service-time is the smartest =
and default selector.<br class=3D""></blockquote><br class=3D"">Regardless=
 of which algorithm is =E2=80=9Cdumbest=E2=80=9D or =E2=80=9Csmartest=E2=80=
=9D, round-robin<br class=3D"">is a legitimate path selection algorithm =
that the vendor decided works<br class=3D"">best with its product. The =
vendor knows its product best :)<br class=3D"">The product=E2=80=99s =
customers set the values suggested here (manually or<br class=3D"">using =
tools provided by the vendor), whether they are upstream or not.<br =
class=3D""></blockquote><br class=3D"">In an *ideal environment* , =
"round-robin" "queue-length" and "service-time"<br class=3D"">work the =
same way, doing a round robin distribution.<br class=3D""><br =
class=3D"">But when things get ugly, "round-robin" could lost data.<br =
class=3D""><br class=3D"">"service-time" works much better in any =
environment, even asymmetrical.<br class=3D"">In highly congested links, =
with different link speeds, faulty paths, ...<br class=3D""><br =
class=3D"">path_selector is like TCP congestion control algorithm.<br =
class=3D""></div></div></blockquote><div><br class=3D""></div><div>We =
may decide to change this behavior in the future. I will pass your input =
to our product team. I don=E2=80=99t expect it=E2=80=99s something =
we=E2=80=99ll change in a short time frame without more discussion and =
testing.</div><div>We don=E2=80=99t see how round-robin can lose data. =
Can you please elaborate?</div><div>In any case, this is our current =
configuration that is set in customer environments. For better or worse, =
not accepting this doesn=E2=80=99t change anything other than =
inconveniencing users.</div><br class=3D""><blockquote type=3D"cite" =
class=3D""><div class=3D""><div class=3D""><br class=3D""><blockquote =
type=3D"cite" class=3D""><blockquote type=3D"cite" class=3D""><blockquote =
type=3D"cite" class=3D"">+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>.no_path_retry =3D =
NO_PATH_RETRY_FAIL,<br class=3D""></blockquote><br class=3D"">Default =
value.<br class=3D""></blockquote><br class=3D"">Isn=E2=80=99t the =
default NO_PATH_RETRY_UNDEF?<br class=3D""></blockquote><br class=3D""><br=
 class=3D"">Practically it's the same: <a =
href=3D"https://marc.info/?l=3Ddm-devel&amp;m=3D147854542623733" =
class=3D"">https://marc.info/?l=3Ddm-devel&amp;m=3D147854542623733</a><br =
class=3D""></div></div></blockquote><div><br class=3D""></div><div>I=E2=80=
=99m not convinced it=E2=80=99s the same. The message you linked says it =
takes what is in the =E2=80=9Cfeatures=E2=80=9D line, which can be =
changed.</div><div>Even if it=E2=80=99s implicitly the same, it=E2=80=99s =
not really the default. We prefer to specify this explicitly.</div><br =
class=3D""><blockquote type=3D"cite" class=3D""><div class=3D""><div =
class=3D""><br class=3D""><br class=3D"">Thank you.<br =
class=3D""></div></div></blockquote></div><br class=3D""></body></html>=

--Apple-Mail=_4D6FEE69-E4CF-49B5-8409-6E3AEEEC47A0--


--===============2242366826128516987==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2242366826128516987==--
