From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [patch 0/2] [V4] block: Support online resize of disk partitions
Date: Tue, 10 Jul 2012 10:20:01 -0400
Message-ID: <20120710142001.GF14884@redhat.com>
References: <20120709213418.799759100@redhat.com>
 <4FFB5DC3.30803@ubuntu.com>
 <20120710135759.GE14884@redhat.com>
 <4FFC387F.3070308@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FFC387F.3070308@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com, kzak@redhat.com, maxim.patlasov@gmail.com
List-Id: dm-devel.ids

On Tue, Jul 10, 2012 at 10:13:19AM -0400, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 7/10/2012 9:57 AM, Vivek Goyal wrote:
> > +static inline sector_t part_nr_sects_read(struct hd_struct *part) 
> > +{ +#if BITS_PER_LONG==32 && defined(CONFIG_LBDAF) &&
> > defined(CONFIG_SMP) +	sector_t nr_sects; +	unsigned seq; +	do { +
> > seq = read_seqcount_begin(&part->nr_sects_seq); +		nr_sects =
> > part->nr_sects; +	} while (read_seqcount_retry(&part->nr_sects_seq,
> > seq)); +	return nr_sects; +#elif BITS_PER_LONG==32 &&
> > defined(CONFIG_PREEMPT)
> 
> Shouldn't this be BITS_PER_LONG==32 && defined(CONFIG_LBDAF) &&
> defined(CONFIG_PREEMPT)?  No sense disabling preemption when the
> sector size is also 32 bits.

Yes. Good catch. We don't want to disable/enable preemption for 32bit UP 
kernels with sector size 32bit. I will modify the patch and repost soon.

BTW, what happened to all the new lines in the code above. Looks like you
mailer chewed these up.

Thanks
Vivek
