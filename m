From: John Dorminy <jdorminy@redhat.com>
Subject: Re: [PATCH 3/4] dm-zoned: V2 metadata handling
Date: Thu, 2 Apr 2020 16:01:28 -0400
Message-ID: <CAMeeMh8+6ssUyYqiDQL2kWpwPwjPZRQJbLa7bDUL2tYqeUKjOw@mail.gmail.com>
References: <20200327071459.67796-1-hare@suse.de>
	<20200327071459.67796-4-hare@suse.de>
	<93a26ed9-6f6e-2a4d-38d3-3fb76fa91e70@oracle.com>
	<CAMeeMh82FSZm4+i2+1f89P542=3HZR6S8--yP88ZiEjYSxUveA@mail.gmail.com>
	<bbebc0d7-2d53-8412-81c2-d36842fc25e9@suse.de>
	<CAMeeMh9JBuOuOi2s0VB6K1KXExUv-kyP2OavRXE==tHJAXbMFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5071372349080338198=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAMeeMh9JBuOuOi2s0VB6K1KXExUv-kyP2OavRXE==tHJAXbMFg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Bob Liu <bob.liu@oracle.com>, device-mapper development <dm-devel@redhat.com>, Damien LeMoal <damien.lemoal@wdc.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

--===============5071372349080338198==
Content-Type: multipart/alternative; boundary="000000000000dd658205a25444ee"

--000000000000dd658205a25444ee
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Actually, I take that back. If it is a worry that the internal
representation will change, it seems also unsafe to be casting the sixteen
bytes as a uuid_t when copying into them with uuid_copy(). If the internal
representation changed to add a new field, then there would be a buffer
overrun when using uuid_copy(). If the internal representation changed the
order of the bytes, uuid_copy() would propagate that to the on-disk
structure and yield compatibility issues.

Perhaps it would be safer to store the UUIDs on disk as a string. Or add to
uuid.[ch] a function to get the raw bytes in a fixed order suitable for
storing on disk?

On Thu, Apr 2, 2020 at 11:52 AM John Dorminy <jdorminy@redhat.com> wrote:

> That does make sense. May I request, then, using UUID_SIZE instead of 16?
> Perhaps with a compile-time assertion that UUID_SIZE has not change from =
16?
>
> On Thu, Apr 2, 2020 at 11:10 AM Hannes Reinecke <hare@suse.de> wrote:
>
>> On 4/2/20 4:53 PM, John Dorminy wrote:
>> > I'm worried about hardcoding uuid members as u8[16].
>> >
>> > May I ask why you're not using uuid_t to define it in the on-disk
>> > structure? It would save the casting of the uuid members to (uuid_t *)
>> > every time you use a uuid.h function.
>> >
>> > Possibly it is customary to use only raw datatypes on disk rather than
>> > opaque types like uuid_t, I'm not sure. But in that case, perhaps usin=
g
>> > the named constant UUID_SIZE instead of 16 would make the meaning
>> clearer?
>> >
>> I prefer to use absolute types (like __u8) when describing the on-disk
>> format.
>> When using opaque types like uuid_t there always is the risk that the
>> internal representation will change, leading to an involuntary change of
>> the on-disk format structure and subsequent compability issues.
>>
>> Cheers,
>>
>> Hannes
>> --
>> Dr. Hannes Reinecke            Teamlead Storage & Networking
>> hare@suse.de                               +49 911 74053 688
>> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
>> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=
=B6rffer
>>
>>

--000000000000dd658205a25444ee
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Actually, I take that back. If it is a worry that the inte=
rnal representation will change, it seems also unsafe to be casting the six=
teen bytes as a uuid_t when copying into them with uuid_copy(). If the inte=
rnal representation changed to add a new field, then there would be a buffe=
r overrun when using uuid_copy(). If the internal representation changed th=
e order of the bytes, uuid_copy() would propagate that to the on-disk struc=
ture and yield compatibility issues. <br><br>Perhaps it would be safer to s=
tore the UUIDs on disk as a string. Or add to uuid.[ch] a function to get t=
he raw bytes in a fixed order suitable for storing on disk? <br></div><br><=
div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Thu, Apr=
 2, 2020 at 11:52 AM John Dorminy &lt;<a href=3D"mailto:jdorminy@redhat.com=
" target=3D"_blank">jdorminy@redhat.com</a>&gt; wrote:<br></div><blockquote=
 class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px so=
lid rgb(204,204,204);padding-left:1ex"><div dir=3D"ltr">That does make sens=
e. May I request, then, using UUID_SIZE instead of 16? Perhaps with a compi=
le-time assertion that UUID_SIZE has not change from 16?<br></div><br><div =
class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Thu, Apr 2, =
2020 at 11:10 AM Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de" target=
=3D"_blank">hare@suse.de</a>&gt; wrote:<br></div><blockquote class=3D"gmail=
_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204=
,204);padding-left:1ex">On 4/2/20 4:53 PM, John Dorminy wrote:<br>
&gt; I&#39;m worried about hardcoding uuid members as u8[16].<br>
&gt; <br>
&gt; May I ask why you&#39;re not using uuid_t to define it in the on-disk =
<br>
&gt; structure? It would save the casting of the uuid members to (uuid_t *)=
 <br>
&gt; every time you use a uuid.h function.<br>
&gt; <br>
&gt; Possibly it is customary to use only raw datatypes on disk rather than=
 <br>
&gt; opaque types like uuid_t, I&#39;m not sure. But in that case, perhaps =
using <br>
&gt; the named constant UUID_SIZE instead of 16 would make the meaning clea=
rer?<br>
&gt; <br>
I prefer to use absolute types (like __u8) when describing the on-disk <br>
format.<br>
When using opaque types like uuid_t there always is the risk that the <br>
internal representation will change, leading to an involuntary change of <b=
r>
the on-disk format structure and subsequent compability issues.<br>
<br>
Cheers,<br>
<br>
Hannes<br>
-- <br>
Dr. Hannes Reinecke=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Teamlead Stora=
ge &amp; Networking<br>
<a href=3D"mailto:hare@suse.de" target=3D"_blank">hare@suse.de</a>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+49 911 74053 688<br>
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg<br>
HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6r=
ffer<br>
<br>
</blockquote></div>
</blockquote></div>

--000000000000dd658205a25444ee--

--===============5071372349080338198==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5071372349080338198==--
