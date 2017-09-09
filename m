From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 0/2] dax, dm: stop requiring dax for device-mapper
Date: Sat, 9 Sep 2017 11:56:43 -0700
Message-ID: <CAPcyv4iTkv_5yR2aLz+wwE=XkwmwOtWUB3_4O3jcVjkf27XYwQ@mail.gmail.com>
References: <150169667935.39569.15808116323143633486.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170802185537.GA16551@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170802185537.GA16551@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: kbuild test robot <lkp@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Michael Ellerman <mpe@ellerman.id.au>, Heiko Carstens <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, dm-devel@redhat.com, Paul Mackerras <paulus@samba.org>, Alasdair Kergon <agk@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Wed, Aug 2, 2017 at 11:55 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Wed, Aug 02 2017 at  1:57pm -0400,
> Dan Williams <dan.j.williams@intel.com> wrote:
>
>> Changes since v2 [1]:
>> * rebase on -next to integrate with commit 273752c9ff03 "dm, dax: Make
>>   sure dm_dax_flush() is called if device supports it" (kbuild robot)
>> * fix CONFIG_DAX dependencies to upgrade CONFIG_DAX=m to CONFIG_DAX=y
>>   (kbuild robot)
>>
>> [1]: https://www.spinics.net/lists/kernel/msg2570522.html
>>
>> ---
>>
>> Bart points out that the DAX core is unconditionally enabled if
>> device-mapper is enabled. Add some config machinery and some
>> stub-static-inline routines to allow dax infrastructure to be deleted
>> from device-mapper at compile time.
>>
>> Since this depends on commit 273752c9ff03 that's already in -next, this
>> should go through the device-mapper tree.
>
> Commit 273752c9ff03eb83856601b2a3458218bb949e46 is upstream as of
> v4.13-rc3 -- so no real need to have this go via linux-dm.git
>
> That said, I don't mind picking it up once we are satisfied with the
> implementation.  I'll start reviewing shortly.

Hi Mike,

Friendly reminder about this cleanup...
