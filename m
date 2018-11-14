From: Christoph Hellwig <hch@lst.de>
Subject: Re: multipath-tools: add ANA support for NVMe device
Date: Wed, 14 Nov 2018 16:35:44 +0100
Message-ID: <20181114153544.GA28758@lst.de>
References: <1541657381-7452-1-git-send-email-lijie34@huawei.com>
	<2691abf6733f791fb16b86d96446440e4aaff99f.camel@suse.com>
	<20181112215323.GA7983@redhat.com>
	<20181113161838.GC9827@localhost.localdomain>
	<d8c35b13-ee5a-e4ee-847a-2bacf788825a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <d8c35b13-ee5a-e4ee-847a-2bacf788825a@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: lijie <lijie34@huawei.com>, xose.vazquez@gmail.com, Mike Snitzer <snitzer@redhat.com>, chengjike.cheng@huawei.com, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, wangzhoumengjian@huawei.com, shenhong09@huawei.com, Martin Wilck <mwilck@suse.com>, sschremm@netapp.com
List-Id: dm-devel.ids

On Wed, Nov 14, 2018 at 08:24:05AM +0100, Hannes Reinecke wrote:
> My argument here is that _ANA_ support should not be tied to the NVME 
> native multipathing at all.

It should.  Because nvme driver multipathing is the only sanctioned
way to use it.  All other ways aren't supported and might break at
any time.

> So personally I don't see why the 'raw' ANA support (parsing log pages, 
> figuring out path states etc) needs to be tied in with native NVMe 
> multipathing. _Especially_ not as my patch really is trivial.

And not actually usable for anything..  They only thing you do is to
increase the code size for embedded nvme users that don't need any
multipathing.
