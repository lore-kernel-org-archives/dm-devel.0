From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3.10,3.14] dm snapshot: allocate a per-target structure
 for snapshot-origin target
Date: Mon, 29 Jun 2015 17:22:44 -0700
Message-ID: <20150630002244.GD6430@kroah.com>
References: <alpine.LRH.2.02.1506031056520.14129@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1506031056520.14129@file01.intranet.prod.int.rdu2.redhat.com>
Sender: stable-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Jun 03, 2015 at 11:00:16AM -0400, Mikulas Patocka wrote:
> This is backport of 599cdf3bfbe21fe94f4416c9e54363b285c9532a for 3.10 and 
> 3.14 kernels. The patch doesn't fix any bug but it is needed for other 
> backported patches.

You sent 5 patches, with no hint as to the order to apply them in :(

Also, these are really big for such old kernels, are they really all
needed?  Why can't people just use 4.0 and newer kernels if they have
these issues?

thanks,

greg k-h
