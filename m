From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 01/23] multipathd: uxlsnr: avoid deadlock on
	exit
Date: Sat, 26 Sep 2020 15:00:58 +0200
Message-ID: <20711328a510d2c02aba22b584a7f5eb1e4ecf65.camel@suse.com>
References: <20200924134054.14632-1-mwilck@suse.com>
	<20200924134054.14632-2-mwilck@suse.com>
	<20200926015207.GJ3384@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200926015207.GJ3384@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 2020-09-25 at 20:52 -0500, Benjamin Marzinski wrote:
> 
> O.k. I'm getting way into the theoretical weeds here, but I believe
> that
> realloc() is technically allowed to return NULL when it shrinks
> allocated memory. In this case num_clients would be too big.  Later
> in
> this function, when we loop through num_clients
> 
>                 for (i = 2; i < num_clients + 2; i++) {
>                         if (polls[i].revents & POLLIN) {
>  
> We could look at an unused polls entry, since its revents doesn't get
> cleared. It's also possible that the fd of this unused entry matches
> the
> fd of an existing client. Then we could try to get a packet from a
> client that isn't sending one, and kill that client. Yeah, this will
> almost certainly never happen.  But we could just zero out the
> revents
> field, or loop over the actual number of structures we polled, and
> then
> it can't happen.

I'll fix this up in this patch, and add another patch to sanitize this.
calling realloc() when the number of fds shrinks really isn't buying us
much.

Martin
