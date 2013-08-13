From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: [PATCH 04/22] block: Abstract out bvec iterator
Date: Tue, 13 Aug 2013 11:51:58 -0700
Message-ID: <20130813185158.GA8981@kmo-pixel>
References: <FEE91CF1-7CDE-45E5-B7BA-DA8522E7DFFE@coraid.com>
 <1375912471-5106-1-git-send-email-kmo@daterainc.com>
 <1375912471-5106-5-git-send-email-kmo@daterainc.com>
 <2D8F228B-65AE-4046-A910-6B354AF0058E@coraid.com>
 <20130809000943.GC15409@kmo-pixel>
 <F14F555B-1B1C-4E73-8AF8-DE57D77C610D@coraid.com>
 <20130809010530.GG15409@kmo-pixel>
 <54e7d248ba68ecf7e7ad4a4180145b72@coraid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54e7d248ba68ecf7e7ad4a4180145b72@coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ed Cashin <ecashin@coraid.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "neilb@suse.de" <neilb@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Tue, Aug 13, 2013 at 10:03:04AM -0400, Ed Cashin wrote:
> On Aug 9, 2013, Ed Cashin wrote:
> > On Aug 8, 2013, at 9:05 PM, Kent Overstreet wrote:
> > ...
> > > It's in the for-jens branch now.
> > 
> > 
> > Just examining the patches, I like the way it cleans up the aoe code.  I
> > had a question about a new BUG added by the for-jens branch the
> > read-response handling path of the aoe driver.
> 
> The aoe driver in linux-bcache/for-jens commit 4c36c973a8f45 is
> passing my tests.
> 
> Here is a patch against that branch illustrating my suggestion for
> handling bad target responses gracefully.

Thanks - shall I just fold that into the aoe immutable bvec patch?
