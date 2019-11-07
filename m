From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: dm-writecache: change config parameters using
	messages
Date: Thu, 7 Nov 2019 21:16:18 +0100
Message-ID: <0fe12edd-c959-a870-0e15-988209cd629a@redhat.com>
References: <fa95f1f0-67d6-d02e-6999-ba1f90d70fe2@petasan.org>
	<8388b99a-a531-981e-9e36-8aeb3dffd18e@petasan.org>
	<20191106150831.GA27888@redhat.com>
	<5370f009-c324-1530-4400-adf1b59f0bbd@petasan.org>
	<20191107190958.GA2821@redhat.com>
	<cba8f93a-3477-9c87-0bff-fe7e6962d606@petasan.org>
	<alpine.LRH.2.02.1911071448290.20334@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1911071448290.20334@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mikulas Patocka <mpatocka@redhat.com>, Maged Mokhtar <mmokhtar@petasan.org>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Dne 07. 11. 19 v 20:50 Mikulas Patocka napsal(a):
>=20
>=20
> On Thu, 7 Nov 2019, Maged Mokhtar wrote:
>=20
>>
>>
>> On 07/11/2019 21:09, Mike Snitzer wrote:
>>> On Thu, Nov 07 2019 at  1:55pm -0500,
>>> Maged Mokhtar <mmokhtar@petasan.org> wrote:
>>>
>>>>
>>>>
>>>> On 06/11/2019 17:08, Mike Snitzer wrote:
>>>>> On Tue, Nov 05 2019 at  4:19pm -0500,
>>>>> Maged Mokhtar <mmokhtar@petasan.org> wrote:
>>>>>
>>>>>> Gentle ping please.
>>>>>>
>>>>>> It could add flexibility in changing cache parameters after device
>>>>>> creation.
>>>>>
>>>>> I'm inclined to _not_ take this type of change.
>>>>>
>>>>> Why isn't changing the config parameters via table reload viable for
>>>>> you?
>>>>>
>>>>
>>

IMHO any target update that is changing behavior of target should be made v=
ia=20
table reload - typical symptom of such requirement is - that change may
requires some memory allocation, metadata updates, synchronization of data =
on=20
used disks...

If these things are made via messages - there is 'no simply way' back
(while with table reload - we drop table if 'suspend' cannot proceed).

Another problem is - that if change is not visible via 'table line',
future table access might be unaware of the change  and may reload
table and expect different behavior.

Also actual table update via  suspend & resume cannot be much slower then=
=20
message anyway - you can use 'noflush' if you need to - depending on the
situation it might be usable -  and such operation is very quick.

Regards

Zdenek
