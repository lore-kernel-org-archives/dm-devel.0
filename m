From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm snapshot: don't use zero chunksize
Date: Thu, 8 Oct 2009 00:36:31 +0100
Message-ID: <20091007233631.GK3054@agk-dp.fab.redhat.com>
References: <20090930144110.GA16605@redhat.com>
	<20091002222716.GA5351@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.0910061859230.20258@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0910061859230.20258@hs20-bc2-1.build.redhat.com>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 06, 2009 at 07:01:37PM -0400, Mikulas Patocka wrote:
> Under some special conditions (too big chunk size or zero-sized device),
> the resulting hash_size is calculated as zero.
> 
> rounddown_pow_of_two(0) is undefined operation (it expands to shift by -1).
> And init_exception_table with zero argument would fail with -ENOMEM.
> 
> This patch makes minimum chunk size 64, just like for pending exception table.
 
Could we have some more specific information in this patch header?

How does a "too big" chunk size happen?  And what is "too big"?

How does a zero-sized device happen and how can this code do anything
sensible if it encounters one - shouldn't it fail with an error instead?
Or do we still have a problem with the sequence in which dm ioctls are being
issued?

Alasdairs
