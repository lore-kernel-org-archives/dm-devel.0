From: Martin George <marting@netapp.com>
Subject: Re: [PATCH] multipath-tools: Remove NetApp IBM Nseries
 code
Date: Tue, 12 Jul 2016 21:58:42 +0530
Message-ID: <57851ABA.8010601@netapp.com>
References: <2927779.USFptljH3X@marting-ubuntu>
	<65b0fdc5-8c18-f8b9-086c-7d2c54c20135@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <65b0fdc5-8c18-f8b9-086c-7d2c54c20135@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 7/12/2016 7:30 AM, Xose Vazquez Perez wrote:
>
>> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
>> index 709ab3c..0b4d366 100644
>> --- a/multipath/multipath.conf.5
>> +++ b/multipath/multipath.conf.5
>> @@ -224,7 +224,7 @@ accepts the optional prio_arg \fIexclusive_pref_bit\fR.
>>   .TP
>>   .I ontap
>>   (Hardware-dependent)
>> -Generate the path priority for NetApp ONTAP class and OEM arrays as IBM NSeries.
>> +Generate the path priority for NetApp ONTAP class arrays.
>>   .TP
>>   .I rdac
>>   (Hardware-dependent)
>
> But I would like to preserve that text in the man page.
>

Ok, fair enough. So only the hwtable.c needs to be updated here for this 
IBM Nseries change.

-Martin
