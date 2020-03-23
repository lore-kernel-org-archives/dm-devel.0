From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 0/7] dm-integrity patches
Date: Mon, 23 Mar 2020 12:58:00 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2003231255320.10387@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200322194220.074515600@debian-a64.vm>
	<20200323142817.GA27360@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200323142817.GA27360@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, David Teigland <teigland@redhat.com>
List-Id: dm-devel.ids



On Mon, 23 Mar 2020, Mike Snitzer wrote:

> On Sun, Mar 22 2020 at  3:42pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Hi
> > 
> > Here I'm sending dm-integrity patches for the upcoming merge window.
> > They supersede dm-integrity patches that I sent before.
> 
> So the dm-bufio discard support isn't needed with your latest
> dm-integrity patches right?
> 
> https://patchwork.kernel.org/patch/11371287/

Yes - it isn't needed until Heinz uses it in the ebs target.

That patch (if used) should also be optimized to walk the rb-tree instead 
of doing lookup of every block number in the range.

Mikulas
