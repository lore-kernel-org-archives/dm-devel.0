From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [PATCH 2.6.11-rc2] dm-ioctl.c: use new kstrdup() from
	library
Date: Mon, 31 Jan 2005 14:23:26 -0600
Message-ID: <20050131202326.GC24164@lists.us.dell.com>
References: <20050131192859.GB24164@lists.us.dell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050131192859.GB24164@lists.us.dell.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Jan 31, 2005 at 01:28:59PM -0600, Matt Domsch wrote:
> Removes private kstrdup() function, uses new implementation in lib/string.c.
> 
> Required to build.

Note, this assumes that Rusty's lib/string.c:kstrdup() patch gets
applied first.

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
