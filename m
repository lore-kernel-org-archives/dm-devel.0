From: "Dmitry Y. Labutin" <dmitry@incub.ru>
Subject: Re: device-mapper error
Date: Sat, 13 Jan 2007 18:56:58 +0300
Message-ID: <425091659.20070113185658@incub.ru>
References: <959119734.20070113170445@incub.ru>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <959119734.20070113170445@incub.ru>
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

Hi.

I found, that problem with device-mapper present on kernel 2.6.18-1.2869.fc6
With kernel 2.6.18-1.2798.fc6 all works fine!

> I see this logs in dmesg on Fedora Core 6. Can you help me?

> device-mapper: table: device /dev/mapper/pdc_bdeigaaigj too small for target
> device-mapper: table: 253:3: linear: dm-linear: Device lookup failed
> device-mapper: ioctl: error adding target to table

-- 
Dmitry Labutin
dmitry@incub.ru
