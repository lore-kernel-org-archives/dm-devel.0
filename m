From: Eckebrecht von Pappenheim <evp@heise.de>
Subject: Re: 2tb-limit in dm-multipath?
Date: Tue, 12 Dec 2006 19:37:34 +0100
Message-ID: <DD0793FBAAB6DD80CBDDE9F4@[192.168.12.2]>
References: <786EB72C710DF5BB0694C505@sigh.heise.de> <457EDC9E.8020705@bzed.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <457EDC9E.8020705@bzed.de>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,

>> I had no problems setting this up (despite some udev-trouble due to an
>> older dmsetup). But when I try to access volumes > 2tb I get something
>> like
>>   
> do you have "Support for Large Block Devices" activated in your kernel
> config?

yes, I have. I can and do use the big partitions directly without any
problems. The trouble starts when I try to use them through multipath.

Best regards,
Eckebrecht


-- 
Eckebrecht von Pappenheim, network administration 
Heise Zeitschriften Verlag GmbH & Co KG
Helstorferstr. 7, D-30625 Hannover, FRG
E-Mail: evp@heise.de  - Tel: +49 511 5352 242  -  FAX: +49 511 5352 479
http://www.heise.de/
