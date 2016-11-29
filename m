From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] dm-mpath: Remove useless
 retain_attached_hw_handler parameter
Date: Mon, 28 Nov 2016 19:28:01 -0500
Message-ID: <20161129002801.GA8989@redhat.com>
References: <1479971509-6320-1-git-send-email-tang.junhui@zte.com.cn>
	<1479971509-6320-2-git-send-email-tang.junhui@zte.com.cn>
	<20161128213907.GB7844@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20161128213907.GB7844@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tang.junhui@zte.com.cn
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Mon, Nov 28 2016 at  4:39pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Nov 24 2016 at  2:11am -0500,
> tang.junhui@zte.com.cn <tang.junhui@zte.com.cn> wrote:
> 
> > From: "tang.junhui" <tang.junhui@zte.com.cn>
> > 
> > Hardware handle would be retained no matter parameter
> > retain_attached_hw_handler is set or not in the logic
> > of current code. So remove this useless parameter.
> 
> Right, that wasn't always the case.  Previously (before commit )
> dm-mpath would first detach the attached handler.

meant to reference commit 1bab0de02 ("dm-mpath, scsi_dh: don't let dm
detach device handlers")
