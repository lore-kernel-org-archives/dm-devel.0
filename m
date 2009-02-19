From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm mpath: delay retry activate_path on
	SCSI_DH_RETRY
Date: Thu, 19 Feb 2009 02:11:18 +0000
Message-ID: <20090219021118.GA3962@agk.fab.redhat.com>
References: <200902171917.38252.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200902171917.38252.knikanth@suse.de>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Feb 17, 2009 at 07:17:37PM +0530, Nikanth Karthikesan wrote:
> Delay retry to activate_path if it returns SCSI_DH_RETRY.
 
Please write a complete patch header if you'd like this queued for upstream!

E.g. Why?  Any cases where this will make matters worse or make no difference?

> +	unsigned long pg_init_jiffy;	/* To delay retry if SCSI_DH_RETRY */
> +#define SCSI_DH_RETRY_DELAY ((HZ * 2))
  
Why that particular value?
Please move it into a header file with an explanation of what it does.

Alasdair
-- 
agk@redhat.com
