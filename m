From: Milan Broz <gmazyland@gmail.com>
Subject: Re: System freezes after OOM
Date: Wed, 13 Jul 2016 15:44:31 +0200
Message-ID: <97c60afe-d922-ce4c-3a5c-5b15bf0fe2da@gmail.com>
References: <57837CEE.1010609@redhat.com>
 <f80dc690-7e71-26b2-59a2-5a1557d26713@redhat.com>
 <9be09452-de7f-d8be-fd5d-4a80d1cd1ba3@redhat.com>
 <alpine.LRH.2.02.1607111027080.14327@file01.intranet.prod.int.rdu2.redhat.com>
 <20160712064905.GA14586@dhcp22.suse.cz>
 <alpine.LRH.2.02.1607121907160.24806@file01.intranet.prod.int.rdu2.redhat.com>
 <20160713111006.GF28723@dhcp22.suse.cz>
 <20160713125050.GJ28723@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160713125050.GJ28723@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, Jerome Marchand <jmarchan@redhat.com>, Stanislav Kozina <skozina@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/13/2016 02:50 PM, Michal Hocko wrote:
> On Wed 13-07-16 13:10:06, Michal Hocko wrote:
>> On Tue 12-07-16 19:44:11, Mikulas Patocka wrote:
> [...]
>>> As long as swapping is in progress, the free memory is below the limit 
>>> (because the swapping activity itself consumes any memory over the limit). 
>>> And that triggered the OOM killer prematurely.
>>
>> I am not sure I understand the last part. Are you saing that we trigger
>> OOM because the initiated swapout will not be able to finish the IO thus
>> release the page in time?
>>
>> The oom detection checks waits for an ongoing writeout if there is no
>> reclaim progress and at least half of the reclaimable memory is either
>> dirty or under writeback. Pages under swaout are marked as under
>> writeback AFAIR. The writeout path (dm-crypt worker in this case) should
>> be able to allocate a memory from the mempool, hand over to the crypt
>> layer and finish the IO. Is it possible this might take a lot of time?
> 
> I am not familiar with the crypto API but from what I understood from
> crypt_convert the encryption is done asynchronously. Then I got lost in
> the indirection. Who is completing the request and from what kind of
> context? Is it possible it wouldn't be runable for a long time?

If you mean crypt_convert in dm-crypt, then it can do asynchronous completion
but usually (with AES-NI ans sw implementations) it run the operation completely
synchronously.
Asynchronous processing is quite rare, usually only on some specific hardware
crypto accelerators.

Once the encryption is finished, the cloned bio is sent to the block
layer for processing.
(There is also some magic with sorting writes but Mikulas knows this better.)

Milan
p.s. I added cc to dm-devel, some dmcrypt people reads only this list.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
