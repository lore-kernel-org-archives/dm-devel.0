From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: multipath-tools: RH-patches for upstream ???
Date: Fri, 4 Oct 2019 17:16:54 +0200
Message-ID: <7d9b044e-9da9-7009-dd4f-f38621d40153@gmail.com>
References: <e2b955d0-69ea-2c2b-9f0f-ccf3b5f369d0@gmail.com>
	<20191003214420.GE25414@octiron.msp.redhat.com>
	<5d38873e4ea51f00d1d49e9e9fb86419542598e8.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5d38873e4ea51f00d1d49e9e9fb86419542598e8.camel@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <Martin.Wilck@suse.com>, "bmarzins@redhat.com" <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

On 10/4/19 9:03 AM, Martin Wilck wrote:

>>> https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0029-RH-Fix-nvme-compilation-warning.patch
>>>
>>>     Subject: [PATCH] RH: Fix nvme compilation warning
>>>
>>
>> I assume that other people aren't seeing these compilation warnings,
>> and
>> this it due to different options that redhat uses when compiling.  I
>> really should push this patch upstream, but that upstream isn't
>> multipath-tools, its nvme-cli, where we copied this file from. Once
>> it's
>> changed there, we can pull the updated files back to multipath-tools.
> 
> Ack. Which compiler option triggers this warning?

With this patch: https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0024-RH-use-rpm-optflags-if-present.patch
and /usr/lib/rpm/redhat/redhat-hardened-cc1 :
*cc1_options:
+ %{!r:%{!fpie:%{!fPIE:%{!fpic:%{!fPIC:%{!fno-pic:-fPIE}}}}}}
