From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 7/7] dm mpath: remove extra nesting in map
 function when path exists
Date: Tue, 4 Feb 2014 03:27:23 +0000
Message-ID: <11AF7C027C4C02408624617A498607840105D634@BPXM12GP.gisp.nec.co.jp>
References: <1391459326-21569-1-git-send-email-snitzer@redhat.com>
	<1391459326-21569-8-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1391459326-21569-8-git-send-email-snitzer@redhat.com>
Content-Language: ja-JP
Content-ID: <36FB1D92E49BD241AF6EAFABACA5EFF6@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 02/04/14 05:28, Mike Snitzer wrote:
> Return early for case when no path exists, this eliminates the need for
> extra nesting for the case when a path exists (the common case).
...
> -	if (pgpath) {
> -		if (__pgpath_busy(pgpath))
> -			goto out_unlock;
> +	if (!pgpath) {

This should be "unlikely(!pgpath)".

> +	if (__pgpath_busy(pgpath))
> +		goto out_unlock;

The above 2 lines should be removed.
(Actually it is a comment for PATCH 1/7 but just in case.)

Other than that:

Reviewed-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

-- 
Jun'ichi Nomura, NEC Corporation
