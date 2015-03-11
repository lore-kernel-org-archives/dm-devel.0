From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm log userspace: use mempool_create_kmalloc_pool()
Date: Wed, 11 Mar 2015 08:58:52 -0400
Message-ID: <20150311125852.GA28768@redhat.com>
References: <alpine.DEB.2.10.1503071642540.2772@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1503071642540.2772@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Cc: Alasdair Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Mar 07 2015 at  7:43pm -0500,
David Rientjes <rientjes@google.com> wrote:

> Mempools created for kmalloc caches should use
> mempool_create_kmalloc_pool().
> 
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Neil Brown <neilb@suse.de>
> Signed-off-by: David Rientjes <rientjes@google.com>

Thanks David, I'll get this queued up.
