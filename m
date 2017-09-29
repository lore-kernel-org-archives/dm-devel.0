From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v5 1/2] dax: introduce CONFIG_DAX_DRIVER
Date: Fri, 29 Sep 2017 16:11:51 +1000
Message-ID: <87o9puuj88.fsf@concordia.ellerman.id.au>
References: <150609750020.25862.11458070207401120153.stgit@dwillia2-desk3.amr.corp.intel.com> <150609750599.25862.7194470012203223173.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <150609750599.25862.7194470012203223173.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, snitzer@redhat.com
Cc: linux-nvdimm@lists.01.org, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, dm-devel@redhat.com, Paul Mackerras <paulus@samba.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-Id: dm-devel.ids

Dan Williams <dan.j.williams@intel.com> writes:

> In support of allowing device-mapper to compile out idle/dead code when
> there are no dax providers in the system, introduce the DAX_DRIVER
> symbol. This is selected by all leaf drivers that device-mapper might be
> layered on top. This allows device-mapper to conditionally 'select DAX'
> only when a provider is present.
>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Bart Van Assche <Bart.VanAssche@wdc.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/powerpc/platforms/Kconfig |    1 +
>  drivers/block/Kconfig          |    1 +
>  drivers/dax/Kconfig            |    4 +++-
>  drivers/nvdimm/Kconfig         |    1 +
>  drivers/s390/block/Kconfig     |    1 +
>  5 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
> index 4fd64d3f5c44..4561340c1f92 100644
> --- a/arch/powerpc/platforms/Kconfig
> +++ b/arch/powerpc/platforms/Kconfig
> @@ -296,6 +296,7 @@ config AXON_RAM
>  	tristate "Axon DDR2 memory device driver"
>  	depends on PPC_IBM_CELL_BLADE && BLOCK
>  	select DAX
> +	select DAX_DRIVER


I would have thought you'd want to replace the select of DAX with
a select of DAX_DRIVER?

With the driver selecting both there's no need for the core to select
DAX, because all the DAX drivers have done it already.

cheers
