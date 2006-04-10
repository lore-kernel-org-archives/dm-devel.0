From: Ed Wilts <ewilts@ewilts.org>
Subject: Re: Device Mapper as a cache for SAN?
Date: Mon, 10 Apr 2006 13:45:31 -0500
Message-ID: <20060410184531.GA12908@www.ewilts.org>
References: <a4e6962a0604101058w75a7147cy8860bc9ebf8f269e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <a4e6962a0604101058w75a7147cy8860bc9ebf8f269e@mail.gmail.com>
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

On Mon, Apr 10, 2006 at 12:58:36PM -0500, Eric Van Hensbergen wrote:
> It seems like device-mapper would allow a fairly straightforward
> implementation of a local-disk cache for a SAN (iSCSI, AOE, etc.).  
> The dm-raid1 and dm-mpath modules seem to have elements of overlap,
> but its not clear if there's a straightforward way to implement a
> local-disk block cache using existing modules, or whether a new one is
> needed.  Has anyone looked at this before?

The obvious question is why?  What would this provide that the kernel
and file systems don't already provide?

        .../Ed

-- 
Ed Wilts, RHCE
Mounds View, MN, USA
mailto:ewilts@ewilts.org
Member #1, Red Hat Community Ambassador Program
