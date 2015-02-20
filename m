From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH v3] staging: writeboost: Add dm-writeboost
Date: Fri, 20 Feb 2015 16:17:59 +0000
Message-ID: <20150220161759.GC4740@debian>
References: <54A508F7.1020207@gmail.com>
 <20150118000952.GB26160@kroah.com>
 <20150220174401.4badb3cbad7be3eed449f4c1@gmail.com>
 <20150220150614.GA4740@debian>
 <54E75201.9030202@gmail.com>
 <20150220155036.GB4740@debian>
 <54E75B70.1010007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54E75B70.1010007@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: ejt@redhat.com, Greg KH <gregkh@linuxfoundation.org>, snitzer@redhat.com, dm-devel@redhat.com, driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sat, Feb 21, 2015 at 01:06:08AM +0900, Akira Hayakawa wrote:
> The size is configurable but typically 512KB (that's the default).
> 
> Refer to bio payload sounds really dangerous but it may be possible
> in some tricky way. but at the moment I am not sure how the
> implementation would be.
> 
> Is there some fancy function that is like memcpy but actually "move"
> the ownership?

When building up your log chunk bio copy the bio_vecs (not the data)
from the original bios.  You can't complete the original bios until
your log chunk has been written.

- Joe
