From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Queue upcall locking (was: [dm-devel] [RFC][PATCH] fix
	dm_any_congested() to properly sync up with suspend code path)
Date: Tue, 11 Nov 2008 13:21:02 -0500
Message-ID: <20081111182102.GB25049@infradead.org>
References: <1225944008.14830.1101.camel@chandra-ubuntu> <Pine.LNX.4.64.0811100746180.24696@hs20-bc2-1.build.redhat.com> <20081110135401.GA11606@infradead.org> <20081110142715.GD16649@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754779AbYKKSVU@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081110142715.GD16649@agk.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mikulas Patocka <mpatocka@redhat.com>, axboe@kernel.dk, dm-devel <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Nov 10, 2008 at 02:27:15PM +0000, Alasdair G Kergon wrote:
> Indeed - the blocking was a bug for which there's a patch, but that doesn't
> deal with how the function should be operating in the first place.
> 
> - If one device is found to be congested, why bother checking the remaining
> devices?
> 
> - If the device is suspended, the response should be that it is congested, I'd
> have thought.

Yes.  device congested is a quick an dirty check - if you encounter
anything long just return congested if I/O would hit this long delay,
too or not congested if you can't really know.
