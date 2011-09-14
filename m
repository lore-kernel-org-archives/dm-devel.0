From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2] block: export __make_request
Date: Wed, 14 Sep 2011 19:40:40 +0100
Message-ID: <20110914194040.37ed38c9@lxorguk.ukuu.org.uk>
References: <20110911145053.GA28996@infradead.org>
	<4E6DD7F0.8020903@kernel.dk>
	<20110912122507.GA12229@infradead.org>
	<4E6DFA8C.3030400@kernel.dk>
	<20110912133826.GA22548@infradead.org>
	<4E6E49BE.6020005@kernel.dk>
	<20110913211911.GA13894@infradead.org>
	<4E70E1C1.8040907@panasas.com>
	<CAFx4rwR=EnCVfi4Pzm9pmTtKWAdzvzOg7wwzBbzZN7YTvu5-fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwR=EnCVfi4Pzm9pmTtKWAdzvzOg7wwzBbzZN7YTvu5-fw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: doug@easyco.com
Cc: Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, nab@linux-iscsi.org, ryanh@us.ibm.com
List-Id: dm-devel.ids

On Wed, 14 Sep 2011 10:53:22 -0700
Doug Dumitru <doug@easyco.com> wrote:

> It would be great if this function were exported, but I would
> encourage everyone to consider exporting it generally, not just for
> GPL usage.

That would require a licensing change for the kernel. The kernel is a GPL
work. Some of us have not licensed it in any other way.

> 
> The kernel seems to be pretty clean that some subsystems are GPL only
> (things like sysfs), and some are open 

The _GPL is meant to make it clear they are internal symbols. The lack of
an _GPL does not make them usable by non GPL code, it merely indicates
that its perhaps more likely that you could in some cases shown something
was not a derivative work.

The licensing is determined by the license document, and that very
clearly says the boundary is derivative works. The rest is just vague
guidance.

In addition btw please be careful when trying to do this even with non
derivative code your lawyer is happy with. The kernel contains algorithms
which are subject to various US software patent mess where GPL use has
been granted, that may impact you if you use such code indirectly in non
GPL code.

Alan
