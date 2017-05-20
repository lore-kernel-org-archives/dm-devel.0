From: "Zouming (IT)" <zouming.zouming@huawei.com>
Subject: Re: [PATCH] multipath-tools: delete vendor name HUASY
 for Huawei devices
Date: Sat, 20 May 2017 17:17:23 +0800
Message-ID: <a1e23307-2a9d-45c5-579e-e2d912e76bcc@huawei.com>
References: <1495268822-18564-1-git-send-email-zouming.zouming@huawei.com>
	<CABr-GneAwr2yFYvjigedLV32csn2jtAR3mK7G_2eOAB+T+9_HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GneAwr2yFYvjigedLV32csn2jtAR3mK7G_2eOAB+T+9_HQ@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: guanjunxiong@huawei.com, philip.yang@huawei.com, shenhong09@huawei.com, device-mapper development <dm-devel@redhat.com>, hege09@huawei.com, qiuxin@huawei.com
List-Id: dm-devel.ids

Hi christophe:

We absolutely sure for product XSG1,no arrays use vendor name HUASY.
Because these arrays are our up-to-date product.

Best regards,
Zou Ming.

On 2017/5/20 17:02, Christophe Varoqui wrote:
> Hi,
> 
> question is, is there arrays in the wild exposing this vendor name ?
> If so, we'll rather keep its defaults for the decade to come.
> 
> Best regards,
> Christophe.
> 
> On Sat, May 20, 2017 at 10:27 AM, Zou Ming <zouming.zouming@huawei.com <mailto:zouming.zouming@huawei.com>> wrote:
> 
>     For product XSG1,HUASY is obsolete for Huawei devices,Only HUAWEI is the official vendor name.
>     ---
>      libmultipath/hwtable.c | 2 +-
>      1 file changed, 1 insertion(+), 1 deletion(-)
> 
>     diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
>     index 54309ef..bd8719c 100644
>     --- a/libmultipath/hwtable.c
>     +++ b/libmultipath/hwtable.c
>     @@ -881,7 +881,7 @@ static struct hwentry default_hw[] = {
>              */
>             {
>                     /* OceanStor V3 */
>     -               .vendor        = "(HUAWEI|HUASY)",
>     +               .vendor        = "HUAWEI",
>                     .product       = "XSG1",
>                     .pgpolicy      = MULTIBUS,
>             },
>     --
>     2.6.4.windows.1
> 
> 
>     --
>     dm-devel mailing list
>     dm-devel@redhat.com <mailto:dm-devel@redhat.com>
>     https://www.redhat.com/mailman/listinfo/dm-devel <https://www.redhat.com/mailman/listinfo/dm-devel>
> 
> 
