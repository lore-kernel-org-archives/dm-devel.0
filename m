From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] block: fix blk_stack_limits() regression due to lcm() change
Date: Mon, 30 Mar 2015 16:53:06 -0400
Message-ID: <yq1fv8mmclp.fsf@sermon.lab.mkp.net>
References: <1418158984-25546-1-git-send-email-linux@rasmusvillemoes.dk>
	<1418158984-25546-2-git-send-email-linux@rasmusvillemoes.dk>
	<CAMM=eLdw+7zfoufBEBSKhVR5d=g-a-GdzTA4WBgXUcMx=Av91A@mail.gmail.com>
	<20150330173909.GA4836@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150330173909.GA4836@redhat.com> (Mike Snitzer's message of
	"Mon, 30 Mar 2015 13:39:09 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Linux 3.19 commit 69c953c ("lib/lcm.c: lcm(n,0)=lcm(0,n) is 0, not
Mike> n") caused blk_stack_limits() to not properly stack queue_limits
Mike> for stacked devices (e.g. DM).

Mike> Fix this regression by establishing lcm_not_zero() and switching
Mike> blk_stack_limits() over to using it.

I'm OK with that approach. The original lcm() behavior made sense when
we were the only user.

+unsigned long lcm_not_zero(unsigned long a, unsigned long b)
+{
+	unsigned long l = lcm(a, b);
+
+	if (l)
+		return l;
+
+	return (b ? : a);
+}

I always blink when I read b ?: a instead of b ? b : a. But no
biggie. That's just my personal preference.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
