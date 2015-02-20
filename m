From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH v3] staging: writeboost: Add dm-writeboost
Date: Fri, 20 Feb 2015 15:50:36 +0000
Message-ID: <20150220155036.GB4740@debian>
References: <54A508F7.1020207@gmail.com>
 <20150118000952.GB26160@kroah.com>
 <20150220174401.4badb3cbad7be3eed449f4c1@gmail.com>
 <20150220150614.GA4740@debian>
 <54E75201.9030202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54E75201.9030202@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: ejt@redhat.com, Greg KH <gregkh@linuxfoundation.org>, snitzer@redhat.com, dm-devel@redhat.com, driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sat, Feb 21, 2015 at 12:25:53AM +0900, Akira Hayakawa wrote:
> Yes.

How big are your log chunks?  Presumably they're relatively small (eg,
256k).  In which case you can optimise for the common case where you
have enough bios to hand to build your log chunk by just referencing
the bio payloads, rather than copying.  It's only the last bit of io
in a burst that should be using this copying slow path.

- Joe
