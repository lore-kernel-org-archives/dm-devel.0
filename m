From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 0/2] introduce interface to list all
	badblocks
Date: Thu, 18 Jun 2020 11:40:50 -0400
Message-ID: <20200618154050.GA18007@redhat.com>
References: <20200618090620.3517530-1-yangerkun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200618090620.3517530-1-yangerkun@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: yangerkun <yangerkun@huawei.com>
Cc: bmr@redhat.com, dm-devel@redhat.com, agk@redhat.com, bgurney@redhat.com
List-Id: dm-devel.ids

On Thu, Jun 18 2020 at  5:06am -0400,
yangerkun <yangerkun@huawei.com> wrote:

> 
> This patchset will list badblocks while we do 'dmsetup status'.
> 
> Image that we have mark block 1 and 2 as bad block, run following
> command will list all bad blocks:
> 
>     $ sudo dmsetup status dust1
>     0 33552384 dust 252:17 bypass verbose badblocks list: 1 2
> 
> v1->v2:
> Realize this logical in dust_status instead dust_message since the
> result can return to user directly.

Seems you've misundeerstood.  Please don't augment status to include the
listing of badblocks.  The list _could_ be extremely long.

The feedback you got earlier was to use DMEMIT() from the .message
hook.  And the listing would be provided as output from the 'dmsetup
message ...' command.

Mike
