From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH V1 Resend 04/11] drivers: md: Drop unlikely before
 IS_ERR(_OR_NULL)
Date: Tue, 11 Aug 2015 07:12:04 +0530
Message-ID: <20150811014203.GF5766@linux>
References: <cover.1439187003.git.viresh.kumar@linaro.org>
 <f5979681afc5c1f30a2b5a0b61507580133bad04.1439187003.git.viresh.kumar@linaro.org>
 <20150810200503.GA24638@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150810200503.GA24638@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: akpm@linux-foundation.org, linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 10-08-15, 16:05, Mike Snitzer wrote:
> On Mon, Aug 10 2015 at  2:12am -0400,
> Viresh Kumar <viresh.kumar@linaro.org> wrote:
> 
> > IS_ERR(_OR_NULL) already contain an 'unlikely' compiler flag and there
> > is no need to do that again from its callers. Drop it.
> > 
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> I picked this up for 4.3, staged in linux-dm.git's 'for-next', see:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=e2545d97b6cc0556fbd1099fca9271e3ca1d0b01

I had no clue about it as I didn't look at individual maintainer's
tree. But rebased things over linux-next/master.

Why isn't your branch merged into linux-next ?

-- 
viresh
