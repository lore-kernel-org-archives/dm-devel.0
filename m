From: Bernd Zeimetz <bernd@bzed.de>
Subject: Re: Device Access Question
Date: Fri, 29 Sep 2006 12:04:25 +0200
Message-ID: <451CEFA9.3090403@bzed.de>
References: <C514D40EFDB5C84083DAEB84A1186A8F266AEE@msc-ex02.msc-ge.mscnet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C514D40EFDB5C84083DAEB84A1186A8F266AEE@msc-ex02.msc-ge.mscnet>
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

Heya,
>
> #multipath -l
> (3600601604032190097fd5fbefd22db11)
> [size=11 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
> \_ round-robin 0 [active]
>  \_ 3:0:0:7 sdi 8:128 [active][ready]
> \_ round-robin 0 [enabled]
>  \_ 3:0:1:7 sdq 65:0  [active][ready]
>
> #fdisk -l /dev/sdi
>   

try
fdisk /dev/mapper/3600601604032190097fd5fbefd22db11
you can configure alias names in mutipath.conf if you don't like the 
weird name.

multipaths {
        multipath {
                wwid                    3600601604032190097fd5fbefd22db11
                alias                   mylunname
        }
}

you'll find a device called /dev/mapper/mylunname then.


Best regards,

Bernd
