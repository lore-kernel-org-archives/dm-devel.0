From: Joe Thornber <thornber@redhat.com>
Subject: Re: Hibernate/Resume and dm-cache, dm-writeboost...
Date: Tue, 30 Dec 2014 10:32:29 +0000
Message-ID: <20141230103228.GA31888@debian>
References: <549B0785.3060807@rolffokkens.nl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <549B0785.3060807@rolffokkens.nl>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>, Mathijs Kwik <mathijs@bluescreen303.nl>
List-Id: dm-devel.ids

On Wed, Dec 24, 2014 at 07:35:49PM +0100, Rolf Fokkens wrote:
> Hi all,
> 
> On the linux-bcache mailing list the potential issue was brought up
> about writes to backing or caching device after bringing up devices
> in initramdisk, but prior to an actual resume. The actual issue is
> that there should be no writes between hibernation and resume:
> 
> http://www.spinics.net/lists/linux-bcache/msg02692.html
> 
> If this is an issue for bcache, I can imagine it also is for other
> caching solutions like dm-cache and dm-writeboost. I'm not an expert
> on this, but from my user perspective it seems somewhat concerning
> (for both bcache and the DM caching solutions) and an expert view on
> this might be needed.

Thanks for bringing this to our attention.  I think dm-cache provides
the neccessary tools to do this; either setting the migration
threshold to zero, or switch to write through mode for the duration of
the hibernate.  But atm this would need to be triggered from userland.
I need to look at hibernate more.

- Joe
