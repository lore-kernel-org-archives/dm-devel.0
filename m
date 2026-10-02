Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDCB515992;
	Fri,  2 Oct 2026 20:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790972064; cv=none; b=WistIRp0jTHIuyqw9vZTehOa0VAM5V1y7Xb59cXO9IZdSEoCOhx18yOzaoiCFZ+aRiiBeslawIzPBERv3RJB8YNDHSfEwUM50G0TYyEkmR2TNCI77gv3qumhH6qQJ5RgQEW2J78XxnqMlQzk66HMK+B0N0tBjcbZNpnWVXodMZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790972064; c=relaxed/simple;
	bh=fs0Ov8lINBSc7JW89f5BCfxU0RjzTuPZ34hBQGckZ94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P5JalWOvKu6ynCiVajGQIDobYZQLLkz4DwjKSz2EjTkV41uRcJhe4RrGzfZPEn6IXOO+rjJ3l0QLlnem8R1P+WE67rsaqtA0utU9RVUiAGEP6zGa/jqMT4ZgHaAmZFRiWrATH8ekC/7ugnroQMGZEDmXZm84Djl37cu5hxEkXeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FPd9qSev; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FPd9qSev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E20E1F000FF;
	Fri,  2 Oct 2026 20:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790972061;
	bh=SJH94DwMdZBmJc1mvMyVDHBOWduaT+xUqWE/HnxR5XA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FPd9qSevmow5oKrgOxcLgYf59uqBqxCQ8G+9L1aqDqkLAfGfF3x8euLd+mJ12cX+w
	 6LOa28zWtvx/bdkEtzOyMht5DfxwAQN3kh37phji2YsDu3mU5j2YCsrGiJNtdGCHcq
	 fb3sTop0OTAg06bBseLyjxI+B/8oq5qNGke9z8i9HWGmN3ElPQH+aqhy4Oc2zypkqW
	 Y4/TLraHMZCaWCic0wSdbVBta2fSHt0V+DxtQohNNjcAtpsmFw/6MI7AwcLXdstRf5
	 t3I5WpOQvd1ZmISLyawcTbr1dUZCqq4LLC/zgBvRWDnQIpTGCuJSQo6wVB3ZDQhucz
	 6O4QzRSHyAqtA==
Date: Fri, 2 Oct 2026 20:14:19 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Lorenz Kofler <lorenz@sigma-star.at>, Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, upstream+dm@sigma-star.at,
	David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] dm-integrity: support keys in the kernel keyring
Message-ID: <20261002201419.GA205250@google.com>
References: <20260928062734.3805458-1-lorenz@sigma-star.at>
 <20260928062734.3805458-2-lorenz@sigma-star.at>
 <6e7bd72b-6f1a-211d-16a8-a35a530af408@redhat.com>
 <b0f8f47a-beb0-426e-bdee-5d0d80ade8ad@sigma-star.at>
 <1e53661e-42f4-72b2-3331-33af21e9fe0f@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e53661e-42f4-72b2-3331-33af21e9fe0f@redhat.com>

On Fri, Oct 02, 2026 at 01:48:23PM +0200, Mikulas Patocka wrote:
> > > These four functions are copied from dm-crypt.c and dm-inlinecrypt.c.
> > > Copying code is generally malpattern, they should be unified and moved to
> > > an include file (that would be included in all three targets) or to the
> > > key management code (that would be called from all three targets).
> > > 
> > 
> > Yes that is the issue I described in the cover letters. But I don't
> > actually know which way is the preferred one. Afaik there are now
> > three options:
> > 
> > 1. static inline helpers in a drivers/md header, so dm-crypt and
> >    dm-integrity each compile their own copy
> > 2. a small library module, similar to dm-bufio, so there is one copy
> >    that follows the value (y/m) of dm-crypt and dm-integrity
> > 3. integration into key management code
> > 
> > Please tell me which option you prefer.
> 
> Try 3, if not possible then 1. I think that introducing a module with this 
> would be overkill.
> 
> The "if (!strncmp(key_string, "logon:", key_desc - key_string + 1)) {" 
> lines are duplicated as well, so I would refactor them and move them to 
> the helper too.
> 
> I don't know why dm-inlinecrypt only uses the "logon:" key while dm-crypt 
> uses "user:", "encrypted:", "trusted:" as well (Eric - could you 
> explain?). So, perhaps, dm-inlinecrypt could be extended to use all four 
> key types as well.

The keyring support didn't exist in my version of the dm-inlinecrypt
patch.  It seems to have been requested by Milan here:
https://lore.kernel.org/dm-devel/682506ea-c9c2-458b-8123-8d78fc53cc7f@gmail.com/
then added by Linlin.

From what I understand, the point of the keyring support in
dm-{crypt,inlinecrypt,integrity} is:

- To support "trusted" keys.  But that is not what was actually
  implemented in dm-inlinecrypt.

- To avoid having the key be readable with STATUSTYPE_TABLE.  But that
  is not what was actually implemented in dm-inlinecrypt.  Keyrings are
  also unnecesary to solve that problem.

- To cause security bugs such as https://lwn.net/Articles/1090568/ .
  Since otherwise things aren't exciting enough, I guess.

Not sure what I'm missing.

But if you really do want to support all four key types in all three of
these targets anyway though, then sure, the code might as well be
shared since it would otherwise be the same code in each.

- Eric
