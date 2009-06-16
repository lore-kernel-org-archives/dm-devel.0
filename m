From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH block#for-2.6.31] block: add request clone interface (v2)
Date: Tue, 16 Jun 2009 11:02:49 +0300
Message-ID: <4A3751A9.8070601@panasas.com>
References: <4A3075B2.9040208@ct.jp.nec.com>	<20090611110903.GO11363@kernel.dk>	<x49vdn3lynd.fsf@segfault.boston.devel.redhat.com>	<20090612133014.GK11363@kernel.dk> <x49ski5v7vs.fsf@segfault.boston.devel.redhat.com> <4A35C0A4.20707@ct.jp.nec.com> <4A3614D1.20403@panasas.com> <4A370B3D.4050108@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751835AbZFPIDT@vger.kernel.org>
In-Reply-To: <4A370B3D.4050108@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On 06/16/2009 06:02 AM, Kiyoshi Ueda wrote:
> Hi Boaz, Jeff, Jens,
>>> Perhaps
>>> blk_rq_{clone,declone} or blk_rq_{clone,declone}_bios
>>>
>>> (Both unclone and declone are found on the net but are not
>>>  found in the free dictionary)
> 
> I had a feeling that blk_rq_{clone,declone} allocates/frees
> the clone request inside the interfaces like bio_clone(), so
> I didn't take such namings.
> And, the clone setup interface may not only make bio clones
> but also do something else (for other request members), so
> I didn't add any 'bio' namings to the interfaces.
> 

I'm convinced blk_rq_prep_clone is good for what it actually does

> Jens, what do you prefer?
> 
> Thanks,
> Kiyoshi Ueda

Thanks
Boaz
