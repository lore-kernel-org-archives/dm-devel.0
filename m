Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D31A1C5D62
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 13:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747056654; cv=none; b=uQnuE3sIF/8x+aoHKQUWoLfH5BDB91FW9lOC7oBtwEjLnFBPbl8JSQIVRr0u+ieZt0uT5ro3aU3wf/eEPYvza1BBa4kGAksFvSW0oo0JiKeFL/uFqFLerRBGwO5swbB0U8hnYE+jnq6UvLqf+lUWAW9vxYqOfvEX1DgT+gAlFUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747056654; c=relaxed/simple;
	bh=1Vra5uDKnQOawKBWrA2ix6luojaBU+U0FdS2qVrfcW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o+LqgZpxMwOsBB+6DhbIpyhWta0Iz1K2/UBlggMb6WwVfNJEITrrLDbpkiBDRMN62TpZ8BM5DU36TMqLnkYrcOOABtQL+wEXcz09KuTqZ8nwLHyBbfCFyKN2oShBoBr5740da4OVr16LjH/EJ+gW2yC46lGxW0VfK9V87s6Rl/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 537AF68B05; Mon, 12 May 2025 15:30:48 +0200 (CEST)
Date: Mon, 12 May 2025 15:30:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@lst.de>, xni@redhat.com, colyli@kernel.org,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	song@kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH RFC md-6.16 v3 15/19] md/md-llbitmap: implement APIs to
 dirty bits and clear bits
Message-ID: <20250512133048.GA32562@lst.de>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com> <20250512011927.2809400-16-yukuai1@huaweicloud.com> <20250512051722.GA1667@lst.de> <0de7efeb-6d4a-2fa5-ed14-e2c0bec0257b@huaweicloud.com> <20250512132641.GC31781@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512132641.GC31781@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 12, 2025 at 03:26:41PM +0200, Christoph Hellwig wrote:
> > 1) bitmap bio must be done before this bio can be issued;
> > 2) bitmap bio will be added to current->bio_list, and wait for this bio
> > to be issued;
> >
> > Do you have a better sulution to this problem?
> 
> A bew block layer API that bypasses bio_list maybe?  I.e. export
> __submit_bio with a better name and a kerneldoc detailing the narrow
> use case.

That won't work as we'd miss a lot of checks, cgroup handling, etc.

But maybe a flag to skip the recursion avoidance?

