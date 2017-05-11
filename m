From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/3] dm: a basic support for using the	select
	or poll function
Date: Thu, 11 May 2017 22:50:05 +0100
Message-ID: <20170511215005.GI6155@agk-dp.fab.redhat.com>
References: <20170509191028.6898-1-agrover@redhat.com>
	<20170509191028.6898-2-agrover@redhat.com>
	<1494495579.6093.10.camel@suse.com>
	<1494495801.6093.12.camel@suse.com>
	<20170511132134.GA10709@redhat.com>
	<1494531043.6093.27.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1494531043.6093.27.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com, Andy Grover <agrover@redhat.com>, mpatocka@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Thu, May 11, 2017 at 09:30:43PM +0200, Martin Wilck wrote:
> I see - but I don't see yet how the ioctl approach (or the
> close()/open() based one, for that matter) would avoid this race.
>  1) application processes event N
>  2) event N+1 arrives in the kernel
>  3) user space issues ioctl or close()/open() sequence, N+1 is recorded
>     in priv->global_event_nr
>  4) user space runs poll()
>  5) event N+2 arrives 4 weeks later and poll returns
 
Well that userspace design is obviously not compatible with the set of 
patches that has been posted and is not what was proposed in the patch
headers.

Userspace records and compares event numbers.

ARM occurs immediately before LIST.  Any userspace processing in response
happens later.

Alasdair
