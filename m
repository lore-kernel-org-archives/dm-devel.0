From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH 07/30] libmpathcmd: use target length in
	strncpy() call
Date: Mon, 24 Jun 2019 10:23:57 +0200
Message-ID: <3843652fe189d29359442bddcb4c178ad6b319ad.camel@suse.de>
References: <20190607130552.13203-1-mwilck@suse.com>
	<20190607130552.13203-8-mwilck@suse.com>
	<20190621192307.GL3251@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190621192307.GL3251@octiron.msp.redhat.com>
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

On Fri, 2019-06-21 at 14:23 -0500, Benjamin Marzinski wrote:
> On Fri, Jun 07, 2019 at 03:05:29PM +0200, Martin Wilck wrote:
> 
> Not a big deal since default socket is a defined string, but since we
> are writing to &addr.sun_path[1], if DEFAULT_SOCKET were of size >=
> "sizeof(addr.sun_path) - 1", the strncpy() would fill all of
> addr.sun_path, without leaving any space for the the null byte at the
> end. I assume you meant to change this to be strlcpy() instead of
> leaving it as strncpy().

I double-checked the man pages unix(7), and I found that abstract unix
socket names do not have to be zero-terminated ("null bytes in the name
have no special significance"). So strncpy() is actually correct in
this case. But the length argument to bind() should be checked.

Thanks,
Martin
