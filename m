From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: [PATCH 16/22] dm: Refactor for new bio cloning/splitting
Date: Thu, 3 Oct 2013 14:45:25 -0700
Message-ID: <20131003214525.GA12183@kmo-pixel>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
 <1375912471-5106-17-git-send-email-kmo@daterainc.com>
 <20130928045909.GA19745@redhat.com>
 <20131003031738.GA27418@kmo-pixel>
 <20131003032320.GA15322@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131003032320.GA15322@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Oct 02, 2013 at 11:23:21PM -0400, Mike Snitzer wrote:
> Great, thanks for finding this, I'll test and review the code further.

Cool - let me know if you find anything else (how thoroughly do you
think you've tested it so far?)
