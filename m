From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RESEND] [PATCH linux-2.6-block#for-2.6.32] Seperate
	read and write statistics of in_flight requests
Date: Fri, 11 Sep 2009 09:17:53 +0200
Message-ID: <20090911071753.GC18599@kernel.dk>
References: <200908241603.15158.knikanth@suse.de>
	<20090824110735.GI12579@kernel.dk>
	<200908241754.08592.knikanth@suse.de>
	<200909110913.46769.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200909110913.46769.knikanth@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: dm-devel@redhat.com, Mark Landis <mark.landis@teradata.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Sep 11 2009, Nikanth Karthikesan wrote:
> Currently, there is a single in_flight counter measuring the number of
> requests in the request_queue. But some monitoring tools would like to
> know how many read requests and write requests are in progress. Split the
> current in_flight counter into two seperate counters for read and write.
> 
> This information is exported as a sysfs attribute, as changing the
> currently available stat files would break the existing tools.

Applied, this is better than breaking existing stat exports.

-- 
Jens Axboe
