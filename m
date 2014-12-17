From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: check error instead of r in clone_endio
Date: Wed, 17 Dec 2014 12:34:43 -0500
Message-ID: <20141217173443.GC27737@redhat.com>
References: <54912490.8030808@huawei.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <54912490.8030808@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: alex chen <alex.chen@huawei.com>
Cc: device-mapper development <dm-devel@redhat.com>, Joseph Qi <joseph.qi@huawei.com>
List-Id: dm-devel.ids

On Wed, Dec 17 2014 at  1:37am -0500,
alex chen <alex.chen@huawei.com> wrote:

> In the clone_endio, when target_type is linear and WRITE SAME bio
> fails, r will be always be initialized 0 because of null end_io, and
> in this case WRITE SAME will not be disabled.
> So we should check error instead of r.
> 
> Signed-off-by: Alex Chen <alex.chen@huawei.com>

I've fixed it a bit differently (clone_endio now matches dm_done) and
have staged it for 3.19, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=5164bece1673cdf04782f8ed3fba70743700f5da

Thanks.
