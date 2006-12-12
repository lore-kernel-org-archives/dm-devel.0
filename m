From: Bernd Zeimetz <bernd@bzed.de>
Subject: Re: 2tb-limit in dm-multipath?
Date: Tue, 12 Dec 2006 17:45:18 +0100
Message-ID: <457EDC9E.8020705@bzed.de>
References: <786EB72C710DF5BB0694C505@sigh.heise.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <786EB72C710DF5BB0694C505@sigh.heise.de>
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
> I had no problems setting this up (despite some udev-trouble due to an older
> dmsetup). But when I try to access volumes > 2tb I get something like
>   
do you have "Support for Large Block Devices" activated in your kernel
config?


Best regards,

Bernd Zeimetz
