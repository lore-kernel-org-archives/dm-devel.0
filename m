From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: dm-ioctl on amd64 with 32bit userspace
Date: Wed, 19 Sep 2007 17:26:50 -0700
Message-ID: <20070919172650.72df609f.akpm@linux-foundation.org>
References: <20070917165726.GA11958@bogon.ms20.nix>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070917165726.GA11958@bogon.ms20.nix>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Guido Guenther <agx@sigxcpu.org>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, 17 Sep 2007 18:57:26 +0200
Guido Guenther <agx@sigxcpu.org> wrote:

> using something like:
> 
> dmsetup message <mpath> 0 fail_if_no_path
> 
> on a 32 bit dmsetup with a amd64 kernel currently fails with:
>  "Invalid target message parameters."
> 
> since the structure padding is 8 bytes and so we're looking at a 4 byte
> to high address in target_message() - this also affects dev_rename() and
> dev_set_geometry(). The attached patch works around the problem but
> doesn't look like a proper fix. But since all the 32bit to 64bit ioctl
> conversion in device mapper seems a bit strange, I'm not sure where to
> fix this properly.
> 
> The bad thing about this is that multipath failover after a trespas on
> such a system won't work (among other things). This at least has been
> broken since 2.6.18 (I doubt it ever worked) and is still broken in
> 2.6.23-rc6-git7. With this patch, failover after a trespas and device
> renaming works as expected.

I don't understand why people aren't running around with their hair on fire
over this bug.    Is everyone running 64-bit dmsetup, or what?

This looks like 2.6.22 and 2.6.23 material to me.  Alasdair?
