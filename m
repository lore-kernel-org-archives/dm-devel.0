From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] RFC: dm: avoid the mutex lock in
 dm_bufio_shrink_count()
Date: Mon, 28 Nov 2016 16:56:18 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1611281656020.107214@chino.kir.corp.google.com>
References: <1479417398-2593-1-git-send-email-dianders@chromium.org> <alpine.DEB.2.10.1611171413450.99747@chino.kir.corp.google.com> <alpine.LRH.2.02.1611231531340.31481@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1611231531340.31481@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Douglas Anderson <dianders@chromium.org>, Mike Snitzer <snitzer@redhat.com>, shli@kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux@roeck-us.net, Sonny Rao <sonnyrao@chromium.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, 23 Nov 2016, Mikulas Patocka wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> dm-bufio: don't take the lock in dm_bufio_shrink_count
> 
> dm_bufio_shrink_count is called from do_shrink_slab to find out how many
> freeable objects are there. The reported value doesn't have to be precise,
> so we don't need to take the dm-bufio lock.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Acked-by: David Rientjes <rientjes@google.com>
