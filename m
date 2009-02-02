From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 12 of 12]:
	dm-snapshot-new-ctr-table-format.patch
Date: Mon, 2 Feb 2009 23:10:53 +0000
Message-ID: <20090202231052.GF20668@agk.fab.redhat.com>
References: <1232482467.19993.48.camel@hydrogen.msp.redhat.com>
	<20090203075414U.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090203075414U.fujita.tomonori@lab.ntt.co.jp>
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

On Tue, Feb 03, 2009 at 07:55:32AM +0900, FUJITA Tomonori wrote:
> BTW, how about adding something like 'compat_name' to struct
> dm_exception_store_type instead of registering two similar structures
> like the followings?
 
Not worth the bother.  You've still to record somewhere whether it's the compat
name that matched or not so the 'dmsetup table' output matches the input.

Alasdair
-- 
agk@redhat.com
