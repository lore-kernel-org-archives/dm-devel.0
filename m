From: "m9230" <m9230@cn.ee.ccu.edu.tw>
Subject: Re: [PATCH] dm.c
Date: Fri, 5 May 2006 15:35:45 +0800
Message-ID: <20060505072857.M41283@cn.ee.ccu.edu.tw>
References: <20060504160048.CA34173C68@hormel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=big5
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060504160048.CA34173C68@hormel.redhat.com>
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

Hi

I am sorry that I did not list the original source.
Thanks to Eric, this is the original source: 
http://oss.sgi.com/bugzilla/show_bug.cgi?id=646 


> Message: 1
> Date: Thu, 4 May 2006 10:51:39 +0800
> From: "m9230" <m9230@cn.ee.ccu.edu.tw>
> Subject: [dm-devel] [PATCH] dm.c
> To: dm-devel@redhat.com
> Message-ID: <20060504025139.M49417@cn.ee.ccu.edu.tw>
> Content-Type: text/plain;	charset=big5
> 
> Hello, I found a problem in dm_blk_ioctl() in dm.c:
> 
> In dm.c, dm_blk_ioctl() is assigning a full unsigned 32 bits of 
> device size to a signed 32 bit size. This may cause BLKGETSIZE64 
> ioctl and BLKGETSIZE ioctl failed to get the device size when device 
> size is larger than 1TB.
> 
> I am using device-mapper.1.01.05.
> 
> Changing "long size;" to "sector_t size;" might fix this up, it 
> works for me. For example: error = ioctl(fd, BLKGETSIZE64, &size); 
> returns "size" in bytes.
> 
> --
> Best Regards, Michael Yao
