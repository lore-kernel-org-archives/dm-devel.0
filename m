From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: > You may find that you need to update your lvm
	userspace tools.
Date: Tue, 5 Feb 2008 12:11:52 +0000
Message-ID: <20080205121152.GA609@agk.fab.redhat.com>
References: <43d009740802022335y21c3f93ep4e444bef71338045@mail.gmail.com>
	<20080202235103.20dd9768.akpm@linux-foundation.org>
	<47A71040.5000300@gmail.com>
	<20080204052709.12f4e0d3.akpm@linux-foundation.org>
	<47A7F4DB.3070406@gmail.com>
	<20080204215304.8b909402.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080204215304.8b909402.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Igor M Podlesny <for.poige+linux@gmail.com>
List-Id: dm-devel.ids

On Mon, Feb 04, 2008 at 09:53:04PM -0800, Andrew Morton wrote:
> Could someone in dm-devel land please get involved?

Vague reports like this are sadly a regular occurrence, and they usually
happen when people don't update their initrd after updating their
kernel.  As well as the obvious problems from incompatible modules, some
versions of distros are worse than others, as they foolishly hard-code
device numbers, and a new kernel happens to assign device numbers in a
different sequence breaking everything.  Another cause is when the
distro lets the boot script run too early without waiting for the kernel
to discover all the devices necessary.  Or sometimes kernel/module
changes mean it no longer sees the devices at all.

Alasdair
-- 
agk@redhat.com
