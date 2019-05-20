From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] multipath-tools (coverity): assert
 availability of CLOCK_MONOTONIC
Date: Mon, 20 May 2019 22:09:56 +0200
Message-ID: <70067e86-7f4a-ff06-d747-4f8402199a2f@acm.org>
References: <20190520163008.20642-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190520163008.20642-1-mwilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 5/20/19 6:30 PM, Martin Wilck wrote:
> +void get_monotonic_time(struct timespec *res)
> +{
> +	struct timespec ts;
> +
> +	assert(clock_gettime(CLOCK_MONOTONIC, &ts) == 0);
> +	*res = ts;
> +}

This is an example of bad coding style because the clock_gettime() call
will be skipped if anyone would compile this code with -DNDEBUG.

Bart.
