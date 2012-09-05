From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH v7 3/9] block: Add bio_reset()
Date: Wed, 5 Sep 2012 13:13:46 -0700
Message-ID: <20120905201346.GG25236@google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-4-git-send-email-koverstreet@google.com>
 <20120828203148.GB24608@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120828221715.GD1048@moria.home.lan>
 <20120901022305.GE19535@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120901022305.GE19535@dhcp-172-17-108-109.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com, bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
List-Id: dm-devel.ids

On Fri, Aug 31, 2012 at 07:23:05PM -0700, Tejun Heo wrote:
> On Tue, Aug 28, 2012 at 03:17:15PM -0700, Kent Overstreet wrote:
> > I still think they should be symmetrical, but if that's true bi_ioc and
> > bi_css need to be moved, and also bio_disassociate_task() should be
> > getting called from bio_free(), not bio_put().
> > 
> > Were you the one that added that call? I know you've been working on
> > that area of the code recently. Sticking it in bio_put() instead of
> > bio_free() seems odd to be, and they're completely equivalent now that
> > bio_free() is only called from bio_put() (save one instance I should
> > probably fix).
> 
> Maybe I botched symmetry but anyways I *suspect* it probably would be
> better to keep css association across bio_reset() give the current
> usages of both mechanisms.  css association indicates the ownership of
> the bio which isn't likely to change while recycling the bio.

Thought about it more and while you're right that css association isn't
likely to change, it'd just be a needless difference. bio_reset() should
be as close to a bio_free()/bio_alloc() as possible, IMO.

Fixed my patches to do it right, though.
