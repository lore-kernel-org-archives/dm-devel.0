From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH 0/0] dm-mpath: queue-length oriented
	dynamic load balancer
Date: Fri, 30 Jan 2009 13:08:35 +0000
Message-ID: <20090130130835.GI1935@agk.fab.redhat.com>
References: <498153BE.60104@ct.jp.nec.com>
	<20090129140335.GA27390@agk-dp.fab.redhat.com>
	<4982B5FE.5040807@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4982B5FE.5040807@ct.jp.nec.com>
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

On Fri, Jan 30, 2009 at 05:10:38PM +0900, Kiyoshi Ueda wrote:
> On 01/29/2009 11:03 PM +0900, Alasdair G Kergon wrote:
> >   1 change to request-based
> >   2 add queue length ps
> >   3 add service time ps
> > i.e. 2 and 3 depend on 1

> 2 and 3 are simpler patches than 1, and I found some problems in 1,

OK - so let's go for 2 then 3 then 1.

Alasdair
-- 
agk@redhat.com
