From: Huaisheng HS1 Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>
Subject: RE: [External]  Re: [PATCH v2 0/6] kaddr and pfn can be NULL to
 ->direct_access()
Date: Thu, 26 Jul 2018 01:29:19 +0000
Message-ID: <TY2PR03MB3343365E80CCBC374C0EFDD4922B0@TY2PR03MB3343.apcprd03.prod.outlook.com>
References: <20180725162849.8320-1-yehs2007@zoho.com>
 <3689520a-4a49-4e1f-6ee9-2ff4a9796b9f@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <3689520a-4a49-4e1f-6ee9-2ff4a9796b9f-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: zh-CN
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "jack-AlSwsSmVLrQ@public.gmane.org" <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, NingTing Cheng <chengnt-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>, "heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "colyli-l3A5Bk7waGM@public.gmane.org" <colyli-l3A5Bk7waGM@public.gmane.org>, "bart.vanassche-Sjgp3cTcYWE@public.gmane.org" <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

> From: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Sent: Thursday, July 26, 2018 5:36 AM
> Subject: [External] Re: [PATCH v2 0/6] kaddr and pfn can be NULL to ->direct_access()
> 
> Pretty straight forward series. Huaisheng, I can apply the whole series
> to libnvdimm if we can get ack's from maintainer of dcssblk and
> dm-writecache for the respective bits.

Thanks Dave and Ross.

Hi Jan an Dan,

The previous patch series for NULL-pfn had got your Reviewed-by or Signed-off-by.
Now I have expanded them to local pointer kaddr, can I get your Reviewed-by for current
patch series? Your acks are very important to me.

Cheers,
Huaisheng Ye
