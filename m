Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CD625E464;
	Mon, 10 Feb 2025 19:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739214343; cv=none; b=LgHdzHLwN3MTuUYnGHO8ZSeQ4wTY0TO8IaylLyNhINdf7HK2AaL4HUHk2mf/mGwiUKt3puDy3xGyylPz3Fm36X/4mrUKRMDHq/ljTwwBXDpXQZau0yWyTr0VuTnTFaX7IOtY6JyIA9ZmttcvHoUsM821g+ZOEXYW9W2Ut9i+e70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739214343; c=relaxed/simple;
	bh=zXBfHFcJ8y1Ef8wxt5I3wKzH1G1cWo22aipJAEO5+d8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JTD3+KJEpksKRqujcCnQ4KnJT5f6mfvvOvQtU13P6KWDAfGjYG8lz1K/qJHzUjGnqnbPv4UFlQflrirj6LJNqpN9qSQ4LckP07L+auYCB1C67ArYwD4gB6uPqTlF0iOv12dVdUNzNwjUjKL+MZokRZ38BziSKteHsf+6VJ9gl6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VWufO9Dv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VWufO9Dv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064E2C4CED1;
	Mon, 10 Feb 2025 19:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739214343;
	bh=zXBfHFcJ8y1Ef8wxt5I3wKzH1G1cWo22aipJAEO5+d8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VWufO9DvWwnhOR4lrjCZhiQN5gxZfJBIhouFkBGqN9i2zwsZBlALn+ZRhF9lEbo3V
	 d6KNNZIhHoMkt4Xb1A9GD+S76m6r6jLPd8NYg0MA6InfmsN2+WkT5AdT4g23HaiyT5
	 uu8LZQgHkBr3fe67bSqHkgu/RQOfVCnkEJwmYRcXrUlSwoe5yZXG7LoB3VQEVIPnK2
	 Xb5AdhxEXOjPZ+n7sMttPRVkm/HR+RWLwwGdfNUoExBXJgaI6cJNkSy3WYv4balluv
	 8bNY5PltM372FVBZ213e7K7HrV4Ti9oyoq4K95R0NkL655CMIGpPD0uf4/Gv/0Yfds
	 Xrn/HMHZhj5YA==
Date: Mon, 10 Feb 2025 11:05:41 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Akilesh Kailash <akailash@google.com>, kernel-team@android.com,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Milan Broz <gmazyland@gmail.com>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm-verity: do forward error correction on metadata I/O
 errors
Message-ID: <20250210190541.GG1264@sol.localdomain>
References: <629167c1-9be0-6128-8605-eb02391e821d@redhat.com>
 <CABCJKucmOTVF1jY3vM7VKHuLkDeUxK1EU7YK=C+vgfWvgZFWPQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABCJKucmOTVF1jY3vM7VKHuLkDeUxK1EU7YK=C+vgfWvgZFWPQ@mail.gmail.com>

On Mon, Feb 10, 2025 at 08:57:55AM -0800, Sami Tolvanen wrote:
> Hi Mikulas,
> 
> On Mon, Feb 10, 2025 at 7:04 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> > Do forward error correction if metadata I/O fails.
> >
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> >
> > ---
> >  drivers/md/dm-verity-target.c |   19 +++++++++++++++++--
> >  1 file changed, 17 insertions(+), 2 deletions(-)
> >
> > Index: linux-2.6/drivers/md/dm-verity-target.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm-verity-target.c        2025-02-04 13:52:45.000000000 +0100
> > +++ linux-2.6/drivers/md/dm-verity-target.c     2025-02-10 15:55:42.000000000 +0100
> > @@ -324,8 +324,22 @@ static int verity_verify_level(struct dm
> >                                                 &buf, bio->bi_ioprio);
> >         }
> >
> > -       if (IS_ERR(data))
> > -               return PTR_ERR(data);
> > +       if (IS_ERR(data)) {
> > +               r = PTR_ERR(data);
> > +               data = dm_bufio_new(v->bufio, hash_block, &buf);
> > +               if (IS_ERR(data))
> > +                       return r;
> > +               if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_METADATA,
> > +                                     hash_block, data) == 0) {
> > +                       aux = dm_bufio_get_aux_data(buf);
> > +                       aux->hash_verified = 1;
> > +                       goto release_ok;
> > +               } else {
> > +                       dm_bufio_release(buf);
> > +                       dm_bufio_forget(v->bufio, hash_block);
> > +                       return r;
> > +               }
> > +       }
> 
> Don't we still have to check for io->in_bh before trying to correct the error?
> 
> Overall, it would be nice not to duplicate code here. Should the
> metadata error correction / handling be moved to a separate function
> similar to verity_handle_data_hash_mismatch?
> 

It's also incorrect to do this when skip_verified=true, since in that case
want_digest (which verity_fec_decode() uses) has not been initialized yet.

- Eric
