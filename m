Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF35F348896;
	Tue, 13 Oct 2026 12:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895687; cv=none; b=gKeV/M/b8kqiHoLx5UBUYub1qxec1iV5UGx3y5gtMM51pzg6WvFcsOyEEMx5TfTDxnPo2Q+5kivtD/8vI5ond+fPZrWRw9aS3IqsJZMvFTDrptFvr3c8AA8newLSqnU6VT6O4LLJC/+TQYSj1B/oqpr43Jmsj0Sqki6zYbygeDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895687; c=relaxed/simple;
	bh=6g6V5Ylz+MVa5h8IorcJzL4TruTiB2QfnwmF6ETD944=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uTM76Yke0K3wOWId997OhQdf4T3ry/0+6lKmACC7qxQ9IbKBpVWIVFBOFmIH8DNW6JlgLV5YcOI2nqyx31MPu4Wx/eS+8QtFPhmaKAyDZQNmg1gApsxJLCdCRvcv+CZWQdSpqsFAFyLmRclhnl1DM3kTu5EVBAuFDvQsulZa3YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=be5rZvUE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="be5rZvUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380581F00893;
	Tue, 13 Oct 2026 12:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791895685;
	bh=iphwhhyVmTgouW/mFzqMgUmbhd36kmOdAWGZq+1Ui4U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=be5rZvUEmN8zfFsAucLpShyYA2UiBs07SliETuK0i0jbRmaaRnnEtMOcK5HW9q2pR
	 kI07NvBCIV/oJKUEA0XdrdbctnU1nUjId76xWrveDw0RSHc3tqY0gzCHmtxpI2AJ8/
	 th9KJkNWEb998b0+xNjus5uoMHCJmUK5QUQ0JLR9EkxEgN4HjISK9w0Pwoj7YQICNB
	 iUF+/TCGzzNOAnEEg0VBmOGf8LnH/9KKKe+sOx+rWqE2SzwZrwl0wmhoPT14puss8H
	 oOZ6X9iiPyqROZTF4+qJRUa4eWgu33szPYs8fUBcn6u4GAgT5yviGZimDI1sq2wcXm
	 3jYLjnIIMu3wg==
Message-ID: <9b516b68-de11-479a-abfb-ec11b31fda5f@kernel.org>
Date: Tue, 13 Oct 2026 14:48:02 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] dm zoned: keep polling for idle reclaim after a
 reclaim pass
To: Kyrylo Biryuk <illofspeed@gmail.com>, dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com, snitzer@kernel.org, agk@redhat.com,
 bmarzins@redhat.com, hare@suse.de, linux-kernel@vger.kernel.org
References: <20261013123940.952-1-illofspeed@gmail.com>
 <20261013123940.952-4-illofspeed@gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261013123940.952-4-illofspeed@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/13 14:39, Kyrylo Biryuk wrote:
> dmz_reclaim_work() re-arms its DMZ_IDLE_PERIOD poll only when
> dmz_should_reclaim() returns false at the start of a pass (and, with the
> first patch of this series, when a pass fails with -ENOSPC). After a pass
> it calls dmz_schedule_reclaim(), which queues the work only if reclaim
> is needed right now. When a pass ends while the target is still busy and
> has enough free zones, nothing is queued at all. Once the target goes
> idle, nothing re-evaluates dmz_should_reclaim() until another zone
> allocation, a "reclaim" message or a resume schedules the work, so the
> random or cache zones that filled up under load stay full.
> 
> Seen on md RAID5 members on 27 TB host-managed drives: after heavy
> writes the random zones stayed full for hours on idle targets; the
> workaround was a timer sending "dmsetup message <dev> 0 reclaim". With
> this patch the emptied and filled zones were reclaimed within minutes of
> the targets going idle, without the timer.
> 
> When reclaim is not needed right now, make dmz_schedule_reclaim() queue
> the idle poll, so the work stays queued after every pass. It uses
> queue_delayed_work(), which leaves already pending work alone, so the
> other callers (zone allocation and the "reclaim" message) neither
> postpone a pending poll nor delay a pending immediate reclaim.
> 
> Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
> Assisted-by: LLM
> Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
