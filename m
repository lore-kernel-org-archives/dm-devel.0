From: lixiaokeng <lixiaokeng@huawei.com>
Subject: Re: [PATCH 3/5] multipathd: add reclear_pp_from_mpp in
 ev_remove_path
Date: Mon, 24 Aug 2020 21:07:27 +0800
Message-ID: <cb7990df-6c84-7fc9-78ef-bf4c8600010f@huawei.com>
References: <5ef5f58e-3a27-8959-3abb-4b4c401cc309@huawei.com>
	<8fd64929-cb4b-5267-1899-15a82e2ff678@huawei.com>
	<fb04916036613edb59dfd470c449a1a199cd03ff.camel@suse.com>
	<905553fd-8c51-2898-8015-3795c6affc9f@huawei.com>
	<352109cf9e0b3f1fbd1851e86bc12fef12c40dec.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <352109cf9e0b3f1fbd1851e86bc12fef12c40dec.camel@suse.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: linfeilong@huawei.com, liuzhiqiang26@huawei.com
List-Id: dm-devel.ids

Hi Martin:
  Thanks for your detailed explanation. I understand it  well.

Regards
Lixiaokeng

On 2020/8/20 23:22, Martin Wilck wrote:
> On Thu, 2020-08-20 at 22:51 +0800, lixiaokeng wrote:
>> Hi Martin:
>>    I test this in 0.8.4 without your patch series . I have review the
>> code with your patch series and I think this problem will be solved.
>> But I have another question.
>> ev_remove_path
>> 	->__setup_multipath
>> 		->update_multipath_strings
>> 			->update_multipath_table
>> 				->update_pathvec_from_dm
>> 					->store_path
>> When multipathd del path xxx(such as sde) and multipath -v2 are
>> executed simultaneously, will the path(sde) deleted be stored to
>> pathvec
>> again? In my opinion, sde is't delete in pathvec and in
>> disassembel_map
>> sde will be stored to mpp->pg. When update_pathvec_from_dm, sde will
>> be
>> stored again.
> 
> in ev_remove_path(), we set INIT_REMOVED state. That means this path
> won't be used in the RELOAD ioctl. If the ioctl is successful, it will
> be gone from the kernel (for the time being). Later, sync_map_state()
> will figure this out, and remove the path. If the parallel "multipath"
> command reloads the map after multipathd's RELOAD operation, and before
> update_multipath_table() called, re-adding the path, the path will be
> read back from the kernel, and sync_map_state() will not delete the it.
>>From multipathd's point of view it will remain in INIT_REMOVED state,
> though. multipathd will not try to reload the map again unless it's
> asked to do so with another "add path" or "del path" command. This
> results in an inconsistent internal state between multipathd and the
> kernel (multipathd considers the path as REMOVED even though it's still
> present in the map). I don't think this can be generally avoided if we
> allow multipath to make changes to kernel maps while multipathd is
> running. (*)
> 
> We could avoid this by delegating these commands from multipath to
> multipathd, as we already do for some other commands. "multipath"
> without any arguments would map to a "multipathd reconfigure" command,
> while "multipath $DEVICE" would be translated to "multipathd add map"
> or "multipathd add path".
> 
> Does this make sense?
> 
> Regards,
> Martin
> 
> (*) Well: we *could* try to analyze incoming uevents, and distinguish
> those that multipathd has initiated itself from other, externally-
> triggered ones. Then if an external event arrives, adding a path which
> we had previously removed, and this external event arrives after the
> remove event we initiated, we could in theory infer that an external
> program had reverted the change we just made. But this would result in
> complex and pretty fragile logic. I'm not sure if it's worth it. The
> "delegating" approach is safer and cleaner IMO.
> 
> 
> 
> .
> 
