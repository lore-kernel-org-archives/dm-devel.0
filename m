From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-raid: check for zero feature flags
	in	metadata
Date: Sat, 30 Apr 2016 01:31:16 +0100
Message-ID: <20160430003116.GA27436@agk-dp.fab.redhat.com>
References: <1461949196-17999-1-git-send-email-heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1461949196-17999-1-git-send-email-heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Apr 29, 2016 at 06:59:56PM +0200, heinzm@redhat.com wrote:
> +	rs->ti->error = "Unable to assemble array: No feature flags supported yet";
> +	if (le32_to_cpu(sb->features)) /* No features supported yet */

Is it worth splitting this into compat_flags and incompat_flags like we did in
thin and cache? 

Alasdair
