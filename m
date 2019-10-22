From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 45/72] libmultipath: fix -Wsign-compare
 warnings with snprintf()
Date: Tue, 22 Oct 2019 09:47:11 -0700
Message-ID: <42e85b61-3f38-af4e-a485-1ba230506d0f@acm.org>
References: <20191012212703.12989-1-martin.wilck@suse.com>
	<20191012212703.12989-46-martin.wilck@suse.com>
	<34e6fc87-10f6-efd7-c8df-710e56cc1956@acm.org>
	<f895f01df7c429abf4a32a395764513c92ecc3af.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f895f01df7c429abf4a32a395764513c92ecc3af.camel@suse.com>
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
To: Martin Wilck <Martin.Wilck@suse.com>, "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2019-10-22 09:07, Martin Wilck wrote:
> Hello Bart,
>=20
> On Sat, 2019-10-12 at 15:59 -0700, Bart Van Assche wrote:
>> On 2019-10-12 14:28, Martin Wilck wrote:
>>> -=09if (snprintf(buf, bufsiz, "%s%s%d", mapname, delim, part) >=3D
>>> bufsiz)
>>> +=09if (snprintf(buf, bufsiz, "%s%s%d", mapname, delim, part)
>>> +=09    >=3D (int)bufsiz)
>>>  =09=09return 0;
>>
>> Please don't insert casts like this. I think enabling -Wsign-compare
>> is
>> wrong because it makes the source code ugly.
>=20
> The casts make it explicit which signedness is intended, which is a
> good thing IMO, better than the compiler trying to figure it out
> using implicit type conversion. Enabling the warning will help avoid
> subtle programming errors in the future, by forcing us to think twice
> about signedness. Considering that, isn't this ugliness - which I don't
> dispute - a relatively minor issue?
>=20
> In this particular case, we're dealing with a historically-caused
> property of snprintf(), as you are probably aware=20
> (https://stackoverflow.com/questions/45740276/why-does-printf-return-an-i=
nt-instead-of-a-size-t-in-c),
> so I'd argue the ugliness is forced upon us, sort of.
>=20
> We can hide the ugliness in a macro if you prefer. Actually, we have
> safe_snprintf() already. We just need to use it in all places where
> this kind of comparison is made. Would that be acceptable to you?

Hi Martin,

Have you considered to use asprintf() instead of snprintf() and a check
whether the output buffer overflows? I think the former is a more
elegant solution.

Thanks,

Bart.
