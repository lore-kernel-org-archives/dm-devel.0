From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] add devname module aliases to allow module
	on-demand auto-loading
Date: Fri, 21 May 2010 20:32:51 +0100
Message-ID: <20100521193251.GP3991@agk-dp.fab.redhat.com>
References: <1274371640.302.5.camel@yio.site> <AANLkTilI3RYcybjG7b1juTa3H31ImxQI1-2R_l7q0yc1@mail.gmail.com> <AANLkTinQwEqFKAiyAwVPwmzLtUXJkaOdZ0c88O_tfp-1@mail.gmail.com> <201005211909.29326.knikanth@suse.de> <AANLkTimGBgpqB7HEZrecv7uEis6L8b5Yv7jfD6iv_f4J@mail.gmail.com> <20100521182325.GO3991@agk-dp.fab.redhat.com> <AANLkTimuciWfkVwn7dKVeKL38WpMiCvgAxGx4ngAankW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimuciWfkVwn7dKVeKL38WpMiCvgAxGx4ngAankW@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Nikanth Karthikesan <knikanth@suse.de>, Peter Rajnoha <prajnoha@redhat.com>, Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>, Miklos Szeredi <miklos@szeredi.hu>, Chris Mason <chris.mason@oracle.com>, Tigran Aivazian <tigran@aivazian.fsnet.co.uk>, Ian Kent <raven@themaw.net>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, May 21, 2010 at 08:51:49PM +0200, Kay Sievers wrote:
> The kernel itself creates /dev/mapper/control today. 

Must have missed that patch:)
Userspace lvm and dm code is certainly not tied to that today.

The device node that userspace lvm and dm tools use is under the
complete control of this userspace code: it chooses the name, and
creates or fixes it if it doesn't already exist with the required
properties: anything devtmpfs is relevant only if it guessed the
right name that this *completely independent* userspace code
chooses to use and already created it exactly as required.

If we were to move to a fixed name for the control device and hand
control of that name to the kernel, then obviously this userspace
code would need adjusting to respect that.

Alasdair
