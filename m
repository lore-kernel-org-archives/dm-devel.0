From: Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH] dm: verity target
Date: Thu, 29 Sep 2011 10:31:03 -0700
Message-ID: <20110929173103.GA22515@google.com>
References: <1316112359-6085-1-git-send-email-msb@chromium.org>
 <CABqD9hYWK2czEKN87xDu7YPbRcp9xrumJ5PZ8aQTzBLafrnBMw@mail.gmail.com>
 <21505.1317245414@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <21505.1317245414@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Cc: Will Drewry <wad@chromium.org>, Mandeep Singh Baines <msb@chromium.org>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>, dm-devel@redhat.com, Elly Jones <ellyjones@chromium.org>, Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu) wrote:
> On Tue, 27 Sep 2011 14:02:05 CDT, Will Drewry said:
> 
> > I was just curious if there is any interest in pulling this change, or
> > if not, if there is any particular set of concerns, fixes, etc.
> 
> Out of curiosity, how much of the stack does this end up eating?  My root
> filesystem is already ext4 on an LVM partition that's on a LUKS/dm-crypt
> partition on a hard drive, and I'm sure somebody out there will have used xfs
> instead - and then exported it via NFS or something. Are we going to get weird
> stack overflows if people throw dm-verity into this sort of mix?
> 

No. dm-verity uses very little stack since most of the code is running
in a separate workqueue context. The _map call is pretty light.

> > realize it's not a small amount of code to digest (though it is
> > smaller than the post from last year[1]).   Would re-posting with an
> > added blob explaining the name be useful,
> 
> Probably will need it to be merged, unless you set up an auto-reply that says
> "Patch rejected, 'verity' is *not* a typo for 'verify'" ;)
> 
> I'll hopefully have some more comments over the weekend if I get some spare
> cycles.
> 
