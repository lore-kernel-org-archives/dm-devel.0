From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 2/3] block: reorganize rounding of max_discard_sectors
Date: Tue, 03 Jul 2012 13:47:31 +0200
Message-ID: <4FF2DBD3.4080800@redhat.com>
References: <1341235225-27551-1-git-send-email-pbonzini@redhat.com> <1341235225-27551-3-git-send-email-pbonzini@redhat.com> <20120703024910.GC3586@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120703024910.GC3586@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, snitzer@redhat.com, martin.petersen@oracle.com, david@fromorbit.com, xfs@oss.sgi.com, dm-devel@redhat.com, hch@lst.de
List-Id: dm-devel.ids

Il 03/07/2012 04:49, Vivek Goyal ha scritto:
>> > +	/* Zero-sector (unknown) and one-sector granularities are the same.  */
>> > +	granularity = max(q->limits.discard_granularity >> 9, 1U);
>> > +
>> >  	/*
>> >  	 * Ensure that max_discard_sectors is of the proper
>> >  	 * granularity
>> >  	 */
>> >  	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
>> > +	max_discard_sectors = round_down(max_discard_sectors, granularity);
>> >  	if (unlikely(!max_discard_sectors)) {
>> >  		/* Avoid infinite loop below. Being cautious never hurts. */
>> >  		return -EOPNOTSUPP;
>> > -	} else if (q->limits.discard_granularity) {
>> > -		unsigned int disc_sects = q->limits.discard_granularity >> 9;
>> > -
>> > -		max_discard_sectors &= ~(disc_sects - 1);
> This is kind of odd. If discard_granularity is zero, we assume that
> discards are supported and granularity is 1. But if max_discard_sectors
> is zero, we assume discards are disabled. Not sure if we should treat
> max_discard_sectors and discard_granularity in same way or not.

Yes, this keeps the same behavior as before.  It is also the one that is
consistent with drivers/scsi/sd.c.  sd_config_discard always sets
limits.discard_granularity and then uses limits.max_discard_sectors to
disable discards.

Paolo
