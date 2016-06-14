From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
Date: Tue, 14 Jun 2016 00:30:58 -0700
Message-ID: <CAPcyv4jjaRBCuX3=8w-Yun79SZ25kp553Nc_WT5KBoPKq81bnw@mail.gmail.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
	<CAPcyv4jdM1phR=kGoP2-7tfsVvbNe2C6hHNS5TD28ALGZQQTSw@mail.gmail.com>
	<1465861755.3504.185.camel@hpe.com>
	<CAPcyv4hnKRc6qrPPuKo1r3=YmuAAaeSSv7xBOpDMAy5UuUhoHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4hnKRc6qrPPuKo1r3=YmuAAaeSSv7xBOpDMAy5UuUhoHw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "agk@redhat.com" <agk@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 13, 2016 at 5:02 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, Jun 13, 2016 at 4:59 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
>> On Mon, 2016-06-13 at 16:18 -0700, Dan Williams wrote:
>>> Thanks Toshi!
>>>
>>> On Mon, Jun 13, 2016 at 3:21 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
>>> >
>>> > This patch-set adds DAX support to device-mapper dm-linear devices
>>> > used by LVM.  It works with LVM commands as follows:
>>> >  - Creation of a logical volume with all DAX capable devices (such
>>> >    as pmem) sets the logical volume DAX capable as well.
>>> >  - Once a logical volume is set to DAX capable, the volume may not
>>> >    be extended with non-DAX capable devices.
>>>
>>> I don't mind this, but it seems a policy decision that the kernel does
>>> not need to make.  A sufficiently sophisticated user could cope with
>>> DAX being available at varying LBAs.  Would it be sufficient to move
>>> this policy decision to userspace tooling?
>>
>> I think this is a kernel restriction.  When a block device is declared as
>> DAX capable, it should mean that the whole device is DAX capable.  So, I
>> think we need to assure the same to a mapped device.
>
> Hmm, but we already violate this with badblocks.  The device is DAX
> capable, but certain LBAs will return an error if direct_access is
> attempted.

Nevermind, for this to be useful we would need to fallback to regular
mmap for a portion of the linear span.  That's different than the
badblocks case.
