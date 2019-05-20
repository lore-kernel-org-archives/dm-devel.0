From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH] multipath-tools (coverity): assert
 availability of CLOCK_MONOTONIC
Date: Mon, 20 May 2019 22:13:16 +0200
Message-ID: <bb911c9ca3b0329431753104c2bf99f5a55a50ac.camel@suse.de>
References: <20190520163008.20642-1-mwilck@suse.com>
	<70067e86-7f4a-ff06-d747-4f8402199a2f@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <70067e86-7f4a-ff06-d747-4f8402199a2f@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, mwilck+gmail@suse.de
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, 2019-05-20 at 22:09 +0200, Bart Van Assche wrote:
> On 5/20/19 6:30 PM, Martin Wilck wrote:
> > +void get_monotonic_time(struct timespec *res)
> > +{
> > +	struct timespec ts;
> > +
> > +	assert(clock_gettime(CLOCK_MONOTONIC, &ts) == 0);
> > +	*res = ts;
> > +}
> 
> This is an example of bad coding style because the clock_gettime()
> call
> will be skipped if anyone would compile this code with -DNDEBUG.

I'd rather call it an example of me being ignorant ...
Thanks a lot for pointing it out.

Martin
