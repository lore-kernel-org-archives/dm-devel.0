From: Jens Wilke <jens.wilke@de.ibm.com>
Subject: Re: [dm-devel] [RFC][PATCH] dm-cache: block level disk cache target for device mapper
Date: Fri, 1 Dec 2006 11:30:04 +0100
Message-ID: <200612011130.04466.jens.wilke@de.ibm.com>
References: <200611271826.kARIQYRi032717@hera.kernel.org> <200611302107.40418.jens.wilke@de.ibm.com> <b1e142760611302316w5917bc67q5a9f26e1d069f716@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S936134AbWLAKaP@vger.kernel.org>
In-Reply-To: <b1e142760611302316w5917bc67q5a9f26e1d069f716@mail.gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: Ming Zhao <mingzhao99th@gmail.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Friday 01 December 2006 08:16, Ming Zhao wrote:
> On 11/30/06, Jens Wilke <jens.wilke@de.ibm.com> wrote:
> > - You don't keep track of I/O on the fly to the cache that is mapped
> > directly in cache_hit(). How do you make sure that this I/O is completed
> > before you replace a cache block?
> 
> The previous I/O from cache hit and the later I/O for cache
> replacement should be queued in order on the cache block device - is
> this a safe assumption?

I don't think you can assume that the request processing in the host
is ordered without sychronization. Everything you queue in your worker
thread is serialized by that. Everything else is out of your control and each
thread may be scheduled or not.

Maybe we have certain guarantees through DM or the block I/O layer, that
I don't know. Can somebody else step in here?

Best,

Jens
