From: Dragan Stancevic <dragan.stancevic@canonical.com>
Subject: Re: [PATCH 6/6] multipathd: Remove a busy-waiting loop
Date: Thu, 18 Aug 2016 15:54:09 -0500
Message-ID: <CAAZtj80JMkFeoyy6aeNUZUAGeva-6cRd1pQo7O0P_czjqnn1Wg@mail.gmail.com>
References: <31d43b64-36c8-1a24-a849-230b5cf6323c@sandisk.com>
	<14804b8b-51a7-e860-91d7-9b594aeed63c@sandisk.com>
	<CAAZtj81LAeoq8Duvu1hLzyOFNp0B_ZAfcqyQAMvmQd19jRLw8A@mail.gmail.com>
	<c7ce9f1d-861e-a9a8-443f-8f921ce742df@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8943802680934496115=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <c7ce9f1d-861e-a9a8-443f-8f921ce742df@sandisk.com>
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

--===============8943802680934496115==
Content-Type: multipart/alternative; boundary=001a113ea4208f9a68053a5ec869

--001a113ea4208f9a68053a5ec869
Content-Type: text/plain; charset=UTF-8

Hi Bart-

it looks ok to me, these three patches combined with your previous patch
that is already in the repo...


Acked-by: dragan.stancevic@canonical.com

On Wed, Aug 17, 2016 at 2:57 PM, Bart Van Assche <bart.vanassche@sandisk.com
> wrote:

> On 08/17/2016 12:36 PM, Dragan Stancevic wrote:
>
>> Acked-by: dragan.stancevic@canonical.com
>> <mailto:dragan.stancevic@canonical.com>
>>
>> I agree with your patch, I have been tracking an issue where multipathd
>> dumps core on the exit path just past the treads being canceled. Your
>> patch is very similar to mine (minus nuking the depth) that I was going
>> to send out to a user to test with. The checker thread accesses a valid
>> pointer with garbage values....
>>
>
> Hello Dragan,
>
> When I prepared my patch I overlooked that multipathd creates most threads
> as detached threads. So I started testing the three attached patches on my
> setup. It would be appreciated if you could have a look at these patches.
>
> Thanks,
>
> Bart.
>

--001a113ea4208f9a68053a5ec869
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Bart-</div><div><br></div><div>it looks ok to me, =
these three patches combined with your previous patch that is already in th=
e repo...</div><div><br></div><div><br></div>Acked-by: <a href=3D"mailto:dr=
agan.stancevic@canonical.com">dragan.stancevic@canonical.com</a><br></div><=
div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Wed, Aug 17, 20=
16 at 2:57 PM, Bart Van Assche <span dir=3D"ltr">&lt;<a href=3D"mailto:bart=
.vanassche@sandisk.com" target=3D"_blank">bart.vanassche@sandisk.com</a>&gt=
;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex">On 08/17/2016 12:36 PM, D=
ragan Stancevic wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Acked-by: <a href=3D"mailto:dragan.stancevic@canonical.com" target=3D"_blan=
k">dragan.stancevic@canonical.com</a><br>
&lt;mailto:<a href=3D"mailto:dragan.stancevic@canonical.com" target=3D"_bla=
nk">dragan.stancevic@canon<wbr>ical.com</a>&gt;<span class=3D""><br>
<br>
I agree with your patch, I have been tracking an issue where multipathd<br>
dumps core on the exit path just past the treads being canceled. Your<br>
patch is very similar to mine (minus nuking the depth) that I was going<br>
to send out to a user to test with. The checker thread accesses a valid<br>
pointer with garbage values....<br>
</span></blockquote>
<br>
Hello Dragan,<br>
<br>
When I prepared my patch I overlooked that multipathd creates most threads =
as detached threads. So I started testing the three attached patches on my =
setup. It would be appreciated if you could have a look at these patches.<b=
r>
<br>
Thanks,<br>
<br>
Bart.<br>
</blockquote></div><br></div>

--001a113ea4208f9a68053a5ec869--


--===============8943802680934496115==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8943802680934496115==--
