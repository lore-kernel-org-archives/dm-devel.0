From: Tejun Heo <tj@kernel.org>
Subject: Re: mempool && io_schedule_timeout()
Date: Wed, 21 Dec 2011 07:34:21 -0800
Message-ID: <CAOS58YP6ogHaadh1Pjf_jF0+zwecJ7aZjQceisH9xTZ5GTTy4w@mail.gmail.com>
References: <20111220221818.GJ10752@google.com>
	<20111221151236.GA27571@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111221151236.GA27571@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Mironchik <tibor0@gmail.com>, Alasdair G Kergon <agk@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

On Wed, Dec 21, 2011 at 7:12 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* FIXME: this should be io_schedule(). =A0The timeout i=
s there as a
>> + =A0 =A0 =A0* workaround for some DM problems in 2.6.18.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 io_schedule_timeout(5*HZ);
>
> Just curious... This was added by 0b1d647a in 2006.
>
> Perhaps the problem was already fixed?

Yeah, I was curious about that too.  It seemed the problem was dm
sharing the same pool from multiple devices (which defeats the purpose
of using mempool BTW).  cc'ing dm devel.  Alasdair, is the problem
fixed now?

Thanks.

--=20
tejun
