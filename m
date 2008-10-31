From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [dm-devel] [PATCH] Add gfp_mask to bio_integrity_clone()
Date: Fri, 31 Oct 2008 15:17:02 +0100
Message-ID: <20081031141701.GI31673@kernel.dk>
References: <490942D4.3070504@ce.jp.nec.com> <yq1hc6s3l4g.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752396AbYJaOS0@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1hc6s3l4g.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 31 2008, Martin K. Petersen wrote:
> >>>>> "Jun'ichi" == Jun'ichi Nomura <j-nomura@ce.jp.nec.com> writes:
> 
> Jun'ichi> What do you think about adding gfp_mask parameter to
> Jun'ichi> bio_integrity_clone() like the attached patch?
> 
> Jun'ichi> It also seems natural to inherit gfp_mask from bio_clone
> Jun'ichi> when bio_integrity_clone is called from it.  Since
> Jun'ichi> bio_clone() is the only caller of bio_integrity_clone() in
> Jun'ichi> 2.6.28-rc2 and all in-tree callers of bio_clone() are using
> Jun'ichi> GFP_NOIO, the patch does nothing other than changing the
> Jun'ichi> interface.
> 
> Looks good to me.  I'll update the non-multipath DM bits accordingly.
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Shall I just include this in the 2.6.29 branch?

-- 
Jens Axboe
