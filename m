From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: feature="1 queue_if_no_path" vs. no_path_retry=queue
Date: Tue, 20 Sep 2011 12:05:00 +0900
Message-ID: <4E7802DC.5090009@ct.jp.nec.com>
References: <20110916224737.GB31898@orenhe-laptop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110916224737.GB31898@orenhe-laptop>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

Oren Held wrote:
> Hi,
> 
> According to all docs I've read, and some code, the following settings seem to have the same effect:
> 1. Setting features = "1 queue_if_no_path"
> 2. Setting no_path_retry = "queue"
> 
> Now that's confusing, especially when having conflicting configuration, e.g., from hwtable.c:
>                 /* IBM DS4100 */
>                 .vendor        = "IBM",
>                 .product       = "1724",
>                 .features      = "1 queue_if_no_path",
>                 .no_path_retry = 300,
> 
> It's not clear enough what would be the resulting behavior of this configuration.
> 
> Did I get it right? Is there a reason for keeping the features = "1 queue_if_no_path" option available in multipath-tools?

See http://marc.info/?l=dm-devel&m=124572577028515&w=2

Thanks,
Kiyoshi Ueda


> Thanks
> 
> Regards
> 
> - Oren
