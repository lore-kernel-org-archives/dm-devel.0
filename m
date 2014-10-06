From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Reducing size of thin spare metadata, thin metadata
Date: Mon, 6 Oct 2014 09:59:44 +0200
Message-ID: <CAAOsTS=ufw7KgFMOW79+4_kwexnp=pALQWR7BLRSr_JUk6xGXQ@mail.gmail.com>
References: <CAAOsTSmgp892H5M4+XLXSQ-H3G_HFUsnykiyjW+MbP4r7U8+Qw@mail.gmail.com>
	<54324732.5080107@redhat.com>
Reply-To: patrik@dsl.sk, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54324732.5080107@redhat.com>
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

2014-10-06 9:39 GMT+02:00 Zdenek Kabelac <zkabelac@redhat.com>:
> Dne 6.10.2014 v 09:28 Patrik Horn=EDk napsal(a):
>
>> Hi,
>>
>> is it possible to (safely) reduce size of thin metadata and / or thin
>> spare metadata? What size of spare metadata is needed? Can it be
>> smaller than size of pool metadata?
>>
>
> You could remove pool spare volume anytime  - lvremove.
> (it's only used for automated lvconvert --repair)
>
> Repair needs free space in VG - if there is no free space - well tool can=
't
> be used.

when does automated lvconvert --repair kick in? Can I do it manually
if it cannot continue automatically? (I actually have space for spare
metadata so I want it there if it useful but smaller. I only need to
decrease size of my volume group by couple of 100s MB because of
moving to new device. My spare is 8 GB as is regular metadata.)

> You could also reduce size of thin pool metadata in case it's too big, ju=
st
> not online.
>
>
> With offline thinpool with these manual steps
> (will be later automated with tool as well):
>
> --
>
> make a temporary LV of any size.
> swap this temp LV with  pool metadata
>
> # lvconvert --thinpool  vg/mypool   --poolmetadata mytemplv
>

Does not lvconvert only change metadata volume not copying data to it?
So isn't there missing step to copy metadata from current metadata to
mytemplv? Why do u use mytemplv anyway and dont copy metadata directly
from current metadata to new smaller LV?

Anyway I prefer to reduce spare metadata if possible and not risk
reducing real metadata, it should be enough for me.

Thanks.

Patrik

> Create your volume for metadata with new reduced size
> (unsure which size is your target - but some calcs based on estimated usa=
ge
> are necessary)
>
> Activate   mytemplv  which has now real metadata from thinpool.
>
> # thin_repair  -i /dev/vg/mytemplv   -o /dev/vg/mynewsizemeta
>
> # thin_check  /dev/vg/mynewsizemeta
>
>
> If all is green - swap new meta into your thinpool
>
> # lvconvert --thinpool  vg/mypool   --poolmetadata mynewsizemeta
>
>
> If all works great you are done :)
> In all other cases you have your backup at hand :)
>
> Yeah - you still have old metadata in mytemplv - this volume you may remo=
ve
> later if all works well - otherwise you may try to swap this volume back.
>
> Zdenek
>
