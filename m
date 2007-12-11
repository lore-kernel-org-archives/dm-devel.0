From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: [dm-devel] [PATCH] improve atomicity of device creation
Date: Tue, 11 Dec 2007 18:35:28 +0100
Message-ID: <3ae72650712110935n20398423t1da02c585a72aead@mail.gmail.com>
References: <1197389316.25082.27.camel@quest>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1197389316.25082.27.camel@quest>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-hotplug-devel@lists.sourceforge.net
List-Id: dm-devel.ids

On Dec 11, 2007 5:08 PM, Scott James Remnant <scott@ubuntu.com> wrote:
> This is a patch we've written and applied in Ubuntu to improve the
> atomicity of devmapper device creation somewhat, and avoid races with
> udev.

Without synchronization between libdevmapper and udev, you can't
predict which one will win in creating the node, right?
So this patch makes is more likely to create a valid device node, but
it can still happen, that libdevmapper replaces the udev nodes, which
is not what we want, right?

Kay

-------------------------------------------------------------------------
SF.Net email is sponsored by: 
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://sourceforge.net/services/buy/index.php
