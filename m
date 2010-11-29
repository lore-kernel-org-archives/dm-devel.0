From: "Ed Lin - PTU" <ed.lin@promise.com>
Subject: RE: data corruption with stex (Promise HW-Raid) driver and device-mapper
Date: Mon, 29 Nov 2010 11:35:37 -0800
Message-ID: <85ABFDC4641C4847BA6088F2982EFD8F04A4A6A1@nonamew.ptu.promise.com>
References: <4CEE32F0.4030302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <4CEE32F0.4030302@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Dan Carpenter <error27@gmail.com>, Markus Schulz <msc@antzsystem.de>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



>-----Original Message-----
>From: Milan Broz [mailto:mbroz@redhat.com] 
>Sent: 2010年11月25日 1:57
>To: Ed Lin - PTU
>Cc: Dan Carpenter; Markus Schulz; 
>linux-kernel@vger.kernel.org; device-mapper development
>Subject: Re: data corruption with stex (Promise HW-Raid) 
>driver and device-mapper
>
>
>On 11/16/2010 02:35 AM, Ed Lin - PTU wrote:
>> The stex driver sets sg_tablesize as 32 (for st_yel it's 38) 
>in the probe
>> entry. It seems that this value was overridden by the system if using
>> dm/lvm, for unknown reason. The driver received requests with more
>> sg items than registered. Sg item number could be as high as 64. This
>> is completely unexpected. The firmware could not handle such
>> requests, and error occurred.
>
>Device-mapper respects hw restrictions, so it must be bug somewhere.
>
>Please cc dm-devel if you think that problem is there.
>

Hello,

This problem is fixed. Martin Petersen proposed a thorough cleaning at
http://marc.info/?l=dm-devel&m=129070330506836&w=2 .
My original patch is at
http://marc.info/?l=dm-devel&m=129067980708110&w=2 ,
which is a simplified minimum version.

Thanks,
Ed Lin
