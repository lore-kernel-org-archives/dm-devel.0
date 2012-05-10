From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [Bcache v13 02/16] Bio pool freeing
Date: Thu, 10 May 2012 17:52:09 -0400
Message-ID: <20120510215208.GC2613@redhat.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <ba8ce9fcca87f192ff5f5d3a436eb8f4d0bcb006.1336619038.git.koverstreet@google.com>
 <20120510213217.GN23768@redhat.com>
 <CAH+dOxL7QwcyUm46cK-pF1qK+kHYC=67iAaQDDwUF2ssJwergA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH+dOxL7QwcyUm46cK-pF1qK+kHYC=67iAaQDDwUF2ssJwergA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Thu, May 10, 2012 at 02:39:26PM -0700, Kent Overstreet wrote:
> On Thu, May 10, 2012 at 2:32 PM, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> > On Wed, May 09, 2012 at 11:08:34PM -0400, Kent Overstreet wrote:
> >> When you allocate a bio from a bio pool, to free it you have to kn=
ow
> >> where it came from; this adds a flag which, if set, means bi_destr=
uctor
> >> is the pointer to the pool and bio_put() can do the right thing.
> >>
> >> This is used in bcache, so we can cleanly use per device bio pools=
=2E
> >
> > Ok, that will explain BIO_HAS_POOL flag. =A0Why to replace
> > bio_has_allocated_vec() with BIO_HAS_VEC flag?
>=20
> Using bio_has_allocated_vec() would mean the bvec would always be
> freed if it wasn't a pointer to the inline vecs - my bio splitting
> code will use the bvec from the original bio for the split if it's
> splitting on a bvec boundary, in which case that's not what we want.
>=20
> It means "bio owns its bvec".

ok, probably we could explain it more in changelog or push this in same
patch where you introduce bio splitting so that bio shares bvec with ot=
her
bio. That way it is easier to understand.

Thanks
Vivek
