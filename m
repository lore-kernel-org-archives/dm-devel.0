Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794548201;
	b=V+nlyGZj3zDuyptZzgLWzQUJOYR1j8qB9UFMOdzgvWPX76gRawcIJNeRLLrDkoFh+o97
	 SzFfIGNx8oURQdJFyqH6nOghOveoNCOUn9MSjwDYsvs0Zh7nYClfbKy/albF7naekpBBp
	 /gLXNzRjRRdjqqItSVQC1Q/TJIIKwOTvNfkl+Yln3u3radIZ1phfoAtRcT15bFSNNPOGW
	 j95CpsrLYKGAKwDNZQY0p3oYMQ2zJWR9vWOJTG/azxAMWiK/zOoGcBvjcsQJoz18GRqvz
	 ZNhxrirk/UbjlJiQfz68Q0qr28kA59HcTsaen+QtysKg1PtcwoK6M3nMatQB7dD7SVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794548201;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=7iv80L9GcHiBzdrS+YiyDqm/6O/OQFrd70zOvsYzbsE=;
	b=mb5WHxo0ohm+/GtfnqOiMqdz6Jq5USY/PISezKmLUqc8zBBRiWzeqZ5LY7epfF0chjSr
	 xeQb4Psm3TOu89NbZS2wwrhpgLciA2bsH6I+zdpF7Pzzq6PAPsXMEwoGMDEpD8NFu5emT
	 ap/u4JmwqvYcQf7WBtfN7kMFy/oOVNEA+pazAFQY7uPqLcrdEq6ur1QxKPnSdbAXO3Bc8
	 enlLzjlCdkK8i92is6OTsHqLNqDjUCRS+9jCdoiL0s/Lsx2Fyrk5lCXKGYZw1pH+fQV5a
	 UoxANgAIOaM/ZcM4OsMvCswq/cjHYBwRPw7isFePduIjVlQ+ICkwsiGnqX+p817u+yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hHCstTRW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE3E606A32A
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 05:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hHCstTRW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCF71F000C4;
	Fri, 13 Nov 2026 05:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794548200;
	bh=7iv80L9GcHiBzdrS+YiyDqm/6O/OQFrd70zOvsYzbsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hHCstTRWvMQXjGxYd6Q+7s3w2xs+XzafQT1SGyI00E9D3lUEO+Gswboh0DxESoZ+p
	 pjJIMIK3PyzChQO3aeo0v9RRzjRopsTz/IFmBKMikkRPoMZGraEohvotV2qZAKnZbg
	 IobrgLEK/umrB876hXQENLYp3ez6c1VJYOUO29N4BPRvar/RzFJ05w5z2TnoGXMoWh
	 Q/6NapM5xWbgAYqe7z/O8hvvHyZ4LLxj2scUk4CqOl8QzoUoPbmC+gRLeaZMV2RRhm
	 dtQxrps5u81dddFxImjEeZxYXGpeMn0yiDGZljvoU3GTU7JQ+myD4e0QRlSLQcsr25
	 BXtss7rDnsJfg==
Date: Thu, 12 Nov 2026 21:36:39 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: =?utf-8?B?5ZGo5Lyf5rGfIChXZWlqaWFuZyBaaG91KQ==?= <weijiang.zhou@unisoc.com>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	=?utf-8?B?6YeR57qi5a6HIChIb25neXUgSmluKQ==?= <hongyu.jin@unisoc.com>,
	=?utf-8?B?5ZC056Wl56aEIChYaWFuZ2x1IFd1KQ==?= <Xianglu.Wu@unisoc.com>,
	=?utf-8?B?5ZC05ZGo6ZWcIChKdXN0aW4gV3Up?= <Justin.Wu@unisoc.com>
Subject: Re: [RFC PATCH 1/2] dm-verity: don't decode FEC into a dm_bufio page
 that is already in the cache
Message-ID: <20261113053639.GA76778@sol>
References: <8048c93b8cf24d83aa6aa536c2518201@zeshmbx08.spreadtrum.com>
 <27b2dc50d3bb497ea3f3f84e7e4b271c@zeshmbx08.spreadtrum.com>
 <5188c1e8-c08a-2a56-7e4c-1d84aba4df35@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5188c1e8-c08a-2a56-7e4c-1d84aba4df35@redhat.com>

On Tue, Nov 10, 2026 at 10:08:02PM +0100, Mikulas Patocka wrote:
> On Tue, 10 Nov 2026, 周伟江 (Weijiang Zhou) wrote:
> > Commit 51ba14fb368e ("dm-verity: do forward error correction on metadata
> > I/O errors") handles a failed hash block read by allocating the block with
> > dm_bufio_new() and decoding into it with verity_fec_decode().
> > 
> > dm_bufio_new() inserts the buffer into the v->bufio cache immediately, with
> > no B_READING state and no read_error, i.e. indistinguishable from a
> > successfully read block that merely has not been hash-verified yet. Its
> > contents are whatever the allocator returned (all zeroes with init_on_alloc),
> > and no I/O is ever submitted for it.
> 
> I don't see why this should be a problem.
> 
> If the device returns random data, FEC is supposed to correct it.
> 
> If the device returns an I/O error and we create a buffer with random 
> data, this is similar to the case where the device returned random data - 
> and FEC should also correct it. It doesn't matter whether the random data 
> came from the device or from uninitialized kernel memory.
> 
> So, it seems to me that this patch is just papering over the problem.

dm-verity does use FEC to try to recover from I/O errors, but this
doesn't mean that I/O errors and corruption are interchangeable and
handled in the same way.  See the difference at the end of
verity_handle_data_hash_mismatch(), for example.  It calls
verity_handle_err() only on actual corruption, not an I/O error.  That
triggers the corruption policy controlled by 'v->mode', which is
different from the I/O error policy controlled by 'v->error_mode'.

> > FEC then reads every other block of the RS codeword and, for blocks on the
> > data device, calls verity_hash_for_block() on them to decide whether they
> > are erasures. That walks the hash tree through the same v->bufio. If one of
> > those data blocks is covered by the hash block being recovered (or by a
> > descendant of it, when it is an upper level block), the nested
> 
> This is the real problem that should be fixed. Correcting a block 
> shouldn't depend on the content of the block being corrected.

There does seem to be a bug where when FEC is trying to read data block
hashes to correct a block, it can detect corruption in the hash tree and
be unable to correct it due to FEC being non-recursive.  That triggers
the corruption policy, when really it shouldn't and FEC should just
consider erasure information unavailable.  That is fixable.

But it is not the root cause problem here.  The root cause problem is
that the call to dm_bufio_new() injects uninitialized data into the hash
block cache as if it came from a successful read.  That turns an I/O
error into corruption, making the corruption policy take effect merely
due to an I/O error.  This is not limited to FEC reading the data block
erasures, either; any concurrent reader can trip over this corruption.

It seems that dm_bufio_new() was designed for writers that overwrite the
full block without reading any of it while also excluding concurrent
readers, e.g. using locks.  That just does not work here, unfortunately.

Using a kmalloc() buffer (this patch) kind of works but is a hack
because it doesn't actually populate the cache at all.  I think the
correct solution would be to have the FEC output initially just go into
fio->output, then populate the cache atomically with the data.  Seems
that dm-bufio.c will need a new function for that.

- Eric
