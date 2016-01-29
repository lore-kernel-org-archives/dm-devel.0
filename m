From: Joe Thornber <thornber@redhat.com>
Subject: Re: [dm-devel] reinstate dm target local ioctl support
Date: Fri, 29 Jan 2016 13:55:34 +0000
Message-ID: <20160129135534.GA23051@rh-vpn>
References: <1453989019-24300-1-git-send-email-apw@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453989019-24300-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.com>, linux-raid@vger.kernel.org, mohan_srinivasan@yahoo.com, Andy Whitcroft <apw@canonical.com>, Tim Gardner <tim.gardner@canonical.com>
List-Id: dm-devel.ids

On Thu, Jan 28, 2016 at 01:50:19PM +0000, Andy Whitcroft wrote:
> How would we feel about carrying something like the patch below in
> mainline to allow for such target local ioctls.

You can send a dm message to individual targets.  No need for target
specific ioctls.

- Joe
