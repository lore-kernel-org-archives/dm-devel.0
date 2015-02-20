From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH v3] staging: writeboost: Add dm-writeboost
Date: Fri, 20 Feb 2015 15:06:14 +0000
Message-ID: <20150220150614.GA4740@debian>
References: <54A508F7.1020207@gmail.com>
 <20150118000952.GB26160@kroah.com>
 <20150220174401.4badb3cbad7be3eed449f4c1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150220174401.4badb3cbad7be3eed449f4c1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, snitzer@redhat.com, ejt@redhat.com, dm-devel@redhat.com, driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Feb 20, 2015 at 05:44:01PM +0900, Akira Hayakawa wrote:
> I will wait for ack from dm maintainers.

Are you still copying the contents of every bio to your own memory
buffer before writing it to disk?

- Joe
