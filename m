Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1220A13A416;
	Mon, 24 Jun 2024 11:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719229616; cv=none; b=ErcX3/YpSxzuKVZL2p5xepw60tIgtLl7SvP5I0RD6dOSrn0HJFagkbJGnh1hvoXGThLmM0VWr9v5VVk3BTpPiZnHWN4/nNuCRK+JKpKaByQrPKDvlKkoxj/9LeqObFoKbbRj86VlCeMEpT+0fgeiA09FIvagWgdq0CkzKLisjKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719229616; c=relaxed/simple;
	bh=2ZaWoOvQNHDf+irIu5NpxDJRZj9JNLJ/jYU1ERqD1Ik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vj+ZgKnXV+K7Fs6n0ctzHBJIjj6YBNWqRyWLq8TPyQjXl/dNRymMiaMhlCMEAUGbMGKBVYjmWLybUl0jR1b2nJAj+Wr8jUrd8e/gxqDAe478nsFTFaEPgqgavO6B9V0yjhFFHQ8m9yJ63cv+AtHKHZ+BhTwjbYAjGtBLqW9I0PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kWlxCr3Y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kWlxCr3Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OIt4Ci1ZCHEZOBFhPpkM44ZhSr5EGwoN/jQm99RyL98=; b=kWlxCr3YSLBH1FgRGK85/8UrAj
	zTu5UJbJVNcWAHrYPonHjXFR5YzsZLm/NzAylybuNvPUtBthwFiE0ChP6gQWtt2jcBTOTiLH0VSjJ
	voZ2kHsb1Kw3oZ8qV9xCQ82muRcwqsdqnP0wDDhdeX2JXLEb8Uo3tlwWtY8Si2/10z1kJ+8mFx8HD
	eMLIQSfRuMxCIhUnxsAUhn74gIaS7qmbyaFIk+KTNqIZ/Hd36leJywwYjZM9S9jkZ6X8bVHgqEoqO
	bt2akxrZvlE7yWJassqRBK0NtbEL7h6pbbHHCHUMQvYoVievXJCLbqwRX+cfFY/c3GRc1b/59Y7yF
	ekyoqqdw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLi9u-0000000GfLz-1RnB;
	Mon, 24 Jun 2024 11:46:54 +0000
Date: Mon, 24 Jun 2024 04:46:54 -0700
From: "hch@infradead.org" <hch@infradead.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>,
	Bryan Gurney <bgurney@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Re: blktests dm/002 always fails for me
Message-ID: <ZnlcrgxYvqqy5uoK@infradead.org>
References: <ZmqrzUyLcUORPdOe@infradead.org>
 <pysa5z7udtu2rotezahzhkxjif7kc4nutl3b2f74n3qi2sp7wr@nt5morq6exph>
 <ZmvezI1KcsyE3Unl@infradead.org>
 <42ecobcsduvlqh77iavjj2p3ewdh7u4opdz4xruauz4u5ddljz@yr7ye4fq72tr>
 <Znkxn7LymUjD3Wac@infradead.org>
 <i4skne2yegneuyuw7nqt2mziuywjwo2p54emgba3fjcg5rflhe@dvqy65je7boc>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <i4skne2yegneuyuw7nqt2mziuywjwo2p54emgba3fjcg5rflhe@dvqy65je7boc>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 24, 2024 at 11:21:33AM +0000, Shinichiro Kawasaki wrote:
> I took a look in the test script and dm-dust code again, and now I think the dd
> command is expected to success. The added bad blocks have default wr_fail_cnt
> value 0, then write error should not happen for the dd command. (Bryan, if this
> understanding is wrong, please let me know.)
> 
> So the error log that Christoph observes indicates that the dd command failed,
> and this failure is unexpected. I can not think of any cause of the failure.

Yes, it does indeed fail, this is 002.full with your patch:

dd: error writing '/dev/mapper/dust1': Invalid argument
1+0 records in
0+0 records out
0 bytes copied, 0.000373943 s, 0.0 kB/s

> 
> Christoph, may I ask you to share the kernel messages during the test run?
> Also, I would like to check the dd command output. The one liner patch below
> to the blktests will create resutls/vdb/dm/002.full with the dd output.

the relevant lines of dmesg output below:

[   57.773967] run blktests dm/002 at 2024-06-24 11:43:53
[   57.791251] I/O error, dev vdb, sector 774 op 0x0:(READ) flags 0x80700 phys_seg 250 prio class 0
[   57.791849] I/O error, dev vdb, sector 520 op 0x0:(READ) flags 0x84700 phys_seg 254 prio class 0
[   57.792420] I/O error, dev vdb, sector 520 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[   57.792805] I/O error, dev vdb, sector 521 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[   57.793190] I/O error, dev vdb, sector 522 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[   57.793578] I/O error, dev vdb, sector 523 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[   57.793955] I/O error, dev vdb, sector 524 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[   57.794318] I/O error, dev vdb, sector 525 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[   57.794700] I/O error, dev vdb, sector 526 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[   57.795130] I/O error, dev vdb, sector 527 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[   57.795516] Buffer I/O error on dev dm-0, logical block 65, async page read
[   57.800743] device-mapper: dust: dust_add_block: badblock added at block 60 with write fail count 0
[   57.802587] device-mapper: dust: dust_add_block: badblock added at block 67 with write fail count 0
[   57.804359] device-mapper: dust: dust_add_block: badblock added at block 72 with write fail count 0
[   57.811253] device-mapper: dust: dust_add_block: badblock added at block 60 with write fail count 0
[   57.813065] device-mapper: dust: dust_add_block: badblock added at block 67 with write fail count 0
[   57.814786] device-mapper: dust: dust_add_block: badblock added at block 72 with write fail count 0
[   57.818023] device-mapper: dust: enabling read failures on bad sectors
[   57.826500] Buffer I/O error on dev dm-0, logical block 8, async page read
