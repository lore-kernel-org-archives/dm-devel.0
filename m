From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Status of Linux LVM thin provisioning
Date: Mon, 19 May 2014 14:05:43 +0200
Message-ID: <CAAOsTS=LS+GdfxuP1eX3kUQduv=tZuoJJ+1G1i9OLcCk+fXE+g@mail.gmail.com>
References: <CAAOsTSk_wy5snVhQM_8k4fyk5KpnYMYn317+OzkgX6CSoA0K7A@mail.gmail.com>
	<5379F028.6040700@redhat.com>
Reply-To: patrik@dsl.sk, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5379F028.6040700@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

thanks for the info. For practical usage we probably need to choose
some distribution, so which one is more recommended than Debian? Is
the situation with Debian so bad or is there some existing
instructions for improving it with mentioned removal of own Debian's
udev rules?

I can say I have pretty good understanding of thin pools and volumes.
But one thing I am missing is some relevant information about
stability and reliability, because thin mapping is much more complex
than non-thin LVM and so it is another complex layer and another
possible point of failure.

So is there some info on what is considered stable and what is
routinely tested and what is yet (highly) experimental functionality?

Thanks.

Best regards,

Patrik Horn=EDk
=B9=E9fredaktor www.DSL.sk
Tel.: +421 905 385 666
Email: patrik@dsl.sk


2014-05-19 13:51 GMT+02:00 Zdenek Kabelac <zkabelac@redhat.com>:
> Dne 19.5.2014 00:46, Patrik Horn=EDk napsal(a):
>
>> Hello there,
>>
>> I am editor in chief of leading Slovak IT news server DSL.sk and I am
>> preparing material for our future article about Linux LVM. We are
>> creating production data storage system and will report experience
>> with that.
>>
>> What I am trying to find out right now is what is exact status of LVM
>> thin provisioning. There is warning in
>>
>> https://www.kernel.org/doc/Documentation/device-mapper/thin-provisioning=
.txt
>> that it is very much still in experimental state and not recommended
>> for production, but the text seems little outdated. So what is exact
>> status and what versions of kernel / tools are needed? (We are
>> currenly using Debian stable but with kernel, LVM and thin
>> provisioning tools from Debian testing, so kernel 3.13.10-1, lvm2
>> 2.02.104(2) (2013-11-13) and thin-provisioning-tools 0.2.8-1.)
>>
>
>
> Hi
>
> The last distro for lvm2 testing I'd suggest is any Debian based one. The
> reason behind it is - Debian supplies its own untested udev rules.
> Unfortunately device stack is becoming more and more complex (udev/system=
d)
> and there are many small piece that needs to cooperate together.
> Synchronization with udev is the critical point - and with badly working
> udev you may experience many error message to be shown and many things may
> not work - however lvm2 tries to at least detect those moments.
>
> I'd say the best is to play with upstream  git repository and  upstream u=
dev
> rules (though you have to carefully remove those from Debian distribution=
).
>
> With any runtime problem - try to seek for help on freenode #lvm.
>
> Also in the recent version (>=3D106) there is  'man lvmthin' which may he=
lp to
> understand usage of thin pools and volumes.
>
> Regards
>
> Zdenek
>
>
