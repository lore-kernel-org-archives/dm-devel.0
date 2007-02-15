From: "Bryn M. Reeves" <breeves@redhat.com>
Subject: Re: [PATCH 2.6.20] updated dm-loop patch
Date: Thu, 15 Feb 2007 12:28:10 +0000
Message-ID: <45D451DA.2000106@redhat.com>
References: <1628079706@web.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1628079706@web.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: devzero@web.de
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

devzero@web.de wrote:
> Hi Bryn, 
> 
> with this patch and also with 0.415 i have the following problem when compiling it with stock 2.6.20 :
> 
>   Building modules, stage 2.
>   MODPOST 1 modules
> WARNING: "invalidate_mapping_pages" [drivers/md/dm-loop.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> i found , that this was due to missing 
> 
> EXPORT_SYMBOL(invalidate_mapping_pages);
> 
> in mm/truncate.c 
> 
> i found 
> http://lkml.org/lkml/2007/1/3/154
> 
> it looks that this didn`t go into 2.6.20 and we need at least 2.6.20-git11 ?
> changelog at http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.20-git11.log telling that it had just had been merged on 10th of february:
> 

Hi Roland,

That's right - I keep my git tree fairly close to upstream, so as soon
as the patch that deprecated invalidate_inode_pages was merged, I
converted dm-loop to use invalidate_mapping_pages instead.

This means that dm-loop will build without warnings on the latest
kernel.org tree but it does mean that you will need the additional patch
you referenced if you want to apply it to a plain 2.6.20 kernel.

Kind regards,

Bryn.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFF1FHa6YSQoMYUY94RAl2iAKDAlrTqxDCNP7i/bhexl6JJGW1rNwCgksXz
5limiJOmDRoBKdHDUsU0pFE=
=HwdH
-----END PGP SIGNATURE-----
