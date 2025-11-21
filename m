Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E326422D7B6
	for <dm-devel@lists.linux.dev>; Fri, 21 Nov 2025 07:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763709868; cv=none; b=Cis0iQhlOe97G0yt60obiuIluwFTggrVYUmnvK3hZK01BPk90s1sTVpG5tZEZsmJH4Dcsb+ZCatN0IiciMFbXkpbK+cSA34vRom/88BQwCobiizCMXz+aR1mqL4B3KDbHZpduUhyfrxN+0zGLu4rsNqA0tO/HxMAKHc7tWiu2no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763709868; c=relaxed/simple;
	bh=iFtbOGudU8T6pWl8mZdnTxhnChXXJ1OcRQxzpvShedw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GY41rP3ZV3iGLr+x5RARPT+6QQt0xujnrPPkTAssO4pPaijsSwXQyA0cSbsqDtsGsJ1iJQR70bakD3pHFwSJJa685tyz512XEI4QrmXlMiX4vCmnfKjEGlYGiWccNDGUcqRr3bWg3Sx43uHGXsMt1QXSxp4wi2vv6gvb5H8oQ9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 51B9B67373; Fri, 21 Nov 2025 08:24:22 +0100 (CET)
Date: Fri, 21 Nov 2025 08:24:21 +0100
From: Christoph Hellwig <hch@lst.de>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
Message-ID: <20251121072421.GA29754@lst.de>
References: <20251117105945.10179-1-urezki@gmail.com> <fff990bc-6ff9-7b34-8e80-57078de40928@redhat.com> <aRxa1wPMsJwBubjx@pc636> <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com> <aRx_lCimJco5BPKA@redhat.com> <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com> <20251119054635.GB19993@lst.de> <bcd929c2-88b0-36e9-0e22-4bb0293300b5@redhat.com> <20251120062146.GA29990@lst.de> <aR8E2ZZtOi0RZt06@pc636>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR8E2ZZtOi0RZt06@pc636>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 20, 2025 at 01:08:57PM +0100, Uladzislau Rezki wrote:
> Could you please check below? Is the last one is correctly reported?

The latter looks unexpected, but is is becase qemu is not passing through
the qemu physical_block_size attribute to any of the nvme settings Linux
interprets as such for NVMe (NVMe doesn't actually have the concept of
a physical block size, unlike SCSI/ATA):

root@testvm:~# nvme id-ns -H /dev/nvme0n1 | grep npw
npwg    : 0
npwa    : 0
root@testvm:~# nvme id-ns -H /dev/nvme0n1 | grep naw
nawun   : 0
nawupf  : 0
root@testvm:~# nvme id-ctrl -H /dev/nvme0 | grep awupf
awupf     : 0

but as said multiple times, that should not really matter - the logical
block size is the granularity of I/O, the physical block size is just
a performance hint.
