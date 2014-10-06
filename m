From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Reducing size of thin spare metadata, thin metadata
Date: Mon, 06 Oct 2014 10:05:43 +0200
Message-ID: <54324D57.1050704@redhat.com>
References: <CAAOsTSmgp892H5M4+XLXSQ-H3G_HFUsnykiyjW+MbP4r7U8+Qw@mail.gmail.com>	<54324732.5080107@redhat.com>
	<CAAOsTS=ufw7KgFMOW79+4_kwexnp=pALQWR7BLRSr_JUk6xGXQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAOsTS=ufw7KgFMOW79+4_kwexnp=pALQWR7BLRSr_JUk6xGXQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: patrik@dsl.sk
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Dne 6.10.2014 v 09:59 Patrik Horn=EDk napsal(a):
> Hi,
>
> 2014-10-06 9:39 GMT+02:00 Zdenek Kabelac <zkabelac@redhat.com>:
>> Dne 6.10.2014 v 09:28 Patrik Horn=EDk napsal(a):
>>
>>> Hi,
>>>
>>> is it possible to (safely) reduce size of thin metadata and / or thin
>>> spare metadata? What size of spare metadata is needed? Can it be
>>> smaller than size of pool metadata?
>>>
>>
>> You could remove pool spare volume anytime  - lvremove.
>> (it's only used for automated lvconvert --repair)
>>
>> Repair needs free space in VG - if there is no free space - well tool ca=
n't
>> be used.
>
> when does automated lvconvert --repair kick in? Can I do it manually
> if it cannot continue automatically? (I actually have space for spare
> metadata so I want it there if it useful but smaller. I only need to
> decrease size of my volume group by couple of 100s MB because of
> moving to new device. My spare is 8 GB as is regular metadata.)

When thin-pool does not pass 'thin-check' during thin-pool activation,
you could try to use this  'lvconvert --repair' at first.

Basically it automates steps described in previous mail - except it will tr=
y =

to use bigger 'replaceable' LV.

Yet the functionality is not really any better then that - it's still missi=
ng
many validation checks between user-land lvm2 metadata and kernel-land =

thin-pool metadata.

But it's being improved.
Meanwhile any 'major' damage of thin-pool metadata do need  'hand' work rep=
air =

- since human can do far better decision then this initial implementation.

Also note - any pool damage is still important to be reported - as
thin pool metadata should be nearly impossible to break in the first place =
;)

Zdenek
