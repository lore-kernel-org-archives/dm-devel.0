From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 0/0] dm-mpath: queue-length oriented dynamic
	load balancer
Date: Thu, 29 Jan 2009 14:03:35 +0000
Message-ID: <20090129140335.GA27390@agk-dp.fab.redhat.com>
References: <498153BE.60104@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <498153BE.60104@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com, stefan.bader@canonical.com
List-Id: dm-devel.ids

On Thu, Jan 29, 2009 at 03:59:10PM +0900, Kiyoshi Ueda wrote:
> This patch-set can be applied on top of 2.6.29-rc2.

It's not clear: are you reordering the dependencies now?

Previously there were three sets of patches taken in this order:
  1 change to request-based
  2 add queue length ps
  3 add service time ps
i.e. 2 and 3 depend on 1

Are you now changing that so that 2 and 3 could go upstream before 1?

Alasdair
