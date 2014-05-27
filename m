From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: [PATCH] block: flush queued bios when the process blocks
Date: Tue, 27 May 2014 10:59:19 -0700
Message-ID: <CALJ65znW7YK2moi6w6n-cm725c7Czci44EFzHDNv4y=sNcF66g@mail.gmail.com>
References: <alpine.LRH.2.02.1405271059190.27492@file01.intranet.prod.int.rdu2.redhat.com>
	<5384AA79.4010206@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5384AA79.4010206@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Mikulas Patocka <mpatocka@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

On Tue, May 27, 2014 at 8:08 AM, Jens Axboe <axboe@kernel.dk> wrote:
> This really begs the question of why we just don't use the per-process plugs
> for this. We already have scheduler hooks in place to flush those at the
> appropriate time. Why are we reinventing something for essentially the same
> thing?

Yes! Unifying the two plugging mechanisms has been on my todo/wishlist for ages.
