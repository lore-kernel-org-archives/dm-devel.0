From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: dm: enable opt-out of device-mapper dax support
Date: Tue, 1 Aug 2017 14:19:50 -0700
Message-ID: <CAPcyv4gjN8AykVO2RoNorR0mOPOXVzg=8s3+mhueGF5+v0-mHA@mail.gmail.com>
References: <150161113411.34055.9762658795237184307.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170801190257.GA10033@redhat.com> <CAPcyv4jxTQhHANEBmObwhvWW7JHnSmHfCqv3JL3xEm0YFamvrA@mail.gmail.com>
 <CAPcyv4hLP98cap0cgWWw_FOeh9yzLJVSaZURntsB0t2D24nF9Q@mail.gmail.com> <1501621491.2475.20.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501621491.2475.20.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Aug 1, 2017 at 2:04 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Tue, 2017-08-01 at 13:59 -0700, Dan Williams wrote:
>> On Tue, Aug 1, 2017 at 12:45 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> > On Tue, Aug 1, 2017 at 12:02 PM, Mike Snitzer <snitzer@redhat.com> wrote:
>> > > On Tue, Aug 01 2017 at  2:12pm -0400,
>> > > Dan Williams <dan.j.williams@intel.com> wrote:
>> > > > [ ... ]
>> > >
>> > > I'm questioning the need to have yet another Kbuild CONFIG option.  If
>> > > the user has enabled CONFIG_BLK_DEV_PMEM and CONFIG_FS_DAX (DAX already
>> > > gets selected by CONFIG_FS_DAX) then shouldn't the DM capabilities just
>> > > be enabled?
>> > >
>> > > Guess I'm just skeptical of: why do we want to move to a model where
>> > > users need to opt-in to DM support for DAX?
>> > >
>> > > I also _really_ don't like each target's DAX support being colocated in
>> > > drivers/md/dm-dax.c
>> > >
>> > > This all looks and feels like a serious step backwards.
>> >
>> > Ok, you want ifdef'd sections of DAX code in each target and make
>> > DM_DAX a silent option that gets enabled with BLK_DEV_PMEM, anything
>> > else?
>>
>> Actually, no, I was thrown off by Bart's suggestion to move code
>> around. I can handle this all by deleting "select DAX" and adding more
>> stubbed out dax helpers.
>
> Hello Mike and Dan,
>
> How about one *-dax.c file per *.c dm file that has to be modified to add DAX support?
> I think that approach would avoid collocation of code for different targets in a
> single dm-dax.c file and would also avoid that #ifdef CONFIG_DAX statements have to
> be added. This approach is orthogonal to removal of CONFIG_DM_DAX.

You're free to send an alternative approach, but the new ifdefs in
include/linux/dax.h seem to be the cleanest option to remove dax text
size when the device-mapper dax support is not needed.
