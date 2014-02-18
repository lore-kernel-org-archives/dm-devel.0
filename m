From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] bio: don't write "bio: create slab" messages to syslog
Date: Tue, 18 Feb 2014 12:18:07 -0800
Message-ID: <20140218201807.GB25515@kernel.dk>
References: <alpine.LRH.2.02.1402181307200.30436@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1402181307200.30436@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Feb 18 2014, Mikulas Patocka wrote:
> When using device mapper, there are many "bio: create slab" messages in
> the log. Device mapper targets have different front_pad, so each time when
> we load a target that wasn't loaded before, we allocate a slab with the
> appropriate front_pad and there is associated "bio: create slab" message.
> 
> This patch removes these messages, there is no need for them.

Agreed, it's time to kill off that message. Applied, thanks.

-- 
Jens Axboe
