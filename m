From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: 1st of 2 patches for dm_emc.c and dm-multipath
 hardware handler interface
Date: Fri, 08 Sep 2006 12:21:19 -0500
Message-ID: <4501A68F.8050708@cs.wisc.edu>
References: <6CCEAEDF4D06984A83F427424F47D6E4013D1397@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6CCEAEDF4D06984A83F427424F47D6E4013D1397@CORPUSMX40A.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Edward Goggin <egoggin@emc.com>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Edward Goggin wrote:
> +
> +	rq->buffer = rq->data = h->buffer;
> +	rq->data_len = len;
> +	rq->bio = rq->biotail = NULL;
>  

I think I only suggested that you use the block layer map functions in
the previous review. Now I will say, use them and fix the core code to
not allocate memory or use a mempool since it will also fix the path
testers at the same time :) The reason is that the scsi layer is trying
to make every thing run with scatterlists. In 2.6.18, every place is
converted (they should be at least), so you should not be adding another
place where we send down a data buffer like this.
