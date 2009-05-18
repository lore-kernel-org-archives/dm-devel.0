From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH 3/3] dm-mpath: add service-time oriented
	dynamic load balancer
Date: Mon, 18 May 2009 12:46:07 +0100
Message-ID: <20090518114607.GA5125@agk-dp.fab.redhat.com>
References: <49F1729A.1000906@ct.jp.nec.com> <49F17362.7080205@ct.jp.nec.com>
	<20090509004959.GJ1320@agk-dp.fab.redhat.com>
	<4A0CDCE1.50409@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A0CDCE1.50409@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, May 15, 2009 at 12:09:21PM +0900, Kiyoshi Ueda wrote:
> However, if I limit the 'perf' value in smaller range (e.g. 0 to 100),
> such overflow shouldn't happen.  So I should be able to use
> multiplication.  Also, I don't need to use size_t for 'perf',
> because 'unsinged' should be enough for such small values.
 
I think a small range would be adequate - look at the number sizes and
go 0-100 or 0-1000 as appropriate.

Thinking of naming, is it 'relative_throughput' ?

However, is it also going to be possible to extend this target to measure the
the actual throughput?  If we did that, would we use a special value to 
indicate it or add a new table parameter and keep the 'perf' ones as a
manual adjustment factor applied on top of the calculated one?

Alasdair
