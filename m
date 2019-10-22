From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 45/72] libmultipath: fix -Wsign-compare
 warnings with snprintf()
Date: Tue, 22 Oct 2019 20:34:21 +0000
Message-ID: <690ab1be1dc189c6efebf5fb953f31f9f0341286.camel@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
	<20191012212703.12989-46-martin.wilck@suse.com>
	<34e6fc87-10f6-efd7-c8df-710e56cc1956@acm.org>
	<f895f01df7c429abf4a32a395764513c92ecc3af.camel@suse.com>
	<42e85b61-3f38-af4e-a485-1ba230506d0f@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <42e85b61-3f38-af4e-a485-1ba230506d0f@acm.org>
Content-Language: en-US
Content-ID: <D189813CC7E6714DBF77E8B71FEA1A9F@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "bvanassche@acm.org" <bvanassche@acm.org>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, 2019-10-22 at 09:47 -0700, Bart Van Assche wrote:
> On 2019-10-22 09:07, Martin Wilck wrote:
> >=20
> > In this particular case, we're dealing with a historically-caused
> > property of snprintf(), as you are probably aware=20
> > (
> > https://stackoverflow.com/questions/45740276/why-does-printf-return-an-=
int-instead-of-a-size-t-in-c
> > ),
> > so I'd argue the ugliness is forced upon us, sort of.
> >=20
> > We can hide the ugliness in a macro if you prefer. Actually, we
> > have
> > safe_snprintf() already. We just need to use it in all places where
> > this kind of comparison is made. Would that be acceptable to you?
>=20
> Hi Martin,
>=20
> Have you considered to use asprintf() instead of snprintf() and a
> check
> whether the output buffer overflows? I think the former is a more
> elegant solution.

Most uses of snprintf() are in libmultipath printing code, where items
are printed sequentially into a big buffer, advancing the buffer
pointer on the way. asprintf() doesn't match that use case well,
AFAICS. But in some other places, switching to asprintf would certainly
make sense. Anyway, I'd like to do that in a separate patch set if you
don't mind; this one is big enough already.

Thanks,
Martin
