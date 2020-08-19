From: lixiaokeng <lixiaokeng@huawei.com>
Subject: Re: [PATCH 4/5] multipathd: disable queueing for
 recreated map in uev_remove_map
Date: Wed, 19 Aug 2020 16:48:51 +0800
Message-ID: <24599c4c-7cf8-f92e-fd75-c4ac47ac4e89@huawei.com>
References: <5ef5f58e-3a27-8959-3abb-4b4c401cc309@huawei.com>
	<178ce8f8-cf74-bb32-1e5c-41674f493a24@huawei.com>
	<9e4b52381f72c8ba6bae6b614daa26cc82ede88d.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9e4b52381f72c8ba6bae6b614daa26cc82ede88d.camel@suse.com>
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
    In history, the deadlock has happened. When I review patchs made by
huawei employees before me, I think this should be sent to upstream.
It is made in May 2018, so I don't know more details. I'm sorry for that.

On 2020/8/19 3:23, Martin Wilck wrote:
> Hi Lixiaokeng,
> 
> 
> A map which is removed and not yet re-added again (as far as udev is
> concerned) doesn't need to queue because it can't possibly be in use.
> So I think the patch can't hurt in other scenarios, at it makes sense
> in the situation you describe. However I have a few questions.
> 
> Have you observed this, or is it theory? I'm wondering: After 2) there
> should be some paths again, so why would the udev workers hang? 
> I guess this could happen if the regenerated paths all in failed /
> standby state, is that what you mean?
> 
> Note also that we set DM_NOSCAN in the udev rules when there are no
> usable paths, so udev workers would only hang if the last path fails /
> is removed after the "multipath -U" check.
> 
> You've certainly hit a weak spot here, and you've nicely described a
> potential problem scenario. The delayed processing of uevents that
> multipathd triggered itself is a recurring cause of headache.
> 
> Regards,
> Martin
> 
> 
> 
