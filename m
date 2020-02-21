From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v5 2/8] drivers/pmem: Allow pmem_clear_poison() to accept arbitrary offset and len
Date: Fri, 21 Feb 2020 16:33:52 -0500
Message-ID: <x49o8tr1v7j.fsf@segfault.boston.devel.redhat.com>
References: <20200218214841.10076-1-vgoyal@redhat.com>
        <20200218214841.10076-3-vgoyal@redhat.com>
        <x49lfoxj622.fsf@segfault.boston.devel.redhat.com>
        <20200220215707.GC10816@redhat.com>
        <x498skv3i5r.fsf@segfault.boston.devel.redhat.com>
        <20200221201759.GF25974@redhat.com>
        <CAPcyv4j3BPGvrhuVaQZgvZ0i+M+i-Ab0BH+mAjR_aZzu4_kidQ@mail.gmail.com>
        <20200221212449.GG25974@redhat.com>
        <CAPcyv4gBHuTDW1M-3W=0nuH1v3whChb8TAK1aA0gosBSKpkqcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4gBHuTDW1M-3W=0nuH1v3whChb8TAK1aA0gosBSKpkqcg@mail.gmail.com>
        (Dan Williams's message of "Fri, 21 Feb 2020 13:30:56 -0800")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Dan Williams <dan.j.williams@intel.com> writes:

> Oh you misunderstood my comment, the "move badblocks to filesystem"
> proposal is long term / down the road thing to consider. In the near
> term this unaligned block zeroing facility is an improvement.

I'm not sure I agree.  I'm going to think about it and get back to you.

-Jeff
