From: Thanos Makatos <thanos.makatos@onapp.com>
Subject: Re: dm-cache failure semantics in write-back mode
Date: Thu, 5 Mar 2015 14:06:29 +0000
Message-ID: <CAM2wQBsHdYPWoysVSYzYQKk+rDjBJk2jJ=W705E+bBfea30gAQ@mail.gmail.com>
References: <CAM2wQBtW2Bit2rx-1+hngUyh1gObtt+vjWQkDVWcTfm=axCyDw@mail.gmail.com>
	<CAM2wQBsGay5cnTR+CO_BpSL8SiYiaQm-MnWFDQC_hG1AH3PcQw@mail.gmail.com>
	<20150303161935.GA23166@debian>
	<CAM2wQBsS2hyA674CspKx6xZ49Fc1a=53UghaT5JkAPpjT3D_Ng@mail.gmail.com>
	<54F62E68.4040002@shiftmail.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1686762593250998002=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54F62E68.4040002@shiftmail.org>
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
List-Id: dm-devel.ids

--===============1686762593250998002==
Content-Type: multipart/alternative; boundary=001a113f7ec80ec7bf05108b131a

--001a113f7ec80ec7bf05108b131a
Content-Type: text/plain; charset=UTF-8

Thanks for clarifying this. My concern is that an "application writer" can
be a Windows VM via qemu and I don't know if flush requests are supported
in the specific qemu version we're using, I'm in the process of confirming
that.

On Tue, Mar 3, 2015 at 9:58 PM, Spelic <spelic@shiftmail.org> wrote:

> On 03/03/2015 18:13, Thanos Makatos wrote:
>
>> Thanks, Joe. So just to make sure I've understood correctly, if the SSD
>> cache is configured as a write-back cache but the device cache is
>> disabled/set to write-though on the HDD and the SSD, then there is no risk
>> of data loss in the event of a failure. Is my understanding correct?
>>
>>
> You don't seem to understand the semantics of flush.
> Writes on filesystems and databases are made more or less like a
> copy-on-write semantic:
> - New data is written elsewhere
> - a flush is issued
> - when flush returns you are sure that such new data is on stable storage
> (disk platters or similar)
> - change one pointer to point from old data to new data (so small that
> this change is atomic)
> - flush again
> when this flush returns you are sure that the data on-disk is updated.
>
> Now you understand why dm-cache has the semantics that it has, which is
> the same semantics as DRAM caches on HDDs.
>
> Applications writers have to follow the semantics described above, in
> order to have "atomic" updates on disk. This is true with dm-cache but also
> with DRAM caches on HDDs.
> Partial data losses are irrelevant if the above logic is followed.
>
> S.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a113f7ec80ec7bf05108b131a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks for clarifying this. My concern is that an &quot;ap=
plication writer&quot; can be a Windows VM via qemu and I don&#39;t know if=
 flush requests are supported in the specific qemu version we&#39;re using,=
 I&#39;m in the process of confirming that.</div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Tue, Mar 3, 2015 at 9:58 PM, Spelic <spa=
n dir=3D"ltr">&lt;<a href=3D"mailto:spelic@shiftmail.org" target=3D"_blank"=
>spelic@shiftmail.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_q=
uote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1e=
x"><span class=3D"">On 03/03/2015 18:13, Thanos Makatos wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Thanks, Joe. So just to make sure I&#39;ve understood correctly, if the SSD=
 cache is configured as a write-back cache but the device cache is disabled=
/set to write-though on the HDD and the SSD, then there is no risk of data =
loss in the event of a failure. Is my understanding correct?<br>
<br>
</blockquote>
<br></span>
You don&#39;t seem to understand the semantics of flush.<br>
Writes on filesystems and databases are made more or less like a copy-on-wr=
ite semantic:<br>
- New data is written elsewhere<br>
- a flush is issued<br>
- when flush returns you are sure that such new data is on stable storage (=
disk platters or similar)<br>
- change one pointer to point from old data to new data (so small that this=
 change is atomic)<br>
- flush again<br>
when this flush returns you are sure that the data on-disk is updated.<br>
<br>
Now you understand why dm-cache has the semantics that it has, which is the=
 same semantics as DRAM caches on HDDs.<br>
<br>
Applications writers have to follow the semantics described above, in order=
 to have &quot;atomic&quot; updates on disk. This is true with dm-cache but=
 also with DRAM caches on HDDs.<br>
Partial data losses are irrelevant if the above logic is followed.<br>
<br>
S.<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/<u></u>mailman/listinfo/dm-devel</a><br>
</blockquote></div><br></div>

--001a113f7ec80ec7bf05108b131a--


--===============1686762593250998002==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1686762593250998002==--
