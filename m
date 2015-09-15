From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH] dm: ioctl: prevent double freeing
Date: Tue, 15 Sep 2015 13:23:37 +0530
Message-ID: <20150915075337.GD9305@sudip-pc>
References: <1441365759-7247-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1441365759-7247-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Sep 04, 2015 at 04:52:39PM +0530, Sudip Mukherjee wrote:
> DM_PARAMS_KMALLOC and DM_PARAMS_VMALLOC should never be set together in
> param_flags. We are setting these flags while allocating so we know that
> there is almost no chance of having these two set together but still we
> can have some additional safety.
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
A gentle ping.

regards
sudip
