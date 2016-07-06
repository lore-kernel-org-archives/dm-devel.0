From: Minfei Huang <mnghuan@gmail.com>
Subject: Re: [PATCH RESENT] dm: Check kthread_run's return value
Date: Wed, 6 Jul 2016 21:27:55 +0800
Message-ID: <20160706132755.GA1712@MinfeideMacBook-Pro.local>
References: <1467645927-4143-1-git-send-email-mnghuan@gmail.com>
 <20160706131601.GA28379@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160706131601.GA28379@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: agk@redhat.com, shli@kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 07/06/16 at 09:16P, Mike Snitzer wrote:
> On Mon, Jul 04 2016 at 11:25am -0400,
> Minfei Huang <mnghuan@gmail.com> wrote:
> 
> > kthread function is used to process kthread_work. And there is no return
> > value checking during create this thread. Add this checking to fix this
> > issue.
> > 
> > Signed-off-by: Minfei Huang <mnghuan@gmail.com>
> This needed rebasing against linux-dm.git's 'for-next'.  I've now staged
> this fix for 4.8 inclusion, see:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=7193a9defcab6f3d3f1eb64c68bad7534e5a39ad

Seems that we should fix it in stable as well.

Thanks
Minfei
