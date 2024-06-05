Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F33218F2C1;
	Wed,  5 Jun 2024 07:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717573908; cv=none; b=ZGbSQMQjwnD3D/k8KyXlaejTtwZte2Bmq6xl4XOXJoeCRmc9Gt8OXcbg0fO2wOAYjMRGH3GCGy0jYopL3EMYu1GVqIh7+WAEC4JkGXDhjAToi9bA12St0+nZbM8xWJuMGa8OmBsSzC+5CtejztYPFr1if+4+OtvDMCX+FtMkqz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717573908; c=relaxed/simple;
	bh=jV6l/P6zCV6JbpSpn+l4qDidPcLYWrZhNbtmcZ6dNcI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mutuaOLpDumEJxZ6NRpGtNd3E8d6uT9PCJ+sGCc21Rs1e1sDLYMAquXeOToGEP0XHk4wYF6S5oKAD1j3sqwaoDppdI06I+JXkuSNjwRopM3iQr0VKUnjSc0tc5HgNp6C2rkNMU3Trim23fGT97418xvxflx3kxZuf/mNpO6u3Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VmNAX0UP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VmNAX0UP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCEBC3277B;
	Wed,  5 Jun 2024 07:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717573907;
	bh=jV6l/P6zCV6JbpSpn+l4qDidPcLYWrZhNbtmcZ6dNcI=;
	h=From:To:Cc:Subject:Date:From;
	b=VmNAX0UPqQeBm2ifuTk9sUMICX2t1YIuRa3IG002Cyo0CgJ0ag7KfZLjA2hIXrnPn
	 j4fXb5XEsM90FCFNebgtriOMkEqMCTEEe5b+rVBgR8Vf2i0u9Pb1qStAw7XuHSFrvz
	 kfA4Cb2x08YfZrJeWeOtizkFhTs+iOzMXx3uv9TT+v/WNFEnqx4L3zbuYKtv1q8GMP
	 A5WLw/M7kffOcyslxy+EnU2S3zHHRpLXHF0KY2WzJQ9eNRa4eZ6NosIbWbTJzgkrTw
	 PrvszlFhvWB+3Zohgy3skucM6gan98OMg7i6WmtfB/BQqw6+9X+Vtf2ciqY38EDqGa
	 BI2/vF6C5eB/A==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v4 0/3] Fix DM zone resource limits stacking
Date: Wed,  5 Jun 2024 16:51:41 +0900
Message-ID: <20240605075144.153141-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the updated patch 4/4 of the series "Zone write plugging and DM
zone fixes". This patch fixes DM zone resource limits stacking (max open
zones and max active zones limits). Patch 1 is new and is added to help
catch problems and eventual regressions of the handling of these limits.

Changes from v3:
 - Modify patch 1 to always check the zone resource limits values in
   disk_update_zone_resources(), including for DM devices that do not
   use zone write plugging. Simplify patch 2 accordingly by removing the
   same check and adjustment of the zone resource limits.
 - Added patch 3

Changes from v2:
 - Modify patch 1 to return an error for the case where the max open
   zones limit is greater than the max active zones limit.
 - Modify patch 2 to avoid duplicated actions on the limits and to
   remove warnings for unusual zone limits.

Changes from v1:
 - Added patch 1
 - Modified patch 2 to not cap the limits for a target with the number
   of sequential zones mapped but rather to use the device limits as is
   when more zones than the limits are mapped and 0 otherwise (no
   limits).

Damien Le Moal (3):
  block: Improve checks on zone resource limits
  dm: Improve zone resource limits handling
  dm: Remove unused macro DM_ZONE_INVALID_WP_OFST

 block/blk-settings.c |   8 ++
 block/blk-zoned.c    |  20 ++++-
 drivers/md/dm-zone.c | 206 +++++++++++++++++++++++++++++++++++--------
 3 files changed, 191 insertions(+), 43 deletions(-)

-- 
2.45.1

