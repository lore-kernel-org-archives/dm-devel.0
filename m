From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/2] multipathd,
 libmultipathd: Make delays independent of clock jumps
Date: Mon, 3 Oct 2016 17:00:41 -0700
Message-ID: <a154032e-09cb-fed3-247d-1044900a6f27@sandisk.com>
References: <55a58c33-1edb-548d-f68b-d25cea442650@sandisk.com>
	<8a70d61e-cdb8-858b-eaec-6bf557412cc8@sandisk.com>
	<CABr-GndHANoDQrriUkZEnAKw+xr=W9MPk=AgrQX=G323+ZBv0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GndHANoDQrriUkZEnAKw+xr=W9MPk=AgrQX=G323+ZBv0A@mail.gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

On 10/03/2016 04:55 AM, Christophe Varoqui wrote:
> This patch seems to depend on another patch flagging tur.c some function
> static.
> It seems I missed this patch. Is it tanked in your tree, and you want to
> post it for inclusion ? Or do you prefer to rebase this "clock jump" patch ?

Hello Christophe,

I will post all patches that are in my tree as soon as I have finished 
testing these patches.

Bart.
