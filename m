From: Chen Gang <gang.chen@asianux.com>
Subject: Re: drivers: md: include "linux/vmalloc.h" in "dm-cache-policy-hints.c"
Date: Thu, 31 Oct 2013 08:48:00 +0800
Message-ID: <5271A8C0.7000906@asianux.com>
References: <5270A465.2040200@asianux.com> <20131030143825.GA8125@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131030143825.GA8125@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: agk@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 10/30/2013 10:38 PM, Mike Snitzer wrote:
> On Wed, Oct 30 2013 at  2:17am -0400,
> Chen Gang <gang.chen@asianux.com> wrote:
>=20
>> Need include related header file, or can not pass compiling, the
>> related error (for powerpc with allmodconfig):
>>
>>     CC [M]  drivers/md/dm-cache-policy-hints.o
>>   drivers/md/dm-cache-policy-hints.c: In function =A1=AEalloc_hash=A1=
=AF:
>>   drivers/md/dm-cache-policy-hints.c:94:2: error: implicit declarati=
on of function =A1=AEvzalloc=A1=AF [-Werror=3Dimplicit-function-declara=
tion]
>>   drivers/md/dm-cache-policy-hints.c:94:14: warning: assignment make=
s pointer from integer without a cast [enabled by default]
>>   drivers/md/dm-cache-policy-hints.c: In function =A1=AEfree_hash=A1=
=AF:
>>   drivers/md/dm-cache-policy-hints.c:101:2: error: implicit declarat=
ion of function =A1=AEvfree=A1=AF [-Werror=3Dimplicit-function-declarat=
ion]
>>   drivers/md/dm-cache-policy-hints.c: In function =A1=AEalloc_bitset=
=A1=AF:
>>   drivers/md/dm-cache-policy-hints.c:184:2: warning: return makes po=
inter from integer without a cast [enabled by default]
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>=20
> This was already fixed a couple days ago in the linux-dm.git 'for-nex=
t'
> branch.
>=20
> But thanks.
>=20
>=20

Thank you too.
--=20
Chen Gang
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
