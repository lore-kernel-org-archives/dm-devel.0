From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: Query: Significance of libmultipath/hwtable.c
Date: Wed, 12 Jun 2013 20:15:04 +0200
Message-ID: <1371060904.30106.4.camel@lapoo.opensvc.com>
References: <CAOUxTKPCj_k9JaAwS9w6zg56mzA+HGQOV_6aw8HzHRU_GpXj-g@mail.gmail.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAOUxTKPCj_k9JaAwS9w6zg56mzA+HGQOV_6aw8HzHRU_GpXj-g@mail.gmail.com>
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

On mer., 2013-06-12 at 11:45 +0530, amit mehta wrote:
> What is the significance of libmultipath/hwtable.c file. I see there
> is a list of vendors mentioned over here.
> 
> <snip>
> 
It's a database of defaults settings for known devices.
Those settings apply when not overriden by explicit settings in
multipath.conf.
  

> grep -i vendor libmultipath/hwtable.c|uniq
>         .vendor        = "COMPELNT",
>         .vendor        = "APPLE*",
>         .vendor        = "3PARdata",
>         .vendor        = "DEC",
>         .vendor        = "HP",
>         .vendor        = "(COMPAQ|HP)",
>         .vendor        = "HP",
>         .vendor        = "DDN",
>         .vendor        = "EMC",
>         .vendor        = "DGC",
>         .vendor        = "EMC",
>         .vendor        = "FSC",
>         .vendor        = "FUJITSU",
>         .vendor        = "HITACHI",
>         .vendor        = "IBM",
>         .vendor        = "IBM",
>         .vendor        = "AIX",
>         .vendor        = "IBM",
>         .vendor        = "AIX",
>         .vendor        = "IBM",
>         .vendor        = "AIX",
>         .vendor        = "DELL",
>         .vendor        = "NETAPP",
>         .vendor        = "IBM",
>         .vendor        = "Pillar",
>         .vendor        = "SGI",
>         .vendor        = "STK",
>         .vendor        = "SUN",
>         .vendor        = "PIVOT3",
>         .vendor        = "SUN",
>         .vendor        = "(LSI|ENGENIO)",
>         .vendor        = "STK",
>         .vendor        = "EUROLOGC",
>         .vendor        = "NEC",
>         .vendor        = NULL,
> 
> <snip>
> 
> 
> Under each of these vendors, there is a list of products from the same
> vendor as well. So does that mean, if the vendor and or product is
> not 
> mentioned in this file, that particular storage hardware may not be 
> supported by dm-multipath?
> 
It only means that the top-level defaults settings will be applied to
those multipaths.

Best regards,
Christophe Varoqui
www.opensvc.com
