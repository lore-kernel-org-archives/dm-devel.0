From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: possible regression by the barrier patch in
	2.6.30-rc2
Date: Fri, 17 Apr 2009 14:22:52 +0100
Message-ID: <20090417132252.GA7843@agk.fab.redhat.com>
References: <49E80C1E.1040905@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <49E80C1E.1040905@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Apr 17, 2009 at 01:57:02PM +0900, Kiyoshi Ueda wrote:
> 1. The semantics of flush suspend has been changed.

We absolutely must complete any I/O issued as a result of the lock_fs()
call in dm_suspend().

Alasdair
-- 
agk@redhat.com
