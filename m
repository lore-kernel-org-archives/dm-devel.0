From: Eric Ren <zren@suse.com>
Subject: Re: [Report] crash tool cannot resolve struct dm_table
 properly
Date: Thu, 13 Apr 2017 22:35:37 +0800
Message-ID: <c689b617-1e2f-5bfe-7485-ca31adefbc4c@suse.com>
References: <ed7ae3a8-f053-fb4b-8523-c09b8c725ed9@suse.com>
	<e9d01427-b93e-37b6-8ef4-ccc0de714d70@linux.vnet.ibm.com>
	<e546861f-80db-400c-df2c-9db656fec956@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e546861f-80db-400c-df2c-9db656fec956@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Steffen Maier <maier@linux.vnet.ibm.com>, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Hey!


On 04/13/2017 06:29 PM, Steffen Maier wrote:
> On 04/13/2017 12:22 PM, Steffen Maier wrote:
>> [...snip...]
>>
>> Does this help somewhat?:
>>
>> https://www.redhat.com/archives/dm-devel/2015-December/msg00042.html
Thanks, I didn't notice that thread. Yes, it will help!
>>
>> As workaround for eppic scripts in crash, we currently re-define struct
>> dm_table in eppic scripts, because "set scope dm_table_create" has not
>> always worked as we liked. Sometimes "whatis dm_table_create" and again
>> "set scope dm_table_create" worked and we put this in .crashrc, but
>> eventually gave up and kept our struct re-define.
>
> Before we wrote above posting, we tried this; maybe it helps in your 
> case:
>
> crash> set gdb on
> gdb: on
> gdb> ptype struct dm_table
> type = struct dm_table {
>     int undefined__;
> }
> gdb> ptype 'drivers/md/dm-table.c'::dm_table
> No symbol "dm_table" in specified context.
> gdb: gdb request failed: ptype 'drivers/md/dm-table.c'::dm_table
> gdb> ptype struct dm_table
> type = struct dm_table {
>     uint64_t features;
>     struct mapped_device *md;
>     unsigned int type;
> ...
>
Great! thanks for your sharing:-)

Regards,
Eric
