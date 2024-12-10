Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848901A0711;
	Tue, 10 Dec 2024 16:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733847180; cv=none; b=i6dMKfwtux5H5AJ/S/AFQkr49FD66jhlHMe4dXSyJE/MAvwYZRVXwwxVi4VWZmXZV/B7eM/vN5Xltq1XmpMWbO7RFBw6sOJn6B2YAEOImHaKz9SS7q2OWU6vdDL+VlmEcq++mgA+Nf/okDz9lE4wLXcI0rR7PyMqWvLr+CL3CZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733847180; c=relaxed/simple;
	bh=BWiMLCg3QCfswfh6mo16EAszQa+YcITPWKUgOMEfI94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oWNtHOHFu0cJRkvl43wC0+3vdq4UyOqyS1n+eo9mEBjAIQUfinv4/BT8Ns5UXi4NNhwcdui87OGhFPvNkfl8aJ6la9OzzvSXBZDnncEr9uM+qb7J6vRZ5OX+TlBhqTZ1+l55LI73hwThYBvyltMHdYw1QKTdWDxnc0HftMFTM6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GjiQJXnd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GjiQJXnd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9964C4CED6;
	Tue, 10 Dec 2024 16:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733847180;
	bh=BWiMLCg3QCfswfh6mo16EAszQa+YcITPWKUgOMEfI94=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GjiQJXndJXOXrLzJ5Iox0uG/ANrKNFFp6VEPp0pruZfpcu9WFPzG1/VARmNUJIfrJ
	 Ptrzn2ArQHr1YusyzlCD6YK8HOdJp787I3IW9vG/bGpEl4ppMTiglUefr6c4F3Q/Ig
	 ZdqaKK/HJLLxcOTiqFmZctyiWBuzNdEwuz5Let1R0ZlgCkdKKUue1IQB2s0vwjmY1o
	 B+4jt7oqxEUkg9F3qT2FBPuHE6oVj3fT2ZmjUHPthwIcTHld73n9jKCz6yhGhRZ24F
	 fQCc1dHQSbuvEV4LDJHqy1hY1Wz/2xsthhSkRyKEajT1DGV45o7B1nMmWABU2Ofp73
	 8jLd+0N5UR7Dg==
Date: Tue, 10 Dec 2024 11:12:58 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 3/4] dm: Fix dm-zoned-reclaim zone write pointer
 alignment
Message-ID: <Z1hoipf4L1CFc6E7@kernel.org>
References: <20241209122357.47838-1-dlemoal@kernel.org>
 <20241209122357.47838-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209122357.47838-4-dlemoal@kernel.org>

On Mon, Dec 09, 2024 at 09:23:56PM +0900, Damien Le Moal wrote:
> The zone reclaim processing of the dm-zoned device mapper uses
> blkdev_issue_zeroout() to align the write pointer of a zone being used
> for reclaiming another zone, to write the valid data blocks from the
> zone being reclaimed at the same position relative to the zone start in
> the reclaim target zone.
> 
> The first call to blkdev_issue_zeroout() will try to use hardware
> offload using a REQ_OP_WRITE_ZEROES operation if the device reports a
> non-zero max_write_zeroes_sectors queue limit. If this operation fails
> because of the lack of hardware support, blkdev_issue_zeroout() falls
> back to using a regular write operation with the zero-page as buffer.
> Currently, such REQ_OP_WRITE_ZEROES failure is automatically handled by
> the block layer zone write plugging code which will execute a report
> zones operation to ensure that the write pointer of the target zone of
> the failed operation has not changed and to "rewind" the zone write
> pointer offset of the target zone as it was advanced when the write zero
> operation was submitted. So the REQ_OP_WRITE_ZEROES failure does not
> cause any issue and blkdev_issue_zeroout() works as expected.
> 
> However, since the automatic recovery of zone write pointers by the zone
> write plugging code can potentially cause deadlocks with queue freeze
> operations, a different recovery must be implemented in preparation for
> the removal of zone write plugging report zones based recovery.
> 
> Do this by introducing the new function blk_zone_issue_zeroout(). This
> function first calls blkdev_issue_zeroout() with the flag
> BLKDEV_ZERO_NOFALLBACK to intercept failures on the first execution
> which attempt to use the device hardware offload with the
> REQ_OP_WRITE_ZEROES operation. If this attempt fails, a report zone
> operation is issued to restore the zone write pointer offset of the
> target zone to the correct position and blkdev_issue_zeroout() is called
> again without the BLKDEV_ZERO_NOFALLBACK flag. The report zones
> operation performing this recovery is implemented using the helper
> function disk_zone_sync_wp_offset() which calls the gendisk report_zones
> file operation with the callback disk_report_zones_cb(). This callback
> updates the target write pointer offset of the target zone using the new
> function disk_zone_wplug_sync_wp_offset().
> 
> dmz_reclaim_align_wp() is modified to change its call to
> blkdev_issue_zeroout() to a call to blk_zone_issue_zeroout() without any
> other change needed as the two functions are functionnally equivalent.
> 
> Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Acked-by: Mike Snitzer <snitzer@kernel.org>
