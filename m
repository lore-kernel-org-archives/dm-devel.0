From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 08/11] block: rename barrier/ordered to flush
Date: Wed, 18 Aug 2010 08:23:43 +0200
Message-ID: <4C6B7C6F.1020809@kernel.org>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <1281616891-5691-9-git-send-email-tj@kernel.org> <20100817132646.GA3577@lst.de> <4C6AB79B.2040303@kernel.org> <20100817170857.GA15297@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20100817170857.GA15297@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

Hello,

On 08/17/2010 07:08 PM, Christoph Hellwig wrote:
> On Tue, Aug 17, 2010 at 06:23:55PM +0200, Tejun Heo wrote:
>> Yeap, agreed.  I couldn't really understand why the the sequence
>> needed to be atomic for ide in the first place so just left it alone.
>> Do you understand why it tried to be atomic?
> 
> I think initial drafs of the barrier specification talked about atomic
> sequences.  Except for that I can't think of any reason.

Hmm... alright, I'll rip it out.

Thanks.

-- 
tejun
