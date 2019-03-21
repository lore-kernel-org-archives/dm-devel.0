From: John Dorminy <jdorminy@redhat.com>
Subject: Re: [PATCH] dm: rename max_io_len to io_boundary
Date: Thu, 21 Mar 2019 18:57:34 -0400
Message-ID: <CAMeeMh8Sed3ZN5wew6epsNJghzXgQ9Krsku-TSsLEGrHLACTnQ@mail.gmail.com>
References: <alpine.LRH.2.02.1903211646170.994@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1903211646170.994@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

I'm thankful for this change making it explicit that this parameter is
not a max IO length but something else. I've been confused by the name
more than once when trying to figure out why IOs weren't coming in as
large as I expected. I wish there were a way for targets to say "I can
accept IO of up to $len" without saying "I want my IO split if it
crosses a multiple of $len, no matter what size it is", and I'm
thankful for this step making it easier if I ever act on that wish...

Boundary doesn't quite strike me as the clearest word, but the words
that come to mind, alignment and granularity, seem to describe other
concepts, at least when it comes to discards. Perhaps zone_granularity
or zone_boundary might be clearer, since all the targets that use it
have a concept of a 'zone' or a 'block' and don't want an IO to need
work in multiple blocks/zones.

>+       /* If non-zero, I/O submitted to a target must not cross this boundary. */
Sounds like the I/O sender is responsible for making sure the I/Os
don't cross the boundary, at least to me. Perhaps this wording might
be clearer?

/* If non-zero, I/O submitted to a target will be split so as to not
straddle any multiple of this length (in bytes) */

Thanks!

John
