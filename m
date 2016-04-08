From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] dm service time: measure service time
 rather than approximate it
Date: Fri, 8 Apr 2016 15:03:49 -0400
Message-ID: <20160408190349.GA8453@redhat.com>
References: <1460141919-12177-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1460141919-12177-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: j-nomura@ce.jp.nec.com, tgill@redhat.com
List-Id: dm-devel.ids

On Fri, Apr 08 2016 at  2:58pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> The DM multipath service-time path-selector has historically tracked the
> amount of outstanding IO per path and used that to approximate the
> service-time of each path.  In practice this has shown itself to work
> fairly well but we can do better by measuring the actual service-time
> during IO completion and using it as the basis for path selection.
> 
> Measuring the actual service-time is still prone to inaccuracies given
> that service-times vary with IO size.  But to counter any potential for
> drawing incorrect conclusions about the service-times of a given path
> the measured service-times are reset periodically.
> 
> This approach has provided a 10% increase in the selection of a path
> that was forcibly made to be less loaded than the alternative path.
> 
> Reported-by: Todd Gill <tgill@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

It should be noted that I have not looked at the implications on actual
throughput or system load.  But I wanted to get this RFC out to see what
others thought about making dm-service-time more intuitive in its
implementation.

Junichi, it'd also be great if you could provide historic context for
why you elected to approximate the service-time based on outstanding IO
rather than measure the actual service-time of each path.

Thanks,
Mike
