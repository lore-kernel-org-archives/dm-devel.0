From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: Page Allocation Failures/OOM with dm-crypt on software RAID10
 (Intel Rapid Storage)
Date: Thu, 14 Jul 2016 20:18:49 +0900
Message-ID: <9074e82f-bf52-011e-8bd7-5731d2b0dcaa@I-love.SAKURA.ne.jp>
References: <02580b0a303da26b669b4a9892624b13@mail.ud19.udmedia.de>
 <20160712095013.GA14591@dhcp22.suse.cz>
 <d9dbe0328e938eb7544fdb2aa8b5a9c7@mail.ud19.udmedia.de>
 <20160712114920.GF14586@dhcp22.suse.cz>
 <e6c2087730e530e77c2b12d50495bdc9@mail.ud19.udmedia.de>
 <20160712140715.GL14586@dhcp22.suse.cz>
 <459d501038de4d25db6d140ac5ea5f8d@mail.ud19.udmedia.de>
 <20160713112126.GH28723@dhcp22.suse.cz>
 <20160713121828.GI28723@dhcp22.suse.cz>
 <74b9325c37948cf2b460bd759cff23dd@mail.ud19.udmedia.de>
 <20160713134717.GL28723@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160713134717.GL28723@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>, Matthias Dahl <ml_linux-kernel@binary-island.eu>
Cc: linux-raid@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 2016/07/13 22:47, Michal Hocko wrote:
> On Wed 13-07-16 15:18:11, Matthias Dahl wrote:
>> I tried to figure this out myself but
>> couldn't find anything -- what does the number "-3" state? It is the
>> position in some chain or has it a different meaning?
> 
> $ git grep "kmem_cache_create.*bio"
> block/bio-integrity.c:  bip_slab = kmem_cache_create("bio_integrity_payload",
> 
> so there doesn't seem to be any cache like that in the vanilla kernel.
> 
It is

  snprintf(bslab->name, sizeof(bslab->name), "bio-%d", entry);

line in bio_find_or_create_slab() in block/bio.c.
I think you can identify who is creating it by printing backtrace at that line.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
