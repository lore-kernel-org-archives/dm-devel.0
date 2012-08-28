From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH v7 4/9] pktcdvd: Switch to bio_kmalloc()
Date: Tue, 28 Aug 2012 15:24:16 -0700
Message-ID: <20120828222416.GF1048@moria.home.lan>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-5-git-send-email-koverstreet@google.com>
 <20120828203247.GC24608@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120828203247.GC24608@dhcp-172-17-108-109.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com, bharrosh@panasas.com, Peter Osterlund <petero2@telia.com>
List-Id: dm-devel.ids

On Tue, Aug 28, 2012 at 01:32:47PM -0700, Tejun Heo wrote:
> On Tue, Aug 28, 2012 at 10:37:31AM -0700, Kent Overstreet wrote:
> > This is prep work for killing bi_destructor - previously, pktcdvd had
> > its own pkt_bio_alloc which was basically duplication bio_kmalloc(),
> > necessitating its own bi_destructor implementation.
> 
> How was this tested?

Hasn't been yet, but I'm getting a new test machine in the next day or
so (and also the patch is a lot smaller since the bio_reset() changes
you suggested).
