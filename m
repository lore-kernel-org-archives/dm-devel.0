From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Reducing size of thin spare metadata, thin metadata
Date: Mon, 06 Oct 2014 10:31:06 +0200
Message-ID: <5432534A.5090409@redhat.com>
References: <CAAOsTSmgp892H5M4+XLXSQ-H3G_HFUsnykiyjW+MbP4r7U8+Qw@mail.gmail.com>	<54324732.5080107@redhat.com>	<CAAOsTS=ufw7KgFMOW79+4_kwexnp=pALQWR7BLRSr_JUk6xGXQ@mail.gmail.com>	<54324D57.1050704@redhat.com>
	<CAAOsTS=ZvKDZAi7RwaO0s4hFEHeggGFZSQCLSjs3fGC+5m5mCA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAOsTS=ZvKDZAi7RwaO0s4hFEHeggGFZSQCLSjs3fGC+5m5mCA@mail.gmail.com>
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

Dne 6.10.2014 v 10:12 Patrik Horn=EDk napsal(a):
> OK, I see. So the result is that pool is not activated when it does
> not pass check and there is no spare? So is it totally safe to have no
> spare?
>
> And so is there a way to reduce size of spare / create spare of
> specified (smaller) size after its removal?
>

Idea behind spare is to have 'reserved' space for pool metadata recovery.
(it's like hidden space in filesystem)

When the pool gets broken and you don't have reserved space for repair
you need to add new free space for recovery.

And at this moment it's getting quite complex (well beyond autonomous =

'lvconvert --repair').

So as long as you know what you are doing and you could repair
metadata manually - you are fine.
(You could disable creation of spare volume in lvm.conf)

But lvm2 requires to have reserved space to proceed for --repair.
After all - the size of pool metadata should be pretty small compared with =
the =

rest of VG.

Zdenek
