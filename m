From: Eric Hawicz <erh@nimenees.com>
Subject: Re: [PATCH 1/1] libdmmp: Add support for upcoming json-c
	0.14.0.
Date: Sat, 30 May 2020 10:25:36 -0400
Message-ID: <cd7e550b-cc5e-ca1a-e092-f5ffcbb16d70@nimenees.com>
References: <1590725443-3519-1-git-send-email-bmarzins@redhat.com>
	<1590725443-3519-2-git-send-email-bmarzins@redhat.com>
	<d092428a245e0b5d88b70f03a473d7df7b95cd27.camel@suse.com>
	<42eef647-d9ef-7956-5852-27188bc4665f@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <42eef647-d9ef-7956-5852-27188bc4665f@gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <Martin.Wilck@suse.com>, "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "mail@eworm.de" <mail@eworm.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "besser82@fedoraproject.org" <besser82@fedoraproject.org>, Eric Haszlakiewicz <erh+git@nimenees.com>
List-Id: dm-devel.ids

On 5/29/2020 7:45 AM, Xose Vazquez Perez wrote:
> On 5/29/20 11:12 AM, Martin Wilck wrote:
>
>> Did you see
>> https://www.redhat.com/archives/dm-devel/2020-May/msg00261.html ?
>>
>> This has first been reported to the list by Christian (
>> https://www.redhat.com/archives/dm-devel/2020-April/msg00261.html), and
>> brought to my attention later by Xose. I personally thought the change
>> from boolean to int is a step in the wrong direction, therefore I
>> submitted my modified version using stdboolh. If everyone else is fine
>> with the int, it's not worth arguing about it.
>>
>> Regards,
>> Martin
>>
>> PS: Can anyone explain why json-c did this? Looks like a "cause hassle
>> for downstream devs and users for no good reason" kind of thing to
>> me...
>>
>
> Add Eric Haszlakiewicz to CC.
>
> Done at:=20
> https://github.com/json-c/json-c/commit/0992aac61f8b087efd7094e9ac2b84fa9=
c040fcd


TRUE and FALSE are rather generic defines that json-c had no business=20
ever setting, especially to json-c specific values, and the fact that we=20
were doing so was conflicting with other cases that already defined it.=A0=
=20
Sorry about the hassle, but I consider that a very good reason to remove=20
them.


Eric
