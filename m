From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
Date: Mon, 13 Jun 2016 16:18:18 -0700
Message-ID: <CAPcyv4jdM1phR=kGoP2-7tfsVvbNe2C6hHNS5TD28ALGZQQTSw@mail.gmail.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hpe.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, dm-devel@redhat.com, linux-raid <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

Thanks Toshi!

On Mon, Jun 13, 2016 at 3:21 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> This patch-set adds DAX support to device-mapper dm-linear devices
> used by LVM.  It works with LVM commands as follows:
>  - Creation of a logical volume with all DAX capable devices (such
>    as pmem) sets the logical volume DAX capable as well.
>  - Once a logical volume is set to DAX capable, the volume may not
>    be extended with non-DAX capable devices.

I don't mind this, but it seems a policy decision that the kernel does
not need to make.  A sufficiently sophisticated user could cope with
DAX being available at varying LBAs.  Would it be sufficient to move
this policy decision to userspace tooling?

> The direct_access interface is added to dm and dm-linear to map
> a request to a target device.

I had dm-linear and md-raid0 support on my list of things to look at,
did you have raid0 in your plans?
