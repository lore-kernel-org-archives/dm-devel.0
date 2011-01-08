From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: kobject_put vs module unload
Date: Sat, 8 Jan 2011 19:09:03 +0100
Message-ID: <AANLkTi=hZ_W877QOwNK3=1-2S03VsKOXF_cVno_ReyrY@mail.gmail.com>
References: <Pine.LNX.4.64.1101072234040.382@hs20-bc2-1.build.redhat.com>
 <20110108055621.GB10391@suse.de> <Pine.LNX.4.64.1101080811400.29089@hs20-bc2-1.build.redhat.com>
 <AANLkTikg7vAG4-E=BD_sC=63R8fDCfEi_wiqnxDnUnK=@mail.gmail.com> <Pine.LNX.4.64.1101081258560.24933@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1101081258560.24933@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Jan 8, 2011 at 19:01, Mikulas Patocka <mpatocka@redhat.com> wro=
te:
> On Sat, 8 Jan 2011, Kay Sievers wrote:
>> On Sat, Jan 8, 2011 at 14:19, Mikulas Patocka <mpatocka@redhat.com> =
wrote:
>> > On Fri, 7 Jan 2011, Greg KH wrote:
>>
>> >> > 4) the reference obtained at point 1) is dropped, kobject refer=
ence count
>> >> > reaches zero and the release callback is called. But that callb=
ack points
>> >> > to an unloaded module and causes a crash.
>> >> >
>> >> > How is it solved? Am I missing something?
>> >>
>> >> You have the code that creates and frees the object, to not be in=
 the
>> >> module that could have been unloaded. =C2=A0It's really just that=
 simple.
>> >
>> > If the whole device mapper subsystem can be a module, where can I =
put the
>> > code?
>> >
>> > I think a similar bug exists in md, it can also be unloaded as a m=
odule
>> > and it has "release" method in its module code.
>>
>> If you still have data structures hanging around, these structures a=
re
>> supposed to take a reference on the module -- and you can not unload
>> the module as long as this is the case.
>>
>> Kay
>
> kobject references don't increase module reference count. If kobject =
held
> module references, it would be a fix for this bug, but could cause ot=
her
> bugs (some modules could be unloadable due to self-references to its =
own
> kobjects).

Sure, they don't automatically take references. It's the job of the
driver/module, to make sure to pin the module for any data of it,
which might be still in use.

Kay
