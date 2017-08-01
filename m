From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: dm: enable opt-out of device-mapper dax support
Date: Tue, 1 Aug 2017 12:45:05 -0700
Message-ID: <CAPcyv4jxTQhHANEBmObwhvWW7JHnSmHfCqv3JL3xEm0YFamvrA@mail.gmail.com>
References: <150161113411.34055.9762658795237184307.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170801190257.GA10033@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170801190257.GA10033-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: dm-devel.ids

On Tue, Aug 1, 2017 at 12:02 PM, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Aug 01 2017 at  2:12pm -0400,
> Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
>> Now that dax is no longer a default property of a block-device, i.e.
>> ->direct_access() is not a block-device operation, we optionally enable
>> device-mapper dax support with a new CONFIG_DM_DAX option.
>>
>> All the dax operations helpers are moved to a new file,
>> drivers/md/dm-dax.c, that is optionally compiled when CONFIG_DM_DAX=y.
>> Otherwise, we stub out all the operations with NULL function pointers
>> and nop wrappers for the core dax routines.
>>
>> Cc: Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Reported-by: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
>> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/md/Kconfig     |   14 +++
>>  drivers/md/Makefile    |    1
>>  drivers/md/dm-dax.c    |  227 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/md/dm-dax.h    |   73 +++++++++++++++
>>  drivers/md/dm-linear.c |   56 ------------
>>  drivers/md/dm-snap.c   |    9 --
>>  drivers/md/dm-stripe.c |   89 -------------------
>>  drivers/md/dm-target.c |    7 -
>>  drivers/md/dm.c        |  105 ++--------------------
>>  drivers/md/dm.h        |   34 +++++++
>>  10 files changed, 363 insertions(+), 252 deletions(-)
>>  create mode 100644 drivers/md/dm-dax.c
>>  create mode 100644 drivers/md/dm-dax.h
>>
>> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
>> index 4a249ee86364..bf27b435f7cd 100644
>> --- a/drivers/md/Kconfig
>> +++ b/drivers/md/Kconfig
>> @@ -200,7 +200,6 @@ config BLK_DEV_DM_BUILTIN
>>  config BLK_DEV_DM
>>       tristate "Device mapper support"
>>       select BLK_DEV_DM_BUILTIN
>> -     select DAX
>>       ---help---
>>         Device-mapper is a low level volume manager.  It works by allowing
>>         people to specify mappings for ranges of logical sectors.  Various
>> @@ -214,6 +213,19 @@ config BLK_DEV_DM
>>
>>         If unsure, say N.
>>
>> +config DM_DAX
>> +     bool "Direct access (DAX) support"
>> +     depends on BLK_DEV_DM
>> +     default BLK_DEV_PMEM
>> +     select DAX
>> +     ---help---
>> +       Enable DAX support for the device-mapper linear and stripe
>> +       targets for use with DAX capable block devices like /dev/pmemN.
>> +       If you have a DAX capable block device and have enabled
>> +       filesystem DAX support (CONFIG_FS_DAX), then say Y.
>> +
>> +       If unsure, say N.
>> +
>
> I'm questioning the need to have yet another Kbuild CONFIG option.  If
> the user has enabled CONFIG_BLK_DEV_PMEM and CONFIG_FS_DAX (DAX already
> gets selected by CONFIG_FS_DAX) then shouldn't the DM capabilities just
> be enabled?
>
> Guess I'm just skeptical of: why do we want to move to a model where
> users need to opt-in to DM support for DAX?
>
> I also _really_ don't like each target's DAX support being colocated in
> drivers/md/dm-dax.c
>
> This all looks and feels like a serious step backwards.

Ok, you want ifdef'd sections of DAX code in each target and make
DM_DAX a silent option that gets enabled with BLK_DEV_PMEM, anything
else?
