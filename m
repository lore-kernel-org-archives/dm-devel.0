From: Steve Feehan <sfeehan@sbb.uvm.edu>
Subject: Re: multipath and StorageWorks HSG80
Date: Thu, 20 Apr 2006 16:44:49 -0400
Message-ID: <20060420204449.GA32417@ingress.sbb.uvm.edu>
References: <20060420194321.GE29759@ingress.sbb.uvm.edu>
	<4447EA16.9070708@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4447EA16.9070708@free.fr>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Apr 20, 2006 at 10:07:50PM +0200, Christophe Varoqui wrote:

> Overall, that's very good howto material, if you care to feed the wiki.

OK, I will see what I can do.

> The IO errors are due to lvm tools trying to scan the individual paths, 
> including those not usable, where they should only care about the 
> multipath devices.
>
> You should blacklist the individual path in the lvm config.

Yes, I put the following in /etc/lvm/lvm.conf:

filter = [ "r|/dev/cdrom|", "r|/dev/sd|" ]

And that makes the errors go away for the LVM case. But I still 
get the kernel errors during bootup.

It's too soon to say for sure, but so far I don't seem to be
getting any errors once the system has booted. Perhaps it's just
during the early stages of booting and not an issue after that?

If anyone would like to see the full dmesg output for a boot
I'd be glad to send it.

And I haven't even begun to test actually failing over the
controllers. I imagine I'll have more problems/questions shortly. :)

Thanks.

-- 
Steve Feehan
