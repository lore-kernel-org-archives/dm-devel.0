From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: free io_barrier after blk_cleanup_queue call
Date: Mon, 10 Oct 2016 09:25:42 -0400
Message-ID: <20161010132542.GA17958@redhat.com>
References: <1476102919-25112-1-git-send-email-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1476102919-25112-1-git-send-email-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Oct 10 2016 at  8:35am -0400,
Tahsin Erdogan <tahsin@google.com> wrote:

> dm_old_request_fn() has paths that access md->io_barrier. The party
> destroying io_barrier should ensure that no future execution
> of dm_old_request_fn() is possible. Move destruction to below
> blk_cleanup_queue() to ensure this.

I have to believe this was born out of code inspection rather than
actual need (due to crash, etc)?

The cleanup order isn't relevant.  The reference counting of a DM device
governs whether a DM device (and its associated 'struct mapped_device')
can be destroyed.  Please have a look at  __dm_destroy, particularly:
        * No one should increment the reference count of the mapped_device,
        * after the mapped_device state becomes DMF_FREEING.

Mike
