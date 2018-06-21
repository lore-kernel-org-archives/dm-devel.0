From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 4.17.0-rc3 1/2] dm: Reduce line length
Date: Thu, 21 Jun 2018 08:26:00 -0400
Message-ID: <20180621122600.GA9973@redhat.com>
References: <20180621120231.GA5346@umar>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180621120231.GA5346@umar>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ssemagoye Umar Munddu <ssemagoyeumar@gmail.com>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Thu, Jun 21 2018 at  8:02am -0400,
Ssemagoye Umar Munddu <ssemagoyeumar@gmail.com> wrote:

> Signed-off-by: Ssemagoye Umar Munddu <ssemagoyeumar@gmail.com>
> ---
>  drivers/md/dm.c | 187 +++++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 123 insertions(+), 64 deletions(-)

There is absolutely no way I'm taking this.

I'm fine with DM code extending beyond 80 columns if it helps with
reading the code.  All you've done is make a mess of everything in
pursuit of satisfying a one-size-fits-all tool.

Worse, if I were to take this change, it'd step all over the git history
of the code.

So, PLEASE do not submit any more patches like this for DM.

Thanks,
Mike
