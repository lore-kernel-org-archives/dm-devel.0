From: Eric Wheeler <lvm-dev@lists.ewheeler.net>
Subject: Re: dm thin: optimize away writing all zeroes to
 unprovisioned blocks
Date: Sat, 6 Dec 2014 14:33:19 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1412061431300.19773@ware.dreamhost.com>
References: <alpine.DEB.2.00.1409301121470.26721@ware.dreamhost.com>
	<alpine.DEB.2.02.1412032237010.12556@ware.dreamhost.com>
	<alpine.DEB.2.02.1412032318290.29609@ware.dreamhost.com>
	<20141204153358.GA19315@redhat.com>
	<20141204154324.GB19315@redhat.com>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <lvm-devel-bounces@redhat.com>
In-Reply-To: <20141204154324.GB19315@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
To: LVM2 development <lvm-devel@redhat.com>
Cc: axboe@kernel.dk, dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

> Actually, given your: count = bv.bv_len / sizeof(uint64_t);
>
> My immediate concern was it would've truncated any partial contents of
> the bio_vec beyond the last uint64_t boundary.  Leading to possible
> false positive return from the function (because some contents weren't
> checked).

Understood.  I had always thought bio data was block-size aligned.

Out of curiosity, do you have examples of when this is not so?

>
> --
> lvm-devel mailing list
> lvm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/lvm-devel
>

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
