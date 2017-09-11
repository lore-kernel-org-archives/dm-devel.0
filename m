From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 2/2] dm: allow device-mapper to operate without dax
 support
Date: Mon, 11 Sep 2017 08:56:01 -0700
Message-ID: <CAPcyv4gBLPsogW_SUkBuAnZggP1WZqkNZZrxFZef7pmGFFFNkA@mail.gmail.com>
References: <150169667935.39569.15808116323143633486.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150169668989.39569.8174620146135008137.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170911144111.GA15556@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170911144111.GA15556-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Mon, Sep 11, 2017 at 7:41 AM, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, Aug 02 2017 at  1:58pm -0400,
> Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
>> Rather than have device-mapper directly 'select DAX', let the fact that
>> BLK_DEV_PMEM selects dax act as a gate for the device-mapper dax
>> support. We arrange for all the dax core routines to compile to nops
>> when CONFIG_DAX=n. With that in place we can simply handle the
>> alloc_dax() error as expected and ifdef out the other device-mapper-dax
>> support code.
>>
>> Now, if dax is provided by a leaf driver that driver may only arrange to
>> compile the dax core as a module. Since device-mapper dax support is
>> consumed by the always-built-in portion of the device-mapper
>> implementation we need to upgrade from DAX=m to DAX=y.
>
> I applied the patches and then got nervous once I dug in.. this last
> paragraph makes little sense to me.  "the always-built-in portion of the
> device-mapper implementation" is why: DM core can happily be compiled as
> a module (dm-mod.ko).
>
> And I'm not sure why you're referencing DAX related
> drivers/md/dm-builtin.c, why are you attachd DM's DAX support to that?
> I'm not seeing where that is actually happening.
>
> I don't see why DM's support for DAX would need to force DAX to be
> builtin rather than just a module.
>
> Sorry I didn't get around to looking at this until now, but it seems you
> went wrong along the way?  Or maybe I'm just missing something?
>

No, my fault, I didn't track BLK_DEV_DM_BUILTIN correctly and we can
safely make DAX a module when CONFIG_BLK_DEV_DM=m. I'll fix that up,
thanks for the catch.
