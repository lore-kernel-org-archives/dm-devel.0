From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Reducing size of thin spare metadata, thin metadata
Date: Mon, 06 Oct 2014 10:57:27 +0200
Message-ID: <54325977.9090805@redhat.com>
References: <CAAOsTSmgp892H5M4+XLXSQ-H3G_HFUsnykiyjW+MbP4r7U8+Qw@mail.gmail.com>	<54324732.5080107@redhat.com>	<CAAOsTS=ufw7KgFMOW79+4_kwexnp=pALQWR7BLRSr_JUk6xGXQ@mail.gmail.com>	<54324D57.1050704@redhat.com>	<CAAOsTS=ZvKDZAi7RwaO0s4hFEHeggGFZSQCLSjs3fGC+5m5mCA@mail.gmail.com>	<5432534A.5090409@redhat.com>
	<CAAOsTSnfpf3GCZu95GisyS6Z+zj6LTkODuhZGu5JmaQXUPXgVg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAOsTSnfpf3GCZu95GisyS6Z+zj6LTkODuhZGu5JmaQXUPXgVg@mail.gmail.com>
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

Dne 6.10.2014 v 10:48 Patrik Horn=EDk napsal(a):
> Thanks Zdenku. But you did not answer some of my questions, which I
> need to know to decide... So is there a way I can create smaller spare
> metadata LV? In mentioned manual steps what do I need mytemplv for and
> why cant I use original pool metadata as input of thin_repair?

Spare volume is maintained to have the size at least as the biggest
pool metadata volume in VG.

There is no point to keep smaller reserved space.

We do not allow to activate 'subvolumes' - thus you cannot activate
just 'thin pool metadata'  - that's why you need to swap _tmeta
out thin pool.

Zdenek
