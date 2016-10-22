From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 16/18] multipath-tools: Use ALUA for HP 3PAR
Date: Sat, 22 Oct 2016 19:00:31 +0200
Message-ID: <fadd8f56-2d9f-003f-5ee0-c2d0076321b6@gmail.com>
References: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
	<1469838506-15689-16-git-send-email-xose.vazquez@gmail.com>
	<trinity-e6c25fb4-7664-4f5d-9885-5aba45504689-1469916891284@3capp-gmx-bs13>
	<aeee838a-6d44-ee76-62c5-4d97cbcaca80@gmail.com>
	<trinity-56e0175a-2d50-4b23-bcd6-901dba2baf2f-1469991975804@3capp-gmx-bs42>
	<cc29c462-f1d4-f74a-5b16-1236b48b85ea@gmail.com>
	<20160803021725.000063d5@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160803021725.000063d5@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 08/03/2016 02:17 AM, Sebastian Herbszt wrote:
> Xose Vazquez Perez wrote:
>> On 07/31/2016 09:06 PM, Sebastian Herbszt wrote:
>>
>>> Xose Vazquez Perez wrote:
>>>>
>>>> No. It's related to hardware_handler, "alua" in this case.
>>>
>>> So how does the output of 'multipath -ll' looks like for persona 1 and 2
>>> with and without 'retain_attached_hw_handler'?
>>
>> retain_attached_hw_handler is innocuous.
>> The paths grouping policy is controlled by the "path_grouping_policy" keyword,
>> multibus vs. group_by_prio. See man page.
> 
> multibus should equal
> 
> path_grouping_policy = group_by_prio
> prio = const
> 
>> Persona 1 and 2 basically is the same, but:
>>
>> Persona 1:	path_grouping_policy = multibus
>> 		failback = manual
>> 		prio = const
>>
>> Persona 2:	path_grouping_policy = group_by_prio
>> 		failback = immediate
>> 		prio = alua				(this is irrelevant, alua-prio is autodetected)
>> 		hardware_handler= "1 alua"		(this is irrelevant, all hardware handlers are autodetected)
>>
>> With 3PAR-OS 3.1.3, or later, you should use "Persona 2"
> 
> The above change plus
> 
> retain_attached_hw_handler = yes
> detect_prio = yes
> 
> should work with persona 1 and 2.


3PAR arrays are Symmetric Active/Active and with ALUA support.


- With Persona 1/Generic(UARepLun, SESLun), only one mode is supported:

o Symmetric Active/Active
        {
                .vendor        = "3PARdata",
                .product       = "VV",
                .pgpolicy      = MULTIBUS,
                .no_path_retry = 18,
        },


- With Persona 2/Generic-ALUA(UARepLun, SESLun, ALUA), both of them are supported:

o Symmetric Active/Active
        {
                .vendor        = "3PARdata",
                .product       = "VV",
                .pgpolicy      = MULTIBUS,
                .no_path_retry = 18,
        },

o Symmetric Active/Active + ALUA
        {
                .vendor        = "3PARdata",
                .product       = "VV",
                .pgpolicy      = GROUP_BY_PRIO,
                .pgfailback    = -FAILBACK_IMMEDIATE,
                .hwhandler     = "1 alua",
                .prio_name     = PRIO_ALUA,
                .no_path_retry = 18,
        },


Thera are also others Symmetric Active/Active arrays with support of ALUA.
At least, EMC/SYMMETRIX and IBM/2810XIV.
