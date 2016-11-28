From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] dm-mpath: Enable hw_handler_params to
 take effect if hw_handler is the same between new and old
Date: Mon, 28 Nov 2016 16:23:57 -0500
Message-ID: <20161128212357.GA7844@redhat.com>
References: <1479971509-6320-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1479971509-6320-1-git-send-email-tang.junhui@zte.com.cn>
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

On Thu, Nov 24 2016 at  2:11am -0500,
tang.junhui@zte.com.cn <tang.junhui@zte.com.cn> wrote:

> From: "tang.junhui" <tang.junhui@zte.com.cn>
> 
> If the hardware handle which a device has already attached is the same
> with m->hw_handler_name, m->hw_handler_params should not be ignored, but
> be enabled to take effect.
> 
> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>

I tweaked this a little bit and staged it for 4.10, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.10&id=1422b33eda2ffbc70eb11163bf7ac1e59ebba222
