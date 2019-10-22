From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 45/72] libmultipath: fix -Wsign-compare
 warnings with snprintf()
Date: Tue, 22 Oct 2019 14:32:54 -0700
Message-ID: <b4e750e1-ecc1-853d-5582-fae16b3932f0@acm.org>
References: <20191012212703.12989-1-martin.wilck@suse.com>
	<20191012212703.12989-46-martin.wilck@suse.com>
	<34e6fc87-10f6-efd7-c8df-710e56cc1956@acm.org>
	<f895f01df7c429abf4a32a395764513c92ecc3af.camel@suse.com>
	<42e85b61-3f38-af4e-a485-1ba230506d0f@acm.org>
	<690ab1be1dc189c6efebf5fb953f31f9f0341286.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <690ab1be1dc189c6efebf5fb953f31f9f0341286.camel@suse.com>
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

On 2019-10-22 13:34, Martin Wilck wrote:
> Most uses of snprintf() are in libmultipath printing code, where items
> are printed sequentially into a big buffer, advancing the buffer
> pointer on the way. asprintf() doesn't match that use case well,
> AFAICS. But in some other places, switching to asprintf would certainly
> make sense. Anyway, I'd like to do that in a separate patch set if you
> don't mind; this one is big enough already.

Hi Martin,

For this patch, have you considered to change the type of the 'bufsiz'
argument of format_partname() from size_t into int or unsigned int? I do
not expect that the output string will ever exceed 65535 characters. As
you probably know the C standard guarantees that there are at least 16
bits in an int.

I'd like to reiterate that introducing -Wsign-compare seems dubious to me.

Thanks,

Bart.
