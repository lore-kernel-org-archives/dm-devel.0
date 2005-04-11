From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: New -udm?
Date: Mon, 11 Apr 2005 11:26:51 -0700
Message-ID: <425AC16B.3080301@us.ibm.com>
References: <C2EEB4E538D3DC48BF57F391F422779321A8EF@SRMANNING.eng.emc.com>
	<425AC120.4080904@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <425AC120.4080904@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <mikenc@us.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Mike Christie wrote:
>>
>> I don't see a way around needing to use pre-allocated bio memory
>> which is reserved strictly for this purpose -- albeit it is possible
>> that a single bio could be reserved for making progress in serial
>> fashion across all multipaths which are in this state.
>>
>>

I agree for bios we are in trouble :)
