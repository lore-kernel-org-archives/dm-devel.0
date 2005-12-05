From: "Carlos Manuel Duclos Vergara" <carlos@embedded.cl>
Subject: Re: [KJ] [PATCH] dm: uninitialize static variables
Date: Mon, 5 Dec 2005 18:06:49 -0000 (GMT)
Message-ID: <56471.206.49.219.34.1133806009.squirrel@webmail.embedded.cl>
References: <20051205132800.34631bbf@lucky.kitzblitz>
	<50993.206.49.219.34.1133786860.squirrel@webmail.embedded.cl>
	<20051205190029.4b29e759@lucky.kitzblitz>
Reply-To: carlos@embedded.cl,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20051205190029.4b29e759@lucky.kitzblitz>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nicolas Kaiser <nikai@nikai.net>
Cc: kernel-janitors@lists.osdl.org, dm-devel@redhat.com, Carlos Manuel Duclos Vergara <carlos@embedded.cl>
List-Id: dm-devel.ids

>  static unsigned int __attribute__((__section__(".bss"))) major =3D 0;
>  static unsigned int __attribute__((__section__(".bss"))) _major =3D 0;

it should be:

static unsigned int major __attribute__ ((section(".bss"))) =3D 0;

> If you could tell me how to achieve this in a fancy way which also work=
s,
> I'm all ears. Maybe the janitorial steering committee might also like t=
he
> idea enough to adjust their current TODO list.

yup, maybe it's worth of a discussion on the list

--=20
Carlos Manuel Duclos Vergara
http://www.toolchains.com/personal/blog
