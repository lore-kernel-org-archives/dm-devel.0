From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCHES] improve sysfs performance, make it O(log n)
Date: Thu, 21 Jul 2011 09:31:48 -0700
Message-ID: <20110721163148.GA31647@suse.de>
References: <Pine.LNX.4.64.1107201836310.4812@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1107201836310.4812@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, Milan Broz <mbroz@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Jul 20, 2011 at 06:56:50PM -0400, Mikulas Patocka wrote:
> Hi
> 
> Here are 5 patches to make sysfs O(log n) and improve performance on 
> operations with many block devices.

Very nice job.

But can you please resend these, one per email, so that they could be
applied to the tree (Documentation/SubmittingPatches describes this
requirement).

Also note that it is past the merge window time for patches to be
accepted for 3.1, so this will remain in my "to-apply" queue until after
3.1-rc1 is out for the 3.2 merge.

thanks,

greg k-h
