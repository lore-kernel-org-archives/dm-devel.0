From: Austin Chang <austin880625@gmail.com>
Subject: Re: [PATCH] dm-cache: document zeroing metadata device step
Date: Mon, 13 Jul 2020 05:10:45 +0800
Message-ID: <20200712211045.GA332416@austin-fedora>
References: <20200712194039.329035-1-austin880625@gmail.com>
 <20200712195932.GV12769@casper.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200712195932.GV12769@casper.infradead.org>
Sender: linux-doc-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sun, Jul 12, 2020 at 08:59:32PM +0100, Matthew Wilcox wrote:
> On Mon, Jul 13, 2020 at 03:40:39AM +0800, Austin Chang wrote:
> > +  # When using dmsetup directly instead of volume manager like lvm2,
> > +  # the first 4k of the metadata device should be zeroed to indicate
> > +  # empty metadata.
> > +  dd if=/dev/zero of=/dev/mapper/metadata bs=4k conv=notrunc
> 
> ... don't you need 'count=1' or you'll zero the entire device?

Oops, I copied the command I just used since zeroing the whole metadata
device didn't harm. But 'count=1' should match what I've just written.
I will send a v2 patch later
