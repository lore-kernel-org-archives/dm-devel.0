Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2B979D0
	for <dm-devel@lists.linux.dev>; Wed, 23 Apr 2025 00:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745369202; cv=none; b=FR7CIVItB1diDT+xwQoKuKCW03qk/I8EKc9sGyiwfSoy4MUJgWgqgEAMeZhrBwZATtov8kipL97vh5BmUe3LVfExdKeA+1lbeDN942EfO6QU6xGeXYXPA5vq19BsMQg38PhaPExB99mUqSWL60lBsspK/rQM63M6L4p+48uhpFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745369202; c=relaxed/simple;
	bh=i5zSXdtUmz/TjJ0Rz5QPbIof7aA8XXlWzFW9Ekc7lUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WPq28Xlux+pda12FL7t7zYClCknxJkpouA5iU9xhg5mxNlQpHKjq5m3+LY9JWOvWxSXg1mDM1GDfbagQbb+BSPVVWh1Io+6J1L/aL6bS9ecsrdGjODLIg6/xptTGzWX22NsVhXd4IMvLVoZnZPIBab8JwRDs0uw7ReAJtcoO60g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X80ndWST; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X80ndWST"
Date: Tue, 22 Apr 2025 20:46:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745369198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CWy84PJHS5kNx0RNxrl0rTlAk3+kKc/MD63AvKNXtUY=;
	b=X80ndWSTArk5KEO1TsCAwPQxrslSHy/k98vGDFliBW58EQ7r/Yyj/fU6KOBfzztlSIkM3R
	oMuvymOeAmIGwnNB4cWxif4Qy+aPQnhpxIp1hdq4lKQJCzEmz5DWuzYtF38G1D5bFyU5L4
	zMqflFVj6Hq97hkplclEluCBXgxmUGw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, 
	Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH 0/4] dm-flakey fixes
Message-ID: <ethruuoyqppc5gh54eowhvlzrkjd4pmvoe2gkljvyyqrmqmunu@g2jaur22cf6b>
References: <20250422234738.1654052-1-bmarzins@redhat.com>
 <gdw3hv5qnvnrusmh6lt3kfrqlwsmf7o7azdx2sfwlebbqsecla@djyd6a7f3ag2>
 <aAgxGBw7ytEOifIY@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAgxGBw7ytEOifIY@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 22, 2025 at 08:15:20PM -0400, Benjamin Marzinski wrote:
> On Tue, Apr 22, 2025 at 08:02:54PM -0400, Kent Overstreet wrote:
> > On Tue, Apr 22, 2025 at 07:47:34PM -0400, Benjamin Marzinski wrote:
> > > This patchset handles some dm-flakey issues reported by Kent Overstreet.
> > > It fixes some issues with dm-flakey's parsing and feature interactions
> > > and makes corrupting read bios work.
> > > 
> > > Benjamin Marzinski (4):
> > >   dm-flakey: Clean up parsing messages
> > >   dm-flakey: error all IOs when num_features is absent
> > >   dm-flakey: remove useless ERROR_READS check in flakey_end_io
> > >   dm-flakey: make corrupting read bios work
> > > 
> > >  drivers/md/dm-flakey.c | 114 ++++++++++++++++++++++-------------------
> > >  1 file changed, 62 insertions(+), 52 deletions(-)
> > 
> > Does it have tests now?
> 
> I tested it. Adding automated tests for it is a work in progress.

If I get done with my other things tonight I can write you a ktest test
for it, if you'd like. It's what I use for testing bcachefs, shouldn't
take too long...
