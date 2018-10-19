From: Vitaly Chikunov <vt@altlinux.org>
Subject: Re: [dm-devel] [PATCH] dm: add secdel target
Date: Fri, 19 Oct 2018 14:49:44 +0300
Message-ID: <20181019114944.syemvziebwfuruof@sole.flsd.net>
References: <20181014112439.8119-1-vt@altlinux.org>
 <20181019061945.GA7403@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181019061945.GA7403@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Jonathan Corbet <corbet@lwn.net>, Shaohua Li <shli@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Oct 18, 2018 at 11:19:45PM -0700, Christoph Hellwig wrote:
> Just as a note:  the name is a complete misowner, a couple overwrite
> are not in any way secure deletion.  So naming it this way and exposing
> this as erase is a problem that is going to get back to bite us.

In what way it's not secure deletion?

It's secure deletion by overwriting discarded data instead of leaving it
as is. Thus it's secure deletion in some way. Level of security and
applicability (disks choice) is to be determined by the end user.
Because nobody could guarantee absolute security. Some three letter
agencies require just one pass of overwrite, some say that more than one
pass does not increase security. Some hardware disks advertising secure
deletion may do not much more than this target. Thus 'secure erase' is
applicable in that way too.


> If you really want this anyway at least give it a different way, and
> do a one-time warning when th first erase comes in that it is not in
> any meaninful way secure.

dm-erase or dm-wipe? dm-discerase? But still provide REQ_OP_SECURE_ERASE
support?
