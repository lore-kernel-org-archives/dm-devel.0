From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 1/3] block: add sysfs entry for discard_alignment
Date: Tue, 03 Jul 2012 13:51:13 +0200
Message-ID: <4FF2DCB1.2090704@redhat.com>
References: <1341235225-27551-1-git-send-email-pbonzini@redhat.com> <1341235225-27551-2-git-send-email-pbonzini@redhat.com> <20120703023442.GB3586@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120703023442.GB3586@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, snitzer@redhat.com, martin.petersen@oracle.com, david@fromorbit.com, xfs@oss.sgi.com, dm-devel@redhat.com, hch@lst.de
List-Id: dm-devel.ids

Il 03/07/2012 04:34, Vivek Goyal ha scritto:
>> > The next patches will actually use the alignment, expose it in sysfs
>> > for ease of debugging.
>> > 
> Don't we already have discard_alignment exported as device attribute.
> 
> /sys/block/<dev>/discard_alignment

Ah, interesting, I missed it completely.  I guess it's because queue/
directories only exist for full disks, and the correct alignment varies
for each partition.  So this patch is unnecessary.

Paolo
