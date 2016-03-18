From: Ming-Hung Tsai <mingnus@gmail.com>
Subject: Re: [PATCH] thin_dump: added --device-id, --skip-mappings,
 and new output --format's
Date: Fri, 18 Mar 2016 14:45:23 +0800
Message-ID: <CAAYit8TWY2LoherwpAU84YeTfQ1mynGAoGDcAG1b+3O662Znvw@mail.gmail.com>
References: <alpine.LRH.2.11.1603150104370.19675@mail.ewheeler.net>
	<20160317154553.GC4033@rh-vpn>
	<alpine.LRH.2.11.1603172245520.21357@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.11.1603172245520.21357@mail.ewheeler.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Wheeler <dm-devel@lists.ewheeler.net>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

2016-03-18 6:45 GMT+08:00 Eric Wheeler <dm-devel@lists.ewheeler.net>:
>
> On Thu, 17 Mar 2016, Joe Thornber wrote:
>
>> If you're skipping the mappings does the new thin_ls provide enough
>> information for you?
>
> Our primary need is the ability to specify --device-id in the o:L:d output
> format (old_format.cc) with mappings.  Our nightly dumps now take 50
> seconds instead of 40 minutes since we only dump the dev_id's that we
> need.
>

I have similar requirement. I did this by my own compact_emitter,
which is a simplified version of "human_readable_emitter", without showing
the arrows and parentheses:

output format:

begin superblock=>uuid:"",time:<time>,transaction:<tid>,flags:<flags>,version:<version>,data_block_size:<bs>,nr_data_blocks:<nr_blocks>
device=>dev_id:<dev_id>,mapped_blocks:<mapped_blocks>,transaction:<tid>,creation_time:<creation_time>,snap_time:<snap_time>
<origin_begin>,<data_begin>,<len>,<time>
<origin_begin>,<data_begin>,1,<time>
...
end superblock

e.g.,

begin superblock=>uuid:"",time:0,transaction:1,flags:0,version:1,data_block_size:2048,nr_data_blocks:5657156
device=>dev_id:10000,mapped_blocks:3864041,transaction:0,creation_time:0,snap_time:0
1000,2000,100,0
1100,3000,200,0
...
end superblock

The <time> field is preserved for snapshot comparison.

Maybe we could discuss on creating a flexible emitter that could
customize the output format:
- Mapping units: sectors or blocks
- Emit the superblock and device tags or not. I think that an end mark
might be better for network transmission,
  to determine whether the dump was ended or not.
- Other consideration: should the customized output compatible to thin_restore ?



Ming-Hung Tsai
