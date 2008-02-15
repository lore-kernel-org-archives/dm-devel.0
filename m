From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH] Implement barrier support for single device DM devices
Date: Fri, 15 Feb 2008 16:07:54 +0300
Message-ID: <47B58EAA.8040405@msgid.tls.msk.ru>
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759502AbYBONIJ@vger.kernel.org>
In-Reply-To: <20080215122002.GM29914@agk.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Alasdair G Kergon wrote:
> On Fri, Feb 15, 2008 at 01:08:21PM +0100, Andi Kleen wrote:
>> Implement barrier support for single device DM devices
>  
> Thanks.  We've got some (more-invasive) dm patches in the works that
> attempt to use flushing to emulate barriers where we can't just
> pass them down like that.

I wonder if it's worth the effort to try to implement this.

As far as I understand (*), if a filesystem realizes that the
underlying block device does not support barriers, it will
switch to using regular flushes instead - isn't it the same
thing as you're trying to do on an MD level?

Note that a filesystem must understand barriers/flushes on
underlying block device, since many disk drives don't support
barriers anyway.

(*) this is, in fact, an interesting question.  I still can't
find complete information about this.  For example, how safe
xfs is if barriers are not supported or turned off?  Is it
"less safe" than with barriers?  Will it use regular cache
flushes if barriers are not here?  Ditto for ext3fs, but
here, barriers are not enabled by default.

/mjt
