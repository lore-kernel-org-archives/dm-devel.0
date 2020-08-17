From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH 0/2] dm-devel:dm-crypt: infrastructure for measurement
 of DM target data using IMA
Date: Mon, 17 Aug 2020 17:46:08 -0400
Message-ID: <5f12cc89c535ccfc6c3d63efa2bf716a1fdd966d.camel@linux.ibm.com>
References: <20200816210250.11506-1-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200816210250.11506-1-tusharsu@linux.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>, agk@redhat.com, snitzer@redhat.com, gmazyland@gmail.com
Cc: tyhicks@linux.microsoft.com, sashal@kernel.org, jmorris@namei.org, nramas@linux.microsoft.com, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, 2020-08-16 at 14:02 -0700, Tushar Sugandhi wrote:
> There are several device-mapper targets which contribute to verify
> the integrity of the mapped devices e.g. dm-integrity, dm-verity,
> dm-crypt etc.
> 
> But they do not use the capabilities provided by kernel integrity
> subsystem (IMA). For instance, the IMA capability that measures several
> in-memory constructs and files to detect if they have been accidentally
> or maliciously altered, both remotely and locally. IMA also has the
> capability to include these measurements in the IMA measurement list and
> use them to extend a TPM PCR so that it can be quoted.

"both remotely" refers to measurement and attestation, while "locally"
refers to integrity enforcement, based on hashes or signatures.  Is
this patch set adding both IMA-measurement and IMA-appraisal?

Mimi

>  These TPM PCR
> extend operations ensure that the tampering with the order of constructs
> being measured, and tampering with the measured constructs themselves -
> doesn't go undetected. In general, this capability is used for remote
> attestation of in-memory constructs and files of interest. As of today,
> device-mapper targets don't use the benefits of extended TPM PCR
> quotes and ultimately the benefits of remote attestation.
> 
> This series bridges this gap, so that all device-mapper targets
> could take advantage of IMA's measuring and quoting abilities - thus
> ultimately enabling remote attestation for device-mapper targets.
> 
> This series is based on the following repo/branch:
>  repo: https://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git
>  branch: next-integrity
>  commit 3db0d0c276a7 ("integrity: remove redundant initialization of variable ret")
> 
> This series also has a dependency on the following patch series and
> should be applied in the following order:
>  1. https://patchwork.kernel.org/patch/11709527/
>  2. https://patchwork.kernel.org/patch/11711249/
>  3. https://patchwork.kernel.org/patch/11712729/
> 
> Tushar Sugandhi (2):
>   dm-devel: collect target data and submit to IMA to measure
>   dm-crypt: collect data and submit to DM to measure
> 
>  drivers/md/Makefile            |   1 +
>  drivers/md/dm-crypt.c          | 170 +++++++++++++++++++
>  drivers/md/dm-ima.c            | 296 +++++++++++++++++++++++++++++++++
>  include/linux/device-mapper.h  |  58 +++++++
>  security/integrity/ima/Kconfig |   2 +-
>  5 files changed, 526 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/md/dm-ima.c
> 
