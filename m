From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: DM configuration
Date: Mon, 10 Oct 2005 14:23:22 +0200
Message-ID: <20051010122322.GA23091@free.fr>
References: <3456F611E9329441B12FBB24447B3FA002CC6311@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <3456F611E9329441B12FBB24447B3FA002CC6311@bgeexc01.asiapacific.cpqcorp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Oct 10, 2005 at 05:19:45PM +0530, Murthy, Narasimha Doraswamy (STSD) wrote:
> Christophe,
> The one mentioned below will be success for the regular expressions that
> matches anywhere in the string. Can we modify strcmp_chomp(...) in
> <multipath-src>/libmultipath/utils.c  as below:
> 
> # diff util.c util.c.mod 
> 29c29
> <       return(strcmp(s1,s2));
> ---
> >       return(strncmp(s1,s2,strlen(s1)));
>  
> so that both the partial string and the complete string can be compared.
> 
> 
Hello,

I fear I don't understand your mail : Isn't the regexp solution enought ? Is 
it overkill ? Why modify strcmp_chomp(), as it no longer is in the find_hwe() 
code path ?

With the patch I posted you can specify vendor/product ids like this :

       device {
                vendor                  IET
                product                 V.RTUAL.*K
       }

Isn't that what you asked for ?

Regards,
cvaroqui
