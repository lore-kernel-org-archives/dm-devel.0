Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47121282F5
	for <dm-devel@lists.linux.dev>; Fri, 24 Jan 2025 06:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737699764; cv=none; b=uu3l1O1GpMuXWqwtusdfyPbqfnir9gP8gdrjgzd7Z9JrrhujF+dbjMCJfGtqTYdlOCPPPCaIe59Fpuf+OouiY9vfhVviSPl0UpyEYzN69xY3EC07F1DVMqB/se4Hibfmhw+gilKfT+AIJ5O1xuzYQ0fw554zcVzsS7ZZ5plaiBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737699764; c=relaxed/simple;
	bh=UYZREb/OOOVxFIGI0/twwWwndn9h7LgxA/HKy8MnJSQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Dm9EZ+NaVkgVstmQotML7dVxX3/o0+iHo4/T6q1CpDemCOMHwH47Y+WzQXRz0lRDWKsEqKta6BYEfv7/f5ZqCP2GvQBps7CsL/C71qd9CF/R4DDx+2mU9Sed3I1y8AAbk9GtX8fJp+VGAonCnVuMUj+YvvTkZP0QI0hUYWGOeag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=MgChREwt; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="MgChREwt"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1737699751;
	bh=UYZREb/OOOVxFIGI0/twwWwndn9h7LgxA/HKy8MnJSQ=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=MgChREwtK8V8L7EOtU5GO9RXU717W0537IVrPKzVRo4F9kLTYG6kuIRmSjxaHm4u9
	 p1O2TF0I87vuta4KAtbdhFQ7rUehe3Qbkr4DqOPX7zZFavoGvqBjOUusDVzmblAWS7
	 EI4E0B8pSx4F7e/+gb4s29rf2RxXH66NaZmkiCrk=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <4F13648A-8444-4C5E-B2F4-FF7643CD8427@flyingcircus.io>
Date: Fri, 24 Jan 2025 07:22:06 +0100
Cc: Xiao Ni <xni@redhat.com>,
 John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 =?utf-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 David Jeffery <djeffery@redhat.com>,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D0D9694F-E8F3-4D83-9628-8FA89B061AB9@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <9A0AE411-B4B8-424A-B9F6-AF933F6544F9@flyingcircus.io>
 <BE85CBCF-1B09-48D0-9931-AA8D298F1D6B@flyingcircus.io>
 <b2a654e7-6c71-a44e-645c-686eed9d5cd8@huaweicloud.com>
 <240E3553-1EDD-49C8-88B8-FB3A7F0CE39C@flyingcircus.io>
 <12295067-fc9a-8847-b370-7d86b2b66426@huaweicloud.com>
 <CALTww28iP_pGU7jmhZrXX9D-xL5Xb6w=9jLxS=fvv_6HgqZ6qw@mail.gmail.com>
 <09338D11-6B73-4C4B-A19A-6BDC6489C91D@flyingcircus.io>
 <C3A9A473-0F0E-4168-BB96-5AB140C6A9FC@flyingcircus.io>
 <0B1D29D1-523C-4E42-95F9-62B32B741930@flyingcircus.io>
 <4DA6F1FE-D465-40C7-A116-F49CF6A2CFF0@flyingcircus.io>
 <CALTww292Dwduh=k1W4=u+N2K6WYK7RXQyPWG3Yn-JpLY9QDbDQ@mail.gmail.com>
 <362DFCF4-14C5-464C-A73F-72C9A3871E2F@flyingcircus.io>
 <CALTww280ztWNUW23-Y+8w_S4ZAR4UYdtAmZU4b_wLHjjpTRPJQ@mail.gmail.com>
 <DD7FDB11-1BC5-4FA9-9398-23434CBDB6F8@flyingcircus.io>
 <F9738805-DB6B-4249-A4B0-EC989AD6C399@flyingcircus.io>
 <FE6CA342-7C31-4280-A62B-EFA222675DAD@flyingcircus.io>
 <f34b49b2-6be2-3a5f-d8b2-ea49f5249dd6@huaweicloud.com>
 <A32F4D73-B034-4927-B783-22F2E79EE711@flyingcircus.io>
 <4F13648A-8444-4C5E-B2F4-FF7643CD8427@flyingcircus.io>
To: Yu Kuai <yukuai1@huaweicloud.com>

Hi,

I=E2=80=99ve been running 6.13 with those patches[1] successfully with =
production load for about 3 days now - this looks like it=E2=80=99s =
fixed!

I=E2=80=99d appreciate a backport to 6.6 =E2=80=A6 is there anyone =
specific I should notify about that?

Thank=E2=80=99s a lot!
Christian

[1] Patches applied to 6.13 vanilla (don=E2=80=99t mind the branch name =
mentioning 6.11), those should be the right ones, I hope:

=
https://github.com/flyingcircusio/fc-nixos/blob/PL-132896-try-kernel-6.11-=
debug-mdraid/pkgs/patch1.patch
=
https://github.com/flyingcircusio/fc-nixos/blob/PL-132896-try-kernel-6.11-=
debug-mdraid/pkgs/patch2.patch
=
https://github.com/flyingcircusio/fc-nixos/blob/PL-132896-try-kernel-6.11-=
debug-mdraid/pkgs/patch3.patch
=
https://github.com/flyingcircusio/fc-nixos/blob/PL-132896-try-kernel-6.11-=
debug-mdraid/pkgs/patch4.patch
=
https://github.com/flyingcircusio/fc-nixos/blob/PL-132896-try-kernel-6.11-=
debug-mdraid/pkgs/patch5.patch


> On 20. Jan 2025, at 10:19, Christian Theune <ct@flyingcircus.io> =
wrote:
>=20
> Sorry again for the long silence =E2=80=A6=20
>=20
> 6.13 applied with the patches is now under test in my setup, I=E2=80=99l=
l let you know whether this have been stable in a few days.
>=20
> For future archaeologists: the previous patch (that you didn=E2=80=99t =
go with) worked mostly well but did trigger a few similar crashes.
>=20
> Christian
>=20
>> On 16. Dec 2024, at 15:18, Christian Theune <ct@flyingcircus.io> =
wrote:
>>=20
>> Hi,
>>=20
>> oh dang, yeah, I noticed that mail and I tried grabbing the proper =
patch but as I previously had issues in my workflow getting them from =
mail I thought I picked the right one elsewhere. I=E2=80=99ll try again =
tomorrow.
>>=20
>> Sorry =E2=80=A6=20
>>=20
>> Christian
>>=20
>>> On 16. Dec 2024, at 14:36, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>=20
>>> Hi,
>>>=20
>>> =E5=9C=A8 2024/12/16 21:25, Christian Theune =E5=86=99=E9=81=93:
>>>> Hi,
>>>> both my servers that exhibited this issue have been running fine =
with 6.6.64 and the proposed patch.
>>>> @yu I=E2=80=99d love to get this backported, is there anything I =
can/need to do?
>>>=20
>>> Looks like you're testing the wrong patch. We'll not go with this =
patch
>>> in upstream.
>>>=20
>>> Do you still remember the patch set from following thread?
>>>=20
>>> =
https://lore.kernel.org/all/5D6DF34A-81EF-47EE-B280-6A243A28011D@flyingcir=
cus.io/
>>>=20
>>> Sorry that I was busy with other things, I'll push this in the next
>>> merge window v6.14-rc1, unless it fails your test. :)
>>>=20
>>> Thanks,
>>> Kuai
>>>=20
>>>> Christian
>>>>> On 10. Dec 2024, at 09:33, Christian Theune <ct@flyingcircus.io> =
wrote:
>>>>>=20
>>>>> Just a quick update: i=E2=80=99ve been out sick and only am =
getting around to start testing the patch on 6.6. it applied cleanly as =
you suggested and I=E2=80=99m waiting for the compile to finish. I=E2=80=99=
ll get back to you in the next days how it worked out.
>>>>>=20
>>>>>> On 15. Nov 2024, at 12:06, Christian Theune <ct@flyingcircus.io> =
wrote:
>>>>>>=20
>>>>>> Will do that!
>>>>>>=20
>>>>>>> On 15. Nov 2024, at 11:11, Xiao Ni <xni@redhat.com> wrote:
>>>>>>>=20
>>>>>>> On Fri, Nov 15, 2024 at 4:45=E2=80=AFPM Christian Theune =
<ct@flyingcircus.io> wrote:
>>>>>>>>=20
>>>>>>>> Hi,
>>>>>>>>=20
>>>>>>>>> On 15. Nov 2024, at 09:07, Xiao Ni <xni@redhat.com> wrote:
>>>>>>>>>=20
>>>>>>>>> On Thu, Nov 14, 2024 at 11:07=E2=80=AFPM Christian Theune =
<ct@flyingcircus.io> wrote:
>>>>>>>>>>=20
>>>>>>>>>> Hi,
>>>>>>>>>>=20
>>>>>>>>>> just a followup: the system ran over 2 days without my =
workload being able to trigger the issue. I=E2=80=99ve seen there is =
another thread where this patch wasn=E2=80=99t sufficient and if i =
understand correctly, Yu and Xiao are working on an amalgamated fix?
>>>>>>>>>>=20
>>>>>>>>>> Christian
>>>>>>>>>=20
>>>>>>>>> Hi Christian
>>>>>>>>>=20
>>>>>>>>> Beside the bitmap stuck problem, the other thread has a new =
problem.
>>>>>>>>> But it looks like you don't have the new problem because you =
already
>>>>>>>>> ran without failure for 2 days. I'll send patches against 6.13 =
and
>>>>>>>>> 6.11.
>>>>>>>>=20
>>>>>>>> Great, thanks!
>>>>>>>>=20
>>>>>>>> What do I need to do to get patches towards 6.6?
>>>>>>>=20
>>>>>>> Hi
>>>>>>>=20
>>>>>>> This patch can apply to 6.6 cleanly. You can have a try on 6.6 =
with
>>>>>>> this patch to see if it works.
>>>>>>>=20
>>>>>>> Regards
>>>>>>> Xiao
>>>>>>>>=20
>>>>>>>> Christian
>>>>>>>>=20
>>>>>>>> --
>>>>>>>> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 =
219401 0
>>>>>>>> Flying Circus Internet Operations GmbH =C2=B7 =
https://flyingcircus.io
>>>>>>>> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 =
Deutschland
>>>>>>>> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: =
Christian Theune, Christian Zagrodnick
>>>>>>=20
>>>>>>=20
>>>>>> Liebe Gr=C3=BC=C3=9Fe,
>>>>>> Christian Theune
>>>>>>=20
>>>>>> --=20
>>>>>> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 =
0
>>>>>> Flying Circus Internet Operations GmbH =C2=B7 =
https://flyingcircus.io
>>>>>> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 =
Deutschland
>>>>>> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian =
Theune, Christian Zagrodnick
>>>>>>=20
>>>>>=20
>>>>> Liebe Gr=C3=BC=C3=9Fe,
>>>>> Christian Theune
>>>>>=20
>>>>> --=20
>>>>> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
>>>>> Flying Circus Internet Operations GmbH =C2=B7 =
https://flyingcircus.io
>>>>> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
>>>>> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian =
Theune, Christian Zagrodnick
>>>>>=20
>>>> Liebe Gr=C3=BC=C3=9Fe,
>>>> Christian Theune
>>>=20
>>=20
>> Liebe Gr=C3=BC=C3=9Fe,
>> Christian Theune
>>=20
>> --=20
>> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
>> Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
>> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
>> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian =
Theune, Christian Zagrodnick
>>=20
>=20
> Liebe Gr=C3=BC=C3=9Fe,
> Christian Theune
>=20
> --=20
> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
> Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian =
Theune, Christian Zagrodnick
>=20

Liebe Gr=C3=BC=C3=9Fe,
Christian Theune

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

