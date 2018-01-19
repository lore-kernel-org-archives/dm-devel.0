From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] FIX "libmultipath: hwtable: multibus for
	NetApp NVMe-FC"
Date: Fri, 19 Jan 2018 15:44:09 +0100
Message-ID: <2ae5f020-e508-5cdd-0ada-d944ccba47f7@gmail.com>
References: <20180113211938.31552-10-mwilck@suse.com>
	<20180119115223.4625-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180119115223.4625-1-mwilck@suse.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 01/19/2018 12:52 PM, Martin Wilck wrote:
> There was an extra parenthesis in the patch I submitted
> previously.

>  		.vendor	       = "NVME",
> -		.product       = "(NetApp |)ONTAP Controller)",
> +		.product       = "(NetApp |)ONTAP Controller",

Out of curiosity, what are the complete product and vendor id strings?
