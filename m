From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH] dm: add secdel target
Date: Fri, 19 Oct 2018 05:00:33 -0700
Message-ID: <20181019120033.GA7869@infradead.org>
References: <20181014112439.8119-1-vt@altlinux.org>
 <20181019061945.GA7403@infradead.org>
 <20181019114944.syemvziebwfuruof@sole.flsd.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181019114944.syemvziebwfuruof@sole.flsd.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Vitaly Chikunov <vt@altlinux.org>
Cc: Christoph Hellwig <hch@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Jonathan Corbet <corbet@lwn.net>, Shaohua Li <shli@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Oct 19, 2018 at 02:49:44PM +0300, Vitaly Chikunov wrote:
> On Thu, Oct 18, 2018 at 11:19:45PM -0700, Christoph Hellwig wrote:
> > Just as a note:  the name is a complete misowner, a couple overwrite
> > are not in any way secure deletion.  So naming it this way and exposing
> > this as erase is a problem that is going to get back to bite us.
> 
> In what way it's not secure deletion?
> 
> It's secure deletion by overwriting discarded data instead of leaving it
> as is.

Overwriting data does not delete data.  Most certainly not in Flash based
SSDs, but also not in many storage arrays, or for that matter many modern
disks that have sectore remapping and various kinds of non-volatile
caches.  There is a reason why devices tend to have special commands to
perform secure erase - depending on the media they might or might not
overwrite internally, but at least they do it in a way that actually
works for the given media and device configuration.


> dm-erase or dm-wipe? dm-discerase?

dm-overwrite?

> But still provide REQ_OP_SECURE_ERASE
> support?

On the one hand that is highly misleading and would warrant a warning
(see above), on the other hand discard is purely advisory and can
be skipped any time, including by intermediate layers.  So I don't think
you can actually do what you want without major changes to the whole
I/O stack.
