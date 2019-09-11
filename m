From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm:for-next 29/30]
 drivers//md/dm-clone-target.c:563:14: error: implicit declaration of
 function 'vmalloc'; did you mean 'kmalloc'?
Date: Wed, 11 Sep 2019 16:22:27 -0400
Message-ID: <20190911202227.GA1413@redhat.com>
References: <201909120035.YsFPOauD%lkp@intel.com>
	<20190911182251.GA634@redhat.com>
	<c35fcc93-91a2-20c2-da4c-9bbdee94e510@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <c35fcc93-91a2-20c2-da4c-9bbdee94e510@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikos Tsironis <ntsironis@arrikto.com>
Cc: dm-devel@redhat.com, Ilias Tsitsimpis <iliastsi@arrikto.com>, kbuild test robot <lkp@intel.com>, kbuild-all@01.org
List-Id: dm-devel.ids

On Wed, Sep 11 2019 at  2:46pm -0400,
Nikos Tsironis <ntsironis@arrikto.com> wrote:

> On 9/11/19 9:22 PM, Mike Snitzer wrote:> 
> > I resolved this and pushed new code, thanks!
> > 
> 
> Hi Mike,
> 
> I just saw the report and was about to fix it, but I noticed you have
> already fixed it. Thanks a lot.
> 
> I had forgotten to include the header file for vmalloc(), but I saw you
> used kvmalloc(), which is even better.
> 
> I took a quick look at the diff and there are a few places that still
> need fixing:
> 
> drivers/md/dm-clone-target.c:563: clone->ht = vmalloc(sz *sizeof(struct hash_table_bucket));
> drivers/md/dm-clone-target.c:579: vfree(clone->ht);
> 
> Also, the allocation of cmd->region_map is done with kvmalloc(), but the
> deallocation is still done with vfree():
> 
> drivers/md/dm-clone-metadata.c:597: vfree(cmd->region_map);
> 
> I will be away from keyboard for the rest of the day, but I will take a
> closer look at the diff tomorrow and I will send a new version fixing
> these and any other issues I might find.

I fixed the above up, thanks.

Please just send any incremental patches relative to what I have staged
now.

Mike
