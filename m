Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102C87346F
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 08:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718094696; cv=none; b=DJEpQNOwQP1AocvkWbLSrhdYEh5tX0mYPtD66IsUj5PAHxZ0LpdHkUWGaZZX3vmtHI4PcbtQYPWPaeGkGcCZ2t0OFlqixQELxsK5lMMYCipd8AE1uFar1uQ+ZBIETnooPFA+nDeGijl7NdDFvKTfomciMp57EltyOZVN9VNnjag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718094696; c=relaxed/simple;
	bh=wpXcbORh+1wj0dP3PDcCLU455xdM3PvTHmev7n0Dpi4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J+vfJ35ebCPEtg8HEOLawSSLtAO8toJc0UrvKNnIVw6MmJStH7wM8TR1KvTN32EHtGZiHqmRg4wThP4Np9bZkMTSWHbQJeHWQLnBDZxPVgD8G1i2JLYzrZC0egdT3Fv3a5J5abqxpIYAIhHMf58XO6KvmuMx40WDS07yTAEwGZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nXPvm9Jb; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nXPvm9Jb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718094696; x=1749630696;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wpXcbORh+1wj0dP3PDcCLU455xdM3PvTHmev7n0Dpi4=;
  b=nXPvm9JbkXrJKwBhp0lFnZ1Vv5zIp6SPMxLF7SvpbBdeVlE43V/D7X46
   mQkWqaQqgh6mI0IPzZWA5svJmC7GTOMN2heIWyCjVKSo7e9xOpR24bcgn
   jkaJmuFFvHeYcovBhN8F1nLo8SZ+o9f5djU68fU+6Vau/5E0qN/FfSJpK
   pkHhsaclGC2Qzs0DwY16GA6UG/0c70RYEtCB1H8U3BFz710NmeUxw5WfB
   0Xl/Puic9TCtEje9x8YG2gjBGcZ2ciOnoYpJrVqa3dm1EvwoJgJ8Ll7sN
   p9cGV93rhvowb01+CBZy4/S8Kgrl6Nt6JLGUkjIlVXN3LlUSfWaqzCzpt
   A==;
X-CSE-ConnectionGUID: p3m4ozDFTcChuAGjDhtJYw==
X-CSE-MsgGUID: 70eRWIU8QZ2ix9ywucAnTA==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="25369292"
X-IronPort-AV: E=Sophos;i="6.08,229,1712646000"; 
   d="scan'208";a="25369292"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 01:31:35 -0700
X-CSE-ConnectionGUID: 21/u/m45QGalCO9X+iVVNA==
X-CSE-MsgGUID: d/bcU8KTS0il3nu5lHAZpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,229,1712646000"; 
   d="scan'208";a="39426247"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.38.248])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 01:31:31 -0700
Date: Tue, 11 Jun 2024 10:31:26 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai3@huawei.com>
Cc: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
 <song@kernel.org>, <xni@redhat.com>, <l@damenly.org>,
 <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <linux-raid@vger.kernel.org>, <yukuai1@huaweicloud.com>,
 <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: Re: [PATCH 02/12] md: add a new enum type sync_action
Message-ID: <20240611103126.00003ee0@linux.intel.com>
In-Reply-To: <20240603125815.2199072-3-yukuai3@huawei.com>
References: <20240603125815.2199072-1-yukuai3@huawei.com>
	<20240603125815.2199072-3-yukuai3@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 3 Jun 2024 20:58:05 +0800
Yu Kuai <yukuai3@huawei.com> wrote:

> In order to make code related to sync_thread cleaner in following
> patches, also add detail comment about each sync action. And also
> prepare to remove the related recovery_flags in the fulture.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.h | 57 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 56 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 170412a65b63..6b9d9246f260 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -34,6 +34,61 @@
>   */
>  #define	MD_FAILFAST	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT)
>  
> +/* Status of sync thread. */
> +enum sync_action {
> +	/*
> +	 * Represent by MD_RECOVERY_SYNC, start when:
> +	 * 1) after assemble, sync data from first rdev to other copies, this
> +	 * must be done first before other sync actions and will only execute
> +	 * once;
> +	 * 2) resize the array(notice that this is not reshape), sync data
> for
> +	 * the new range;
> +	 */
> +	ACTION_RESYNC,
> +	/*
> +	 * Represent by MD_RECOVERY_RECOVER, start when:
> +	 * 1) for new replacement, sync data based on the replace rdev or
> +	 * available copies from other rdev;
> +	 * 2) for new member disk while the array is degraded, sync data from
> +	 * other rdev;
> +	 * 3) reassemble after power failure or re-add a hot removed rdev,
> sync
> +	 * data from first rdev to other copies based on bitmap;
> +	 */
> +	ACTION_RECOVER,
> +	/*
> +	 * Represent by MD_RECOVERY_SYNC | MD_RECOVERY_REQUESTED |
> +	 * MD_RECOVERY_CHECK, start when user echo "check" to sysfs api
> +	 * sync_action, used to check if data copies from differenct rdev are
> +	 * the same. The number of mismatch sectors will be exported to user
> +	 * by sysfs api mismatch_cnt;
> +	 */
> +	ACTION_CHECK,
> +	/*
> +	 * Represent by MD_RECOVERY_SYNC | MD_RECOVERY_REQUESTED, start when
> +	 * user echo "repair" to sysfs api sync_action, usually paired with
> +	 * ACTION_CHECK, used to force syncing data once user found that
> there
> +	 * are inconsistent data,
> +	 */
> +	ACTION_REPAIR,
> +	/*
> +	 * Represent by MD_RECOVERY_RESHAPE, start when new member disk is
> added
> +	 * to the conf, notice that this is different from spares or
> +	 * replacement;
> +	 */
> +	ACTION_RESHAPE,
> +	/*
> +	 * Represent by MD_RECOVERY_FROZEN, can be set by sysfs api
> sync_action
> +	 * or internal usage like setting the array read-only, will forbid
> above
> +	 * actions.
> +	 */
> +	ACTION_FROZEN,
> +	/*
> +	 * All above actions don't match.
> +	 */
> +	ACTION_IDLE,
> +	NR_SYNC_ACTIONS,
> +};

I like if counter is keep in same style as rest enum values, like ACTION_COUNT.

Anyway LGTM.

Mariusz
