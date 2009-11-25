From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [PATCH 7/7] Hold all write bios when errors are handled
Date: Wed, 25 Nov 2009 18:50:24 -0500
Message-ID: <4B0DC2C0.9020008@redhat.com>
References: <Pine.LNX.4.64.0911180711510.21358@hs20-bc2-1.build.redhat.com>	<Pine.LNX.4.64.0911180712340.21358@hs20-bc2-1.build.redhat.com>	<Pine.LNX.4.64.0911180713150.21358@hs20-bc2-1.build.redhat.com>	<Pine.LNX.4.64.0911180718540.21358@hs20-bc2-1.build.redhat.com>	<20091123055835.GA28981@us.ibm.com>	<Pine.LNX.4.64.0911240638250.27545@hs20-bc2-1.build.redhat.com>	<20091124191704.GB7971@us.ibm.com>	<Pine.LNX.4.64.0911250807500.14481@hs20-bc2-1.build.redhat.com>	<20091125202346.GB1673@us.ibm.com>
	<4B0DB408.6020906@redhat.com> <20091125232010.GA5968@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091125232010.GA5968@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 11/25/09 18:20, malahal@us.ibm.com wrote:
> Takahiro Yasui [tyasui@redhat.com] wrote:
>> I think again the scenario which Mikulas pointed. It looks double failures
>> (fails happened on two legs), and human intervention would be acceptable.
>> However, how do we know if the second leg contains valid data?
>>
>> There might be two cases.
>>
>>   1) System crashed during write operations without any disk failures, and
>>      the first leg fails at the next boot.
>>
>>      We can use the secondary leg because data in the secondary leg is valid.
>>
>>   2) System crashed after the secondary leg failed, and the first leg fails
>>      and the secondary leg gets back online at the next boot.
>>
>>      We can't use the secondary leg because data might be stale.
>>
>> I haven't checked the contents of log disk, but I guess we can't
>> differentiate these cases from log disks.
> 
> There were plans to add a new region state to make sure that all the
> mirror legs have same data after a "crash". Currently your best bet is a
> complete resync after a crash!

Please let me clarify this. There are two legs and system crash happens.
Then, how can we resync? We have only one leg (secondary) after boot.
When we use "mirror", we expect the last device to contain valid data,
don't we?

> Or just have LVM meta data that records a device failure. Suspend writes
> [for any kind of leg] and record device failure in the LVM meta data and
> restart writes. This requires LVM meta data change though!

Do you mean that write I/Os need to be blocked when the secondary leg fails
in order to update LVM meta data by lvm commands called by dmeventd?

Thanks,
Taka
