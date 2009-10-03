From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Do not overload dispatch queue (Was: Re: IO scheduler based IO
	controller V10)
Date: Sat, 3 Oct 2009 16:28:40 +0200
Message-ID: <20091003142840.GE31616@kernel.dk>
References: <20091002173732.GK31616@kernel.dk> <1254507215.8667.7.camel@marge.simson.net> <20091002181903.GN31616@kernel.dk> <1254548931.8299.18.camel@marge.simson.net> <1254549378.8299.21.camel@marge.simson.net> <20091003112915.GA12925@redhat.com> <20091003124049.GB12925@redhat.com> <20091003132115.GB31616@kernel.dk> <20091003135623.GD12925@redhat.com> <1254578553.7499.5.camel@marge.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753630AbZJCO2i@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1254578553.7499.5.camel@marge.simson.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Galbraith <efault@gmx.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@linux-foundation.org>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, riel@redhat.com
List-Id: dm-devel.ids

On Sat, Oct 03 2009, Mike Galbraith wrote:
> On Sat, 2009-10-03 at 09:56 -0400, Vivek Goyal wrote:
> 
> > I have kept the overload delay period as "cfq_slice_sync" same as Mike had
> > done. We shall have to experiment what is a good waiting perioed. Is 100ms
> > too long if we are waiting for a request from same process which recently
> > finished IO and we did not enable idle on it.
> > 
> > I guess we can tweak the delay period as we move along.
> 
> I kept the delay period very short to minimize possible damage. Without
> the idle thing, it wasn't enough, but with, worked a treat, as does your
> patch.

Can you test the current line up of patches in for-linus? It has the
ramp up I talked about included as well.

-- 
Jens Axboe
