From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH 05/30] multipath-tools: fix more gcc 9
 -Wstringop-truncation warnings
Date: Mon, 24 Jun 2019 09:47:32 +0200
Message-ID: <246f3f47b66b928352cda90eea28b19650b37148.camel@suse.de>
References: <20190607130552.13203-1-mwilck@suse.com>
	<20190607130552.13203-6-mwilck@suse.com>
	<20190621191656.GK3251@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190621191656.GK3251@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, mwilck+gmail@suse.de
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 2019-06-21 at 14:16 -0500, Benjamin Marzinski wrote:
> On Fri, Jun 07, 2019 at 03:05:27PM +0200, Martin Wilck wrote:
> > More often than not, this means replacing strncpy() by strlcpy().
> 
> This depends on "libmultipath: add size argument to dm_get_uuid()"
> for
> the the extra argument in the call to dm_get_uuid() from
> get_refwwid().
> Otherwise, it looks fine.

Sorry, this mistake slipped in during my attempt to reorder the patch
series into similar-topic groups. I'll fix it and your other issue with
patc 07/30, and resubmit.

Martin
