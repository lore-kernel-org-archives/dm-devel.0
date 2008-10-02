From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 5/7] block: Find bio sector offset given idx and offset
Date: Thu, 2 Oct 2008 19:07:10 +0200
Message-ID: <20081002170709.GM19428@kernel.dk>
References: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com> <1222846723-18213-6-git-send-email-martin.petersen@oracle.com> <20081001081056.GB19428@kernel.dk> <yq163obiuoi.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755268AbYJBRHj@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq163obiuoi.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: neilb@suse.de, agk@sourceware.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 01 2008, Martin K. Petersen wrote:
> >>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:
> 
> Jens> Too may BUG's there, me thinks, and the interface looks
> Jens> fragile. What if the bio is alreday done (bi_idx == bi_vcnt)?
> 
> Good point!  Obviously I've only used the function for bio splitting
> and not at completion time.  Updated patch below.
> 
> 
> block: Find bio sector offset given idx and offset
> 
> Helper function to find the sector offset in a bio given bvec index
> and page offset.

Looks good, I've applied patches 1-5.

-- 
Jens Axboe
