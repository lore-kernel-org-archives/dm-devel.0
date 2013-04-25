From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH -next] dm snapshot: fix error return code in
	snapshot_ctr()
Date: Thu, 25 Apr 2013 21:28:57 +0100
Message-ID: <20130425202857.GC23535@agk-dp.fab.redhat.com>
References: <CAPgLHd-ZjORYMQ9DSa_CBRipu8NnpOkpsqyswk8FG8cdi98dHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPgLHd-ZjORYMQ9DSa_CBRipu8NnpOkpsqyswk8FG8cdi98dHQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: agk@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org, yongjun_wei@trendmicro.com.cn, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Apr 19, 2013 at 09:26:07AM +0800, Wei Yongjun wrote:
> Fix to return -ENOMEM in create slab pool error case
> instead of 0, as done elsewhere in this function.

Queued - thanks.

Alasdair

