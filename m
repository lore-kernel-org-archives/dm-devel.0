From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: randconfig build error with next-20150908, in
 drivers/md/dm-mpath.c
Date: Fri, 11 Sep 2015 14:29:03 -0400
Message-ID: <20150911182902.GB25678@redhat.com>
References: <CA+r1ZhgR=dO0ezk0Nm0JuAb1D0AU7K2Am=Pyy9aPqCMsLW9Y0w@mail.gmail.com>
 <20150908172356.GA1584@redhat.com>
 <20150909160418.GB28608@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150909160418.GB28608@lst.de>
Sender: linux-next-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, James Bottomley <JBottomley@Odin.com>, linux-kernel <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, linux-next <linux-next@vger.kernel.org>, Jim Davis <jim.epost@gmail.com>, agk@redhat.com
List-Id: dm-devel.ids

On Wed, Sep 09 2015 at 12:04pm -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Does this fix the issue for you?  My Kconfig-fu isn't the best,
> but the idea behind this is that dm-mpath will depend on SCSI
> if SCSI_DH is set.  If SCSI_DH is not set it will use the stubs
> and not care about SCSI.
> 
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index b597273..e9ea681 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -393,7 +393,7 @@ config DM_MULTIPATH
>  	# of SCSI_DH if the latter isn't defined but if
>  	# it is, DM_MULTIPATH must depend on it.  We get a build
>  	# error if SCSI_DH=m and DM_MULTIPATH=y
> -	depends on SCSI_DH || !SCSI_DH
> +	depends on !SCSI_DH || SCSI
>  	---help---
>  	  Allow volume managers to support multipath hardware.
>  

I verified (with next-20150911) that without your patch I saw the
reported problem using the provided randconfig (that had
CONFIG_SCSI_DH=y and CONFIG_DM_MULTIPATH=y):

drivers/built-in.o: In function `activate_path':
/root/snitm/git/linux/drivers/md/dm-mpath.c:1225: undefined reference to `scsi_dh_activate'
drivers/built-in.o: In function `parse_path':
/root/snitm/git/linux/drivers/md/dm-mpath.c:581: undefined reference to `scsi_dh_attached_handler_name'
/root/snitm/git/linux/drivers/md/dm-mpath.c:600: undefined reference to `scsi_dh_attach'
/root/snitm/git/linux/drivers/md/dm-mpath.c:615: undefined reference to `scsi_dh_set_params'
make: *** [vmlinux] Error 1

But with your patch the build completes successfully.

James, please feel free to pull in Christoph's patch and add my:

Tested-by: Mike Snitzer <snitzer@redhat.com>
