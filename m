From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Reducing size of thin spare metadata, thin metadata
Date: Mon, 6 Oct 2014 10:48:48 +0200
Message-ID: <CAAOsTSnfpf3GCZu95GisyS6Z+zj6LTkODuhZGu5JmaQXUPXgVg@mail.gmail.com>
References: <CAAOsTSmgp892H5M4+XLXSQ-H3G_HFUsnykiyjW+MbP4r7U8+Qw@mail.gmail.com>
	<54324732.5080107@redhat.com>
	<CAAOsTS=ufw7KgFMOW79+4_kwexnp=pALQWR7BLRSr_JUk6xGXQ@mail.gmail.com>
	<54324D57.1050704@redhat.com>
	<CAAOsTS=ZvKDZAi7RwaO0s4hFEHeggGFZSQCLSjs3fGC+5m5mCA@mail.gmail.com>
	<5432534A.5090409@redhat.com>
Reply-To: patrik@dsl.sk, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5432534A.5090409@redhat.com>
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

Thanks Zdenku. But you did not answer some of my questions, which I
need to know to decide... So is there a way I can create smaller spare
metadata LV? In mentioned manual steps what do I need mytemplv for and
why cant I use original pool metadata as input of thin_repair?

Thanks.

2014-10-06 10:31 GMT+02:00 Zdenek Kabelac <zkabelac@redhat.com>:
> Dne 6.10.2014 v 10:12 Patrik Horn=EDk napsal(a):
>>
>> OK, I see. So the result is that pool is not activated when it does
>> not pass check and there is no spare? So is it totally safe to have no
>> spare?
>>
>> And so is there a way to reduce size of spare / create spare of
>> specified (smaller) size after its removal?
>>
>
> Idea behind spare is to have 'reserved' space for pool metadata recovery.
> (it's like hidden space in filesystem)
>
> When the pool gets broken and you don't have reserved space for repair
> you need to add new free space for recovery.
>
> And at this moment it's getting quite complex (well beyond autonomous
> 'lvconvert --repair').
>
> So as long as you know what you are doing and you could repair
> metadata manually - you are fine.
> (You could disable creation of spare volume in lvm.conf)
>
> But lvm2 requires to have reserved space to proceed for --repair.
> After all - the size of pool metadata should be pretty small compared with
> the rest of VG.
>
> Zdenek
>
