From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [PATCH 5 of 10] LVM:  hack to make things work
Date: Sat, 27 Feb 2010 02:39:25 -0500
Message-ID: <4B88CC2D.6010207@redhat.com>
References: <201002262336.o1QNaTcS024350@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <201002262336.o1QNaTcS024350@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jbrassow@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Jonathan Brassow wrote:
> @@ -1559,11 +1569,16 @@ int lv_add_mirror_lvs(struct logical_vol
>   */
>  int lv_add_log_segment(struct alloc_handle *ah, struct logical_volume *log_lv)
>  {
> -	const char *segtype_name = ah->log_area_count > 1 ? "mirror" : "striped";
> +	int r;

I guess you forgot to remove "int r;".

Thanks,
Taka
