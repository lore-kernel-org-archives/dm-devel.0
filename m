From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [dm-devel] linux-next: Tree for Feb 2 (drivers/md/dm.c)
Date: Thu, 2 Feb 2017 12:19:57 -0800
Message-ID: <73fe1d1f-e0ef-f79c-9997-2573f5687d70@redhat.com>
References: <20170202182117.73e354f1@canb.auug.org.au>
 <8a8224e7-4c90-7fa7-9960-fc04fe658014@infradead.org>
 <20170202182916.GA26910@redhat.com> <20170202184409.GA27869@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170202184409.GA27869@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org, dm <dm-devel@redhat.com>, linux-next@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On 02/02/2017 10:44, Christoph Hellwig wrote:
> ec8013bedd ("dm: do not forward ioctls from logical volumes to the
> underlying device"),
> 
> The trivial fix would be to add a select of the SCSI_REQUEST symbol
> to dm, but my gut feeling teels me the call is simply wrong, and
> should be removed and instead all ioctls on DM devices that don't
> map to a full underlying devices should be rejected.

I would certainly be fine with that.  It would not be surprising if
something broke, but a middle ground could be to allow all ioctls if you
have CAP_SYS_RAWIO and none if you don't.

Paolo
