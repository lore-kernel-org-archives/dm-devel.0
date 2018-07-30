From: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [External]  [PATCH v2 2/6] s390, dcssblk: kaddr and pfn can be
 NULL to ->direct_access()
Date: Mon, 30 Jul 2018 07:14:58 +0200
Message-ID: <20180730071458.42e3c5a1@mschwideX1>
References: <20180725162849.8320-1-yehs2007@zoho.com>
 <20180725162849.8320-3-yehs2007@zoho.com>
 <TY2PR03MB334328133134A67C87E5CC5C92290@TY2PR03MB3343.apcprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <TY2PR03MB334328133134A67C87E5CC5C92290-9Zl3wwa4NoIz0wPdwKFbI682SN/2zMuYvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Huaisheng HS1 Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>
Cc: "jack-AlSwsSmVLrQ@public.gmane.org" <jack-AlSwsSmVLrQ@public.gmane.org>, "snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "bart.vanassche-Sjgp3cTcYWE@public.gmane.org" <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, NingTing Cheng <chengnt-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>, "colyli-l3A5Bk7waGM@public.gmane.org" <colyli-l3A5Bk7waGM@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: dm-devel.ids

On Sat, 28 Jul 2018 04:07:25 +0000
Huaisheng HS1 Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org> wrote:

> May I have your ack's for this patch? The whole series would be applied
> to libnvdimm if it could get your approval.
> And any suggestion is welcome.

Sure, it is just two additional ifs. I did not think that this needed an
ack, but here you go:

Acked-by: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>

> 
> Cheers,
> Huaisheng Ye
> 
> > From: Huaisheng Ye <yehs2007-ytc+IHgoah0@public.gmane.org>
> > Sent: Thursday, July 26, 2018 12:29 AM
> > 
> > From: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>
> > 
> > dcssblk_direct_access() needs to check the validity of pointers kaddr
> > and pfn for NULL assignment. If anyone equals to NULL, it doesn't need
> > to calculate the value.
> > 
> > If either of them is equal to NULL, that is to say callers may
> > have no need for kaddr or pfn, so this patch is prepared for allowing
> > them to pass in NULL instead of having to pass in a pointer or local
> > variable that they then just throw away.
> > 
> > Signed-off-by: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/s390/block/dcssblk.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
> > index ed60728..23e526c 100644
> > --- a/drivers/s390/block/dcssblk.c
> > +++ b/drivers/s390/block/dcssblk.c
> > @@ -922,9 +922,11 @@ static DEVICE_ATTR(save, S_IWUSR | S_IRUSR, dcssblk_save_show,
> >  	unsigned long dev_sz;
> > 
> >  	dev_sz = dev_info->end - dev_info->start + 1;
> > -	*kaddr = (void *) dev_info->start + offset;
> > -	*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset),
> > -			PFN_DEV|PFN_SPECIAL);
> > +	if (kaddr)
> > +		*kaddr = (void *) dev_info->start + offset;
> > +	if (pfn)
> > +		*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset),
> > +				PFN_DEV|PFN_SPECIAL);
> > 
> >  	return (dev_sz - offset) / PAGE_SIZE;
> >  }
> > --
> > 1.8.3.1  
> 


-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.
