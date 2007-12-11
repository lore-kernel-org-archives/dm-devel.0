From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] improve atomicity of device creation
Date: Tue, 11 Dec 2007 18:08:29 +0000
Message-ID: <20071211180829.GW22311@agk.fab.redhat.com>
References: <1197389316.25082.27.camel@quest>
	<20071211162538.GR22311@agk.fab.redhat.com>
	<1197391333.25082.31.camel@quest>
	<20071211170352.GS22311@agk.fab.redhat.com>
	<1197393526.25082.36.camel@quest>
	<3ae72650712110951h477d1fc0hd9abd39f069da105@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <3ae72650712110951h477d1fc0hd9abd39f069da105@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: device-mapper development <dm-devel@redhat.com>, linux-hotplug-devel@lists.sourceforge.net
List-Id: dm-devel.ids

On Tue, Dec 11, 2007 at 06:51:31PM +0100, Kay Sievers wrote:
> We can make the kernel's kobject_uevent() return the generated seqnum to
> the caller.

Is 32 bits enough?

We added 'uint32_t padding;' recently which we I reckon we could now use for
this.

dm_kobject_uevent() and alloc_dev() could keep a new field in
struct mapped_device up-to-date, and a new function could return its
value to dm-ioctl.c code to place into a renamed 'padding' field
before returning to userspace?

Alasdair
-- 
agk@redhat.com
