From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH v2] dm: Fix alignment stacking on	partitioned
	devices
Date: Tue, 5 Jan 2010 18:27:35 +0000
Message-ID: <20100105182735.GC6042@agk-dp.fab.redhat.com>
References: <1261591640-24380-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1261591640-24380-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Wed, Dec 23, 2009 at 01:07:20PM -0500, Mike Snitzer wrote:
> +	if (blk_stack_limits(limits, &q->limits, offset) < 0)

extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
                            sector_t offset);

This function is asking for the offset to be supplied as sector_t i.e.
in units of sectors, but this patch uses bytes.  Please either change
that to sectors as per the prototype, or if it really does want bytes,
fix the prototype to make that clear.

Alasdair
