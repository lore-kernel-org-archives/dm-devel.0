From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [PATCH 7/7] Hold all write bios when errors are handled
Date: Wed, 25 Nov 2009 17:47:36 -0500
Message-ID: <4B0DB408.6020906@redhat.com>
References: <Pine.LNX.4.64.0911180710370.21358@hs20-bc2-1.build.redhat.com>	<Pine.LNX.4.64.0911180711140.21358@hs20-bc2-1.build.redhat.com>	<Pine.LNX.4.64.0911180711510.21358@hs20-bc2-1.build.redhat.com>	<Pine.LNX.4.64.0911180712340.21358@hs20-bc2-1.build.redhat.com>	<Pine.LNX.4.64.0911180713150.21358@hs20-bc2-1.build.redhat.com>	<Pine.LNX.4.64.0911180718540.21358@hs20-bc2-1.build.redhat.com>	<20091123055835.GA28981@us.ibm.com>	<Pine.LNX.4.64.0911240638250.27545@hs20-bc2-1.build.redhat.com>	<20091124191704.GB7971@us.ibm.com>	<Pine.LNX.4.64.0911250807500.14481@hs20-bc2-1.build.redhat.com>
	<20091125202346.GB1673@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091125202346.GB1673@us.ibm.com>
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

On 11/25/09 15:23, malahal@us.ibm.com wrote:
> Mikulas Patocka [mpatocka@redhat.com] wrote:
>>
>>>> Imagine this scenario:
>>>> * secondary leg fails
>>>> * write fails on the secondaty leg and succeeds on the primary leg 
>>>> and is successfully complete
>>>> * the computer crashes
>>>> * after a reboot, the primary leg is inaccessible and the secondary leg is 
>>>> back online --- now raid1 would be returning stale data.
>>>
>>> The software can detect this case. We can fail this completely or use
>>> the data from the secondary that could be "stale" with help from admin. 
>>> Let us call this method 1.
>>
>> You can't detect it because the computer crashed *before* you write the 
>> information that the secondary leg failed to the metadata.
>>
>> So, after a reboot, you can't tell if any mirror leg failed some requests 
>> before the crash.
> 
> My definition of 'primary' is the first leg. Now on, I will use "first
> leg" to avoid confusion.  On a reboot, LVM can find if its first leg is
> missing. If it is missing, it can ask the admin whether to use the
> 'second' leg or not. When I said, "software" can detect, I really meant
> that LVM can detect that the "first leg" is missing.

I think again the scenario which Mikulas pointed. It looks double failures
(fails happened on two legs), and human intervention would be acceptable.
However, how do we know if the second leg contains valid data?

There might be two cases.

  1) System crashed during write operations without any disk failures, and
     the first leg fails at the next boot.

     We can use the secondary leg because data in the secondary leg is valid.

  2) System crashed after the secondary leg failed, and the first leg fails
     and the secondary leg gets back online at the next boot.

     We can't use the secondary leg because data might be stale.

I haven't checked the contents of log disk, but I guess we can't differentiate
these cases from log disks. Another possibility I thought was error messages.
If any error messages for the secondary leg are recorded, we can judge that
the secondary leg contains stale data, but I suspect that it is not a secure
way because syslog might not be written in disk before system crash.

I would like to enhance system availability by keep system running when
the secondary leg fails, but we need to confirm this case.

I appreciate your comments.

Thanks,
Taka
