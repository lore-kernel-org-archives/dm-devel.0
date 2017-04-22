From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH for-4.12] block, dm: use __blk_integrity_register to
 properly setup integrity profile
Date: Sat, 22 Apr 2017 11:10:43 -0400
Message-ID: <20170422151043.GA22651@redhat.com>
References: <20170421222815.45663-1-snitzer@redhat.com>
 <yq1o9vpjs9f.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1o9vpjs9f.fsf@oracle.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, linux-block@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Fri, Apr 21 2017 at  6:43pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> 
> Mike/Mikulas,
> 
> > Introduce __blk_integrity_register() to allow users more precise control
> > over the logical block size used to register the integrity profile.
> > blk_integrity_register() now calls __blk_integrity_register().
> 
> This seems a bit kludgy. It would be cleaner having the integrity
> interval be explicitly specified in the integrity template for all
> callers. Maybe with a fallback to qlbs if it's set to 0.

Fair enough, I'll revise and send v2 shortly.  Thanks.
