From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] libmultipath: I/O access overrun occured in
 mutipath device under the displayed capacity
Date: Wed, 26 Oct 2016 11:10:01 -0700
Message-ID: <0641fe0a-3299-7eb5-2aed-2115946222e6@sandisk.com>
References: <1477451932-7756-1-git-send-email-zhou.guichun@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1477451932-7756-1-git-send-email-zhou.guichun@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: zhou.guichun@zte.com.cn, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

On 10/25/2016 08:18 PM, zhou.guichun@zte.com.cn wrote:
> From: zhouguichun <zhou.guichun@zte.com.cn>
>
> I/O access overrun occured in mutipath device under
> the displayed capacity since that the displayed
> capacity is greater than the real capacity
> (Eg. a 3456M disk display as 3.4G).
>
> In this patch, we keep the displayed capacity three
> decimals by abandoning the rest of decimals instead
> of by rounding up(Eg. a 3.4567G disk display as
> 3.456G), so that the displayed capacity will not be
> greater than the real capacity, and the error will
> also be in a permissible range.

The motivation of this patch looks really weird to me. How could the 
rounding in snprint_size() cause an access past the end of a block 
device? Using the output of that function as block device size is wrong. 
Please use /sys/class/block/dm*/size instead.

Bart.
