From: Ming-Hung Tsai <mingnus@gmail.com>
Subject: Re: [PATCH] thin_dump: added --device-id, --skip-mappings,
 and new output --format's
Date: Wed, 16 Mar 2016 13:42:00 +0800
Message-ID: <CAAYit8RET-xAjtYASOBA0xEK5DWP4ubvm5bcZEmTkUd7BOvUDg@mail.gmail.com>
References: <alpine.LRH.2.11.1603150104370.19675@mail.ewheeler.net>
	<CAM2wQBvGUs=Co=b89Nw_TYN_qBfCZj-6S7sHdinDNHPm_ZS1PA@mail.gmail.com>
	<alpine.LRH.2.11.1603151735530.19675@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.11.1603151735530.19675@mail.ewheeler.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Wheeler <dm-devel@lists.ewheeler.net>, Thanos Makatos <thanos.makatos@onapp.com>
Cc: device-mapper development <dm-devel@redhat.com>, Joe Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

2016-03-16 1:51 GMT+08:00 Eric Wheeler <dm-devel@lists.ewheeler.net>:
> On Tue, 15 Mar 2016, Thanos Makatos wrote:
>
>> On 15 March 2016 at 01:45, Eric Wheeler <dm-devel@lists.ewheeler.net> wrote:
>> > Hi Joe,
>> >
>> > We use thin_dump on live dm-thin metadata snapshots all the time.  In our
>> > case, we want to dump the XML for new (snapshot) volumes instead of
>> > dumping the entire 16gb metadata device (37.8% used) which takes ~20-30
>> > minutes instead of ~5 seconds for a single volume with --device-id.
>>
>> I'm interested in extracting the mappings of a particular device, too.
>> In fact, I've implemented this (along with extracting the mappings in
>> binary format) and have only recently opened a PR:
>> https://github.com/jthornber/thin-provisioning-tools/pull/49. It seems
>> that we've replicated some work here, I'm not sure whether we're
>> supposed to send patches to this list or open PR on github.
>
> Interesting, it is neat to see a binary format too.
>
> I think we need to come up with a consistent way to extend attributes
> being passed down into mapping_tree_emitter::visit() by way of
> thin_provisioning::metadata_dump().  What is preferred?
>
> I noticed that caching::metadata_dump() has the same prototype, so do
> those need to remain compatable calls?
>
> Should we countinue to extend the arguments to metadata_dump()
> as Thanos and I have done, or, should we pop up the mte call to the caller
> and pass a pointer to thin_provisioning::metadata_dump(..., *mte) and let
> the caller configure the mte with setter functions or constructor calls?

Hi,

You are not alone, I did the same feature and used it for a long time.
My solution is similar to Thanos, I override thin_provisioning::metadata_dump()
to accept the additional dev_id:

void metadata_dump(metadata::ptr md, emitter::ptr e);
void metadata_dump(metadata::ptr md, emitter::ptr e, uint64_t dev_id);

Instead of passing dev_id to mapping_tree_emitter, I pass the dd_map
with only one device,
then let the mapping_tree_emitter to traverse the bottom-level tree directly:

void
thin_provisioning::metadata_dump(metadata::ptr md, emitter::ptr e,
uint64_t dev_id)
{
    uint64_t key[1] = {dev_id};
    dev_tree::maybe_value single_mapping_tree_root =
md->mappings_top_level_->lookup(key);
    device_tree::maybe_value details = md->details_->lookup(key);

    // ... error handling

    details_extractor de;
    de.visit(dev_id, *details);  // de contains only one device

    e->begin_superblock(...);
    {
        mapping_tree_emitter mte(md, e, de.get_details(),
mapping_damage_policy(repair));
        std::vector<uint64_t> path(1, dev_id); //
btree_detail::btree_path is std::vector<uint64_t>
        mte.visit(path, *single_mapping_tree_root);
    }
    e->end_superblock();
}

But this looks still a bit messy: I should setup the visitors and
trees carefully to do what I want.

I also wrote some debugging feature for thin_dump. I can push the code
if you have interest.

1. thin_dump -b <metadata_dev> : Dump the device_details tree only. Do
not emit the data mappings.
(This could be replace by the new thin_ls)

output (no mappings):
<superblock ... >
  <device ... >
  </device>
  <device ... >
  </device>
</superblock>

2. thin_dump -r2 <metadata_dev>: dump the data mapping tree despite
the device_details tree was broken



Ming-Hung Tsai
