From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Queue upcall locking (was: [dm-devel] [RFC][PATCH] fix
	dm_any_congested() to properly sync up with suspend code path)
Date: Tue, 11 Nov 2008 13:22:11 -0500
Message-ID: <20081111182211.GC25049@infradead.org>
References: <1225944008.14830.1101.camel@chandra-ubuntu> <Pine.LNX.4.64.0811100746180.24696@hs20-bc2-1.build.redhat.com> <20081110135401.GA11606@infradead.org> <20081110142715.GD16649@agk.fab.redhat.com> <Pine.LNX.4.64.0811100933520.16965@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754979AbYKKSWW@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811100933520.16965@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, dm-devel <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Nov 10, 2008 at 09:40:18AM -0500, Mikulas Patocka wrote:
> > - If the device is suspended, the response should be that it is 
> > congested, I'd have thought.
> 
> Yes, but these congestion upcalls are used only for optimization and the 
> device is suspended for so small time, that it doesn't matter if we 
> optimize io acces in small moment or not.

We use device congested to not block pdflush on a device that can't
currently accept I/O.  For a suspended device congested is always
correct, pdflush will just come back a little later and in the mean time
write out stuff that doesn't delay it.
