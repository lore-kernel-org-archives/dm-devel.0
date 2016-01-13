From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [LSF/MM ATTEND] plan to deprecate old
	.request_fn	request-based code path?
Date: Wed, 13 Jan 2016 11:02:40 +0000
Message-ID: <20160113110240.GB452@agk-dp.fab.redhat.com>
References: <20160112185947.GA29176@redhat.com>
	<alpine.LRH.2.02.1601121835590.29321@file01.intranet.prod.int.rdu2.redhat.com>
	<56960904.5060006@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56960904.5060006@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: linux-block@vger.kernel.org, Junichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>, lsf-pc@lists.linux-foundation.org, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Wed, Jan 13, 2016 at 09:21:24AM +0100, Hannes Reinecke wrote:
> We have been down that road already. It doesn't work.
> There is a reason why we switched to request-based multipathing.

It's worth reminding people of the original write-up explaining this
switch:

  https://www.kernel.org/doc/ols/2007/ols2007v2-pages-235-244.pdf

(and that since that was written, there have been plenty of changes,
both to the request-based code itself and the bio-based path which Kent
streamlined).

Alasdair
