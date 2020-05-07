From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH -next] dm mpath: Remove unused variable ret
Date: Thu, 7 May 2020 10:29:58 -0400
Message-ID: <20200507142958.GA12032@redhat.com>
References: <1588854412-19301-1-git-send-email-zou_wei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1588854412-19301-1-git-send-email-zou_wei@huawei.com>
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
To: Samuel Zou <zou_wei@huawei.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On Thu, May 07 2020 at  8:26am -0400,
Samuel Zou <zou_wei@huawei.com> wrote:

> This patch fixes below warning reported by coccicheck:
> 
> drivers/md/dm-historical-service-time.c:240:14-16: Unneeded variable: "sz". Return "0" on line 261
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Samuel Zou <zou_wei@huawei.com>

Nack.

DMEMIT() uses the local sz variable.
